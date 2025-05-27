Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E103280310;
	Tue, 27 May 2025 16:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364864; cv=none; b=SYlmLIrjValulUisGep9+anwZNstn+yiLetr00Amw4LDsuUNlz2uzGOqTq6vlGszZq2G207lDpaF87paFJYw/7hQbXV8aQH6+4KfQAZF+T2fElOWbVDj6eJEgZ4FONVQLEPNltih0HhrzGY8cOFm6wujKijB4Hb/dYEGKyTeG5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364864; c=relaxed/simple;
	bh=QeLjwIW/QzmH/hb3tjxpFGEpJ+ZO6PiDKDQQ/lKasus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blJjsGWeFapEhLnwzkx40+lJi7/fUkZcFqfSDKlqneucCfDsIrFL/JxuSY0UTrx26KuL77/SrFDMvL1SeQudbU3dhRvWktSA82RMdkfz/zwMvpRuR0s3UYKfrxZLUDv8EUC8dWSR4+GJP+ljE2RkvgjGUnrnJNV/Ud5LVFX+9C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zHX3Attl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zHX3Attl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725E0C4CEE9;
	Tue, 27 May 2025 16:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364863;
	bh=QeLjwIW/QzmH/hb3tjxpFGEpJ+ZO6PiDKDQQ/lKasus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zHX3AttlDaKps7eTmu7HHVSflD+cRCvBM6PEcVQkDGG2whWCmgJoYjSTnuifLS0A0
	 c7xRkAEcVm1Ja8AA9OznZJ5Xx4gWCRFqQUGwkKhCeUeFXXrusq02SKFYCE4iJJbhw1
	 XK9Zw/S3aJ866hwxVip+OnYvdmmQi/iImZpOuKDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Somashekhar Puttagangaiah <somashekhar.puttagangaiah@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 191/626] wifi: cfg80211: allow IR in 20 MHz configurations
Date: Tue, 27 May 2025 18:21:24 +0200
Message-ID: <20250527162452.776772614@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

[ Upstream commit cf4bd1608882792d4742e27a819493312904a680 ]

Some regulatory bodies doesn't allow IR (initiate radioation) on a
specific subband, but allows it for channels with a bandwidth of 20 MHz.
Add a channel flag that indicates that, and consider it in
cfg80211_reg_check_beaconing.

While on it, fix the kernel doc of enum nl80211_reg_rule_flags and
change it to use BIT().

Signed-off-by: Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Co-developed-by: Somashekhar Puttagangaiah <somashekhar.puttagangaiah@intel.com>
Signed-off-by: Somashekhar Puttagangaiah <somashekhar.puttagangaiah@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308225541.d3ab352a73ff.I8a8f79e1c9eb74936929463960ee2a324712fe51@changeid
[fix typo]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h       |  3 +++
 include/uapi/linux/nl80211.h | 52 ++++++++++++++++++++----------------
 net/wireless/chan.c          |  8 +++++-
 net/wireless/nl80211.c       |  4 +++
 net/wireless/reg.c           |  4 ++-
 5 files changed, 46 insertions(+), 25 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 941dc62f3027c..8a712ca73f2b0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -127,6 +127,8 @@ struct wiphy;
  *	even if it is otherwise disabled.
  * @IEEE80211_CHAN_ALLOW_6GHZ_VLP_AP: Allow using this channel for AP operation
  *	with very low power (VLP), even if otherwise set to NO_IR.
