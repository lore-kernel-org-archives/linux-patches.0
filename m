Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1537359FAC;
	Fri,  9 Jan 2026 12:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962516; cv=none; b=kDOzehQoJ9LLJRk7UASdhn/O79q335tTnYfpsT4jsQVwI1JRB05CkYMMdT5A6vPNBN3Udrh27bRfdilrjVteyuxQNPS3scqqxoCM91ZdYWlxHsEH2X7GrCOvSzkMhuOqo0oEd5mbxU/YyIjiZEhjaP7tiAYfff+LAdoKKqyGQO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962516; c=relaxed/simple;
	bh=SQLqrxw6IeunqwpltdiI3jNYYCX4HTqzijhHTxgPdM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYFEMz9Hl5HcmS+8/14HO2Mj3q8HjZ5EVVJmPFBfm7Xd2JscwvcLlbt/BE3rDF1Zxw27tBui3iM0NeYbjwB6xVbehdS4qR6NhLnGUxQDsFRRpyci6i51eZqMpEofFWmUCcC02seXqwYSnypJZNQTl93jlstm1V1APrh7ZxyOyKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VN42CO7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VN42CO7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B50C19424;
	Fri,  9 Jan 2026 12:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962516;
	bh=SQLqrxw6IeunqwpltdiI3jNYYCX4HTqzijhHTxgPdM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VN42CO7Gj427azt8HQb3ecQN0TSBGZ2GmJnYez8kOHzPPE0Tb9BwMdFQdxgOpHe/o
	 fP2IoKrPHZt+mvXvAgGAhfN9GFJ4Ou9quFyeuX7Y1mk5eF7bnbUnTGZjpWlEPHz38c
	 bfqLdNKv1OdER+b2c2QZ7tbVfdEDOFv0ZF3WwiMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 393/634] wifi: nl80211: add a command to enable/disable HW timestamping
Date: Fri,  9 Jan 2026 12:41:11 +0100
Message-ID: <20260109112132.318963760@linuxfoundation.org>
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

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit cbbaf2bb829b6c4ef911d4a725fc9b1fadc1e43f ]

Add a command to enable and disable HW timestamping of TM and FTM
frames. HW timestamping can be enabled for a specific mac address
or for all addresses.

The low level driver will indicate how many peers HW timestamping
can be enabled concurrently, and this information will be passed
to userspace.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230301115906.05678d7b1c17.Iccc08869ea8156f1c71a3111a47f86dd56234bd0@changeid
[switch to needing netdev UP, minor edits]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: a519be2f5d95 ("wifi: mac80211: do not use old MBSSID elements")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h       | 27 ++++++++++++++++++++++++++
 include/uapi/linux/nl80211.h | 22 +++++++++++++++++++++
 net/wireless/nl80211.c       | 37 ++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 17 +++++++++++++++++
 net/wireless/trace.h         | 25 ++++++++++++++++++++++++
 5 files changed, 128 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7efa3adf234d..34709bd733ed 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -830,6 +830,18 @@ struct cfg80211_fils_aad {
 	const u8 *anonce;
 };
 
