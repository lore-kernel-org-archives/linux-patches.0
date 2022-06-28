Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6944C98
	for <patches@lists.linux.dev>; Tue, 28 Jun 2022 22:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656453682; x=1687989682;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NbmPwvqMll5L108yNCJnt3K6AOKe4/adCY0m7n5Bi84=;
  b=NoPcOgW6VKJ6tGTT7N9RphNOCjmmid4owhM7Nmq8I8CQRcIiXp7Ww+RX
   dSBEbbdKR9cZUS5b+NkvETzz4KV8JeMoBJUMDdNbxO135+llAPQ5JZ7Ed
   1d7GTqDm0FJTBeTh3hOyAbzpb5Kh8xz+LjwCh2VgWQoy0FDFv5IZvV+Kn
   9rVMbHMN6meX8KiYoh/NTpfBuGxBGZbsALwe28ha8tBrT5p9VOWh8W09f
   zdcY4p+7T7i/m+Axy1qMzVpNjMBOdl4WpCl4VvMpYhYS5LPn83n075vEy
   VL0l2jFiHCbvfOpgK/I76vq08P2j3xq8MpCvSXLVcQf/TWQtEJL+2M3C9
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="270622088"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="270622088"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 15:01:21 -0700
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="647098061"
Received: from vrgatne-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.43.114])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 15:01:20 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <patches@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>,
	stable@vger.kernel.org,
	Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Abhi Cs <abhi.cs@intel.com>
Subject: [PATCH v2] cxl/mbox: Fix missing variable payload checks in cmd size validation
Date: Tue, 28 Jun 2022 16:01:09 -0600
Message-Id: <20220628220109.633564-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1838; h=from:subject; bh=NbmPwvqMll5L108yNCJnt3K6AOKe4/adCY0m7n5Bi84=; b=owGbwMvMwCXGf25diOft7jLG02pJDEm7q1TbhTilbQq+72+0XrHppf+5HdOP7Vjp7ljkuqZi45rI KpGNHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZhI1zaG/07vbD7+5emJDNlhMEHejf 9H2ZyTkitTfv47xFI3y/L3yo8M/4yu/xZ2L/tYszoviy1zn1dvp7GaPLezyOP8si4vjXU72AA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

The conversion of command sizes to unsigned missed a couple of checks
against variable size payloads during command validation, which made all
variable payload commands unconditionally fail. Add the checks back using
the new CXL_VARIABLE_PAYLOAD scheme.

Fixes: 26f89535a5bb ("cxl/mbox: Use type __u32 for mailbox payload sizes")
Cc: <stable@vger.kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Reported-by: Abhi Cs <abhi.cs@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---

Since v1[1]:
- Collect Reviewed-by tags
- Don't use nested if statements, switch to a compount if () instead.
  (Alison)

[1]: https://lore.kernel.org/all/20220628200427.601714-1-vishal.l.verma@intel.com/

 drivers/cxl/core/mbox.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 40e3ccb2bf3e..16176b9278b4 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -355,11 +355,13 @@ static int cxl_to_mem_cmd(struct cxl_mem_command *mem_cmd,
 		return -EBUSY;
 
 	/* Check the input buffer is the expected size */
-	if (info->size_in != send_cmd->in.size)
+	if ((info->size_in != CXL_VARIABLE_PAYLOAD) &&
+	    (info->size_in != send_cmd->in.size))
 		return -ENOMEM;
 
 	/* Check the output buffer is at least large enough */
-	if (send_cmd->out.size < info->size_out)
+	if ((info->size_out != CXL_VARIABLE_PAYLOAD) &&
+	    (send_cmd->out.size < info->size_out))
 		return -ENOMEM;
 
 	*mem_cmd = (struct cxl_mem_command) {

base-commit: 1985cf58850562e4b960e19d46f0d8f19d6c7cbd
-- 
2.36.1

