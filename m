Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7366A14AD19;
	Mon, 16 Sep 2024 12:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488156; cv=none; b=KiWF0jCmCYqFXV6AZLub2vSpLXJuc5qfjMwsU65E11rYl66Rvp5CAJ1LJboAIOhD+oPwUwXNyvbsnvg/Ab+qTESFWauMuQLGIn9cOaXG4MoR/o8NsZsDtOdmpFrhSN4Szn1nWKjT1beFFFgMOP6ew+XkDsCCwApvHP0PvyB9mU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488156; c=relaxed/simple;
	bh=W5eE0wdm3UeykaEwnGzKBngCs6o78fifZIxSt5m1+wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccov/d/r7C6QObeFv/SFzsmzR1A79yaeFV/E7SY8YUMYUvIfy+kcR/dvesuFbXm3j78zKzE/A0gdWM8t8MvHGL+novldPtNHsGfmGZGqUq2kDOM4BWtqw9efn1JmhBcOwmmW6LZnzEQV4CkX62rL9wLWzOfytASnR5Ojce+bQEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfOoRkff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfOoRkff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BFBC4CEC4;
	Mon, 16 Sep 2024 12:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488156;
	bh=W5eE0wdm3UeykaEwnGzKBngCs6o78fifZIxSt5m1+wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mfOoRkff7kaaTDxs6KL3lpONNZE4LV06PPKThT44JAdIV9S0U3U0JTGWEnwvfLI66
	 5oRDab053MSD9aLH9pQnYz9iwHGc5mjS0mlPMII5gmSnmZVjV4qD3mhjK0Y1VemrhL
	 CUJflwzY20fnyEErdpQ75J9ogPWL+HTNVrYMnYXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Felix Fietkau <nbd@nbd.name>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 015/121] wifi: mt76: mt7921: fix NULL pointer access in mt7921_ipv6_addr_change
Date: Mon, 16 Sep 2024 13:43:09 +0200
Message-ID: <20240916114229.430535333@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3e3ad3518d85..cca7132ed6ab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -1182,7 +1182,7 @@ static void mt7921_ipv6_addr_change(struct ieee80211_hw *hw,
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



