Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDB2EB8
	for <patches@lists.linux.dev>; Wed, 13 Sep 2023 18:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694630286; x=1726166286;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xI88hAM69WWRoFYmYgNa2YKj3tBz+3B5FzPZW/C4gzc=;
  b=aHboj0JDhnCCKAWVexTE5F/FVlH6FAH5v2HeLjuWaHAiaT90ZmoVy1IU
   xHaPajeXiZnQqy33sTchbUTOJXdQqJG+pnLnkJpHykyEAGSH7oDDgQwFx
   iCScn9CMZtZqsixQL6dXIQdXeq2AJKh+yjUwc2Cpw/F5PYonh1RvbnixD
   3+QvLZz1ehfq69oGOM5uU4cUVMxvgoLY1DudPYZNsYPo5NdRmM/o9wB4U
   1ubsgd8+7Xn9nOFMc5AkOnMcYtQalKetboTBs5PLyKXELNY/jevjnrrL1
   aV+EuIJmgyXIXElDo9QEQdQ5pTNVmeitSmujpKk81ho+e1MtKh30wMCRM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="369019201"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="369019201"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 11:37:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="744238603"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="744238603"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 11:37:57 -0700
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
Subject: [PATCH 09/10] platform/x86/intel/ifs: Add new error code
Date: Wed, 13 Sep 2023 11:33:47 -0700
Message-Id: <20230913183348.1349409-10-jithu.joseph@intel.com>
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

Make driver aware of a newly added error code so that it can
provide a more appropriate error message.

Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
---
 drivers/platform/x86/intel/ifs/runtest.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/runtest.c b/drivers/platform/x86/intel/ifs/runtest.c
index ba3f9ad88a82..997d2f07aa0c 100644
--- a/drivers/platform/x86/intel/ifs/runtest.c
+++ b/drivers/platform/x86/intel/ifs/runtest.c
@@ -40,6 +40,8 @@ enum ifs_status_err_code {
 	IFS_UNASSIGNED_ERROR_CODE		= 7,
 	IFS_EXCEED_NUMBER_OF_THREADS_CONCURRENT	= 8,
 	IFS_INTERRUPTED_DURING_EXECUTION	= 9,
+	IFS_UNASSIGNED_ERROR_CODE_0xA		= 0xA,
+	IFS_CORRUPTED_CHUNK		= 0xB,
 };
 
 static const char * const scan_test_status[] = {
@@ -55,6 +57,8 @@ static const char * const scan_test_status[] = {
 	[IFS_EXCEED_NUMBER_OF_THREADS_CONCURRENT] =
 	"Exceeded number of Logical Processors (LP) allowed to run Scan-At-Field concurrently",
 	[IFS_INTERRUPTED_DURING_EXECUTION] = "Interrupt occurred prior to SCAN start",
+	[IFS_UNASSIGNED_ERROR_CODE_0xA] = "Unassigned error code 0xA",
+	[IFS_CORRUPTED_CHUNK] = "Scan operation aborted due to corrupted image. Try reloading",
 };
 
 static void message_not_tested(struct device *dev, int cpu, union ifs_status status)
@@ -123,6 +127,8 @@ static bool can_restart(union ifs_status status)
 	case IFS_MISMATCH_ARGUMENTS_BETWEEN_THREADS:
 	case IFS_CORE_NOT_CAPABLE_CURRENTLY:
 	case IFS_UNASSIGNED_ERROR_CODE:
+	case IFS_UNASSIGNED_ERROR_CODE_0xA:
+	case IFS_CORRUPTED_CHUNK:
 		break;
 	}
 	return false;
-- 
2.25.1

