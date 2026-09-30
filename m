Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723EB4D4888;
	Wed, 30 Sep 2026 16:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785794; cv=none; b=ayf3HKyTnNmtSXcjEnhPAeopeGclaNsQrwJp5yCsUDB17i6WasupDc7PD8KXdoL2HGqSKNucAFMjhamHx5nfh5DkRI7P+chsniB41G61OWpfp3meuGE/uUqLJocZh7bRz7pR6VxLZtswJAIf8AhBnbyjDUjOCstHNRLJWcYkqk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785794; c=relaxed/simple;
	bh=4OGNailipLHkX+o3tYoyeCA05BNUiO96UCRZH9uN/5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/CbM9toqDQE64qhPTXLecnq1kMOupFotdEKf63hR9hz19YwAAORFUJD/vpIkTH7V5lzFrTdI7PHQOVPWXD8C86nHZp7uDit+ktAEoe7kgGK7vb7be/DU5/9dMmn17AcCTOA99NRUsvfLNZcau2l+poEt/HV0X4CiTrD3eRpDhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMctQwy1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMctQwy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CD51F000FF;
	Wed, 30 Sep 2026 16:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785793;
	bh=XUz+wzZFiQVqUuk3So37gnobmyzs8eN5WA5M6N9iO40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMctQwy1ThNqeN8y4FSIZNzXcu5zhD2zjRoe2zOErfx/xumjsUu9ZJO4DFynJeVtG
	 tGQDJ7voQxzXePMPxVvnURDRWq8mvRgVwFW5t7bcsUI1koAAApVMR7b05H57bQj/oH
	 Uo1avQd+oHuMNqs2tAIQ8rr8Eg/7XSY9LvF3/RkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Sisodiya <mukesh.sisodiya@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 632/982] wifi: cfg80211: make TDLS management link-aware
Date: Wed, 30 Sep 2026 17:22:48 +0200
Message-ID: <20260930152430.345940128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Mukesh Sisodiya <mukesh.sisodiya@intel.com>

[ Upstream commit c6112046b1a9c130c455ab0bbe74c3f41138693c ]

For multi-link operation(MLO) TDLS management
frames need to be transmitted on a specific link.
The TDLS setup request will add BSSID along with
peer address and userspace will pass the link-id
based on BSSID value to the driver(or mac80211).

Signed-off-by: Mukesh Sisodiya <mukesh.sisodiya@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230616094948.cb3d87c22812.Ia3d15ac4a9a182145bf2d418bcb3ddf4539cd0a7@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 038e1d126304 ("wifi: mac80211: require a peer station for TDLS setup confirm")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c |  8 ++++----
 include/net/cfg80211.h                          |  7 ++++---
 net/mac80211/ieee80211_i.h                      |  8 ++++----
 net/mac80211/tdls.c                             | 10 +++++-----
 net/wireless/nl80211.c                          |  7 +++++--
 net/wireless/rdev-ops.h                         | 15 ++++++++-------
 net/wireless/trace.h                            | 13 ++++++++-----
 7 files changed, 38 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 3b9b75eb4cdb8..8744a9a3eb6b5 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3756,10 +3756,10 @@ static int mwifiex_cfg80211_set_coalesce(struct wiphy *wiphy,
  */
 static int
 mwifiex_cfg80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
-			   const u8 *peer, u8 action_code, u8 dialog_token,
-			   u16 status_code, u32 peer_capability,
-			   bool initiator, const u8 *extra_ies,
-			   size_t extra_ies_len)
+			   const u8 *peer, int link_id, u8 action_code,
+			   u8 dialog_token, u16 status_code,
+			   u32 peer_capability, bool initiator,
+			   const u8 *extra_ies, size_t extra_ies_len)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	int ret;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 90aad35cccc10..297a88a4e14e6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4544,9 +4544,10 @@ struct cfg80211_ops {
 				  struct cfg80211_gtk_rekey_data *data);
 
 	int	(*tdls_mgmt)(struct wiphy *wiphy, struct net_device *dev,
-			     const u8 *peer, u8 action_code,  u8 dialog_token,
-			     u16 status_code, u32 peer_capability,
-			     bool initiator, const u8 *buf, size_t len);
+			     const u8 *peer, int link_id,
+			     u8 action_code, u8 dialog_token, u16 status_code,
+			     u32 peer_capability, bool initiator,
+			     const u8 *buf, size_t len);
 	int	(*tdls_oper)(struct wiphy *wiphy, struct net_device *dev,
 			     const u8 *peer, enum nl80211_tdls_operation oper);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2f437ddd8f1ed..5c3993f611625 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2519,10 +2519,10 @@ void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
 
 /* TDLS */
 int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
-			const u8 *peer, u8 action_code, u8 dialog_token,
-			u16 status_code, u32 peer_capability,
-			bool initiator, const u8 *extra_ies,
-			size_t extra_ies_len);
+			const u8 *peer, int link_id,
+			u8 action_code, u8 dialog_token, u16 status_code,
+			u32 peer_capability, bool initiator,
+			const u8 *extra_ies, size_t extra_ies_len);
 int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			const u8 *peer, enum nl80211_tdls_operation oper);
 void ieee80211_tdls_peer_del_work(struct wiphy *wiphy, struct wiphy_work *wk);
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 57bd4fc8d2375..e54442471c45a 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -6,7 +6,7 @@
  * Copyright 2014, Intel Corporation
  * Copyright 2014  Intel Mobile Communications GmbH
  * Copyright 2015 - 2016 Intel Deutschland GmbH
