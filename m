Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706983A6B92;
	Sat, 17 Oct 2026 16:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253588; cv=none; b=jSPPO0vdy9iwy/rZM3Cu+q5LV+94FtSj8ThAfz9zv6/oc4kLM7bIFz7+f3DGWglkwIBdXm9Mvnhoe3ygApAUJWivrxcKFzC+AJVo3YawFyWNIzkIEJiDkBtgVFjw/84AL+h/Ln7m0pNDamz2YKarItVJps/6qNIzGkZhVpPSn70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253588; c=relaxed/simple;
	bh=qdceNZTAuLY1MsaxFQrNb1ys+OtWRkoRdzqFUyAzPNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqEGCNfN6r8pq8F/aaxG4X3TovGGowfbyq+EgMd3AsQ3WpcM1aLehNA1bK+bM8wxq/WGHDl6cWHiQNSY+mBszCN/DyUl75qS4ZjKDO46PNCjwDlfR6JlB5w/A76c03YTJ2ZsCBhY26jXy1XYBtpMhDtHLF1MgklMzaeBD0hjVw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKpYqMi7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKpYqMi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBCC1F000C5;
	Sat, 17 Oct 2026 16:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253586;
	bh=A4rv46NSfI4f1b/at0WCFKkGM6ZNpk8nJWzZ4RlDxcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IKpYqMi7jVxpafSJkRRiHXB2BeTAQ6M39kcsKF+qG1h4QDjoNUmkopG/fRRi9WtQt
	 C4dAe2ElegWfkyxME/v4eirxVHogLPUn6r3KAxbli/CK2nFXZb2yEJl2+AttJEcaR3
	 q+DWGa8Xhllu6bRI6amnTb9g13xHFDRNeFj0XADs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 168/869] wifi: mac80211: log link information in ieee80211_determine_chan_mode
Date: Sat, 17 Oct 2026 17:50:09 +0200
Message-ID: <20261017160041.356892990@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 2e3de34f5ceebdccd9464e7400986d2131915465 ]

ieee80211_determine_chan_mode is called for each link and if there is a
downgrade, then it is interesting to know on which link it happened.
Pass through the link_id where relevant and use the new link_id_info
macro instead of sdata_info so that the link ID is printed when
relevant.

Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250101070249.d400da710fc4.I64775ec914603d3c7b0c6ea14b507c0370c11622@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 99067b58a408 ("wifi: mac80211: don't WARN for connections on invalid channels")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debug.h | 10 +++++++++-
 net/mac80211/mlme.c  | 30 +++++++++++++++++-------------
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/debug.h b/net/mac80211/debug.h
index 35a8ba25fa57f..5b81998cb0c98 100644
--- a/net/mac80211/debug.h
+++ b/net/mac80211/debug.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Portions
- * Copyright (C) 2022 - 2023 Intel Corporation
+ * Copyright (C) 2022 - 2024 Intel Corporation
  */
 #ifndef __MAC80211_DEBUG_H
 #define __MAC80211_DEBUG_H
