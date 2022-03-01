Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE17D7C
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 19:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646164555; x=1677700555;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=dD5vgT47K/7ze5uYlH7rkWVlSTm7dGQOtKM9I4Tl4yk=;
  b=SKGQr/5HHqd+9YTGaFXh4yxjLLvQdtUVZ9SLbIAN2SREqcCSVeAYel8d
   bfHfa477yiMEI1tHNmgQYwb2ZMlO0Sy5lVwEJVhoKsMDeZ+RTOl27f+CO
   oadLjGA/fRJAj9EBUH/ohrE9AoDVrFeTb5Yx0s5YZu+SdH2pcTo2LbPT+
   fsO17h6npOyt02nQVNR41dONN/d3AEVdBlu8Fwv0ppwYpu3VZU0C0XN0z
   avI5BXdF1J6/JgbvZ2sGu73qMnwUbfmCR0xppD0GPnmTvEcr6oMP2h9jq
   qfgKbMBxNkcjP1OYgZsZoq0fG2sO55JN0oDBtE255Nd2ztz2hAQ+4j11c
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="252958549"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="252958549"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 11:55:53 -0800
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="630133155"
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
Subject: [RFC 01/10] x86/microcode/intel: expose collect_cpu_info_early() for IFS
Date: Tue,  1 Mar 2022 11:54:48 -0800
Message-Id: <20220301195457.21152-2-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220301195457.21152-1-jithu.joseph@intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

IFS uses a image provided by Intel that can be regarded as firmware.
IFS image carries the Processor Signature such as family/model/stepping
similar to what we find in the microcode header.

Expose collect_cpu_info_early() and cpu_signatures_match() for IFS image
sanity check.

No functional change.

Originally-by: Kyung Min Park <kyung.min.park@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/microcode_intel.h | 6 ++++++
 arch/x86/kernel/cpu/microcode/intel.c  | 8 +++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index d85a07d7154f..ec19eeac535b 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -74,12 +74,18 @@ extern void load_ucode_intel_ap(void);
 extern void show_ucode_info_early(void);
 extern int __init save_microcode_in_initrd_intel(void);
 void reload_ucode_intel(void);
+int collect_cpu_info_early(struct ucode_cpu_info *uci);
+bool cpu_signatures_match(unsigned int s1, unsigned int p1,
+			  unsigned int s2, unsigned int p2);
 #else
 static inline __init void load_ucode_intel_bsp(void) {}
 static inline void load_ucode_intel_ap(void) {}
 static inline void show_ucode_info_early(void) {}
 static inline int __init save_microcode_in_initrd_intel(void) { return -EINVAL; }
 static inline void reload_ucode_intel(void) {}
+static inline void collect_cpu_info_early(struct ucode_cpu_info *uci) {}
+static inline void cpu_signatures_match(unsigned int s1, unsigned int p1,
+					unsigned int s2, unsigned int p2) {}
 #endif
 
 #endif /* _ASM_X86_MICROCODE_INTEL_H */
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index d28a9f8f3fec..360ec06eec1e 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -45,8 +45,8 @@ static struct microcode_intel *intel_ucode_patch;
 /* last level cache size per core */
 static int llc_size_per_core;
 
-static inline bool cpu_signatures_match(unsigned int s1, unsigned int p1,
-					unsigned int s2, unsigned int p2)
+bool cpu_signatures_match(unsigned int s1, unsigned int p1,
+			  unsigned int s2, unsigned int p2)
 {
 	if (s1 != s2)
 		return false;
@@ -58,6 +58,7 @@ static inline bool cpu_signatures_match(unsigned int s1, unsigned int p1,
 	/* ... or they intersect. */
 	return p1 & p2;
 }
+EXPORT_SYMBOL_GPL(cpu_signatures_match);
 
 /*
  * Returns 1 if update has been found, 0 otherwise.
@@ -342,7 +343,7 @@ scan_microcode(void *data, size_t size, struct ucode_cpu_info *uci, bool save)
 	return patch;
 }
 
-static int collect_cpu_info_early(struct ucode_cpu_info *uci)
+int collect_cpu_info_early(struct ucode_cpu_info *uci)
 {
 	unsigned int val[2];
 	unsigned int family, model;
@@ -372,6 +373,7 @@ static int collect_cpu_info_early(struct ucode_cpu_info *uci)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(collect_cpu_info_early);
 
 static void show_saved_mc(void)
 {
-- 
2.17.1

