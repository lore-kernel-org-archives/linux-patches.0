Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC955038E1;
	Thu, 17 Sep 2026 16:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664011; cv=none; b=q3w2mWCTnVvkT3BR75bBtucAtITLdaD22U6fGzozQwvMWPOUcC9n+wIL/cRLMujSdtr+1CJKxDq4+2rEB3WgfYRp//u0labTXMW9UXFMnO16z6nuTMy8M+JjJSiN3MKwA1+6ED46N4ugEqlEJSIWXpuo05SNZAKw60oam/z5vqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664011; c=relaxed/simple;
	bh=fhnWNmYx3GB1/zD3D2A+RTuBazo6q+JwXq+htzz1vFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHrc2RLETyAgo7iyIyVgL99PYucGFBkvHeEcilWZNc+ncRYYvL0TagVbeTfdaR3lK6lIF1wL2jjgu4WbH85B1R5T2Png2bs/u6A3nc0RuOliiaDjGcfZTQBkdEU3oSewK0qEoJwVkZOOXCSUrMoRIfySakwdO6lowUbItHOmp/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ic5AvYAl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ic5AvYAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211761F000FF;
	Thu, 17 Sep 2026 16:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664010;
	bh=C0vGqhlrjnAC3n3YXkqEkdSHQ7JTd/YbZbtzpTJCVIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ic5AvYAlkMGDgRefcSdTUjqOmWEhuedLnltjF/Bg8tKQ17QlLjNqISJeC8U6CJOex
	 zZRKtwUC7zFGf4sJhpa2Kz6i9P1WKgr2nVCvnhdEQ4cQsGA/qXOPbPxrTYLORkjhiR
	 bjGLYRU4UQ7rCo8ns6pHEhKViLdv0ftm1wvjOsC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0212/1250] wifi: iwlwifi: mld: honor BSS_CHANGED_BEACON_ENABLED
Date: Thu, 17 Sep 2026 16:00:07 +0100
Message-ID: <20260917151557.872310365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit a342c99cb70dde344723f6c802efd24e614f4fda ]

We should stick to mac80211's flow to start / stop beaconing. This
allows to stop beaconing before we remove the BIGTK.

Note that the start and stop beaconing flows are not exactly symmetric.
When we start beaconing, we just update the beacon template. We assume
that mac80211 won't update the beacons, if we're not supposed to be
sending it.

Also note that we now send the beacon template after the broadcast
station was added to the firmware: the broadcast station is added in
the start_ap() flow, while the beacon template is now added in the
link_changed() flow which happens later. This is not what we did
before this patch, but this sequence is supported by the firmware as
well.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260511203428.cf10e5754171.I8022517c6c5aedb4b56fba30a5545de8f62dddbe@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/ap.c   | 25 +++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mld/ap.h   |  6 ++++-
 .../net/wireless/intel/iwlwifi/mld/mac80211.c |  8 +++++-
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ap.c b/drivers/net/wireless/intel/iwlwifi/mld/ap.c
index 5c59acc8c4c5a..c29e4a77be058 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ap.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ap.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2024 Intel Corporation
+ * Copyright (C) 2024, 2026 Intel Corporation
  */
 #include <linux/crc32.h>
 
@@ -239,6 +239,25 @@ int iwl_mld_store_ap_early_key(struct iwl_mld *mld,
 	return -ENOSPC;
 }
 
+void iwl_mld_stop_beacon(struct iwl_mld *mld, struct ieee80211_vif *vif,
+			 struct ieee80211_bss_conf *link)
+{
+	struct iwl_mld_link *mld_link = iwl_mld_link_from_mac80211(link);
+	struct iwl_mac_beacon_cmd cmd = {};
+	int cmd_ver = iwl_fw_lookup_cmd_ver(mld->fw, BEACON_TEMPLATE_CMD, 14);
+
+	if (WARN_ON(!mld_link))
+		return;
+
+	if (cmd_ver < 15)
+		return;
+
+	/* leave byte_cnt 0 */
+	cmd.link_id = cpu_to_le32(mld_link->fw_id);
+
+	iwl_mld_send_cmd_pdu(mld, BEACON_TEMPLATE_CMD, &cmd);
+}
+
 static int iwl_mld_send_ap_early_keys(struct iwl_mld *mld,
 				      struct ieee80211_vif *vif,
 				      struct ieee80211_bss_conf *link)
@@ -276,10 +295,6 @@ int iwl_mld_start_ap_ibss(struct ieee80211_hw *hw,
 	if (vif->type == NL80211_IFTYPE_AP)
 		iwl_mld_send_ap_tx_power_constraint_cmd(mld, vif, link);
 
-	ret = iwl_mld_update_beacon_template(mld, vif, link);
-	if (ret)
-		return ret;
-
 	/* the link should be already activated when assigning chan context,
 	 * and LINK_CONTEXT_MODIFY_EHT_PARAMS is deprecated
 	 */
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/ap.h b/drivers/net/wireless/intel/iwlwifi/mld/ap.h
index 4a6f52b9552d7..a3b6bed814adf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/ap.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/ap.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2024 Intel Corporation
+ * Copyright (C) 2024, 2026 Intel Corporation
  */
 #ifndef __iwl_ap_h__
 #define __iwl_ap_h__
@@ -14,6 +14,10 @@ int iwl_mld_update_beacon_template(struct iwl_mld *mld,
 				   struct ieee80211_vif *vif,
 				   struct ieee80211_bss_conf *link_conf);
 
+void iwl_mld_stop_beacon(struct iwl_mld *mld,
+			 struct ieee80211_vif *vif,
+			 struct ieee80211_bss_conf *link_conf);
+
 int iwl_mld_start_ap_ibss(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif,
 			  struct ieee80211_bss_conf *link);
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 67b61765adf39..322669d78b193 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -1154,8 +1154,14 @@ iwl_mld_link_info_changed_ap_ibss(struct iwl_mld *mld,
 	if (link_changes)
 		iwl_mld_change_link_in_fw(mld, link, link_changes);
 
-	if (changes & BSS_CHANGED_BEACON)
+	if (changes & BSS_CHANGED_BEACON) {
+		WARN_ON(!link->enable_beacon);
 		iwl_mld_update_beacon_template(mld, vif, link);
+	}
+
+	/* Enabling beacons was already covered above */
+	if ((changes & BSS_CHANGED_BEACON_ENABLED) && !link->enable_beacon)
+		iwl_mld_stop_beacon(mld, vif, link);
 }
 
 static
-- 
2.53.0



