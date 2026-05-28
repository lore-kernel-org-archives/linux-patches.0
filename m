Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C27C335566;
	Thu, 28 May 2026 20:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999055; cv=none; b=OTmk4Ud6Dsyol8WFl/rVO2Cs6UM/G7MMmKds5CFPgjfky8ntPu0lDbN7I4mM4MRWJ2wWwZBRtKdKFVTPPlHifBG63h0z5MAkNm+JJsnaBf23CJtgVErgwaMA67uTfIwtOrQ1L5Feve+fGqgQGT15RxSI1QbIAWXjdLnTW+/46nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999055; c=relaxed/simple;
	bh=DRg1ZkHaGelnZe109SN1jVpvi66ZnMCaExur0HpBOFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGgmpykuU5y4T7Xnz+nTeXVQPXYSCvlMocvXdtpoo1DBbviapm99kamtcqne6xeaaD+FNrAGDrVr5vZE/2D6R1PrUME3DlKqBfEJThjxbh1jSEpIiTkodInVC3ZJy6zI597HZ5G6fktucxlVl5wI6bZrwMRybpj2Jv3YP3mL6ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQaa6pS6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQaa6pS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC3D1F000E9;
	Thu, 28 May 2026 20:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999054;
	bh=5+DwonjwOyCfRO8nPCRof31Uo5ta/FpvLoSZWB2cdHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQaa6pS6p8auQ/+9garKRJuqbLlwJrTvS/bRccq7gtLf9JirJfyIgBdRqhCD5u9yn
	 rBRYRH4KJln59upJ6OBugT4olNl9B+pAZwiXTbQ6KoMGfOAuYjG7Eo3IPwuUyOkTfv
	 6H9tzOYeJrbdZM91kdppX5lRFNw0zd5Sbzl1tFZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 356/461] wifi: iwlwifi: mld: dont dereference a pointer before NULL checking it
Date: Thu, 28 May 2026 21:48:05 +0200
Message-ID: <20260528194657.726310057@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit d733ed481fd20a8e7bfe5119c4e77761ba3f87ee ]

In iwl_mld_remove_link, the link->fw_id is saved at the beginning of the
function so we have it after we freed the link.

But the link pointer can be NULL, and is not checked when the fw_id is
stored.

Fix it by simply freeing the link at the end of the function.

fFixes: 0e66a39f4f0e ("wifi: iwlwifi: fix potential use after free in iwl_mld_remove_link()")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20260515151351.371f40fc6711.I6a82cfe9655564e9c5731af91c36493b26b1208e@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/link.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/link.c b/drivers/net/wireless/intel/iwlwifi/mld/link.c
index b5430e8a73d66..7496528e85874 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/link.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2024-2025 Intel Corporation
+ * Copyright (C) 2024-2026 Intel Corporation
  */
 
 #include "constants.h"
@@ -504,7 +504,6 @@ void iwl_mld_remove_link(struct iwl_mld *mld,
 	struct iwl_mld_vif *mld_vif = iwl_mld_vif_from_mac80211(bss_conf->vif);
 	struct iwl_mld_link *link = iwl_mld_link_from_mac80211(bss_conf);
 	bool is_deflink = link == &mld_vif->deflink;
-	u8 fw_id = link->fw_id;
 
 	if (WARN_ON(!link || link->active))
 		return;
@@ -512,15 +511,15 @@ void iwl_mld_remove_link(struct iwl_mld *mld,
 	iwl_mld_rm_link_from_fw(mld, bss_conf);
 	/* Continue cleanup on failure */
 
-	if (!is_deflink)
-		kfree_rcu(link, rcu_head);
-
 	RCU_INIT_POINTER(mld_vif->link[bss_conf->link_id], NULL);
 
-	if (WARN_ON(fw_id >= mld->fw->ucode_capa.num_links))
+	if (WARN_ON(link->fw_id >= mld->fw->ucode_capa.num_links))
 		return;
 
-	RCU_INIT_POINTER(mld->fw_id_to_bss_conf[fw_id], NULL);
+	RCU_INIT_POINTER(mld->fw_id_to_bss_conf[link->fw_id], NULL);
+
+	if (!is_deflink)
+		kfree_rcu(link, rcu_head);
 }
 
 void iwl_mld_handle_missed_beacon_notif(struct iwl_mld *mld,
-- 
2.53.0



