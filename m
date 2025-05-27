Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE961D63EF;
	Tue, 27 May 2025 17:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367862; cv=none; b=IXnefpwvIwP9zwri9Lz7gaF8+BV3I9eR81NXNbMTfhx0WWRBe06X/xNXex6OLheG+k/Im8OxLno495qhCnN+cHu1nwDTCTkjX6L1mQ/g7iGYZOJX2BWu6Oo3he0nj1XJQomFe+IxdU/l3ns1QchNUvV0TCNKe3iFpedVVGAB/X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367862; c=relaxed/simple;
	bh=0OnMaRwGpDAOn9CDjuVo6/ZAGNgg1vUFK1U6m1bx1q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uwy+pfhcfCHK+dmnwglgkhtfWoSXHl70KNLkPr38Mn26it4E5l8hYsXNFr06MQu+3H/YOSyGQ6aenYGHQj377Ul4eZriZ/0zh0KrW3iui3FexXQHVBD5N5OrAXAWWnawNAb1EInIhT/Bu5qtztHYfinfBTtAsXomgLJ44Ydwrzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PnfBbGgW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnfBbGgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83531C4CEE9;
	Tue, 27 May 2025 17:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367861;
	bh=0OnMaRwGpDAOn9CDjuVo6/ZAGNgg1vUFK1U6m1bx1q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnfBbGgW2FO52W1M9xaGj1VkgrLCWvD0by+K3S4FMtDKDi7nnH71hqoh7VF6Z/tU8
	 TvYJLPE2VWi0RERed6yiA5lP4okmy9m7/sXe4ZVgNg39M7surUz2fXN3BbIm6eL5en
	 ckU8YHsnpprtdsUx8Mq+HyABSQ3y1S7mrjAZVDpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 523/783] wifi: mac80211: set ieee80211_prep_tx_info::link_id upon Auth Rx
Date: Tue, 27 May 2025 18:25:20 +0200
Message-ID: <20250527162534.449741242@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 8c60179b64434894eac1ffab7396bac131bc8b6e ]

This will be used by the low level driver.
Note that link_id  will be 0 in case of a non-MLO authentication.
Also fix a call-site of mgd_prepare_tx() where the link_id was not
populated.

Update the documentation to reflect the current state
ieee80211_prep_tx_info::link_id is also available in mgd_complete_tx().

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250205110958.6a590f189ce5.I1fc5c0da26b143f5b07191eb592f01f7083d55ae@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mac80211.h    | 4 ++--
 net/mac80211/driver-ops.h | 3 ++-
 net/mac80211/mlme.c       | 4 +++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dcbb2e54746c7..b421526aae851 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -7,7 +7,7 @@
  * Copyright 2007-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 - 2024 Intel Corporation
+ * Copyright (C) 2018 - 2025 Intel Corporation
  */
 
 #ifndef MAC80211_H
@@ -3829,7 +3829,7 @@ enum ieee80211_reconfig_type {
  * @was_assoc: set if this call is due to deauth/disassoc
  *	while just having been associated
  * @link_id: the link id on which the frame will be TX'ed.
- *	Only used with the mgd_prepare_tx() method.
+ *	0 for a non-MLO connection.
  */
 struct ieee80211_prep_tx_info {
 	u16 duration;
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 5acecc7bd4a99..307587c8a0037 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -2,7 +2,7 @@
 /*
 * Portions of this file
 * Copyright(c) 2016 Intel Deutschland GmbH
-* Copyright (C) 2018-2019, 2021-2024 Intel Corporation
+* Copyright (C) 2018-2019, 2021-2025 Intel Corporation
 */
 
 #ifndef __MAC80211_DRIVER_OPS
@@ -955,6 +955,7 @@ static inline void drv_mgd_complete_tx(struct ieee80211_local *local,
 		return;
 	WARN_ON_ONCE(sdata->vif.type != NL80211_IFTYPE_STATION);
 
+	info->link_id = info->link_id < 0 ? 0 : info->link_id;
 	trace_drv_mgd_complete_tx(local, sdata, info->duration,
 				  info->subtype, info->success);
 	if (local->ops->mgd_complete_tx)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ca247609f11bf..8235400b7e5d8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -8,7 +8,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018 - 2024 Intel Corporation
+ * Copyright (C) 2018 - 2025 Intel Corporation
  */
 
 #include <linux/delay.h>
@@ -4579,6 +4579,8 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
 	status_code = le16_to_cpu(mgmt->u.auth.status_code);
 
+	info.link_id = ifmgd->auth_data->link_id;
+
 	if (auth_alg != ifmgd->auth_data->algorithm ||
 	    (auth_alg != WLAN_AUTH_SAE &&
 	     auth_transaction != ifmgd->auth_data->expected_transaction) ||
-- 
2.39.5



