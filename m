Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7804835A925
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 18:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787681747; cv=none; b=ssBzyTsAiPDsLmizUpzqXUmBw3iyH9qJE3dNeLQqmz2tBclhYLem6JfdkzOrGZDZeYlU+kXygNiI7d70jAz9kAxxIokZdg3MmF/fdQzRqtgZi+sQ+o57/5Xw15lcz1C6FHCT7U8ez40WAslc2QoXkMzrkr+vylPAlZkgpWi3cG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787681747; c=relaxed/simple;
	bh=PELISMkprQd9ZEo2y8Iazx3I4f6IpFv/qOObgsRVBYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SI4c64chqfmwzPGesPw0zG1UcnVOW+iWm1IEGFLELlqqEgjsEmaUaJE9FQLhM0SBnRiL7wnA8RAMMoxWNGSKEjLckWmrLbKDDTWwqFxZUELj0HfKR3rfJlznIlELaNW/+4hlWbWjKu964zAlirw1ziLEmpcUgXjgUGbKrAqQYb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dUy04wSe; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dUy04wSe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787681739; x=1819217739;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PELISMkprQd9ZEo2y8Iazx3I4f6IpFv/qOObgsRVBYg=;
  b=dUy04wSeSLVqrmQ0duBDoA8Azyc9qNmgHBv/tIdzssppKw2bewKr/YEC
   58yo+4nuVoNcB2QJfTrYfmAUCDZxKu0k8Op2/uVyxiYjGl+bDLiFhc5lL
   WYcy3VWDu1Z1MYgWD9mu1Fwr0u8JCFMILtYCCInkJTk97t6qN1N5ar9iF
   XEgMxpTUfl1cS1lQdTna8tbzXEPMYVOhq/AaF4v3ZkKKAohU+pnAa+KNH
   iI+TrFA1DhLvKmXPpQMx7x3mS1mhWP8gVppIDOolgvTAmbiPzKNTNcqVI
   xUlGDpet0vftxz93x+6LeMK0C9LmWl8Qb5OvGTpXgX4T+N7poYx2V2SSE
   g==;
X-CSE-ConnectionGUID: o8bF4fisRayL3th4zL/YNg==
X-CSE-MsgGUID: cDRUuEtgRTeZzbZ4BQ84dw==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="88174225"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="88174225"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 11:15:35 -0700
X-CSE-ConnectionGUID: aukwALA0RqihITxgGtoj3Q==
X-CSE-MsgGUID: 9CnREe/JRaKfAbr13APjdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="265559611"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.222.141])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 11:15:35 -0700
From: Tony Luck <tony.luck@intel.com>
To: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hansg@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>,
	Breno Leitao <leitao@debian.org>,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: [PATCH 6/7] platform/x86/intel/bff: Compute unique ID for overflowed filter
Date: Tue, 25 Aug 2026 11:15:25 -0700
Message-ID: <20260825181526.13203-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825181526.13203-1-tony.luck@intel.com>
References: <20260825181526.13203-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each L2 cache instance has its own bitfix filter, but always reports
errors in machine check bank 3 (on Diamond Rapids).

Compute a unique bitfix filter instance number based on the CPU that
logged the error and the machine check bank number.

Special case for banks associated with the Integrated Memory Hub (IMH).
Here the "even" numbered CPU modules are associated with IMH0 and the
"odd" modules with IMH1.

The unique id will be used to store a time stamp of when the bitfix
filter overflowed so that frequent overflows can be logged.

Co-developed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/bff.c | 74 ++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/platform/x86/intel/bff.c b/drivers/platform/x86/intel/bff.c
index 8cc29d11e019..ae9dc0bf2777 100644
--- a/drivers/platform/x86/intel/bff.c
+++ b/drivers/platform/x86/intel/bff.c
@@ -18,13 +18,18 @@
 #define pr_fmt(fmt) "bff: " fmt
 
 #include <linux/bits.h>
+#include <linux/cacheinfo.h>
+#include <linux/cleanup.h>
 #include <linux/cpufeature.h>
+#include <linux/cpuhplock.h>
 #include <linux/device-id/x86_cpu.h>
 #include <linux/errno.h>
 #include <linux/init.h>
+#include <linux/limits.h>
 #include <linux/module.h>
 #include <linux/notifier.h>
 #include <linux/printk.h>
+#include <linux/topology.h>
 #include <linux/types.h>
 
 #include <asm/cpu_device_id.h>
@@ -34,6 +39,8 @@
 #include <asm/msr.h>
 #include <asm/msr-index.h>
 
+#define NUM_IMH_PER_SKT		2
+
 /* Intel bitfix filter control register defines */
 #define MSR_MC0_BFF_CTL		0x000006c0
 #define MSR_MCx_BFF_CTL(x)	(MSR_MC0_BFF_CTL + (x))
@@ -67,11 +74,78 @@ MODULE_DEVICE_TABLE(x86cpu, bff_cpu_ids);
 
 static const enum bff_type *bank_types;
 
+/* Diamond Rapids maps APICID[2] to the IMH instance. */
+static void bff_set_imh_id(struct mce *mce, unsigned long *id)
+{
+	int imh_num = (NUM_IMH_PER_SKT * topology_physical_package_id(mce->extcpu)) +
+		      ((mce->apicid >> 2) & 0x1);
+
+	*id |= imh_num;
+}
+
+static bool bff_set_cache_id(int cpu, int level, unsigned long *id)
+{
+	int cacheid;
+
+	guard(cpus_read_lock)();
+
+	cacheid = get_cpu_cacheinfo_id(cpu, level);
+	if (cacheid == -1) {
+		pr_warn("Could not get L%d cache id for CPU %d\n", level, cpu);
+		return false;
+	}
+
+	*id |= cacheid;
+
+	return true;
+}
+
+#define BFF_ID_BANK_SHIFT	16
+
+/*
+ * Cache IDs are only unique within a cache level.
+ * Include the MCA bank number so each BFF-capable hardware
+ * resource has a unique tracking ID.
+ */
+static unsigned long get_bff_id(struct mce *mce)
+{
+	unsigned long id = (unsigned long)mce->bank << BFF_ID_BANK_SHIFT;
+
+	switch (bank_types[mce->bank]) {
+	case BFF_BANK_DCU:
+	case BFF_BANK_DTLB:
+		if (!bff_set_cache_id(mce->extcpu, 1, &id))
+			return ULONG_MAX;
+		break;
+
+	case BFF_BANK_MLC:
+		if (!bff_set_cache_id(mce->extcpu, 2, &id))
+			return ULONG_MAX;
+		break;
+
+	case BFF_BANK_CCF:
+		if (!bff_set_cache_id(mce->extcpu, 3, &id))
+			return ULONG_MAX;
+		break;
+
+	case BFF_BANK_HSF:
+	case BFF_BANK_IOCACHE:
+		bff_set_imh_id(mce, &id);
+		break;
+	default:
+		return ULONG_MAX;
+	}
+
+	return id;
+}
+
 static void handle_bff(struct mce *mce)
 {
 	/* The bitfix filter overflowed, get the target CPU to reset it. */
 	if (wrmsrq_on_cpu(mce->extcpu, MSR_MCx_BFF_CTL(mce->bank), MCI_BFF_RESET))
 		pr_warn("Failed to reset bitfix filter for CPU %d Bank %d\n", mce->extcpu, mce->bank);
+
+	pr_debug("unique_id = 0x%lx\n", get_bff_id(mce));
 }
 
 static int bff_mce_notify(struct notifier_block *nb, unsigned long val, void *data)
-- 
2.55.0

