Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B58D13A244;
	Tue, 27 May 2025 17:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365663; cv=none; b=jpAt+HjY+FeW79l5PT7c2/W6I0CF/uhN9oc6TQF4sIdGoxJT6WMgxaxmFlTfb+FYB2mEAK60Guow2XWW3hmPJRjvR4C55E+nAExYCKJsHNE2TWilB/kPNe9BKCsaDohVOTSVUCTVHwYxgEqdoLEQBLs0y01lFOHge9HOxZP13T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365663; c=relaxed/simple;
	bh=2Mh29vkrR1uorFccW+kPq+AY73l+fqgNqqM5gV+bVkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sa6aluKkaGRU51zIxEzWFmecjuBzo1nOZ4zHHua1i8JvFFDK2myQnFPmBntYung0nB7Hf0y7Oi9oyGnE1se/TqAAdpIxaqm2hNbkVUPj2xiJw4+Rm0gp9CWr/qA0ICezt30MoDAcjm453U6+e5amFSzde+AVcPZ4z0aEMdR0M5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4BTdsmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4BTdsmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCD0C4CEE9;
	Tue, 27 May 2025 17:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365661;
	bh=2Mh29vkrR1uorFccW+kPq+AY73l+fqgNqqM5gV+bVkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4BTdsmWlhRCTPeN4ZQMCceZnl9wbcji1AgJ+Ciou7fYY8iZTYLwCoNe2HaDoWTOm
	 HRQEfWZ8Pb1PlIsoQFH4hv6CZVO4fbPMm1bRBEF64it8ghT/oYCEYJrpYPzYDUex6e
	 t4AXBRZ97VagrXCPZAhsjoXkGZrCf//DuXRFSbRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 418/626] wifi: mac80211: set ieee80211_prep_tx_info::link_id upon Auth Rx
Date: Tue, 27 May 2025 18:25:11 +0200
Message-ID: <20250527162501.995672926@linuxfoundation.org>
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
index 3b964f8834e71..fee854892bec5 100644
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
@@ -3803,7 +3803,7 @@ enum ieee80211_reconfig_type {
  * @was_assoc: set if this call is due to deauth/disassoc
  *	while just having been associated
  * @link_id: the link id on which the frame will be TX'ed.
- *	Only used with the mgd_prepare_tx() method.
+ *	0 for a non-MLO connection.
  */
 struct ieee80211_prep_tx_info {
 	u16 duration;
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index a06644084d15d..d1c10f5f95160 100644
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
index 6a23a24f7d794..8fa9b9dd46118 100644
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
@@ -4307,6 +4307,8 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
 	status_code = le16_to_cpu(mgmt->u.auth.status_code);
 
+	info.link_id = ifmgd->auth_data->link_id;
+
 	if (auth_alg != ifmgd->auth_data->algorithm ||
 	    (auth_alg != WLAN_AUTH_SAE &&
 	     auth_transaction != ifmgd->auth_data->expected_transaction) ||
-- 
2.39.5



