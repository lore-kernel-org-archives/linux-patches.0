Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007AC2CA3
	for <patches@lists.linux.dev>; Fri,  7 Jan 2022 22:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641596091; x=1673132091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iRXggUCYvjzFUYA6NKKQDmdD9Wpx+PMAccMrHW3rXH4=;
  b=XiK2FrUuDkvgT76aEZsIstO/uN9Ccsw3nJ+o1H+diZg0HPQIqM8RMNyW
   spZuXWjgtgntPLrgbKkfWErqFQwLQu22e8fIrIW+cexo1Cm88N2HP77bD
   ABq2kGr1nFQLe6njyd4HGdJv4MphzLPpD0PhsgicfJYanIF/1dVWVYu1F
   oRpbp+FQrBu8iXBkfeOqwNnmBA69fz80lZR8suXrHVsdV5A4jmhGuXQEy
   EIg6A/mLD+3m4fwKrrJIRnvEGOWkM7wC/HC7LNxf3xy0nWhm6jca2bZ6/
   6ktMgW/CflP8rf01CPuBD1bpsVfxhAb85HfHT7wK79Ox8sg2XERkz5l30
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="242907964"
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="242907964"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 14:54:48 -0800
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="471452462"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 14:54:48 -0800
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Smita Koralahalli Channabasappa <smita.koralahallichannabasappa@amd.com>,
	Wei Huang <wei.huang2@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 3/5] x86/ras: Read/save PPIN MSR during initialization
Date: Fri,  7 Jan 2022 14:54:40 -0800
Message-Id: <20220107225442.1690165-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220107225442.1690165-1-tony.luck@intel.com>
References: <20220107225442.1690165-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the PPIN (Protected Processor Inventory Number) MSR is read by
every CPU that processes a machine check, CMCI, or just polls machine
check banks from a periodic timer. This is not a "fast" MSR, so this
adds to overhead of processing errors.

Add a new "ppin" field to the cpuinfo_x86 structure. Read and save the
PPIN during initialization. Use this copy in mce_setup() instead of
reading the MSR.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/processor.h | 2 ++
 arch/x86/kernel/cpu/common.c     | 1 +
 arch/x86/kernel/cpu/mce/core.c   | 7 +------
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 355d38c0cf60..1db5bb3413ae 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -119,6 +119,8 @@ struct cpuinfo_x86 {
 	int			x86_cache_mbm_width_offset;
 	int			x86_power;
 	unsigned long		loops_per_jiffy;
+	/* protected processor identification number */
+	u64			ppin;
 	/* cpuid returned max cores value: */
 	u16			x86_max_cores;
 	u16			apicid;
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3688f70ee0a2..9a90f96257d1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -155,6 +155,7 @@ static void ppin_init(struct cpuinfo_x86 *c)
 
 	/* Is the enable bit set? */
 	if (val & 2UL) {
+		c->ppin = __rdmsr(info->msr_ppin);
 		set_cpu_cap(c, info->feature);
 		return;
 	}
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 6ed365337a3b..ec38c0c6c235 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -139,12 +139,7 @@ noinstr void mce_setup(struct mce *m)
 	m->socketid = cpu_data(m->extcpu).phys_proc_id;
 	m->apicid = cpu_data(m->extcpu).initial_apicid;
 	m->mcgcap = __rdmsr(MSR_IA32_MCG_CAP);
-
-	if (this_cpu_has(X86_FEATURE_INTEL_PPIN))
-		m->ppin = __rdmsr(MSR_PPIN);
-	else if (this_cpu_has(X86_FEATURE_AMD_PPIN))
-		m->ppin = __rdmsr(MSR_AMD_PPIN);
-
+	m->ppin = cpu_data(m->extcpu).ppin;
 	m->microcode = boot_cpu_data.microcode;
 }
 
-- 
2.31.1

