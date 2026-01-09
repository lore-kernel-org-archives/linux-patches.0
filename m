Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A710733032C;
	Fri,  9 Jan 2026 12:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962597; cv=none; b=beR3ImIuy0c6jyxqwZpujs6rY5I3sHBMADo26XIbrLrUVRyuWcS8dnUHMlb0PTGIf/GZcKvUidZ4x3JGa7ymgq8ghlPR4kTWE06MzzyywjbRaswudGwjTS8gZti/B6V1aHeg/oJYZf5QkYkeEDvmY+R2x2UcuI5wE5bJzcW56xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962597; c=relaxed/simple;
	bh=64wjJVZiRc3pj6HRhOw217GjQVtWgCF9ct8k5IILpYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NV+ULDllgqYUEdwWnJ0z1g3/p80EUrw1PMBmgzhx4pFBvwhabnsQUD5SA4fcCRQNcgEJBi0Z2d+dt+C5t0NByyE4K9i6hM5BZK2BA/6L027dCBX730uEJ8rF0+RcaiLYVGbUr2F5Efm9kbrnU5Ufpw4TSjg+tNeH7DgxPX5XIv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jk7SidB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jk7SidB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334B4C4CEF1;
	Fri,  9 Jan 2026 12:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962597;
	bh=64wjJVZiRc3pj6HRhOw217GjQVtWgCF9ct8k5IILpYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jk7SidB64Dn6jhwKXtvvlzhNIpln0Utu+JVYXhIpRoUTank3B4aCC+uQERaL6qfE3
	 8kwjJMGVqDbV4RIKEsfb2Dc5/hShPa6iksxngzzDC7p9Un2tccWfsRXPCud9hRwqgi
	 pfKyKMM6aWhXBgGbWNkL7IV6vTmqkLEnGEd7f4PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinayak Yadawad <vinayak.yadawad@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 389/634] cfg80211: Update Transition Disable policy during port authorization
Date: Fri,  9 Jan 2026 12:41:07 +0100
Message-ID: <20260109112132.168896533@linuxfoundation.org>
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

From: Vinayak Yadawad <vinayak.yadawad@broadcom.com>

[ Upstream commit 0ff57171d6d225558c81a69439d5323e35b40549 ]

In case of 4way handshake offload, transition disable policy
updated by the AP during EAPOL 3/4 is not updated to the upper layer.
This results in mismatch between transition disable policy
between the upper layer and the driver. This patch addresses this
issue by updating transition disable policy as part of port
authorization indication.

Signed-off-by: Vinayak Yadawad <vinayak.yadawad@broadcom.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: a519be2f5d95 ("wifi: mac80211: do not use old MBSSID elements")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c  |  2 +-
 include/net/cfg80211.h                               |  4 +++-
 include/uapi/linux/nl80211.h                         |  3 +++
 net/wireless/core.h                                  |  5 ++++-
 net/wireless/nl80211.c                               |  8 +++++++-
 net/wireless/nl80211.h                               |  3 ++-
 net/wireless/sme.c                                   | 12 ++++++++----
 net/wireless/util.c                                  |  4 +++-
 8 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 7eec5eb62371..6e7de5dce49e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6009,7 +6009,7 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 	brcmf_dbg(CONN, "Report roaming result\n");
 
 	if (profile->use_fwsup == BRCMF_PROFILE_FWSUP_1X && profile->is_ft) {
-		cfg80211_port_authorized(ndev, profile->bssid, GFP_KERNEL);
+		cfg80211_port_authorized(ndev, profile->bssid, NULL, 0, GFP_KERNEL);
 		brcmf_dbg(CONN, "Report port authorized\n");
 	}
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e35bc5c35732..d15033420ca3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -7825,6 +7825,8 @@ void cfg80211_roamed(struct net_device *dev, struct cfg80211_roam_info *info,
  *
  * @dev: network device
  * @bssid: the BSSID of the AP
+ * @td_bitmap: transition disable policy
+ * @td_bitmap_len: Length of transition disable policy
  * @gfp: allocation flags
  *
  * This function should be called by a driver that supports 4 way handshake
@@ -7835,7 +7837,7 @@ void cfg80211_roamed(struct net_device *dev, struct cfg80211_roam_info *info,
  * indicate the 802.11 association.
  */
 void cfg80211_port_authorized(struct net_device *dev, const u8 *bssid,
-			      gfp_t gfp);
+			      const u8* td_bitmap, u8 td_bitmap_len, gfp_t gfp);
 
 /**
  * cfg80211_disconnected - notify cfg80211 that connection was dropped
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c32e7616a366..c14a91bbca7c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2749,6 +2749,8 @@ enum nl80211_commands {
  *	When used with %NL80211_CMD_FRAME_TX_STATUS, indicates the ack RX
  *	timestamp. When used with %NL80211_CMD_FRAME RX notification, indicates
  *	the incoming frame RX timestamp.
+ * @NL80211_ATTR_TD_BITMAP: Transition Disable bitmap, for subsequent
+ *	(re)associations.
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3276,6 +3278,7 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TX_HW_TIMESTAMP,
 	NL80211_ATTR_RX_HW_TIMESTAMP,
+	NL80211_ATTR_TD_BITMAP,
 
 	/* add attributes here, update the policy in nl80211.c */
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index ee980965a7cf..17dfdf9fe749 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -277,6 +277,8 @@ struct cfg80211_event {
 		} ij;
 		struct {
 			u8 bssid[ETH_ALEN];
+			const u8 *td_bitmap;
+			u8 td_bitmap_len;
 		} pa;
 	};
 };
