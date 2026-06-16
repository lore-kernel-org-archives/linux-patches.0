Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A3343C05C;
	Tue, 16 Jun 2026 15:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623027; cv=none; b=ArHrn/sC5wDjeASonhEGhEd5xTSCdUTg13wTXeshif7eVvYnAfDly6J82xh8db0RfFmq2UxGI52UeWobWDSxJYv2h5+XZVGEraolcnUscGgGKZ1RiX87799d4PrIvZu7N6p7EIp2+9bYfux9CFriz6oWl6o5fe63xwKXmZYUQ6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623027; c=relaxed/simple;
	bh=2xNehpR3PyWjuZBS8z49TVituj7xrOwAqNdvYhqxfdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t92Y/TknR66cEpXzcmxt55De9XFiM8Tdygk92rfEPwbDf0y1XX3HBFVuQ0aWTREzR0Y6Olx1a/E6KhSqPREQ5qnzR7TF0qbdWKsLs9lQM2MI3Yd/xTogLdMWoE3f0ILbh42Dhs+izynIYgVVEKXDNY+8F3sEcC88zowPli6VGrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frVyN/YP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frVyN/YP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63E31F000E9;
	Tue, 16 Jun 2026 15:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623026;
	bh=W41CLREQVqv9Yna/Om4SWozzdOoMcvueXt9jt4w/MoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=frVyN/YPXicaIizoTdJ0uaNKjfaYjF1mUe6V6WIpdmtlqHru+Re5MCpX5zbQoI+41
	 ySjk1ooadT0H04ed6KWRLlyE97GRQHWtOvD1TOfTN1Qc7eSFmK+legEPI5QVntXG2d
	 hPHUphihs6JXJpFWZwoDg5N2kXk9zDmrKVvTJaGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Chandrakanthan <quic_haric@quicinc.com>,
	Amith A <amith.a@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 041/378] wifi: cfg80211: add support to handle incumbent signal detected event from mac80211/driver
Date: Tue, 16 Jun 2026 20:24:32 +0530
Message-ID: <20260616145112.059532063@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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
Stable-dep-of: cb9959ab5f99 ("wifi: cfg80211: enforce HE/EHT cap/oper consistency")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h       | 23 +++++++++++++++++++++
 include/uapi/linux/nl80211.h | 19 +++++++++++++++++
 net/wireless/nl80211.c       | 40 ++++++++++++++++++++++++++++++++++++
 net/wireless/trace.h         | 19 +++++++++++++++++
 4 files changed, 101 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fc01de19c7981a..2311d852e19ebc 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -10472,4 +10472,27 @@ cfg80211_s1g_get_primary_sibling(struct wiphy *wiphy,
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
index b63f718509060d..b53e2d78c7bb3f 100644
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
@@ -2984,6 +2992,15 @@ enum nl80211_commands {
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
@@ -3557,6 +3574,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_UHR_CAPABILITY,
 	NL80211_ATTR_DISABLE_UHR,
 
+	NL80211_ATTR_INCUMBENT_SIGNAL_INTERFERENCE_BITMAP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b94231c8441c48..d00357488ea8ea 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -21120,6 +21120,46 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
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
index 643ccf4f022722..352a57d8b96819 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -4225,6 +4225,25 @@ TRACE_EVENT(cfg80211_nan_cluster_joined,
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



