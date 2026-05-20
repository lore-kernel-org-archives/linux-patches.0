Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB1B29B8D3;
	Wed, 20 May 2026 16:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294657; cv=none; b=BS0Jr/8TewoWD+zkbPqP4CX7Jh9g9d7qTKKV09X2hOgECvEgFMpOPnXnhTwvs8xJmD55NEvlw8rrkIqyvYXJ04PJzjftuP/zeoiSDUypAPsHF116IZ7aTJgy+z1B1Et505GvJtPBeoPnHyhaPdMkMxzRNXvXBmTtGMp2uGMYXIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294657; c=relaxed/simple;
	bh=fC2NpJdxP3KO5sHGXtsO8FHdzPVZxw54qwzZfBYCgNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQJWqfRmiGz5sm5cwE4wt9Gsr+38RhhOUv5ijOX2flXNWOa/2x4riHpC6H90ZZGu8DhYhQJdvZdmuKb+oQsqTPZ3QVY8RKCZcfwkJ8m2bX7UTE6De7IkIOzOvvS+t4XmrjL3cVaQBMi34wAKnDF8ruFFrOdaWq25RLDTXqHITWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVXt1OkZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVXt1OkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613941F000E9;
	Wed, 20 May 2026 16:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294655;
	bh=EPQRVjN/Um3Ul48s/+JXe9AABX+o0PCrezEv7pV2ACY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVXt1OkZ+nAgS7fNdUTvNEYtgwxpPfp0cOp4KEdK4goaNwaa5asCSYuK0sjtYLs70
	 1bNBlHoBtStXyyry4GMCLrFYRWFmslhzLzKpuer7RE+hGs7WeqpoytpUPFVEsR8SB4
	 LonivV5kksn6jk8XgYMZL9AEOseuNABwUu9kWlBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0120/1146] wifi: mt76: mt7996: fix wrong DMAD length when using MAC TXP
Date: Wed, 20 May 2026 18:06:10 +0200
Message-ID: <20260520162151.049912202@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Shayne Chen <shayne.chen@mediatek.com>

[ Upstream commit 97b9f9831bf297f3ffa62018721601ed2736f2c3 ]

The struct mt76_connac_fw_txp is used for HIF TXP. Change to use the
struct mt76_connac_hw_txp to fix the wrong DMAD length for MAC TXP.

Fixes: cb6ebbdffef2 ("wifi: mt76: mt7996: support writing MAC TXD for AddBA Request")
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20260203155532.1098290-1-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 7fa15b374ed49..5797412962b85 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1139,10 +1139,10 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	 * req
 	 */
 	if (le32_to_cpu(ptr[7]) & MT_TXD7_MAC_TXD) {
-		u32 val;
+		u32 val, mac_txp_size = sizeof(struct mt76_connac_hw_txp);
 
 		ptr = (__le32 *)(txwi + MT_TXD_SIZE);
-		memset((void *)ptr, 0, sizeof(struct mt76_connac_fw_txp));
+		memset((void *)ptr, 0, mac_txp_size);
 
 		val = FIELD_PREP(MT_TXP0_TOKEN_ID0, id) |
 		      MT_TXP0_TOKEN_ID0_VALID_MASK;
@@ -1161,6 +1161,8 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 				  tx_info->buf[1].addr >> 32);
 #endif
 		ptr[3] = cpu_to_le32(val);
+
+		tx_info->buf[0].len = MT_TXD_SIZE + mac_txp_size;
 	} else {
 		struct mt76_connac_txp_common *txp;
 
-- 
2.53.0



