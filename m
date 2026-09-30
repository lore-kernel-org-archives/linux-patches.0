Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAED1E0DD8;
	Wed, 30 Sep 2026 16:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787192; cv=none; b=Nfj/tQ/NGRCrV4fA0QPw/GAyP2EuL4S2clKuC3XuT/5qYS43stUFABQcPUmqrBOUapVLC88KxVgIlVtv6ioerpMMun3CbtrmV4IgWVAGrZnvv82dJ71dHo5Uve/1evcJEUAxTWDLhY8NHiRBp85DEFUEzqUAhl9gEVaQVXiNfQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787192; c=relaxed/simple;
	bh=OyUwtP+F8rqawXXM2NmA1DciluZKmKarOeZEnApfhR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grq9f0sxB8ZlKB5aFMhGwfAbAmYWDIfg08gobxf5iBb1E7Q6pZ9A3xQGmm9qgXgSiTFIfK7Txm7YVO0DUV9mfzxX/5RmOLmMSp5DrEP+0K7NWK0M8AqbniJ2HRDQOucW4DjRxevebdKvfzqDuh45/6n4STrjbBebZyVJxDQVeDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9F2tZDb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9F2tZDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304F91F000FF;
	Wed, 30 Sep 2026 16:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787191;
	bh=frFt3A76uZ5lotnCEv5nMZr9NYFCTVpQTdOqI0f8fgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9F2tZDbKLz55SKLYGLEAQaQDTFf6c/ZG451JoRwqiG1yAN9rQ5B3PD4W1NQ/jmZF
	 nZP5b5yyt9AoamJm6MrGQRoWPI14b96FEYDBvfLjI0TNM2Sk7S8xAk6DzzMxm8JfSy
	 0SoxbJPgqUR3hHS/riHhurWIlQcJpraCEuwQWPXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 143/457] net: spacemit: clear TX descriptor on fragment mapping failure
Date: Wed, 30 Sep 2026 17:24:08 +0200
Message-ID: <20260930152349.140075655@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Bilal <meatuni001@gmail.com>

[ Upstream commit 2d14720beb58870b15a52b236c3ab0be0e06e915 ]

emac_tx_mem_map() writes TX_DESC_0_OWN into the ring descriptor for
every slot beyond old_head as soon as that slot's memset()'d local
copy is committed with "*tx_desc_addr = tx_desc", i.e. before the
buffers for that slot have necessarily all been mapped successfully.
If emac_tx_map_frag() then fails on a later fragment, the err_free_skb
path calls emac_free_tx_buf() to unmap and drop the skb, but leaves
the already-written descriptor memory untouched, and tx_ring->head is
never advanced past old_head (the "tx_ring->head = head" store is
skipped by the goto).

So a slot between old_head and the rolled-back head can be left with
TX_DESC_0_OWN set and buffer_addr_{1,2} pointing at DMA mappings that
emac_free_tx_buf() just tore down, while software considers that slot
free again. The next successful emac_tx_mem_map() call only rebuilds
old_head itself; if the DMA engine auto-advances into the following
descriptor once it finishes old_head's packet, it will fetch that
stale, already-unmapped address.

emac_tx_clean_desc() already treats emac_free_tx_buf() and clearing
the descriptor as a pair when reclaiming completed descriptors; do
the same in the mapping failure path.

Fixes: bfec6d7f2001 ("net: spacemit: Add K1 Ethernet MAC")
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Reviewed-by: Vivian Wang <wangruikang@iscas.ac.cn>
Reviewed-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Link: https://patch.msgid.link/20260919191937.271202-1-meatuni001@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/spacemit/k1_emac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/spacemit/k1_emac.c b/drivers/net/ethernet/spacemit/k1_emac.c
index f7f16397a2c2a..d641ac26a1e86 100644
--- a/drivers/net/ethernet/spacemit/k1_emac.c
+++ b/drivers/net/ethernet/spacemit/k1_emac.c
@@ -803,6 +803,9 @@ static void emac_tx_mem_map(struct emac_priv *priv, struct sk_buff *skb)
 	while (i != head) {
 		emac_free_tx_buf(priv, i);
 
+		tx_desc_addr = &((struct emac_desc *)tx_ring->desc_addr)[i];
+		memset(tx_desc_addr, 0, sizeof(*tx_desc_addr));
+
 		if (++i == tx_ring->total_cnt)
 			i = 0;
 	}
-- 
2.53.0



