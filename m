Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3EE1CAB3;
	Fri,  9 Jan 2026 12:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962513; cv=none; b=BryQgZ1yPiADOPyHkFWYywk+iE0XBrg3WcyLLvVJ20OchD6GF4H5YHSQkG57ZrAoySehPYSyctoUHjTMahHuhuFzM4mgpDOXS+941DVcQIg599b9aHgIiT1yworsOgkmqGI2Qj5TO5k7Dl+zwQkirxbh4h1h7FjDSFS/j81z/Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962513; c=relaxed/simple;
	bh=TMBGII4besB1chdMVuZ/U0zVwq74p/Rq+TyAGEpQqgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWnWBn6LlXcq9irlQ5LIMYUVfdN9+hoJbIsBAG18mMH2erEW+aa1++SKzBDb8HV8rP/4X6jLQif2cA8t2m1aGI2y5rN4FbL0aa9J0Yn0MDNs9ankZDK53Jaj2HV3DKRYD65vDX9pwdkXtEjeRQppswyg0UdvPwxxEsTF6xYXr8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ttuAWbAz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttuAWbAz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA54CC4CEF1;
	Fri,  9 Jan 2026 12:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962513;
	bh=TMBGII4besB1chdMVuZ/U0zVwq74p/Rq+TyAGEpQqgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttuAWbAzaXmJnwFWOoyqVWTbd2fFA4jVwQWoU3N6rqiYLx3NQxtQP92JyRRvHmUmq
	 wuLKk2NZohNrQPawcDQNs6BJptAf7GaXYVsEy8jmKIEYA4fuaFjBAQC7QdJa4BWPPI
	 0W4Tst3gVkEOG9Furo1d25LRzjpc5XqwglA0V41M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aloka Dixit <quic_alokad@quicinc.com>,
	Muna Sinada <quic_msinada@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 392/634] wifi: nl80211: validate and configure puncturing bitmap
Date: Fri,  9 Jan 2026 12:41:10 +0100
Message-ID: <20260109112132.281539664@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Aloka Dixit <quic_alokad@quicinc.com>

[ Upstream commit d7c1a9a0ed180d8884798ce97afe7283622a484f ]

- New feature flag, NL80211_EXT_FEATURE_PUNCT, to advertise
  driver support for preamble puncturing in AP mode.
- New attribute, NL80211_ATTR_PUNCT_BITMAP, to receive a puncturing
  bitmap from the userspace during AP bring up (NL80211_CMD_START_AP)
  and channel switch (NL80211_CMD_CHANNEL_SWITCH) operations. Each bit
  corresponds to a 20 MHz channel in the operating bandwidth, lowest
  bit for the lowest channel. Bit set to 1 indicates that the channel
  is punctured. Higher 16 bits are reserved.
- New members added to structures cfg80211_ap_settings and
  cfg80211_csa_settings to propagate the bitmap to the driver after
  validation.

