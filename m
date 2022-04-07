Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1692596
	for <patches@lists.linux.dev>; Thu,  7 Apr 2022 19:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649358861; x=1680894861;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=+eR5D0XLFb0F39D069TY7O/BYuSHP4xfr5BdPVb8HQk=;
  b=EwlVE5wGaQiuP5pfwIZuT4qW2Wa6E1M7WVUqJPGVaqgCd+/qd1fcHhDu
   lI2hgFv0UwZuEANzKtJK2omW8+p6cLYlEE77JIXpko85tUxAfAQtVYRgg
   Q52eD02JqLSPSB6RsiHHb+NClYaZ3V28EaOUnElsyi6I0ELZbnPPyas0w
   EWwMRmPqOPyLYA2Jjclc4Rqpx2wc8al0BJxYEytBo3z/APu+xCPbkX6p/
   a7/w0252NPFgXomScqTrqTcGCk8un5kezw0QpX5WuXyDQ5OAPArPCtWVr
   k8okRks0N6wRYSt9iy+196Yr4TUrGTfGxdzS7ZRGLAzJblzN6HNn3PU8X
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="322111004"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="322111004"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 12:14:17 -0700
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="571193717"
Received: from coffy.sc.intel.com ([10.3.79.166])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 12:14:17 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
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
Subject: [PATCH v2 05/10] platform/x86/intel/ifs: Check IFS Image sanity
Date: Thu,  7 Apr 2022 12:13:42 -0700
Message-Id: <20220407191347.9681-6-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220407191347.9681-1-jithu.joseph@intel.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

IFS image is designed specifically for a given family, model and
stepping of the processor. Like Intel microcode header, the IFS image
has the Processor Signature, Checksum and Processor Flags that must be
matched with the information returned by the CPUID.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 drivers/platform/x86/intel/ifs/load.c | 67 +++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index a1be4d6558a1..8f2735775f5b 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -3,6 +3,7 @@
 
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
+#include <asm/microcode_intel.h>
 
 #include "ifs.h"
 static const char *ifs_path = "intel/ifs/";
@@ -24,6 +25,67 @@ struct ifs_header {
 #define IFS_HEADER_SIZE	(sizeof(struct ifs_header))
 static struct ifs_header *ifs_header_ptr;	/* pointer to the ifs image header */
 static u64 ifs_hash_ptr;			/* Address of ifs metadata (hash) */
+static int ifs_sanity_check(void *mc)
+{
+	struct microcode_header_intel *mc_header = mc;
+	unsigned long total_size, data_size;
+	u32 sum, i;
+
+	total_size = get_totalsize(mc_header);
+	data_size = get_datasize(mc_header);
+
+	if ((data_size + MC_HEADER_SIZE > total_size) || (total_size % sizeof(u32))) {
+		dev_err(&ifs_pdev->dev, "bad ifs data file size.\n");
+		return -EINVAL;
+	}
+
+	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
+		dev_err(&ifs_pdev->dev, "invalid/unknown ifs update format.\n");
+		return -EINVAL;
+	}
+
+	sum = 0;
+	i = total_size / sizeof(u32);
+	while (i--)
+		sum += ((u32 *)mc)[i];
+
+	if (sum) {
+		dev_err(&ifs_pdev->dev, "bad ifs data checksum, aborting.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static bool find_ifs_matching_signature(struct ucode_cpu_info *uci, void *mc)
+{
+	struct microcode_header_intel *shdr;
+	unsigned int mc_size;
+
+	shdr = (struct microcode_header_intel *)mc;
+	mc_size = get_totalsize(shdr);
+
+	if (!mc_size || ifs_sanity_check(shdr) < 0) {
+		dev_err(&ifs_pdev->dev, "ifs sanity check failure\n");
+		return false;
+	}
+
+	if (!cpu_signatures_match(uci->cpu_sig.sig, uci->cpu_sig.pf, shdr->sig, shdr->pf)) {
+		dev_err(&ifs_pdev->dev, "ifs signature, pf not matching\n");
+		return false;
+	}
+
+	return true;
+}
+
+static bool ifs_image_sanity_check(void *data)
+{
+	struct ucode_cpu_info uci;
+
+	cpu_collect_info_early(&uci);
+
+	return find_ifs_matching_signature(&uci, data);
+}
 
 static const struct firmware *load_binary(const char *path)
 {
@@ -36,6 +98,11 @@ static const struct firmware *load_binary(const char *path)
 		goto out;
 	}
 
+	if (!ifs_image_sanity_check((void *)fw->data)) {
+		dev_err(&ifs_pdev->dev, "ifs header sanity check failed\n");
+		release_firmware(fw);
+		fw = NULL;
+	}
 out:
 
 	return fw;
-- 
2.17.1

