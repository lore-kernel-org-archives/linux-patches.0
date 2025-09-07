Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8D1269CE6;
	Sun,  7 Sep 2025 20:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277497; cv=none; b=tvhcGQWFzidjHRQID5BeIPWZMuaFEtWwb2a4Kae76NS8CaEaGabgTZNvFYF+P+98zNC6mpkA3WgiOIADjbjJsNTgJZXaHcCTO1482b4fDs5siCQhmM0QrsHp9J16q8q2SuENvEv6JmGeeLl5Q7qC4xxekblFEi0bknulV9vOeSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277497; c=relaxed/simple;
	bh=3dXzWXuGELxDotgHvglIGULrjJiuxpvCEnz2oC8U3Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U99PhjLNM0OHIorT32IFcQnH7/5o5w3tGjjjErcbFyEqnX9VXIH2TrWQVx3JLlqf+yQwQ/bW6eW6I48RZBNR3iHcB78kbOv/OUtLsRw6qlAu3OrPbzmbxAWxDb9C7M0RCOJj7RRqg6X58C/CSbOg+pEHohU1UBIxAX0O9QAVTOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cowYLTYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cowYLTYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C750FC4CEF0;
	Sun,  7 Sep 2025 20:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277497;
	bh=3dXzWXuGELxDotgHvglIGULrjJiuxpvCEnz2oC8U3Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cowYLTYFgy9iG6n1N4QYVxeG/ljG8vZjBlSzHQ1RSRTaHfelWfA71GnqS9o7fw/nl
	 l+21vOQTzoeiJTt8wv2lqLT3gJUTqxBIE2OHMsEXWXO9hxH9XUzH2+AiN8DPkDWxXZ
	 zFEXFoOtGNG2kwvbFLn+2NS58ikekuZ7R7ELNw+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Monroe <chad.monroe@adtran.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 034/183] wifi: mt76: prevent non-offchannel mgmt tx during scan/roc
Date: Sun,  7 Sep 2025 21:57:41 +0200
Message-ID: <20250907195616.583419282@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index e6cf16706667e..03b042fdf997f 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -332,6 +332,7 @@ mt76_tx(struct mt76_phy *phy, struct ieee80211_sta *sta,
 	struct mt76_wcid *wcid, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct sk_buff_head *head;
 
 	if (mt76_testmode_enabled(phy)) {
@@ -349,7 +350,8 @@ mt76_tx(struct mt76_phy *phy, struct ieee80211_sta *sta,
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



