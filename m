Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025759;
	b=gOY/b/rOIXLuc/JvbVkQjEquBcZWtHX7EUqhOQXXMQB/nmja8gBMLyX6VEDBXMf0OEP/
	 eQo6lwL7blZrF2EN0Xjw70n3MejIS0ygw/fAZYD29cFPx4sV2ZXo1gM79zHgj8tS3wXqa
	 +llDkPJeXjN1ufAqBQn7aP8zL2NiJ5AUv3/ZAxTFoS9xczbLwXcRHOV7KJyaL6DsiTL9X
	 efkVsQR9Rk/TNRWfSXuAzer24f/1BfzVwn6Ogh/kjUoeD7VRf1DG9HJYghXHi1GFtm249
	 N9bd1PR/UaTzDguBqMvW+M2j4qiNFt0qggnbiOvY8unO6N5d1bYDvHKllzmgp7LARRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wAQmR4Kb17WXdHdOviR0ajchyjQ1rlM+t1mZjgJhkXU=;
	b=mBMus/rewF5a+FJVamHw3+vS59iirMMOK8U3SzjZeX25CsrjDrEYYnILwKyLhW0879IF
	 Hrt3xNvV3JXHTAE21VH2wNFSa1KLR0rlqqZf6TauxOh5S9Le00g1ygPgYF4DkCiTLTpXd
	 v/6Wth7B9hHqnGbaCEonENc1AQOn2YZdxoqcEy0SsbV024QmExr14c8z2pu5N4pjTLEn8
	 2FLmmr6BW0EC7JaFvgrbzBL/MqvkdDm0yuqNDHLXeNlG0kelh7jTzlEL9Qs0LpS74LRAF
	 nu9NnnuH7LXKT8ve1FtpANVK0i6G+UsS4u8qfHDlIqZ6c2fvqDeW9M+kirDcCLvXC8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LXN7DUVg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B781B606A31C;
	Wed, 18 Nov 2026 18:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LXN7DUVg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107961F000C5;
	Wed, 18 Nov 2026 18:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025759;
	bh=wAQmR4Kb17WXdHdOviR0ajchyjQ1rlM+t1mZjgJhkXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LXN7DUVgubiEpilz/OssDAhvBMwS8D0idffuQLm8RGj6KQM19Ul55LhfONr7W0kS3
	 bMfVyhwfFAQh3iJgbWOyZokTcyDkbQIjjniRThgqBqbw6EZJVXB+OihHyePWI9/lJv
	 o9s6D/aQ5rQjM7akYfGCWix2U+jYPnr9hWTvY1Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1191/2151] wifi: mt76: optimize ROC for same-channel case
Date: Wed, 18 Nov 2026 15:48:46 +0100
Message-ID: <20261118150205.607629955@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit f72dd74dd0b69e3a87b4702f3c860e9a7318d5dd ]

mt76_remain_on_channel() always creates an HT20 chandef and goes
offchannel, even when the ROC channel matches the operating channel.
This unnecessarily narrows bandwidth and triggers beacon stop/restart.

When the ROC channel matches the current operating channel, preserve
the full chandef and skip the offchannel transition, matching the
optimization already present in the scan code.

Extract the shared same-channel detection into mt76_offchannel_chandef()
and use it in both ROC and scan paths.

Link: https://patch.msgid.link/20260309060730.87840-6-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 3aaa4871006d ("wifi: mt76: clear offchannel state if a scan has no channel to restore")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/channel.c |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76.h    | 12 ++++++++++++
 drivers/net/wireless/mediatek/mt76/scan.c    |  6 +-----
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/channel.c b/drivers/net/wireless/mediatek/mt76/channel.c
index 08c910bd835f2..286a98fae760b 100644
--- a/drivers/net/wireless/mediatek/mt76/channel.c
+++ b/drivers/net/wireless/mediatek/mt76/channel.c
@@ -395,8 +395,8 @@ int mt76_remain_on_channel(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mlink->mvif->roc_phy = phy;
 	phy->roc_vif = vif;
 	phy->roc_link = mlink;
-	cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_HT20);
-	ret = __mt76_set_channel(phy, &chandef, true);
+	ret = __mt76_set_channel(phy, &chandef,
+				 mt76_offchannel_chandef(phy, chan, &chandef));
 	if (ret) {
 		mlink->mvif->roc_phy = NULL;
 		phy->roc_vif = NULL;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 9542c4fbdee23..7de5e5f19a66a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1781,6 +1781,18 @@ void mt76_queue_tx_complete(struct mt76_dev *dev, struct mt76_queue *q,
 			    struct mt76_queue_entry *e);
 int __mt76_set_channel(struct mt76_phy *phy, struct cfg80211_chan_def *chandef,
 		       bool offchannel);
+
+static inline bool
+mt76_offchannel_chandef(struct mt76_phy *phy, struct ieee80211_channel *chan,
+			struct cfg80211_chan_def *chandef)
+{
+	cfg80211_chandef_create(chandef, chan, NL80211_CHAN_HT20);
+	if (phy->main_chandef.chan != chan)
+		return true;
+
+	*chandef = phy->main_chandef;
+	return false;
+}
 int mt76_set_channel(struct mt76_phy *phy, struct cfg80211_chan_def *chandef,
 		     bool offchannel);
 void mt76_scan_work(struct work_struct *work);
diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index 2faa84c516e7b..69a6b793b1fcc 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -142,11 +142,7 @@ void mt76_scan_work(struct work_struct *work)
 	}
 
 	dev->scan.chan = req->channels[dev->scan.chan_idx++];
-	cfg80211_chandef_create(&chandef, dev->scan.chan, NL80211_CHAN_HT20);
-	if (phy->main_chandef.chan == dev->scan.chan) {
-		chandef = phy->main_chandef;
-		offchannel = false;
-	}
+	offchannel = mt76_offchannel_chandef(phy, dev->scan.chan, &chandef);
 
 	mt76_set_channel(phy, &chandef, offchannel);
 
-- 
2.53.0