Signed-off-by: Aloka Dixit <quic_alokad@quicinc.com>
Signed-off-by: Muna Sinada <quic_msinada@quicinc.com>
Link: https://lore.kernel.org/r/20230131001227.25014-3-quic_alokad@quicinc.com
[move validation against 0xffff into policy]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: a519be2f5d95 ("wifi: mac80211: do not use old MBSSID elements")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h       |  8 ++++++++
 include/uapi/linux/nl80211.h | 11 +++++++++++
 net/wireless/nl80211.c       | 32 ++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bf79788f1c5d..7efa3adf234d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1325,6 +1325,9 @@ struct cfg80211_unsol_bcast_probe_resp {
  * @fils_discovery: FILS discovery transmission parameters
  * @unsol_bcast_probe_resp: Unsolicited broadcast probe response parameters
  * @mbssid_config: AP settings for multiple bssid
+ * @punct_bitmap: Preamble puncturing bitmap. Each bit represents
+ *	a 20 MHz channel, lowest bit corresponding to the lowest channel.
+ *	Bit set to 1 indicates that the channel is punctured.
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -1359,6 +1362,7 @@ struct cfg80211_ap_settings {
 	struct cfg80211_fils_discovery fils_discovery;
 	struct cfg80211_unsol_bcast_probe_resp unsol_bcast_probe_resp;
 	struct cfg80211_mbssid_config mbssid_config;
+	u16 punct_bitmap;
 };
 
 /**
@@ -1376,6 +1380,9 @@ struct cfg80211_ap_settings {
  * @radar_required: whether radar detection is required on the new channel
  * @block_tx: whether transmissions should be blocked while changing
  * @count: number of beacons until switch
+ * @punct_bitmap: Preamble puncturing bitmap. Each bit represents
+ *	a 20 MHz channel, lowest bit corresponding to the lowest channel.
+ *	Bit set to 1 indicates that the channel is punctured.
  */
 struct cfg80211_csa_settings {
 	struct cfg80211_chan_def chandef;
@@ -1388,6 +1395,7 @@ struct cfg80211_csa_settings {
 	bool radar_required;
 	bool block_tx;
 	u8 count;
+	u16 punct_bitmap;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c14a91bbca7c..173aef8916ae 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2751,6 +2751,12 @@ enum nl80211_commands {
  *	the incoming frame RX timestamp.
  * @NL80211_ATTR_TD_BITMAP: Transition Disable bitmap, for subsequent
  *	(re)associations.
+ *
+ * @NL80211_ATTR_PUNCT_BITMAP: (u32) Preamble puncturing bitmap, lowest
+ *	bit corresponds to the lowest 20 MHz channel. Each bit set to 1
+ *	indicates that the sub-channel is punctured. Higher 16 bits are
+ *	reserved.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3280,6 +3286,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_RX_HW_TIMESTAMP,
 	NL80211_ATTR_TD_BITMAP,
 
+	NL80211_ATTR_PUNCT_BITMAP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -6294,6 +6302,8 @@ enum nl80211_feature_flags {
  *	might apply, e.g. no scans in progress, no offchannel operations
  *	in progress, and no active connections.
  *
+ * @NL80211_EXT_FEATURE_PUNCT: Driver supports preamble puncturing in AP mode.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -6362,6 +6372,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_FILS_CRYPTO_OFFLOAD,
 	NL80211_EXT_FEATURE_RADAR_BACKGROUND,
 	NL80211_EXT_FEATURE_POWERED_ADDR_CHANGE,
+	NL80211_EXT_FEATURE_PUNCT,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1ab60967d6cd..0eb8c8e0bf18 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -810,6 +810,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_MLD_ADDR] = NLA_POLICY_EXACT_LEN(ETH_ALEN),
 	[NL80211_ATTR_MLO_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_MAX_NUM_AKM_SUITES] = { .type = NLA_REJECT },
+	[NL80211_ATTR_PUNCT_BITMAP] = NLA_POLICY_RANGE(NLA_U8, 0, 0xffff),
 };
 
 /* policy for the key attributes */
@@ -3178,6 +3179,21 @@ static bool nl80211_can_set_dev_channel(struct wireless_dev *wdev)
 		wdev->iftype == NL80211_IFTYPE_P2P_GO;
 }
 
+static int nl80211_parse_punct_bitmap(struct cfg80211_registered_device *rdev,
+				      struct genl_info *info,
+				      const struct cfg80211_chan_def *chandef,
+				      u16 *punct_bitmap)
+{
+	if (!wiphy_ext_feature_isset(&rdev->wiphy, NL80211_EXT_FEATURE_PUNCT))
+		return -EINVAL;
+
+	*punct_bitmap = nla_get_u32(info->attrs[NL80211_ATTR_PUNCT_BITMAP]);
+	if (!cfg80211_valid_disable_subchannel_bitmap(punct_bitmap, chandef))
+		return -EINVAL;
+
+	return 0;
+}
+
 int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 			  struct genl_info *info,
 			  struct cfg80211_chan_def *chandef)
@@ -5955,6 +5971,14 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
+	if (info->attrs[NL80211_ATTR_PUNCT_BITMAP]) {
+		err = nl80211_parse_punct_bitmap(rdev, info,
+						 &params->chandef,
+						 &params->punct_bitmap);
+		if (err)
+			goto out;
+	}
+
 	if (!cfg80211_reg_can_beacon_relax(&rdev->wiphy, &params->chandef,
 					   wdev->iftype)) {
 		err = -EINVAL;
@@ -10107,6 +10131,14 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_CH_SWITCH_BLOCK_TX])
 		params.block_tx = true;
 
+	if (info->attrs[NL80211_ATTR_PUNCT_BITMAP]) {
+		err = nl80211_parse_punct_bitmap(rdev, info,
+						 &params.chandef,
+						 &params.punct_bitmap);
+		if (err)
+			goto free;
+	}
+
 	wdev_lock(wdev);
 	err = rdev_channel_switch(rdev, dev, &params);
 	wdev_unlock(wdev);
-- 
2.51.0



