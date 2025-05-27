Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC22280008;
	Tue, 27 May 2025 17:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367009; cv=none; b=kvL2iZMFkHi5y7ho7tGPAaBOWQdEGcL87zOEZJ4ypn2PS1dM8CRZP3zUdfdvEZ3a3p4oExi6D0+OneKWGgAZOIxlFb8DHPtXxoQpig5JeJewhsr/HRoIpkZxq9TvBAp4Rjk6yBzGarIKhZvc9QBf22P3EHiZqTkW58bsKVWi+X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367009; c=relaxed/simple;
	bh=ghGHRdeFA05d0iQfsTsdacYPWJO+8/F7WrUgd2+Hbb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxEp+m1bOg5pUCZbINeTXnmrxbND61tXw4APh/kM4TOJrOcN61DqEbb22WjpH2y6lpVbxStFb3+H7hZtR3lz76POP4F70Ophi7zRAznq+BpIUtXDiNouqnoDb6S19XjquL2ERwPVW1VITuKq3qq+tzYPjsEPHaRMlF0tSxNgcEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clBjIAEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clBjIAEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73255C4CEE9;
	Tue, 27 May 2025 17:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367008;
	bh=ghGHRdeFA05d0iQfsTsdacYPWJO+8/F7WrUgd2+Hbb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clBjIAEzOk8jz84L74eAQscIb19X6d08d0RIDp9zFRldWZYawr9PLjHclvw2cAujg
	 lf9bo47zUHlzUg6mwZMoh2bA0Wb753rpXLMnAFEdwXu6Eb0bLLsG79aBoqWiblNRfp
	 ei86jNUOycAwelBJxNjZCwmtgsYkLYD36MhPbC0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 218/783] wifi: iwlwifi: fix debug actions order
Date: Tue, 27 May 2025 18:20:15 +0200
Message-ID: <20250527162522.004468875@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit eb29b4ffafb20281624dcd2cbb768d6f30edf600 ]

The order of actions taken for debug was implemented incorrectly.
Now we implemented the dump split and do the FW reset only in the
middle of the dump (rather than the FW killing itself on error.)
As a result, some of the actions taken when applying the config
will now crash the device, so we need to fix the order.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308231427.6de7fa8e63ed.I40632c48e2a67a8aca05def572a934b88ce7934b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 08d990ba8a794..ce787326aa69d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2018-2024 Intel Corporation
+ * Copyright (C) 2018-2025 Intel Corporation
  */
 #include <linux/firmware.h>
 #include "iwl-drv.h"
@@ -1372,15 +1372,15 @@ void _iwl_dbg_tlv_time_point(struct iwl_fw_runtime *fwrt,
 	switch (tp_id) {
 	case IWL_FW_INI_TIME_POINT_EARLY:
 		iwl_dbg_tlv_init_cfg(fwrt);
-		iwl_dbg_tlv_apply_config(fwrt, conf_list);
 		iwl_dbg_tlv_update_drams(fwrt);
 		iwl_dbg_tlv_tp_trigger(fwrt, sync, trig_list, tp_data, NULL);
+		iwl_dbg_tlv_apply_config(fwrt, conf_list);
 		break;
 	case IWL_FW_INI_TIME_POINT_AFTER_ALIVE:
 		iwl_dbg_tlv_apply_buffers(fwrt);
 		iwl_dbg_tlv_send_hcmds(fwrt, hcmd_list);
-		iwl_dbg_tlv_apply_config(fwrt, conf_list);
 		iwl_dbg_tlv_tp_trigger(fwrt, sync, trig_list, tp_data, NULL);
+		iwl_dbg_tlv_apply_config(fwrt, conf_list);
 		break;
 	case IWL_FW_INI_TIME_POINT_PERIODIC:
 		iwl_dbg_tlv_set_periodic_trigs(fwrt);
@@ -1390,14 +1390,14 @@ void _iwl_dbg_tlv_time_point(struct iwl_fw_runtime *fwrt,
 	case IWL_FW_INI_TIME_POINT_MISSED_BEACONS:
 	case IWL_FW_INI_TIME_POINT_FW_DHC_NOTIFICATION:
 		iwl_dbg_tlv_send_hcmds(fwrt, hcmd_list);
-		iwl_dbg_tlv_apply_config(fwrt, conf_list);
 		iwl_dbg_tlv_tp_trigger(fwrt, sync, trig_list, tp_data,
 				       iwl_dbg_tlv_check_fw_pkt);
+		iwl_dbg_tlv_apply_config(fwrt, conf_list);
 		break;
 	default:
 		iwl_dbg_tlv_send_hcmds(fwrt, hcmd_list);
-		iwl_dbg_tlv_apply_config(fwrt, conf_list);
 		iwl_dbg_tlv_tp_trigger(fwrt, sync, trig_list, tp_data, NULL);
+		iwl_dbg_tlv_apply_config(fwrt, conf_list);
 		break;
 	}
 }
-- 
2.39.5



