Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CEA369D7A;
	Sat, 12 Sep 2026 07:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198862; cv=none; b=RQ/sGZ7miJ0xZ06TD1PmmM+pKjLJ6B8TC6wcz7suPtpgzNAOOzMjJ73RtZZPN+qqrjtdAJ5uN6A7YUH+vaPIoRZ1FYNWUZRcGD3ijI7nLu7Py/8D81+7BUaGHR8yQH0tTjc8uUi3SCdOKdvzHCLeq+S+zKVYwGQ5FzjxkCJxseg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198862; c=relaxed/simple;
	bh=9rh5682vZ0Lgxcxd+tH1ru4m0TLE571H3q4omx00QaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d452oK9mbKeOwzob2t5XxMa82238mmBwldA1ZdH1CESwAz5JDKj+R+ijfhoixU0HpNwOuT7tWzcYfCzDfI9tO3F97yb482TBx/K8e19MYFQVli7soNtmFphuwK7cGZBr46qFuTqDq7MRq0/5/5JRD8UwY5DooKiDIDQLoGxwYLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SltPIdfU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SltPIdfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2BB1F000FF;
	Sat, 12 Sep 2026 07:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198854;
	bh=o+zNbOvXKLHpww59RgN58iJ16ShxiPSkYX0vsjY7lCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SltPIdfU8315Fbgug+lGSUmT0FEC6n9voaEoxr8GidEOLB99qb6ENThfQ1KYHIVuZ
	 qah0f/EhEVDtbjIUOonAizfJGjgyM3cvKUPFstytIQt4vdb9H+CQgTlJ8IVZ2pZbb9
	 sSdxqg67VjDhiotmianjP3kqvsmzrrjBasbTmOrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0467/1815] wifi: iwlwifi: guard against division by zero in iwl_dbg_tlv_alloc_fragments
Date: Sat, 12 Sep 2026 08:36:57 +0200
Message-ID: <20260912065659.851329890@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index b1a55909f0d4b..11763dec77eca 100644
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
@@ -611,6 +611,9 @@ static int iwl_dbg_tlv_alloc_fragments(struct iwl_fw_runtime *fwrt,
 	    cpu_to_le32(IWL_FW_INI_LOCATION_DRAM_PATH))
 		return 0;
 
+	if (!fw_mon_cfg->req_size)
+		return -EIO;
+
 	num_frags = le32_to_cpu(fw_mon_cfg->max_frags_num);
 	if (fwrt->trans->mac_cfg->device_family < IWL_DEVICE_FAMILY_AX210) {
 		if (alloc_id != IWL_FW_INI_ALLOCATION_ID_DBGC1)
@@ -621,6 +624,9 @@ static int iwl_dbg_tlv_alloc_fragments(struct iwl_fw_runtime *fwrt,
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



