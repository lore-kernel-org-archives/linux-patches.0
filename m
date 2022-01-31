Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6732C3FE5
	for <patches@lists.linux.dev>; Mon, 31 Jan 2022 23:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643670081; x=1675206081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D5IxgMQQPsxXkTofIEcbAivuT+zDal3E4DIqU1/Lh7U=;
  b=OcR10lFZdmFO3m6YTSNl+X/z6R81KRmHG5L4quarvsg2rNYCqDfx9buz
   i0i0mplhyU4Esu3Tiux1ygwivS9WbgBow3bYFSeAaoxqvS1xyacJLw1O4
   nZfDq+Sog5p+7mf/KjjJIO/1JsIsjKUA3zwvEqF1r4aeLaqR61HlE741t
   azdxKGIccwe/ZC88O/LH5Hh3HrhxiB1paP53H3Y5agfLFpviYVhPQhfSV
   CrT6oHMqQTyqeZ77VCJ71ZHnf/c15IJ7Pya24y5CgSC74XvgFy93L5o/N
   91QhaohEUOWxa+gJSQxD8jACGQoyI80HkDI4SQU+ypXq7NFzibPGhpoHW
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="234960830"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="234960830"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 15:01:18 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="522831341"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 15:01:18 -0800
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
Subject: [PATCH v3 2/5] x86/cpu: X86_FEATURE_INTEL_PPIN finally has a CPUID bit
Date: Mon, 31 Jan 2022 15:01:08 -0800
Message-Id: <20220131230111.2004669-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220131230111.2004669-1-tony.luck@intel.com>
References: <20220121174743.1875294-1-tony.luck@intel.com>
 <20220131230111.2004669-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After nine generations of adding to model specific list of CPUs that
support PPIN (Protected Processor Inventory Number) Intel allocated
a CPUID bit to enumerate the MSRs.

CPUID(EAX=7, ECX=1).EBX bit 0 enumerates presence of MSR_PPIN_CTL and
MSR_PPIN. Add it to the "scattered" CPUID bits and add an entry to the
ppin_cpuids[] x86_match_cpu() array to catch Intel CPUs that implement
it.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/common.c    | 1 +
 arch/x86/kernel/cpu/scattered.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index b0bd8a6b5beb..0681c69a1f09 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -104,6 +104,7 @@ static struct ppin_info {
 
 static const struct x86_cpu_id ppin_cpuids[] = {
 	X86_MATCH_FEATURE(X86_FEATURE_AMD_PPIN, &ppin_info[X86_VENDOR_AMD]),
+	X86_MATCH_FEATURE(X86_FEATURE_INTEL_PPIN, &ppin_info[X86_VENDOR_INTEL]),
 
 	/* Legacy models without CPUID enumeration */
 	X86_MATCH_INTEL_FAM6_MODEL(IVYBRIDGE_X, &ppin_info[X86_VENDOR_INTEL]),
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 21d1f062895a..4143b1e4c5c6 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -26,6 +26,7 @@ struct cpuid_bit {
 static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_APERFMPERF,       CPUID_ECX,  0, 0x00000006, 0 },
 	{ X86_FEATURE_EPB,		CPUID_ECX,  3, 0x00000006, 0 },
+	{ X86_FEATURE_INTEL_PPIN,	CPUID_EBX,  0, 0x00000007, 1 },
 	{ X86_FEATURE_CQM_LLC,		CPUID_EDX,  1, 0x0000000f, 0 },
 	{ X86_FEATURE_CQM_OCCUP_LLC,	CPUID_EDX,  0, 0x0000000f, 1 },
 	{ X86_FEATURE_CQM_MBM_TOTAL,	CPUID_EDX,  1, 0x0000000f, 1 },
-- 
2.31.1

