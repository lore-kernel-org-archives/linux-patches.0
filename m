Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488351367
	for <patches@lists.linux.dev>; Thu, 28 Apr 2022 15:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651160349; x=1682696349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CuWq5/+Z/B81lbzlKa//2RLsdmx1GbsReZrpsHXJ32k=;
  b=XxzU/nQRlVGVi54j5WnM3UBEKOlWcLhwnZRYg5k+jaVQJeeKXrkMxq4e
   1MPM1xaW8SSbBWgr0F9DZ58gvLwUMm7vzgQQIaBG8N8nQ/WJlgLCIqSmi
   Q5eYRFu36Qa28XBXz/WPQsBwXYnVXcbQTHQjevOCBV4i+z8xxa62HGMV5
   U9nJTfwzQtuAJoJoXJkY+vS9341olIX2tb2M62XUtY0UXRMq/FEO85dXa
   IbOh1qRxFRUMAcDq6EZrWDZIvkTGoPMyjgPACF3j/BGOwCiDDekV990VG
   qe+pxS8wzHpvwpqylxK4fOglQd8jON4BfazPPPjDrtKmQTCxyUZjR2Om+
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="352759583"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="352759583"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 08:39:02 -0700
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="559734335"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 08:39:02 -0700
From: Tony Luck <tony.luck@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	corbet@lwn.net,
	gregkh@linuxfoundation.org,
	andriy.shevchenko@linux.intel.com,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	rostedt@goodmis.org,
	dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: [PATCH v5 05/10] platform/x86/intel/ifs: Check IFS Image sanity
Date: Thu, 28 Apr 2022 08:38:44 -0700
Message-Id: <20220428153849.295779-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220428153849.295779-1-tony.luck@intel.com>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jithu Joseph <jithu.joseph@intel.com>

IFS image is designed specifically for a given family, model and
stepping of the processor. Like Intel microcode header, the IFS image
has the Processor Signature, Checksum and Processor Flags that must be
matched with the information returned by the CPUID.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Co-developed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/load.c | 68 +++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index 9fb71d38c819..aece78d1c757 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -2,9 +2,74 @@
 /* Copyright(c) 2022 Intel Corporation. */
 
 #include <linux/firmware.h>
+#include <asm/cpu.h>
+#include <asm/microcode_intel.h>
 
 #include "ifs.h"
 
+static int ifs_sanity_check(struct device *dev,
+			    const struct microcode_header_intel *mc_header)
+{
+	unsigned long total_size, data_size;
+	u32 sum, i;
+	u8 *mc;
+
+	total_size = get_totalsize(mc_header);
+	data_size = get_datasize(mc_header);
+
+	if ((data_size + MC_HEADER_SIZE > total_size) || (total_size % sizeof(u32))) {
+		dev_err(dev, "bad ifs data file size.\n");
+		return -EINVAL;
+	}
+
+	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
+		dev_err(dev, "invalid/unknown ifs update format.\n");
+		return -EINVAL;
+	}
+
+	mc = (u8 *)mc_header;
+	sum = 0;
+	i = total_size / sizeof(u32);
+	while (i--)
+		sum += ((u32 *)mc)[i];
+
+	if (sum) {
+		dev_err(dev, "bad ifs data checksum, aborting.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static bool find_ifs_matching_signature(struct device *dev, struct ucode_cpu_info *uci,
+					const struct microcode_header_intel *shdr)
+{
+	unsigned int mc_size;
+
+	mc_size = get_totalsize(shdr);
+
+	if (!mc_size || ifs_sanity_check(dev, shdr) < 0) {
+		dev_err(dev, "ifs sanity check failure\n");
+		return false;
+	}
+
+	if (!intel_cpu_signatures_match(uci->cpu_sig.sig, uci->cpu_sig.pf, shdr->sig, shdr->pf)) {
+		dev_err(dev, "ifs signature, pf not matching\n");
+		return false;
+	}
+
+	return true;
+}
+
+static bool ifs_image_sanity_check(struct device *dev, const struct microcode_header_intel *data)
+{
+	struct ucode_cpu_info uci;
+
+	intel_cpu_collect_info(&uci);
+
+	return find_ifs_matching_signature(dev, &uci, data);
+}
+
 /*
  * Load ifs image. Before loading ifs module, the ifs image must be located
  * in /lib/firmware/intel/ifs and named as {family/model/stepping}.{testname}.
@@ -24,5 +89,8 @@ void ifs_load_firmware(struct device *dev)
 		return;
 	}
 
+	if (!ifs_image_sanity_check(dev, (struct microcode_header_intel *)fw->data))
+		dev_err(dev, "ifs header sanity check failed\n");
+
 	release_firmware(fw);
 }
-- 
2.35.1

