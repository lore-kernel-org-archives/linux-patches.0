Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4153218DF89;
	Sun,  7 Sep 2025 20:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277092; cv=none; b=Wt9YB0GnMSd5ENKL9q8Xec1Un01xES1OGEAp8aEXrgJr8yt3NUoGhIpeUK1OTQrOThPFVRT5jg3ng/1HwoQ6cNVXSsJ97t3cVBypjnkEygk4j4wbhFoOzvB5e3GV5fjYWtP336oeUR8Gy3kdDJUDmJszV27pleUZKyRHaEw/Gjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277092; c=relaxed/simple;
	bh=W73gOe4m2GCpThBVPwzmDO7DUBY+XqgUYBGtCFaEVqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQFxyHA2MxIB32Q7tHVQVaw0+f/EU6/gTk+ROM3ngOBjJWjlvGZ4h32KdtPaqln5uZciaJVcsmy2tXaTNHuC1zhq1jQ16Oic2/V/AJronml8hUvPr0+TgFcxERq5Ylf0pshpBo7qGixJyijz502OVbYUwVirRJXBGyH5xOFZiYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gW7y+Cty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gW7y+Cty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919FBC4CEF0;
	Sun,  7 Sep 2025 20:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277092;
	bh=W73gOe4m2GCpThBVPwzmDO7DUBY+XqgUYBGtCFaEVqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gW7y+CtyUpfZvySuttHVuTIW89b2DfhwqTdb+TE9SBKxl+B3CXQ7HWeNUYkV8xSB0
	 CyIf7dLj3ZT3jJSUTRUzXQV23jvvzhHsPWTsEzN+O94/6iQ5LY3nc2sx3DplWNBLwK
	 arWT0IEgNOxZ1eBOBsbBh8kb34ehLJphlwM/qDTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad.monroe@adtran.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/175] wifi: mt76: prevent non-offchannel mgmt tx during scan/roc
Date: Sun,  7 Sep 2025 21:57:11 +0200
Message-ID: <20250907195615.708506062@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 4c2334587b0a13b8f4eda1336ae657297fcd743b ]

Only put probe request packets in the offchannel queue if
IEEE80211_TX_CTRL_DONT_USE_RATE_MASK is set and IEEE80211_TX_CTL_TX_OFFCHAN
is unset.

Fixes: 0b3be9d1d34e ("wifi: mt76: add separate tx scheduling queue for off-channel tx")
Reported-by: Chad Monroe <chad.monroe@adtran.com>
Link: https://patch.msgid.link/20250813121106.81559-2-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 065a1e4537457..5e081972bf445 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -334,6 +334,7 @@ mt76_tx(struct mt76_phy *phy, struct ieee80211_sta *sta,
 	struct mt76_wcid *wcid, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct sk_buff_head *head;
 
 	if (mt76_testmode_enabled(phy)) {
@@ -351,7 +352,8 @@ mt76_tx(struct mt76_phy *phy, struct ieee80211_sta *sta,
 	info->hw_queue |= FIELD_PREP(MT_TX_HW_QUEUE_PHY, phy->band_idx);
 
 	if ((info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) ||
-	    (info->control.flags & IEEE80211_TX_CTRL_DONT_USE_RATE_MASK))
+	    ((info->control.flags & IEEE80211_TX_CTRL_DONT_USE_RATE_MASK) &&
+	     ieee80211_is_probe_req(hdr->frame_control)))
 		head = &wcid->tx_offchannel;
 	else
 		head = &wcid->tx_pending;
-- 
2.50.1



