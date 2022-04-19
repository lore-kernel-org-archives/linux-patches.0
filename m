Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33E91374
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 16:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650386350; x=1681922350;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5ARNz7nUBZvuZ8VHGg0IyjYjwy19s9Gc7GZ5lMCyM5s=;
  b=e6paifIoboQZZX3mpWwx53LS3G+4KkZgYVz0alReA9xg3ZK9D1wJbfY/
   ieNszyR+p6WvZdej/fc5DmFfFjSGfiru8j7zyZabFTf8serEyyPVSPs8R
   UbxjkrG43KnBPv9xZNSs/qiEDbNiM5aiMeUg8O5tpo/VnHjz4NfcLsVIS
   Q7EQ8U9Evp5cmpuE5TXRrc8NoEHcVNwbyIEs0Pn7lEbaXW4y6Q2Gwv7QU
   Mjq2aT1ZmD2M/T7y0goDNuSdn4Ag1k0pN8sHSXUD62tCZZ+ofgrvbPeBX
   YXmu2p0jVgboIMzx6FO7wZjuVoRIirXHHzeerKweYi5d/rCms0H/Vr3bL
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10322"; a="244395711"
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="244395711"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:39:08 -0700
X-IronPort-AV: E=Sophos;i="5.90,273,1643702400"; 
   d="scan'208";a="554802150"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2022 09:39:08 -0700
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
Subject: [PATCH v3 06/11] platform/x86/intel/ifs: Check IFS Image sanity
Date: Tue, 19 Apr 2022 09:38:54 -0700
Message-Id: <20220419163859.2228874-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419163859.2228874-1-tony.luck@intel.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
 <20220419163859.2228874-1-tony.luck@intel.com>
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
 drivers/platform/x86/intel/ifs/load.c | 69 +++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index fa6c64707a73..b05d9055c391 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -3,9 +3,73 @@
 
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
+#include <asm/cpu.h>
+#include <asm/microcode_intel.h>
 
 static const char *ifs_path = "intel/ifs/";
 
+static int ifs_sanity_check(struct device *dev, void *mc)
+{
+	struct microcode_header_intel *mc_header = mc;
+	unsigned long total_size, data_size;
+	u32 sum, i;
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
+static bool find_ifs_matching_signature(struct device *dev, struct ucode_cpu_info *uci, void *mc)
+{
+	struct microcode_header_intel *shdr;
+	unsigned int mc_size;
+
+	shdr = (struct microcode_header_intel *)mc;
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
+static bool ifs_image_sanity_check(struct device *dev, void *data)
+{
+	struct ucode_cpu_info uci;
+
+	intel_cpu_collect_info_early(&uci);
+
+	return find_ifs_matching_signature(dev, &uci, data);
+}
+
 /*
  * Load ifs image. Before loading ifs module, the ifs image must be located
  * in /lib/firmware/intel/ifs and named as {family/model/stepping}.{testname}.
@@ -25,6 +89,11 @@ int load_ifs_binary(struct device *dev)
 		return ret;
 	}
 
+	if (!ifs_image_sanity_check(dev, (void *)fw->data)) {
+		dev_err(dev, "ifs header sanity check failed\n");
+		ret = -ENOENT;
+	}
+
 	release_firmware(fw);
 
 	return ret;
-- 
2.35.1

