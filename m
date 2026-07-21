Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FED471260;
	Tue, 21 Jul 2026 17:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656493; cv=none; b=JCqrAAA/Mh+4sj6mqclpVP4fPo0b8PGS711x+Lgwz8VFHnO42euE+/5WDBYn1j05rQ80TPxiRbm7Ixf0op01cI4+QApdWjChcRn+S3bP6ox7knlETrGoXVEU0INyplw5XKWnEIC/k4fD2IcIdfH4BFZ6LcG7rSlHi1HmfXS7d0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656493; c=relaxed/simple;
	bh=R6aqQlYzlmhg/hcVpBEhv9yuzV6WpVZh9drbQBzHFDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvWrYKOdgn2i4/nZ0KFQ1MgZ8CMnCdDh3yn0Louao/PvQR8S8fVXfTNrpIGpLpx82SxFJI6krMkSs625z3/W++HT1uXq7PGpZCsJa+1JNkVHmq8TMjEgZgakyVmkJGg72+WXdKKWBA0+4X7v139pn6fFQpppCV8aeE7bB6qZmi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ht9Yr8j2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ht9Yr8j2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE951F000E9;
	Tue, 21 Jul 2026 17:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656492;
	bh=DGRjzY7wriBq+cOmxwEOOxHEYQt02OUe/HLrZc9x8Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ht9Yr8j2TP37EL+Iy9uPR+MUxC5V/nOft3PhEdOQzPySsl3LXsHlNu5W3UrSxnbQp
	 5NbJuWdye6fziyaf7HTSCHBXtw9OquGRnhx+zV2PoV020LZtEnymmG9Z8lq1B0cM3b
	 XRt5mNaLUDMe9/d5a0ZEec069CQEOMB53vxg6SJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0407/1611] wifi: mt76: mt7996: Fix possible token leak in mt7996_tx_prepare_skb()
Date: Tue, 21 Jul 2026 17:08:43 +0200
Message-ID: <20260721152524.400524123@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 831074096d0450308357271fc0ffd3f600a2487e ]

If link_conf or link_sta lookup fails in mt7996_tx_prepare_skb routine,
mt7996 driver leaks an already allocated tx token. Fix the issue
releasing the token in case of error.

Fixes: 7ef0c7ad735b0 ("wifi: mt76: mt7996: Implement MLD address translation for EAPOL")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260531-mt7996_tx_prepare_skb-token-leack-v1-1-2b9c9f59ceb1@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 8 ++++++--
 drivers/net/wireless/mediatek/mt76/tx.c         | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 149d8d711fc4c4..989cf23f11142a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1106,11 +1106,11 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 
 		link_conf = rcu_dereference(vif->link_conf[wcid->link_id]);
 		if (!link_conf)
-			return -EINVAL;
+			goto error_release_token;
 
 		link_sta = rcu_dereference(sta->link[wcid->link_id]);
 		if (!link_sta)
-			return -EINVAL;
+			goto error_release_token;
 
 		dma_sync_single_for_cpu(mdev->dma_dev, tx_info->buf[1].addr,
 					tx_info->buf[1].len, DMA_TO_DEVICE);
@@ -1215,6 +1215,10 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	tx_info->nbuf = MT_CT_DMA_BUF_NUM;
 
 	return 0;
+
+error_release_token:
+	mt76_token_release(mdev, id, NULL);
+	return -EINVAL;
 }
 
 u32 mt7996_wed_init_buf(void *ptr, dma_addr_t phys, int token_id)
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index b78ae6a34b658b..9fb0cca5524a45 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -903,7 +903,7 @@ mt76_token_release(struct mt76_dev *dev, int token, bool *wake)
 #endif
 	}
 
-	if (dev->token_count < dev->token_size - MT76_TOKEN_FREE_THR &&
+	if (wake && dev->token_count < dev->token_size - MT76_TOKEN_FREE_THR &&
 	    dev->phy.q_tx[0]->blocked)
 		*wake = true;
 
-- 
2.53.0



