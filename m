Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2AF361960;
	Sat, 12 Sep 2026 10:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207491; cv=none; b=JTsDk6VrWACFrz7FJVsJcVRJhKMDNYUFYVGoVoAz/LfVsp0CRp9KNipNXgEfrbsfNk9sfeQ5kj6H+AJcrZ3MX86OPvw4ysqJekDMF5WCXd3lF5INo+qBTyd/SKmqreo2RnTyRPS16BIN/QsYtD0M9Xv5Bdw9TIKEg021dpqMzxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207491; c=relaxed/simple;
	bh=Tt7zJHm5Q0EHO4ff1Q9NG6EKSLMigrxjYEg6c6sZ9AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDQ52iozJ5rpEL63q4cpzhgGLENgUS0BcvKK6M7cmZLamI61fmnflLR3/CaArrymLX4Za1ySM9b+tUryJfTqF13ATF9QCPt3UdinNcieNy8b/a6Xz3eUYbnRcX9obY2EjLcja2DD1q7+3RiCPR2zrZhUD++GA5rtbEsE00NtAOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aaxeRYdf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aaxeRYdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844621F000FF;
	Sat, 12 Sep 2026 10:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207489;
	bh=83Kde+hC+UD2wcucDQ4eRoV9RTSlZyWdtR5ovvk3Apc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aaxeRYdfACZFXPIg5BC1asYzf6hudgbR4zOPxi1xkciCNYiEsEYjoch+7PE/0o8le
	 PNf/E3gloxvIprp7WQyzZn9+psIGkVNazoCuM6/3YqZGZMJN9Ma0fj87HCVLNYfKGG
	 aPSY4LfOyrghJqBbKxXCw88RFjTgRO9MZK6v7FR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0424/1518] wifi: iwlwifi: guard against division by zero in iwl_dbg_tlv_alloc_fragments
Date: Sat, 12 Sep 2026 08:43:13 +0200
Message-ID: <20260912065633.042159604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit 9318bc0c41b24705690cf80d1596cf6b711e7027 ]

Make sure we don't end-up with a num_frags = 0 situation.
For that, check that the required size is not 0 and put a checker on
num_frags as well.

Fixes: 14124b25780d ("iwlwifi: dbg_ini: implement monitor allocation flow")
Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715220243.60121deecf2c.Iebc891c95a7bd1b2a093b0bb88532db446a758ee@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 5240dacf13607..fe37c8f75c71d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2018-2025 Intel Corporation
+ * Copyright (C) 2018-2026 Intel Corporation
  */
 #include <linux/firmware.h>
 #include "iwl-drv.h"
@@ -602,6 +602,9 @@ static int iwl_dbg_tlv_alloc_fragments(struct iwl_fw_runtime *fwrt,
 	    cpu_to_le32(IWL_FW_INI_LOCATION_DRAM_PATH))
 		return 0;
 
+	if (!fw_mon_cfg->req_size)
+		return -EIO;
+
 	num_frags = le32_to_cpu(fw_mon_cfg->max_frags_num);
 	if (fwrt->trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_AX210) {
 		if (alloc_id != IWL_FW_INI_ALLOCATION_ID_DBGC1)
@@ -612,6 +615,9 @@ static int iwl_dbg_tlv_alloc_fragments(struct iwl_fw_runtime *fwrt,
 		return -EIO;
 	}
 
+	if (!num_frags)
+		return -EIO;
+
 	remain_pages = DIV_ROUND_UP(le32_to_cpu(fw_mon_cfg->req_size),
 				    PAGE_SIZE);
 	num_frags = min_t(u32, num_frags, BUF_ALLOC_MAX_NUM_FRAGS);
-- 
2.53.0



