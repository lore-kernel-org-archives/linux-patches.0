Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8877734AB14;
	Sat, 12 Sep 2026 10:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209449; cv=none; b=GeG9ytbAkRnxEcuoe96iO7ysQ+HHyiQ6eK9DNoxyte6QTygvv32xq4iu5cvNaTNP17HfCjMdgpoao2uNiVyW5G+KGvhLP5OWYwQWkavSWrFUknU0FZ6lZg65JSWVls85wnYMiivnv4LSIitbZJaKfj2F8EOGU8vk74O8oHTeKyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209449; c=relaxed/simple;
	bh=YmoyKR2pbSumJdyk+3f2xIqwzHElv+puW5keDRhveFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INQocrNmWEEhK1Y3zdDVQN77D6sLTu3MoRnVKUvE80NzLI6LMJKRN5aKw7BGlFBDkFeVDqzc3C8Kmp0YbbFGR9EJxYHRe3tAkuCdsvrn/IJU/YYoF6YHuWM8MorbaB9wqU7Ieo1pK6zyaHEycg7GCTfltgrpowUKTXHA0jUEFFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aE+lMLj0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aE+lMLj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BB51F0089E;
	Sat, 12 Sep 2026 10:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209448;
	bh=WH1LBMcbLegbyzZcdeELcld4mxyU5F/Sp9Vep1kGh5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aE+lMLj0iB5EVBWun+pnquQEELYZlfwL4XtnDbYDJ0gatXBFububQ1tWTkyLpzERC
	 Kk3ylqRkcTr5sWDJTqG/kYMU0I6OjqoIVJz4l3gz9kE0e2fLeonCzCJzrNIKL7QQoI
	 AZKB/ant6fI4YN9+b3woUzdJGZL0ne6c1GVB6SZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Chandrakanthan <quic_haric@quicinc.com>,
	Amith A <amith.a@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0821/1518] wifi: cfg80211: add support to handle incumbent signal detected event from mac80211/driver
Date: Sat, 12 Sep 2026 08:49:50 +0200
Message-ID: <20260912065642.010450718@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Chandrakanthan <quic_haric@quicinc.com>

[ Upstream commit 6a584e336cefb230e2d981a464f4d85562eb750c ]

When any incumbent signal is detected by an AP/mesh interface operating
in 6 GHz band, FCC mandates the AP/mesh to vacate the channels affected
by it [1].

Add a new API cfg80211_incumbent_signal_notify() that can be used
by mac80211 or drivers to notify the higher layers about the signal
interference event with the interference bitmap in which each bit
denotes the affected 20 MHz in the operating channel.

Add support for the new nl80211 event and nl80211 attribute as well to
notify userspace on the details about the interference event. Userspace is
expected to process it and take further action - vacate the channel, or
reduce the bandwidth.

[1] - https://apps.fcc.gov/kdb/GetAttachment.html?id=nXQiRC%2B4mfiA54Zha%2BrW4Q%3D%3D&desc=987594%20D02%20U-NII%206%20GHz%20EMC%20Measurement%20v03&tracking_number=277034

Signed-off-by: Hari Chandrakanthan <quic_haric@quicinc.com>
Signed-off-by: Amith A <amith.a@oss.qualcomm.com>
Link: https://patch.msgid.link/20260216032027.2310956-2-amith.a@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 6c5fc504d0d6 ("wifi: cfg80211: stop PMSR before P2P and NAN teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h       | 23 +++++++++++++++++++++
 include/uapi/linux/nl80211.h | 19 +++++++++++++++++
 net/wireless/nl80211.c       | 40 ++++++++++++++++++++++++++++++++++++
 net/wireless/trace.h         | 19 +++++++++++++++++
 4 files changed, 101 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3cb8d45579d42..c44c35dedc589 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -10382,4 +10382,27 @@ cfg80211_s1g_get_primary_sibling(struct wiphy *wiphy,
 	return ieee80211_get_channel_khz(wiphy, sibling_1mhz_khz);
 }
 