+ * @IEEE80211_CHAN_ALLOW_20MHZ_ACTIVITY: Allow activity on a 20 MHz channel,
+ *	even if otherwise set to NO_IR.
  */
 enum ieee80211_channel_flags {
 	IEEE80211_CHAN_DISABLED			= BIT(0),
@@ -155,6 +157,7 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_NO_6GHZ_AFC_CLIENT	= BIT(23),
 	IEEE80211_CHAN_CAN_MONITOR		= BIT(24),
 	IEEE80211_CHAN_ALLOW_6GHZ_VLP_AP	= BIT(25),
+	IEEE80211_CHAN_ALLOW_20MHZ_ACTIVITY     = BIT(26),
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f97f5adc8d518..c2d7faf8d87fa 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4294,6 +4294,8 @@ enum nl80211_wmm_rule {
  *	otherwise completely disabled.
  * @NL80211_FREQUENCY_ATTR_ALLOW_6GHZ_VLP_AP: This channel can be used for a
  *	very low power (VLP) AP, despite being NO_IR.
+ * @NL80211_FREQUENCY_ATTR_ALLOW_20MHZ_ACTIVITY: This channel can be active in
+ *	20 MHz bandwidth, despite being NO_IR.
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
@@ -4338,6 +4340,7 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_6GHZ_AFC_CLIENT,
 	NL80211_FREQUENCY_ATTR_CAN_MONITOR,
 	NL80211_FREQUENCY_ATTR_ALLOW_6GHZ_VLP_AP,
+	NL80211_FREQUENCY_ATTR_ALLOW_20MHZ_ACTIVITY,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
@@ -4549,31 +4552,34 @@ enum nl80211_sched_scan_match_attr {
  * @NL80211_RRF_NO_6GHZ_AFC_CLIENT: Client connection to AFC AP not allowed
  * @NL80211_RRF_ALLOW_6GHZ_VLP_AP: Very low power (VLP) AP can be permitted
  *	despite NO_IR configuration.
+ * @NL80211_RRF_ALLOW_20MHZ_ACTIVITY: Allow activity in 20 MHz bandwidth,
+ *	despite NO_IR configuration.
  */
 enum nl80211_reg_rule_flags {
-	NL80211_RRF_NO_OFDM		= 1<<0,
-	NL80211_RRF_NO_CCK		= 1<<1,
-	NL80211_RRF_NO_INDOOR		= 1<<2,
-	NL80211_RRF_NO_OUTDOOR		= 1<<3,
-	NL80211_RRF_DFS			= 1<<4,
-	NL80211_RRF_PTP_ONLY		= 1<<5,
-	NL80211_RRF_PTMP_ONLY		= 1<<6,
-	NL80211_RRF_NO_IR		= 1<<7,
-	__NL80211_RRF_NO_IBSS		= 1<<8,
-	NL80211_RRF_AUTO_BW		= 1<<11,
-	NL80211_RRF_IR_CONCURRENT	= 1<<12,
-	NL80211_RRF_NO_HT40MINUS	= 1<<13,
-	NL80211_RRF_NO_HT40PLUS		= 1<<14,
-	NL80211_RRF_NO_80MHZ		= 1<<15,
-	NL80211_RRF_NO_160MHZ		= 1<<16,
-	NL80211_RRF_NO_HE		= 1<<17,
-	NL80211_RRF_NO_320MHZ		= 1<<18,
-	NL80211_RRF_NO_EHT		= 1<<19,
-	NL80211_RRF_PSD			= 1<<20,
-	NL80211_RRF_DFS_CONCURRENT	= 1<<21,
-	NL80211_RRF_NO_6GHZ_VLP_CLIENT	= 1<<22,
-	NL80211_RRF_NO_6GHZ_AFC_CLIENT	= 1<<23,
-	NL80211_RRF_ALLOW_6GHZ_VLP_AP	= 1<<24,
+	NL80211_RRF_NO_OFDM                 = 1 << 0,
+	NL80211_RRF_NO_CCK                  = 1 << 1,
+	NL80211_RRF_NO_INDOOR               = 1 << 2,
+	NL80211_RRF_NO_OUTDOOR              = 1 << 3,
+	NL80211_RRF_DFS                     = 1 << 4,
+	NL80211_RRF_PTP_ONLY                = 1 << 5,
+	NL80211_RRF_PTMP_ONLY               = 1 << 6,
+	NL80211_RRF_NO_IR                   = 1 << 7,
+	__NL80211_RRF_NO_IBSS               = 1 << 8,
+	NL80211_RRF_AUTO_BW                 = 1 << 11,
+	NL80211_RRF_IR_CONCURRENT           = 1 << 12,
+	NL80211_RRF_NO_HT40MINUS            = 1 << 13,
+	NL80211_RRF_NO_HT40PLUS             = 1 << 14,
+	NL80211_RRF_NO_80MHZ                = 1 << 15,
+	NL80211_RRF_NO_160MHZ               = 1 << 16,
+	NL80211_RRF_NO_HE                   = 1 << 17,
+	NL80211_RRF_NO_320MHZ               = 1 << 18,
+	NL80211_RRF_NO_EHT                  = 1 << 19,
+	NL80211_RRF_PSD                     = 1 << 20,
+	NL80211_RRF_DFS_CONCURRENT          = 1 << 21,
+	NL80211_RRF_NO_6GHZ_VLP_CLIENT      = 1 << 22,
+	NL80211_RRF_NO_6GHZ_AFC_CLIENT      = 1 << 23,
+	NL80211_RRF_ALLOW_6GHZ_VLP_AP       = 1 << 24,
+	NL80211_RRF_ALLOW_20MHZ_ACTIVITY    = 1 << 25,
 };
 
 #define NL80211_RRF_PASSIVE_SCAN	NL80211_RRF_NO_IR
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index e579d7e1425fe..c4f3fefeb3544 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -6,7 +6,7 @@
  *
  * Copyright 2009	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
- * Copyright 2018-2024	Intel Corporation
+ * Copyright 2018-2025	Intel Corporation
  */
 
 #include <linux/export.h>
@@ -1621,6 +1621,12 @@ bool cfg80211_reg_check_beaconing(struct wiphy *wiphy,
 	if (cfg->reg_power == IEEE80211_REG_VLP_AP)
 		permitting_flags |= IEEE80211_CHAN_ALLOW_6GHZ_VLP_AP;
 
+	if ((cfg->iftype == NL80211_IFTYPE_P2P_GO ||
+	     cfg->iftype == NL80211_IFTYPE_AP) &&
+	    (chandef->width == NL80211_CHAN_WIDTH_20_NOHT ||
+	     chandef->width == NL80211_CHAN_WIDTH_20))
+		permitting_flags |= IEEE80211_CHAN_ALLOW_20MHZ_ACTIVITY;
+
 	return _cfg80211_reg_can_beacon(wiphy, chandef, cfg->iftype,
 					check_no_ir ? IEEE80211_CHAN_NO_IR : 0,
 					permitting_flags);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ecfceddce00fc..c778ffa1c8efd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1213,6 +1213,10 @@ static int nl80211_msg_put_channel(struct sk_buff *msg, struct wiphy *wiphy,
 		if ((chan->flags & IEEE80211_CHAN_ALLOW_6GHZ_VLP_AP) &&
 		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_ALLOW_6GHZ_VLP_AP))
 			goto nla_put_failure;
+		if ((chan->flags & IEEE80211_CHAN_ALLOW_20MHZ_ACTIVITY) &&
+		    nla_put_flag(msg,
+				 NL80211_FREQUENCY_ATTR_ALLOW_20MHZ_ACTIVITY))
+			goto nla_put_failure;
 	}
 
 	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2b626078739c5..f6846eb0f4b84 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -5,7 +5,7 @@
  * Copyright 2008-2011	Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright      2017  Intel Deutschland GmbH
- * Copyright (C) 2018 - 2024 Intel Corporation
+ * Copyright (C) 2018 - 2025 Intel Corporation
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -1603,6 +1603,8 @@ static u32 map_regdom_flags(u32 rd_flags)
 		channel_flags |= IEEE80211_CHAN_PSD;
 	if (rd_flags & NL80211_RRF_ALLOW_6GHZ_VLP_AP)
 		channel_flags |= IEEE80211_CHAN_ALLOW_6GHZ_VLP_AP;
+	if (rd_flags & NL80211_RRF_ALLOW_20MHZ_ACTIVITY)
+		channel_flags |= IEEE80211_CHAN_ALLOW_20MHZ_ACTIVITY;
 	return channel_flags;
 }
 
-- 
2.39.5



