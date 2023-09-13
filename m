Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03037391
	for <patches@lists.linux.dev>; Wed, 13 Sep 2023 18:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694630280; x=1726166280;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zYniCTlI2hRtCCmtPBhkZpW2hr3gRwPR25GRONFDmyM=;
  b=WyYmA+d2fMDHjHuKZAD+D9shFmYa+6RrbL4++6z3ckgXl6Egnkn4exzX
   WsHvciWZR/HrH4+sx4XDbmrFG9ULsr8jG/rep6SUEizpBT87VJrFTWQ8E
   MNIBU6xfDa7/Ur86xS2TFjDZt1ZTILgOabzGi2HcAuE9eyvHgpNO//7/c
   ain0mYaOy49wGZMYmpdIygVYAXzaw9+Q790LY6sZsL3k/p74ZuDzFeDie
   idaCGklx1IiRVon6ML8Z2Y7ok6khcxxSkJsUnHLXexmQcm7feun8/Glpj
   55yOXL3unwS8ELudJy5atkpjfIgkx7+rtAF5b6OxUE+hfdJzOJZdAG2nL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="369019112"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="369019112"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 11:37:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="744238575"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="744238575"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 11:37:53 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rostedt@goodmis.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	pengfei.xu@intel.com
Subject: [PATCH 01/10] platform/x86/intel/ifs: Store IFS generation number
Date: Wed, 13 Sep 2023 11:33:39 -0700
Message-Id: <20230913183348.1349409-2-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230913183348.1349409-1-jithu.joseph@intel.com>
References: <20230913183348.1349409-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IFS generation number is reported via MSR_INTEGRITY_CAPS.
As IFS support gets added to newer CPUs, some differences
are expected during IFS image loading and test flows.

Define MSR bitmasks to extract and store the generation in
driver data, so that driver can modify its MSR interaction
appropriately.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 arch/x86/include/asm/msr-index.h      | 2 ++
 drivers/platform/x86/intel/ifs/ifs.h  | 2 ++
 drivers/platform/x86/intel/ifs/core.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 1d111350197f..a71a86a01488 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -222,6 +222,8 @@
 #define MSR_INTEGRITY_CAPS_ARRAY_BIST          BIT(MSR_INTEGRITY_CAPS_ARRAY_BIST_BIT)
 #define MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT	4
 #define MSR_INTEGRITY_CAPS_PERIODIC_BIST	BIT(MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT)
+#define MSR_INTEGRITY_CAPS_SAF_GEN_REV_SHIFT	9
+#define MSR_INTEGRITY_CAPS_SAF_GEN_REV_MASK	(0x3ull << MSR_INTEGRITY_CAPS_SAF_GEN_REV_SHIFT)
 
 #define MSR_LBR_NHM_FROM		0x00000680
 #define MSR_LBR_NHM_TO			0x000006c0
diff --git a/drivers/platform/x86/intel/ifs/ifs.h b/drivers/platform/x86/intel/ifs/ifs.h
index 93191855890f..d666aeed20fc 100644
--- a/drivers/platform/x86/intel/ifs/ifs.h
+++ b/drivers/platform/x86/intel/ifs/ifs.h
@@ -229,6 +229,7 @@ struct ifs_test_caps {
  * @status: it holds simple status pass/fail/untested
  * @scan_details: opaque scan status code from h/w
  * @cur_batch: number indicating the currently loaded test file
+ * @generation: IFS test generation enumerated by hardware
  */
 struct ifs_data {
 	int	loaded_version;
@@ -238,6 +239,7 @@ struct ifs_data {
 	int	status;
 	u64	scan_details;
 	u32	cur_batch;
+	u32	generation;
 };
 
 struct ifs_work {
diff --git a/drivers/platform/x86/intel/ifs/core.c b/drivers/platform/x86/intel/ifs/core.c
index 306f886b52d2..88d84aad9334 100644
--- a/drivers/platform/x86/intel/ifs/core.c
+++ b/drivers/platform/x86/intel/ifs/core.c
@@ -94,6 +94,8 @@ static int __init ifs_init(void)
 	for (i = 0; i < IFS_NUMTESTS; i++) {
 		if (!(msrval & BIT(ifs_devices[i].test_caps->integrity_cap_bit)))
 			continue;
+		ifs_devices[i].rw_data.generation = (msrval & MSR_INTEGRITY_CAPS_SAF_GEN_REV_MASK)
+							>> MSR_INTEGRITY_CAPS_SAF_GEN_REV_SHIFT;
 		ret = misc_register(&ifs_devices[i].misc);
 		if (ret)
 			goto err_exit;
-- 
2.25.1