+
+/**
+ * cfg80211_incumbent_signal_notify - Notify userspace of incumbent signal detection
+ * @wiphy: the wiphy to use
+ * @chandef: channel definition in which the interference was detected
+ * @signal_interference_bitmap: bitmap indicating interference across 20 MHz segments
+ * @gfp: allocation context for message creation and multicast; pass GFP_ATOMIC
+ *	if called from atomic context (e.g. firmware event handler), otherwise
+ *	GFP_KERNEL
+ *
+ * Use this function to notify userspace when an incumbent signal is detected on
+ * the operating channel in the 6 GHz band. The notification includes the
+ * current channel definition and a bitmap representing interference across
+ * the operating bandwidth. Each bit in the bitmap corresponds to a 20 MHz
+ * segment, with the lowest bit representing the lowest frequency segment.
+ * Punctured sub-channels are included in the bitmap structure but are always
+ * set to zero since interference detection is not performed on them.
+ */
+void cfg80211_incumbent_signal_notify(struct wiphy *wiphy,
+				      const struct cfg80211_chan_def *chandef,
+				      u32 signal_interference_bitmap,
+				      gfp_t gfp);
+
 #endif /* __NET_CFG80211_H */
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 4bb3d32838989..69152abd64b9a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1361,6 +1361,12 @@
  *	user space that the NAN new cluster has been joined. The cluster ID is
  *	indicated by %NL80211_ATTR_MAC.
  *
+ * @NL80211_CMD_INCUMBENT_SIGNAL_DETECT: Once any incumbent signal is detected
+ *	on the operating channel in 6 GHz band, userspace is notified with the
+ *	signal interference bitmap using
+ *	%NL80211_ATTR_INCUMBENT_SIGNAL_INTERFERENCE_BITMAP. The current channel
+ *	definition is also sent.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1624,6 +1630,8 @@ enum nl80211_commands {
 	NL80211_CMD_NAN_NEXT_DW_NOTIFICATION,
 	NL80211_CMD_NAN_CLUSTER_JOINED,
 
+	NL80211_CMD_INCUMBENT_SIGNAL_DETECT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2983,6 +2991,15 @@ enum nl80211_commands {
  *	this feature during association. This is a flag attribute.
  *	Currently only supported in mac80211 drivers.
  *
+ * @NL80211_ATTR_INCUMBENT_SIGNAL_INTERFERENCE_BITMAP: u32 attribute specifying
+ *	the signal interference bitmap detected on the operating bandwidth for
+ *	%NL80211_CMD_INCUMBENT_SIGNAL_DETECT. Each bit represents a 20 MHz
+ *	segment, lowest bit corresponds to the lowest 20 MHz segment, in the
+ *	operating bandwidth where the interference is detected. Punctured
+ *	sub-channels are included in the bitmap structure; however, since
+ *	interference detection is not performed on these sub-channels, their
+ *	corresponding bits are consistently set to zero.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3556,6 +3573,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_UHR_CAPABILITY,
 	NL80211_ATTR_DISABLE_UHR,
 
+	NL80211_ATTR_INCUMBENT_SIGNAL_INTERFERENCE_BITMAP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1227a2055d6f1..86848602c85b1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -21102,6 +21102,46 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 }
 EXPORT_SYMBOL(cfg80211_ch_switch_notify);
 
+void cfg80211_incumbent_signal_notify(struct wiphy *wiphy,
+				      const struct cfg80211_chan_def *chandef,
+				      u32 signal_interference_bitmap,
+				      gfp_t gfp)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+
+	trace_cfg80211_incumbent_signal_notify(wiphy, chandef, signal_interference_bitmap);
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_INCUMBENT_SIGNAL_DETECT);
+	if (!hdr)
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx))
+		goto nla_put_failure;
+
+	if (nl80211_send_chandef(msg, chandef))
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL80211_ATTR_INCUMBENT_SIGNAL_INTERFERENCE_BITMAP,
+			signal_interference_bitmap))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_MLME, gfp);
+	return;
+
+nla_put_failure:
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_incumbent_signal_notify);
+
 void cfg80211_ch_switch_started_notify(struct net_device *dev,
 				       struct cfg80211_chan_def *chandef,
 				       unsigned int link_id, u8 count,
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 2b71f1d867a08..27779d11b3733 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -4222,6 +4222,25 @@ TRACE_EVENT(cfg80211_nan_cluster_joined,
 		  WDEV_PR_ARG, __entry->cluster_id,
 		  __entry->new_cluster ? " [new]" : "")
 );
+
+TRACE_EVENT(cfg80211_incumbent_signal_notify,
+	TP_PROTO(struct wiphy *wiphy,
+		 const struct cfg80211_chan_def *chandef,
+		 u32 signal_interference_bitmap),
+	TP_ARGS(wiphy, chandef, signal_interference_bitmap),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		CHAN_DEF_ENTRY
+		__field(u32, signal_interference_bitmap)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		CHAN_DEF_ASSIGN(chandef);
+		__entry->signal_interference_bitmap = signal_interference_bitmap;
+	),
+	TP_printk(WIPHY_PR_FMT ", " CHAN_DEF_PR_FMT ", signal_interference_bitmap=0x%x",
+		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG, __entry->signal_interference_bitmap)
+);
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.53.0



