Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E311547F5;
	Mon, 16 Sep 2024 12:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488602; cv=none; b=dDKGjKXWL8xQBcaVbUMd66YiYuYFjatW5g1jXmj+lwHhrnvWPWDZDoUg4nbrjCp7duTG0OrluhOJDGlOI7TB8/QTvkMs8AvnnPGhOeSiDygsbHM4gwtXxOb18KV+GR1dwXSjXjxF8WxBdtrYatZBlWzohBo58i+By/ds9PO7QqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488602; c=relaxed/simple;
	bh=/LuoSL5w9LRmRK4ek5+e8xZrRhzDVG/MYgiij2w9SFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LT2aOqVVC18pfrKWvqYst3l+zpsoCzvNJTd3RO1kLunyer6F7lQM5aEkfeuTBe7DKv1Nru6EhXAJSrdqy0TpjFXQI+gvvIkLILKSKw5L3c0tRKW7y1iebVoU2ytYUTptBvnjph5eKmEZdx8s8yJ7+BsD0POD8ouyEK0zNEa5O7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIv6kZTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIv6kZTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F0FC4CECF;
	Mon, 16 Sep 2024 12:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488601;
	bh=/LuoSL5w9LRmRK4ek5+e8xZrRhzDVG/MYgiij2w9SFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIv6kZTyKS8ojeZNHV46lmqcRpQ1jGFKUnLu5wRXtnudCNkM0CvjUrnZnsSXW9EEg
	 ut0YaiPVLWvtFpjlKb31otcxeMg6tFWa9Rd+xAI+W3aa1UQD6yle45vmSXUZu3LnaD
	 CiIiQVbmuKQr7oxb7/GoCmjNCxfbVrDgkJrFsSso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Felix Fietkau <nbd@nbd.name>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 21/91] wifi: mt76: mt7921: fix NULL pointer access in mt7921_ipv6_addr_change
Date: Mon, 16 Sep 2024 13:43:57 +0200
Message-ID: <20240916114225.221567327@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bert Karwatzki <spasswolf@web.de>

[ Upstream commit 479ffee68d59c599f8aed8fa2dcc8e13e7bd13c3 ]

When disabling wifi mt7921_ipv6_addr_change() is called as a notifier.
At this point mvif->phy is already NULL so we cannot use it here.

Signed-off-by: Bert Karwatzki <spasswolf@web.de>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20240812104542.80760-1-spasswolf@web.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 6a5c2cae087d..6dec54431312 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1095,7 +1095,7 @@ static void mt7921_ipv6_addr_change(struct ieee80211_hw *hw,
 				    struct inet6_dev *idev)
 {
 	struct mt792x_vif *mvif = (struct mt792x_vif *)vif->drv_priv;
-	struct mt792x_dev *dev = mvif->phy->dev;
+	struct mt792x_dev *dev = mt792x_hw_dev(hw);
 	struct inet6_ifaddr *ifa;
 	struct in6_addr ns_addrs[IEEE80211_BSS_ARP_ADDR_LIST_LEN];
 	struct sk_buff *skb;
-- 
2.43.0