+/**
+ * struct cfg80211_set_hw_timestamp - enable/disable HW timestamping
+ * @macaddr: peer MAC address. NULL to enable/disable HW timestamping for all
+ *	addresses.
+ * @enable: if set, enable HW timestamping for the specified MAC address.
+ *	Otherwise disable HW timestamping for the specified MAC address.
+ */
+struct cfg80211_set_hw_timestamp {
+	const u8 *macaddr;
+	bool enable;
+};
+
 /**
  * cfg80211_get_chandef_type - return old channel type from chandef
  * @chandef: the channel definition
@@ -4291,6 +4303,8 @@ struct mgmt_frame_regs {
  * @add_link_station: Add a link to a station.
  * @mod_link_station: Modify a link of a station.
  * @del_link_station: Remove a link of a station.
+ *
+ * @set_hw_timestamp: Enable/disable HW timestamping of TM/FTM frames.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -4644,6 +4658,8 @@ struct cfg80211_ops {
 				    struct link_station_parameters *params);
 	int	(*del_link_station)(struct wiphy *wiphy, struct net_device *dev,
 				    struct link_station_del_parameters *params);
+	int	(*set_hw_timestamp)(struct wiphy *wiphy, struct net_device *dev,
+				    struct cfg80211_set_hw_timestamp *hwts);
 };
 
 /*
@@ -5099,6 +5115,8 @@ struct wiphy_iftype_akm_suites {
 	int n_akm_suites;
 };
 
+#define CFG80211_HW_TIMESTAMP_ALL_PEERS	0xffff
+
 /**
  * struct wiphy - wireless hardware description
  * @mtx: mutex for the data (structures) of this device
@@ -5308,6 +5326,13 @@ struct wiphy_iftype_akm_suites {
  *	NL80211_MAX_NR_AKM_SUITES in order to avoid compatibility issues with
  *	legacy userspace and maximum allowed value is
  *	CFG80211_MAX_NUM_AKM_SUITES.
+ *
+ * @hw_timestamp_max_peers: maximum number of peers that the driver supports
+ *	enabling HW timestamping for concurrently. Setting this field to a
+ *	non-zero value indicates that the driver supports HW timestamping.
+ *	A value of %CFG80211_HW_TIMESTAMP_ALL_PEERS indicates the driver
+ *	supports enabling HW timestamping for all peers (i.e. no need to
+ *	specify a mac address).
  */
 struct wiphy {
 	struct mutex mtx;
@@ -5456,6 +5481,8 @@ struct wiphy {
 	u8 ema_max_profile_periodicity;
 	u16 max_num_akm_suites;
 
+	u16 hw_timestamp_max_peers;
+
 	char priv[] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 173aef8916ae..274d1b34c954 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1281,6 +1281,16 @@
  * @NL80211_CMD_MODIFY_LINK_STA: Modify a link of an MLD station
  * @NL80211_CMD_REMOVE_LINK_STA: Remove a link of an MLD station
  *
+ * @NL80211_CMD_SET_HW_TIMESTAMP: Enable/disable HW timestamping of Timing
+ *	measurement and Fine timing measurement frames. If %NL80211_ATTR_MAC
+ *	is included, enable/disable HW timestamping only for frames to/from the
+ *	specified MAC address. Otherwise enable/disable HW timestamping for
+ *	all TM/FTM frames (including ones that were enabled with specific MAC
+ *	address). If %NL80211_ATTR_HW_TIMESTAMP_ENABLED is not included, disable
+ *	HW timestamping.
+ *	The number of peers that HW timestamping can be enabled for concurrently
+ *	is indicated by %NL80211_ATTR_MAX_HW_TIMESTAMP_PEERS.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1532,6 +1542,8 @@ enum nl80211_commands {
 	NL80211_CMD_MODIFY_LINK_STA,
 	NL80211_CMD_REMOVE_LINK_STA,
 
+	NL80211_CMD_SET_HW_TIMESTAMP,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2757,6 +2769,13 @@ enum nl80211_commands {
  *	indicates that the sub-channel is punctured. Higher 16 bits are
  *	reserved.
  *
+ * @NL80211_ATTR_MAX_HW_TIMESTAMP_PEERS: Maximum number of peers that HW
+ *	timestamping can be enabled for concurrently (u16), a wiphy attribute.
+ *	A value of 0xffff indicates setting for all peers (i.e. not specifying
+ *	an address with %NL80211_CMD_SET_HW_TIMESTAMP) is supported.
+ * @NL80211_ATTR_HW_TIMESTAMP_ENABLED: Indicates whether HW timestamping should
+ *	be enabled or not (flag attribute).
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3288,6 +3307,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PUNCT_BITMAP,
 
+	NL80211_ATTR_MAX_HW_TIMESTAMP_PEERS,
+	NL80211_ATTR_HW_TIMESTAMP_ENABLED,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0eb8c8e0bf18..5e2b676f5ce0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -811,6 +811,9 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_MLO_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_MAX_NUM_AKM_SUITES] = { .type = NLA_REJECT },
 	[NL80211_ATTR_PUNCT_BITMAP] = NLA_POLICY_RANGE(NLA_U8, 0, 0xffff),
+
+	[NL80211_ATTR_MAX_HW_TIMESTAMP_PEERS] = { .type = NLA_U16 },
+	[NL80211_ATTR_HW_TIMESTAMP_ENABLED] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -2965,6 +2968,11 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		if (rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_MLO)
 			nla_put_flag(msg, NL80211_ATTR_MLO_SUPPORT);
 
+		if (rdev->wiphy.hw_timestamp_max_peers &&
+		    nla_put_u16(msg, NL80211_ATTR_MAX_HW_TIMESTAMP_PEERS,
+				rdev->wiphy.hw_timestamp_max_peers))
+			goto nla_put_failure;
+
 		/* done */
 		state->split_start = 0;
 		break;
@@ -16162,6 +16170,29 @@ nl80211_remove_link_station(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
+static int nl80211_set_hw_timestamp(struct sk_buff *skb,
+				    struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct cfg80211_set_hw_timestamp hwts = {};
+
+	if (!rdev->wiphy.hw_timestamp_max_peers)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_MAC] &&
+	    rdev->wiphy.hw_timestamp_max_peers != CFG80211_HW_TIMESTAMP_ALL_PEERS)
+		return -EOPNOTSUPP;
+
+	if (info->attrs[NL80211_ATTR_MAC])
+		hwts.macaddr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	hwts.enable =
+		nla_get_flag(info->attrs[NL80211_ATTR_HW_TIMESTAMP_ENABLED]);
+
+	return rdev_set_hw_timestamp(rdev, dev, &hwts);
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -17333,6 +17364,12 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP |
 					 NL80211_FLAG_MLO_VALID_LINK_ID),
 	},
+	{
+		.cmd = NL80211_CMD_SET_HW_TIMESTAMP,
+		.doit = nl80211_set_hw_timestamp,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 5f210686c411..df7f88ca0db3 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1498,4 +1498,21 @@ rdev_del_link_station(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_set_hw_timestamp(struct cfg80211_registered_device *rdev,
+		      struct net_device *dev,
+		      struct cfg80211_set_hw_timestamp *hwts)
+{
+	struct wiphy *wiphy = &rdev->wiphy;
+	int ret;
+
+	if (!rdev->ops->set_hw_timestamp)
+		return -EOPNOTSUPP;
+
+	trace_rdev_set_hw_timestamp(wiphy, dev, hwts);
+	ret = rdev->ops->set_hw_timestamp(wiphy, dev, hwts);
+	trace_rdev_return_int(wiphy, ret);
+
+	return ret;
+}
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 137937b1f4b3..f325ca28face 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3901,6 +3901,31 @@ TRACE_EVENT(rdev_del_link_station,
 		  __entry->link_id)
 );
 
+TRACE_EVENT(rdev_set_hw_timestamp,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_set_hw_timestamp *hwts),
+
+	TP_ARGS(wiphy, netdev, hwts),
+
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(macaddr)
+		__field(bool, enable)
+	),
+
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(macaddr, hwts->macaddr);
+		__entry->enable = hwts->enable;
+	),
+
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", mac %pM, enable: %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->macaddr,
+		  __entry->enable)
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.51.0



