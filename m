Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943DA3375C5;
	Tue, 16 Jun 2026 15:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622958; cv=none; b=aku5R2YUSk+0UQpClqF/RpvCwGdYxpuUWj580iGJ+iqtcAmbWeCyOZdur12zjjG5RRbwkyAoC3LYPjk6kB6zJTa8qzNvZ4vqcPg2id1IYBPpLYnWKDrEmyZJtSvMpNiJ0GzNVKX2SNUFePWNfGLCpZsw3pg1jY8GE/w5xGq9UXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622958; c=relaxed/simple;
	bh=ZrED/UQgng1NfPe1EisptLl6oayTsxpCb6b77PN1TZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjjqXnrr15oN4UlZTvxcuffunbQOiDw912d2+IQdp62b1ayKC/1a5KwHz/ysUk8D6pqH+0KFdJoJhhaTAtexP3MJAm1DIPzQM8izV+dt3JTFwuwtLQrfftf0+B/SxAHDAVLWLSooP+gJiaQbAJQySFzxmzvas5BRmi3rRH3P5SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B481z0xR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B481z0xR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D86E1F00A3A;
	Tue, 16 Jun 2026 15:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622957;
	bh=qmlIwR7VIJi7uIihCaVfco7STA+ilIhtfUAVs81vY9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B481z0xROhGIRUQrIZ3iEWZk+nWR9YSiQuzY5cliFEt2m3P2eGUfp4zF4ElU9fssg
	 KonOdAlIT6pWC+F6eNF+1j1L1Vx6wuCs2ej/O38FJvvXhcBihSeCq28ZIweSUg3c5d
	 87wAqbXdO4vO06eRHiLMacC3Lx7o6IHIzW9pWpPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 061/378] net: ethernet: mtk_eth_soc: Fix use-after-free in metadata dst teardown
Date: Tue, 16 Jun 2026 20:24:52 +0530
Message-ID: <20260616145113.205096583@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 80df409e1a483676826a6c66e693dba6ac507751 ]

mtk_free_dev() calls metadata_dst_free() which frees the metadata_dst
with kfree() immediately, bypassing the RCU grace period.
In the RX path, skb_dst_set_noref() sets a non-refcounted pointer from
the skb to the metadata_dst. This function requires RCU read-side
protection and the dst must remain valid until all RCU readers complete.
Since metadata_dst_free() calls kfree() directly, a use-after-free can
occur if any skb still holds a noref pointer to the dst when the driver
tears it down.
Replace metadata_dst_free() with dst_release() which properly goes
through the refcount path: when the refcount drops to zero, it schedules
the actual free via call_rcu_hurry(), ensuring all RCU readers have
completed before the memory is freed.

Fixes: 2d7605a72906 ("net: ethernet: mtk_eth_soc: enable hardware DSA untagging")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260602-airoha-mtk-metadata-uaf-fix-v1-2-3aaa99d83351@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 796f79088f3662..2eca2b2a964fef 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4469,7 +4469,7 @@ static int mtk_free_dev(struct mtk_eth *eth)
 	for (i = 0; i < ARRAY_SIZE(eth->dsa_meta); i++) {
 		if (!eth->dsa_meta[i])
 			break;
-		metadata_dst_free(eth->dsa_meta[i]);
+		dst_release(&eth->dsa_meta[i]->dst);
 	}
 
 	return 0;
-- 
2.53.0



