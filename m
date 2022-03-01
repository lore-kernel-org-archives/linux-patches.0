Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B745EAD
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 19:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646164558; x=1677700558;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=uC5rspVyubKHGiV6BlR4gnoUFKw65v33QJn3OEQqbkU=;
  b=BuhV+r4SH2rLp9APkW2+wS7SPBwCdgF9VEH0p87lScBkVPwVecMHhqSU
   Uh11tWyWrsUHmgTT8moBs63kUykl/eio340kYoNt/bNRttu5o9kHSaRqu
   3uvZRMY7EMVXc1Txx3yK973Z68jTr/89NZ/i93mddeUsB21d65EpT9PMd
   Kas8/tbGciUCXeEbUAylIAAacqGbrqi5K/hke3EYkCWqwMxTXfLFnp11h
   emUUdLv85II6pZ4z09gt15ur18WPTZAd76cUbXYuwhfvKR18SCLc4yERJ
   FpJMP6i3QyH/L8vym8RWt8y0Z86AF0WLPz7QIqXcED0CwPLJDpiKnNRW7
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="252958565"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="252958565"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 11:55:54 -0800
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="630133167"
Received: from coffy.sc.intel.com ([10.3.79.166])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 11:55:53 -0800
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
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com
Subject: [RFC 05/10] platform/x86/intel/ifs: Check IFS Image sanity
Date: Tue,  1 Mar 2022 11:54:52 -0800
Message-Id: <20220301195457.21152-6-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220301195457.21152-1-jithu.joseph@intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

IFS image is designed specifically for a given family, model and
stepping of the processor. Like Intel microcode header, the IFS image
has the Processor Signature, Checksum and Processor Flags that must be
matched with the information returned by the CPUID.

Originally-by: Kyung Min Park <kyung.min.park@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 drivers/platform/x86/intel/ifs/load.c | 67 +++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index 1a5e906c51af..b40f70258f8e 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -6,6 +6,7 @@
 
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
+#include <asm/microcode_intel.h>
 
 #include "ifs.h"
 static const char *ifs_path = "intel/ifs/";
@@ -27,6 +28,67 @@ struct ifs_header {
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
+		pr_err("bad ifs data file size.\n");
+		return -EINVAL;
+	}
+
+	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
+		pr_err("invalid/unknown ifs update format.\n");
+		return -EINVAL;
+	}
+
+	sum = 0;
+	i = total_size / sizeof(u32);
+	while (i--)
+		sum += ((u32 *)mc)[i];
+
+	if (sum) {
+		pr_err("bad ifs data checksum, aborting.\n");
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
+		pr_err("ifs sanity check failure\n");
+		return false;
+	}
+
+	if (!cpu_signatures_match(uci->cpu_sig.sig, uci->cpu_sig.pf, shdr->sig, shdr->pf)) {
+		pr_err("ifs signature, pf not matching\n");
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
+	collect_cpu_info_early(&uci);
+
+	return find_ifs_matching_signature(&uci, data);
+}
 
 static const struct firmware *load_binary(const char *path)
 {
@@ -45,6 +107,11 @@ static const struct firmware *load_binary(const char *path)
 		goto out;
 	}
 
+	if (!ifs_image_sanity_check((void *)fw->data)) {
+		pr_err("ifs header sanity check failed\n");
+		release_firmware(fw);
+		fw = NULL;
+	}
 out:
 	platform_device_unregister(ifs_pdev);
 
-- 
2.17.1

