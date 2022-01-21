Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC372CA8
	for <patches@lists.linux.dev>; Fri, 21 Jan 2022 17:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642787289; x=1674323289;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nWX0k/Ycng9nd3KVMoKJdljWJ4mHhaMHhIgKvclEDPw=;
  b=E15QVb1zoW4Iv/o47q9/GcQPwzJqmqY5A+zLmcT4IQSClLl+3pSLUdYL
   kWB77EU0N2VcvZ+9Sq+GZ2BODTcTv1Qfz6NJVMZSuIo4QOXoNDLkLXH45
   h5xxXEB/M+d5CwSty85nDWrDpjydlF6OdFCCjpyIzGTDmtUUbkebZ7W8y
   EbJyXyUiDjLakpI8xDOhJ11nvZ6XbbjQnJCrF7VW6DIepyzCGij7pZaGI
   EhAubDfJmTY1LYETdVyi9g78m40eNYNh1yDjjUC/y9b2gHTTfmXJgnv5d
   /vVIs31nyZy2EA2sQwKXoA8ruN3H9MZr6Nib7ATSG1Db7hRIOvLKbcEKm
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10234"; a="225694170"
X-IronPort-AV: E=Sophos;i="5.88,306,1635231600"; 
   d="scan'208";a="225694170"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 09:47:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,306,1635231600"; 
   d="scan'208";a="623394795"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 09:47:51 -0800
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
Subject: [PATCH v2 3/6] x86/cpu: X86_FEATURE_INTEL_PPIN finally has a CPUID bit
Date: Fri, 21 Jan 2022 09:47:40 -0800
Message-Id: <20220121174743.1875294-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220121174743.1875294-1-tony.luck@intel.com>
References: <20220107225442.1690165-1-tony.luck@intel.com>
 <20220121174743.1875294-1-tony.luck@intel.com>
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
index b7700a47eadd..8a039d1ea57f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -106,6 +106,7 @@ static struct ppin_info {
 
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

