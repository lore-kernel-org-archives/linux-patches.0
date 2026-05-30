Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A074481DD;
	Sat, 30 May 2026 17:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160825; cv=none; b=GL357lByaPhFdVEqVIw08N/VfVglhIdRKaQVjfwjEb/7qlIxLhdK2CdvFauVwvypDbf5P6PILBagbcyD+ko9L7C6XORhJN6pZ83t42wJ5KkqfSbRLnutLcRVnKJrMjEyCQJKymFe8Q1zYtt68QJ3P4gZZ5vL6jAM5o13+onZQp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160825; c=relaxed/simple;
	bh=THYi1h6wOv3PTkw2fQy8hAAW8geWlSrb1ycMM3944xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHKPlQBFK9G1ZcapVmzoUzSljd0gLzs0QSth5ElMsthaCIYYm2F80iAc0b9eeq0rIvWkDE7bw0UZKGJfjLY5Sbk/XhFglHbjuPnuTmFTMzs+DEPO669ITnuYx1rFgRce45kgiHV2zG2sOAWRz+G82axtwDaNpqIfFgo4AIDIXp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zsUZayTr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zsUZayTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1531F0089F;
	Sat, 30 May 2026 17:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160824;
	bh=6KcXKhYhLglromLpnxu6wdB7hnu9LXIqbgUuYONRN1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zsUZayTrKfLt94oPiR5OiNdGDppFMrXmphAtbP8tEZtmBgUKiW3N83+7yS80eIF9u
	 hmB3jm9zO6GoQ0CleRHylv7rx1MwgT3G9IvJr8i/tDAXkKOF2p5vscEzfLCUcIlTXj
	 pR8wbDFkonIsxK/NSTPT7YMNFF8fQUMbo3F0h6Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 446/969] wifi: mwifiex: Fix memory leak in mwifiex_11n_aggregate_pkt()
Date: Sat, 30 May 2026 17:59:30 +0200
Message-ID: <20260530160312.591338416@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 990a73dec3fdc145fef6c827c29205437d533ece ]

In mwifiex_11n_aggregate_pkt(), skb_aggr is allocated via
mwifiex_alloc_dma_align_buf(). If mwifiex_is_ralist_valid() returns false,
the function currently returns -1 immediately without freeing the
previously allocated skb_aggr, causing a memory leak.

Since skb_aggr has not yet been queued via skb_queue_tail(), no other
references to this memory exist. Therefore, it has to be freed locally
before returning the error.

Fix this by calling mwifiex_write_data_complete() to free skb_aggr before
returning the error status.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
Link: https://patch.msgid.link/20260119092625.1349934-1-zilin@seu.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/11n_aggr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
index 34b4b34276d6d..042b1fe5f0d67 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
@@ -203,6 +203,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 
 		if (!mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
 			spin_unlock_bh(&priv->wmm.ra_list_spinlock);
+			mwifiex_write_data_complete(adapter, skb_aggr, 1, -1);
 			return -1;
 		}
 
-- 
2.53.0