- * Copyright (C) 2019, 2021-2022 Intel Corporation
+ * Copyright (C) 2019, 2021-2023 Intel Corporation
  */
 
 #include <linux/ieee80211.h>
@@ -1186,10 +1186,10 @@ ieee80211_tdls_mgmt_teardown(struct wiphy *wiphy, struct net_device *dev,
 }
 
 int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
-			const u8 *peer, u8 action_code, u8 dialog_token,
-			u16 status_code, u32 peer_capability,
-			bool initiator, const u8 *extra_ies,
-			size_t extra_ies_len)
+			const u8 *peer, int link_id,
+			u8 action_code, u8 dialog_token, u16 status_code,
+			u32 peer_capability, bool initiator,
+			const u8 *extra_ies, size_t extra_ies_len)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int ret;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index aa85e2e063bbc..d749fa91f399b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12221,6 +12221,7 @@ static int nl80211_tdls_mgmt(struct sk_buff *skb, struct genl_info *info)
 	u32 peer_capability = 0;
 	u16 status_code;
 	u8 *peer;
+	int link_id;
 	bool initiator;
 
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_TDLS) ||
@@ -12242,8 +12243,9 @@ static int nl80211_tdls_mgmt(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_TDLS_PEER_CAPABILITY])
 		peer_capability =
 			nla_get_u32(info->attrs[NL80211_ATTR_TDLS_PEER_CAPABILITY]);
+	link_id = nl80211_link_id_or_invalid(info->attrs);
 
-	return rdev_tdls_mgmt(rdev, dev, peer, action_code,
+	return rdev_tdls_mgmt(rdev, dev, peer, link_id, action_code,
 			      dialog_token, status_code, peer_capability,
 			      initiator,
 			      nla_data(info->attrs[NL80211_ATTR_IE]),
@@ -17118,7 +17120,8 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_tdls_mgmt,
 		.flags = GENL_UNS_ADMIN_PERM,
-		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP |
+					 NL80211_FLAG_MLO_VALID_LINK_ID),
 	},
 	{
 		.cmd = NL80211_CMD_TDLS_OPER,
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index df7f88ca0db38..db6d91c905603 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -903,17 +903,18 @@ static inline int rdev_set_rekey_data(struct cfg80211_registered_device *rdev,
 
 static inline int rdev_tdls_mgmt(struct cfg80211_registered_device *rdev,
 				 struct net_device *dev, u8 *peer,
-				 u8 action_code, u8 dialog_token,
-				 u16 status_code, u32 peer_capability,
-				 bool initiator, const u8 *buf, size_t len)
+				 int link_id, u8 action_code,
+				 u8 dialog_token, u16 status_code,
+				 u32 peer_capability, bool initiator,
+				 const u8 *buf, size_t len)
 {
 	int ret;
-	trace_rdev_tdls_mgmt(&rdev->wiphy, dev, peer, action_code,
+	trace_rdev_tdls_mgmt(&rdev->wiphy, dev, peer, link_id, action_code,
 			     dialog_token, status_code, peer_capability,
 			     initiator, buf, len);
-	ret = rdev->ops->tdls_mgmt(&rdev->wiphy, dev, peer, action_code,
-				   dialog_token, status_code, peer_capability,
-				   initiator, buf, len);
+	ret = rdev->ops->tdls_mgmt(&rdev->wiphy, dev, peer, link_id,
+				   action_code, dialog_token, status_code,
+				   peer_capability, initiator, buf, len);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index da03b6ff71b2a..73e388cd32fee 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1779,15 +1779,16 @@ DEFINE_EVENT(wiphy_netdev_id_evt, rdev_sched_scan_stop,
 
 TRACE_EVENT(rdev_tdls_mgmt,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
-		 u8 *peer, u8 action_code, u8 dialog_token,
+		 u8 *peer, int link_id, u8 action_code, u8 dialog_token,
 		 u16 status_code, u32 peer_capability,
 		 bool initiator, const u8 *buf, size_t len),
-	TP_ARGS(wiphy, netdev, peer, action_code, dialog_token, status_code,
-		peer_capability, initiator, buf, len),
+	TP_ARGS(wiphy, netdev, peer, link_id, action_code, dialog_token,
+		status_code, peer_capability, initiator, buf, len),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		NETDEV_ENTRY
 		MAC_ENTRY(peer)
+		__field(int, link_id)
 		__field(u8, action_code)
 		__field(u8, dialog_token)
 		__field(u16, status_code)
@@ -1799,6 +1800,7 @@ TRACE_EVENT(rdev_tdls_mgmt,
 		WIPHY_ASSIGN;
 		NETDEV_ASSIGN;
 		MAC_ASSIGN(peer, peer);
+		__entry->link_id = link_id;
 		__entry->action_code = action_code;
 		__entry->dialog_token = dialog_token;
 		__entry->status_code = status_code;
@@ -1806,11 +1808,12 @@ TRACE_EVENT(rdev_tdls_mgmt,
 		__entry->initiator = initiator;
 		memcpy(__get_dynamic_array(buf), buf, len);
 	),
-	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", %pM, action_code: %u, "
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", %pM"
+		  ", link_id: %d, action_code: %u "
 		  "dialog_token: %u, status_code: %u, peer_capability: %u "
 		  "initiator: %s buf: %#.2x ",
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->peer,
-		  __entry->action_code, __entry->dialog_token,
+		  __entry->link_id, __entry->action_code, __entry->dialog_token,
 		  __entry->status_code, __entry->peer_capability,
 		  BOOL_TO_STR(__entry->initiator),
 		  ((u8 *)__get_dynamic_array(buf))[0])
-- 
2.53.0



