Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04F8194A45;
	Tue, 27 May 2025 17:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366704; cv=none; b=kntqOhxSxpFQLPr/7xzff99y8CYnb05eg40fvt3a0aF9R7YPYCxH4NaeOC1bWgvGWJ/HgjLjtvPoSYKUcQB/YbkhTNGFi4YwmkKfkfG5c0olKnIay4x8e/TDP2Wj7BSCGMgLWAm0GeZSQJhFKUGW98gx/B3neHgSqnPbCpMB2Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366704; c=relaxed/simple;
	bh=c2mnlqn0XJ/wMGyCd2Cp6ZpXvtAgnrQCrJ9MKmcHDXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHk15NP/F8OXo+xjL4FoKWb+4RPqdDo5bMusZ3hBfJDQcxWUpLPQiccFPDIX+SnX2Bo+SQFjtnqL5mrYnZBIaT8RSic9CDiaxGbq6VTQXrhI0yq1HbC6yKkdNmJmkoF/yZ3wUTP6+1NBdrKHm/UOKDM03g2VKLBXuXNJt5KfUa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DbchZORB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DbchZORB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C29C4CEE9;
	Tue, 27 May 2025 17:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366704;
	bh=c2mnlqn0XJ/wMGyCd2Cp6ZpXvtAgnrQCrJ9MKmcHDXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DbchZORB2olLWLuF6wiKUv6rscm9zZjgITwXk+oMTNxZJw/7aCI7wpo+EtGcAbMtX
	 7jmsY0r7X6gLaCNN78kFEJGFT8AtYCjDDYj14Jh164Mfs0fuE9qoLMpvu/Rq92n47Q
	 eYFqQUc4mRLHLn72L7Z46fa2q6ShQCE2dCIitB+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 114/783] wifi: mt76: scan: fix setting tx_info fields
Date: Tue, 27 May 2025 18:18:31 +0200
Message-ID: <20250527162517.793904471@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 5b5f1ca9ce73ab6c35e5cd3348f8432ba190d7f4 ]

ieee80211_tx_prepare_skb initializes the skb cb, so fields need to be set
afterwards.

Link: https://patch.msgid.link/20250311103646.43346-8-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/scan.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index 1c4f9deaaada5..9b20ccbeb8cf1 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -52,11 +52,6 @@ mt76_scan_send_probe(struct mt76_dev *dev, struct cfg80211_ssid *ssid)
 		ether_addr_copy(hdr->addr3, req->bssid);
 	}
 
-	info = IEEE80211_SKB_CB(skb);
-	if (req->no_cck)
-		info->flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
-	info->control.flags |= IEEE80211_TX_CTRL_DONT_USE_RATE_MASK;
-
 	if (req->ie_len)
 		skb_put_data(skb, req->ie, req->ie_len);
 
@@ -64,10 +59,20 @@ mt76_scan_send_probe(struct mt76_dev *dev, struct cfg80211_ssid *ssid)
 	skb_set_queue_mapping(skb, IEEE80211_AC_VO);
 
 	rcu_read_lock();
-	if (ieee80211_tx_prepare_skb(phy->hw, vif, skb, band, NULL))
-		mt76_tx(phy, NULL, mvif->wcid, skb);
-	else
+
+	if (!ieee80211_tx_prepare_skb(phy->hw, vif, skb, band, NULL)) {
 		ieee80211_free_txskb(phy->hw, skb);
+		goto out;
+	}
+
+	info = IEEE80211_SKB_CB(skb);
+	if (req->no_cck)
+		info->flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
+	info->control.flags |= IEEE80211_TX_CTRL_DONT_USE_RATE_MASK;
+
+	mt76_tx(phy, NULL, mvif->wcid, skb);
+
+out:
 	rcu_read_unlock();
 }
 
-- 
2.39.5