@@ -152,6 +152,14 @@ do {									\
 		else							\
 			_sdata_err((link)->sdata, fmt, ##__VA_ARGS__);	\
 	} while (0)
+#define link_id_info(sdata, link_id, fmt, ...)				\
+	do {								\
+		if (ieee80211_vif_is_mld(&sdata->vif))			\
+			_sdata_info(sdata, "[link %d] " fmt, link_id,	\
+				    ##__VA_ARGS__);			\
+		else							\
+			_sdata_info(sdata, fmt, ##__VA_ARGS__);		\
+	} while (0)
 #define _link_id_dbg(print, sdata, link_id, fmt, ...)			\
 	do {								\
 		if (ieee80211_vif_is_mld(&(sdata)->vif))		\
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d194587bf020a..4cde4792aede9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -345,6 +345,7 @@ ieee80211_determine_ap_chan(struct ieee80211_sub_if_data *sdata,
 
 static bool
 ieee80211_verify_peer_he_mcs_support(struct ieee80211_sub_if_data *sdata,
+				     int link_id,
 				     const struct ieee80211_he_cap_elem *he_cap,
 				     const struct ieee80211_he_operation *he_op)
 {
@@ -372,9 +373,9 @@ ieee80211_verify_peer_he_mcs_support(struct ieee80211_sub_if_data *sdata,
 	 */
 	if ((mcs_80_map_tx & 0x3) == IEEE80211_HE_MCS_NOT_SUPPORTED ||
 	    (mcs_80_map_rx & 0x3) == IEEE80211_HE_MCS_NOT_SUPPORTED) {
-		sdata_info(sdata,
-			   "Missing mandatory rates for 1 Nss, rx 0x%x, tx 0x%x, disable HE\n",
-			   mcs_80_map_tx, mcs_80_map_rx);
+		link_id_info(sdata, link_id,
+			     "Missing mandatory rates for 1 Nss, rx 0x%x, tx 0x%x, disable HE\n",
+			     mcs_80_map_tx, mcs_80_map_rx);
 		return false;
 	}
 
@@ -418,9 +419,9 @@ ieee80211_verify_peer_he_mcs_support(struct ieee80211_sub_if_data *sdata,
 		if (ap_rx_val == IEEE80211_HE_MCS_NOT_SUPPORTED ||
 		    ap_tx_val == IEEE80211_HE_MCS_NOT_SUPPORTED ||
 		    ap_rx_val < ap_op_val || ap_tx_val < ap_op_val) {
-			sdata_info(sdata,
-				   "Invalid rates for %d Nss, rx %d, tx %d oper %d, disable HE\n",
-				   nss, ap_rx_val, ap_tx_val, ap_op_val);
+			link_id_info(sdata, link_id,
+				     "Invalid rates for %d Nss, rx %d, tx %d oper %d, disable HE\n",
+				     nss, ap_rx_val, ap_tx_val, ap_op_val);
 			return false;
 		}
 	}
@@ -871,8 +872,8 @@ ieee80211_determine_chan_mode(struct ieee80211_sub_if_data *sdata,
 		return elems;
 	case NL80211_BAND_6GHZ:
 		if (ap_mode < IEEE80211_CONN_MODE_HE) {
-			sdata_info(sdata,
-				   "Rejecting non-HE 6/7 GHz connection");
+			link_id_info(sdata, link_id,
+				     "Rejecting non-HE 6/7 GHz connection");
 			ret = -EINVAL;
 			goto free;
 		}
@@ -943,16 +944,18 @@ ieee80211_determine_chan_mode(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (chanreq->oper.width != ap_chandef->width || ap_mode != conn->mode)
-		sdata_info(sdata,
-			   "regulatory prevented using AP config, downgraded\n");
+		link_id_info(sdata, link_id,
+			     "regulatory prevented using AP config, downgraded\n");
 
 	if (conn->mode >= IEEE80211_CONN_MODE_HE &&
-	    (!ieee80211_verify_peer_he_mcs_support(sdata, (void *)elems->he_cap,
+	    (!ieee80211_verify_peer_he_mcs_support(sdata, link_id,
+						   (void *)elems->he_cap,
 						   elems->he_operation) ||
 	     !ieee80211_verify_sta_he_mcs_support(sdata, sband,
 						  elems->he_operation))) {
 		conn->mode = IEEE80211_CONN_MODE_VHT;
-		sdata_info(sdata, "required MCSes not supported, disabling HE\n");
+		link_id_info(sdata, link_id,
+			     "required MCSes not supported, disabling HE\n");
 	}
 
 	if (conn->mode >= IEEE80211_CONN_MODE_EHT &&
@@ -962,7 +965,8 @@ ieee80211_determine_chan_mode(struct ieee80211_sub_if_data *sdata,
 		conn->bw_limit = min_t(enum ieee80211_conn_bw_limit,
 				       conn->bw_limit,
 				       IEEE80211_CONN_BW_LIMIT_160);
-		sdata_info(sdata, "required MCSes not supported, disabling EHT\n");
+		link_id_info(sdata, link_id,
+			     "required MCSes not supported, disabling EHT\n");
 	}
 
 	/* the mode can only decrease, so this must terminate */
-- 
2.53.0



