Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4212E3BE643;
	Sat, 12 Sep 2026 12:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215819; cv=none; b=tdYf+OmGYQJ9genfQeDKihudv0ydn5YssNLNwGexW7gK2enQFOutPyx04HfxTGfiV038z49Sh7JD9JhToxsNOfg2Bna7ECBru1I811qGMRZQELc2d4EoTVRLraKyeqH/ZIM4J7Kz4SebHlrWFOSr+D0E5eXfHVTyFq3FAfYEvJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215819; c=relaxed/simple;
	bh=tv2EtYBDeeW2xRwWZEm83RKyAwDpbVFTAhaUH98GyGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/rHk7lE/F0PaYmImB1fcj11GSB75zCrhd7WUk4FiHfFGo2fInnE05134vALgWW9Fm//tWMlEYec9oSvd+PSgNPGYdRzmNmsruiIArtBDzAEHdKHIdqUeMW2Z3/KmjaBj0e3AEG/A1Cz0nph4ebt1pntkqdtjGC5hE/7/YOARe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+pePH+q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+pePH+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154A81F000FF;
	Sat, 12 Sep 2026 12:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215818;
	bh=1fCE2Lwu+ud4cKVL03tWc1sW2oNikCqBrzgqkxR/jO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+pePH+quFGXjUX+oS7upCj+0VHOofRlgiVRp7VW+I6ruFZpb4iW8IVPhddPpyq9M
	 KQkhmUbRiWHrc2D4LmQe+pslzHkfttRIFnmHUVVH9BmBjhEX87wkS4qYLNWLdoOkV3
	 WtyznNBSzSNnTMgkfy1TIUAy8j/sUJ8sK4EMh7lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0567/1376] wifi: iwlwifi: guard against division by zero in iwl_dbg_tlv_alloc_fragments
Date: Sat, 12 Sep 2026 08:49:53 +0200
Message-ID: <20260912065620.168907430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index ce787326aa69d..47d5488c95043 100644
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
 	if (fwrt->trans->trans_cfg->device_family < IWL_DEVICE_FAMILY_AX210) {
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



