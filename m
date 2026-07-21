Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A400F46C4A7;
	Tue, 21 Jul 2026 15:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649467; cv=none; b=snSUBk8zNG7Fo8phwH3go7DPfkqpof365inrySm0zDeN37u7tqd1yY6b/fr5RIYiVIfsE//yT0MYfnEnt2tdV/JzbZzx+ty07WMziTKqX2Ojv26Xrr8Gjyh0WJV6niekHGC0iU6U5K5QQlcDf2CQ+mFL+71QqLqDnFyaQdY97yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649467; c=relaxed/simple;
	bh=4HDLnOgKdnFgu9mY3vEFlQelJDlc39W9YAhjtaA5Hww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbQeBi/QvUjsxPGnkJtTE7+Cm3u1XJzaohj6r9vSXGSfznyen3kQ111eyQI12TfiVIx0Cs6830znI/QsEJmS24ceNpxRml6Su9eHfNML2OBhi4fHBvg7rgG8sNQaW98kjkOYMju8nrWoIo7BTDKA+m8rQxYp8aVW20LMJUPU2J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xg0Er0x7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xg0Er0x7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0C41F000E9;
	Tue, 21 Jul 2026 15:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649466;
	bh=GoBdX0Mr+Ewh+OPeldG2D96nqWNO657WFAtCN93MkLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xg0Er0x7FNoafdX10XwRWQECR/P3yh7TQZXfKkzB+6NhLkJBP/are+YKw0LokoWO8
	 4WOS8gmcQXqXVZ+CXJRxVciGkZiMUsV1fVKhvmBv2B7BIKExMna8WO/hsU7mnC7j0z
	 I+fMv1P35ewxJILi7+a+hJ4rorpveADarMfdaIrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0587/2077] wifi: mt76: mt7996: Fix possible token leak in mt7996_tx_prepare_skb()
Date: Tue, 21 Jul 2026 17:04:20 +0200
Message-ID: <20260721152606.657272487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index e2a83da3a09c0a..09df505ee5a77e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1067,11 +1067,11 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 
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
@@ -1176,6 +1176,10 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	tx_info->nbuf = MT_CT_DMA_BUF_NUM;
 
 	return 0;
+
+error_release_token:
+	mt76_token_release(mdev, id, NULL);
+	return -EINVAL;
 }
 
 u32 mt7996_wed_init_buf(void *ptr, dma_addr_t phys, int token_id)
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 22f9690634c942..f96d9c47185354 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -933,7 +933,7 @@ mt76_token_release(struct mt76_dev *dev, int token, bool *wake)
 #endif
 	}
 
-	if (dev->token_count < dev->token_size - MT76_TOKEN_FREE_THR &&
+	if (wake && dev->token_count < dev->token_size - MT76_TOKEN_FREE_THR &&
 	    dev->phy.q_tx[0]->blocked)
 		*wake = true;
 
-- 
2.53.0