@@ -421,7 +423,8 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 			bool wextev);
 void __cfg80211_roamed(struct wireless_dev *wdev,
 		       struct cfg80211_roam_info *info);
-void __cfg80211_port_authorized(struct wireless_dev *wdev, const u8 *bssid);
+void __cfg80211_port_authorized(struct wireless_dev *wdev, const u8 *bssid,
+				const u8 *td_bitmap, u8 td_bitmap_len);
 int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev);
 void cfg80211_autodisconnect_wk(struct work_struct *work);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3ff2fe98a974..1ab60967d6cd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -18016,7 +18016,8 @@ void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
 }
 
 void nl80211_send_port_authorized(struct cfg80211_registered_device *rdev,
-				  struct net_device *netdev, const u8 *bssid)
+				  struct net_device *netdev, const u8 *bssid,
+				  const u8 *td_bitmap, u8 td_bitmap_len)
 {
 	struct sk_buff *msg;
 	void *hdr;
@@ -18036,6 +18037,11 @@ void nl80211_send_port_authorized(struct cfg80211_registered_device *rdev,
 	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, bssid))
 		goto nla_put_failure;
 
+	if ((td_bitmap_len > 0) && td_bitmap)
+		if (nla_put(msg, NL80211_ATTR_TD_BITMAP,
+			    td_bitmap_len, td_bitmap))
+			goto nla_put_failure;
+
 	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 855d540ddfb9..ba9457e94c43 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -83,7 +83,8 @@ void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
 			 struct net_device *netdev,
 			 struct cfg80211_roam_info *info, gfp_t gfp);
 void nl80211_send_port_authorized(struct cfg80211_registered_device *rdev,
-				  struct net_device *netdev, const u8 *bssid);
+				  struct net_device *netdev, const u8 *bssid,
+				  const u8 *td_bitmap, u8 td_bitmap_len);
 void nl80211_send_disconnected(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev, u16 reason,
 			       const u8 *ie, size_t ie_len, bool from_ap);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 26106802b17b..5adf3912f585 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1270,7 +1270,8 @@ void cfg80211_roamed(struct net_device *dev, struct cfg80211_roam_info *info,
 }
 EXPORT_SYMBOL(cfg80211_roamed);
 
-void __cfg80211_port_authorized(struct wireless_dev *wdev, const u8 *bssid)
+void __cfg80211_port_authorized(struct wireless_dev *wdev, const u8 *bssid,
+					const u8 *td_bitmap, u8 td_bitmap_len)
 {
 	ASSERT_WDEV_LOCK(wdev);
 
@@ -1283,11 +1284,11 @@ void __cfg80211_port_authorized(struct wireless_dev *wdev, const u8 *bssid)
 		return;
 
 	nl80211_send_port_authorized(wiphy_to_rdev(wdev->wiphy), wdev->netdev,
-				     bssid);
+				     bssid, td_bitmap, td_bitmap_len);
 }
 
 void cfg80211_port_authorized(struct net_device *dev, const u8 *bssid,
-			      gfp_t gfp)
+			      const u8 *td_bitmap, u8 td_bitmap_len, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
@@ -1297,12 +1298,15 @@ void cfg80211_port_authorized(struct net_device *dev, const u8 *bssid,
 	if (WARN_ON(!bssid))
 		return;
 
-	ev = kzalloc(sizeof(*ev), gfp);
+	ev = kzalloc(sizeof(*ev) + td_bitmap_len, gfp);
 	if (!ev)
 		return;
 
 	ev->type = EVENT_PORT_AUTHORIZED;
 	memcpy(ev->pa.bssid, bssid, ETH_ALEN);
+	ev->pa.td_bitmap = ((u8 *)ev) + sizeof(*ev);
+	ev->pa.td_bitmap_len = td_bitmap_len;
+	memcpy((void *)ev->pa.td_bitmap, td_bitmap, td_bitmap_len);
 
 	/*
 	 * Use the wdev event list so that if there are pending
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 00c1530e1979..b513e24572a3 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1113,7 +1113,9 @@ void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 			__cfg80211_leave(wiphy_to_rdev(wdev->wiphy), wdev);
 			break;
 		case EVENT_PORT_AUTHORIZED:
-			__cfg80211_port_authorized(wdev, ev->pa.bssid);
+			__cfg80211_port_authorized(wdev, ev->pa.bssid,
+						   ev->pa.td_bitmap,
+						   ev->pa.td_bitmap_len);
 			break;
 		}
 		wdev_unlock(wdev);
-- 
2.51.0



