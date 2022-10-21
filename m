Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5AC6AA8
	for <patches@lists.linux.dev>; Fri, 21 Oct 2022 20:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666384554; x=1697920554;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QxRC+gbPUdUp3j7hZeJ/DbMqthGvlXHYc4JmKqG4KW8=;
  b=GwNmxKyd/5I5m7NMPmzYWsKu65u8nLTBSpnPfjyHDKaYzQK5ccy59Hlg
   yn1UUJ6DZA2aVNRGkYZYHOiYWEXKR1ywrjuHZF3H+FMe7GjEI3elMU9Se
   esfaiCjY4A84VeE74YGkws3uv5sqz9b9SXialHfOhN7buae9LXHBmHc2g
   /A+OGFPlFGLuAV5j71WI/gMisVBeUw206GtuVeLBXvRs5+taO0Lh5ItmP
   qGiT4+FSrieHkfIrKNXQTqls6Eu8PPrbiksgP0K4D4kBGphstTPYleqho
   uDMKPLLE0u7KPyGcsXTOGl3MgYa5OFLuYLrv/jwzuWhEg3amhwaw+bPZ6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="333675907"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="333675907"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:35 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="735701017"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="735701017"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:35 -0700
From: Jithu Joseph <jithu.joseph@intel.com>
To: hdegoede@redhat.com,
	markgross@kernel.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	gregkh@linuxfoundation.org,
	jithu.joseph@intel.com,
	ashok.raj@intel.com,
	tony.luck@intel.com,
	linux-kernel@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	patches@lists.linux.dev,
	ravi.v.shankar@intel.com,
	thiago.macieira@intel.com,
	athenas.jimenez.gonzalez@intel.com
Subject: [PATCH 07/14] x86/microcode/intel: Expose microcode_sanity_check()
Date: Fri, 21 Oct 2022 13:34:06 -0700
Message-Id: <20221021203413.1220137-8-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221021203413.1220137-1-jithu.joseph@intel.com>
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IFS test image carries the same microcode header as regular Intel
microcode blobs. Microcode blobs  use header version of 1,
whereas IFS test images will use header version of 2.

microcode_sanity_check() can be used by IFS driver to perform
sanity check of the IFS test images too.

Refactor header version as a parameter and expose this function.
Qualify the function name with intel.

No functional change intended.

Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
---
 arch/x86/include/asm/microcode_intel.h |  3 +++
 arch/x86/kernel/cpu/microcode/intel.c  | 14 +++++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index 33db2a62ed34..27eba991c6b6 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -75,6 +75,7 @@ extern void show_ucode_info_early(void);
 extern int __init save_microcode_in_initrd_intel(void);
 void reload_ucode_intel(void);
 int microcode_intel_find_matching_signature(void *mc, unsigned int csig, int cpf);
+int microcode_intel_sanity_check(void *mc, bool print_err, int hdr_ver);
 #else
 static inline __init void load_ucode_intel_bsp(void) {}
 static inline void load_ucode_intel_ap(void) {}
@@ -83,6 +84,8 @@ static inline int __init save_microcode_in_initrd_intel(void) { return -EINVAL;
 static inline void reload_ucode_intel(void) {}
 static inline int microcode_intel_find_matching_signature(void *mc, unsigned int csig, int cpf)
 	{ return 0; }
+static inline int microcode_intel_sanity_check(void *mc, bool print_err, int hdr_ver)
+	{ return -EINVAL; }
 #endif
 
 #endif /* _ASM_X86_MICROCODE_INTEL_H */
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 5473b094baee..bc3f33a25d7a 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -37,6 +37,8 @@
 #include <asm/setup.h>
 #include <asm/msr.h>
 
+#define MICROCODE_HEADER_VER 1
+
 static const char ucode_path[] = "kernel/x86/microcode/GenuineIntel.bin";
 
 /* Current microcode patch used in early patching on the APs. */
@@ -164,7 +166,7 @@ static void save_microcode_patch(struct ucode_cpu_info *uci, void *data, unsigne
 		intel_ucode_patch = p->data;
 }
 
-static int microcode_sanity_check(void *mc, bool print_err)
+int microcode_intel_sanity_check(void *mc, bool print_err, int hdr_ver)
 {
 	unsigned long total_size, data_size, ext_table_size;
 	struct microcode_header_intel *mc_header = mc;
@@ -181,9 +183,10 @@ static int microcode_sanity_check(void *mc, bool print_err)
 		return -EINVAL;
 	}
 
-	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
+	if (mc_header->ldrver != 1 || mc_header->hdrver != hdr_ver) {
 		if (print_err)
-			pr_err("Error: invalid/unknown microcode update format.\n");
+			pr_err("Error: invalid/unknown microcode update format. Header version %d\n",
+			       mc_header->hdrver);
 		return -EINVAL;
 	}
 
@@ -261,6 +264,7 @@ static int microcode_sanity_check(void *mc, bool print_err)
 	}
 	return 0;
 }
+EXPORT_SYMBOL_GPL(microcode_intel_sanity_check);
 
 /*
  * Get microcode matching with BSP's model. Only CPUs with the same model as
@@ -282,7 +286,7 @@ scan_microcode(void *data, size_t size, struct ucode_cpu_info *uci, bool save)
 		mc_size = get_totalsize(mc_header);
 		if (!mc_size ||
 		    mc_size > size ||
-		    microcode_sanity_check(data, false) < 0)
+		    microcode_intel_sanity_check(data, false, MICROCODE_HEADER_VER) < 0)
 			break;
 
 		size -= mc_size;
@@ -821,7 +825,7 @@ static enum ucode_state generic_load_microcode(int cpu, struct iov_iter *iter)
 		memcpy(mc, &mc_header, sizeof(mc_header));
 		data = mc + sizeof(mc_header);
 		if (!copy_from_iter_full(data, data_size, iter) ||
-		    microcode_sanity_check(mc, true) < 0) {
+		    microcode_intel_sanity_check(mc, true, MICROCODE_HEADER_VER) < 0) {
 			break;
 		}
 
-- 
2.25.1

