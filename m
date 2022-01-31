Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD98E2C80
	for <patches@lists.linux.dev>; Mon, 31 Jan 2022 23:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643670079; x=1675206079;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MdeQY8Jo7hmZqw1uzB+etOY106xNm7rWrFs0/phXfqs=;
  b=DA6rPfu/ze3zLbjQmFAIQKOzKkDDiA38JRL0vkwaY1cyCBgal4h1jHNl
   TqfWwPsMnEorHbQ/U89fsELCYQ/3DWPGc5K3f5XBs5iCDQ4PtKd6NVlXF
   fGYLHV8fA9j/Teqld3A5Fol3y0rSeikFr0kKFoYA3yHwfy+ylxG0XtwFb
   3HV7PsX6vBzw7KAXJMlZq6CW/4oWTQcrN00eanSY/E/QsFLWq6eXXuumR
   UbuXhkGgUUUKpfSxJGf1kHOm0WekzQRZr90pQnsUAoOr3IsBaa9/GI6jr
   yswPwk+dc59AXhKjURebbtx5YVLal+F5ccW0nsEFMpWECh5kaQ8oCyYYa
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="234960827"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="234960827"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 15:01:18 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="522831334"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 15:01:17 -0800
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
Subject: [PATCH v3 0/5] PPIN (Protected Processor Inventory Number) updates
Date: Mon, 31 Jan 2022 15:01:06 -0800
Message-Id: <20220131230111.2004669-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220121174743.1875294-1-tony.luck@intel.com>
References: <20220121174743.1875294-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The series starts out with two changes that I expect are uncontroversial.
Later parts get progressively more "RFC" - but seem to have survived
discussions on LKML.

1) Simple cleanup to merge Intel and AMD duplicated code to test for
   presence of PPIN and check whether it is enabled.

2) Long overdue update from Intel to enumerate the PPIN and PPIN_CTL
   MSRs. See the December 2021 Software Developers Manual

3) Code to scan machine check banks re-reads the PPIN every time banks
   are scanned (whether for a machine check, a CMCI, or just a periodic
   poll). Since PPIN never changes, this seems like unnecessary overhead.
   Read the MSR once (per CPU) and save to memory.

4) Refactor as prep for last part.

5) Add "ppin" to /sys/devices/system/cpu/cpu*/topology/ppin

Use case: ppin is already useful when reporting machine check
errors. Patches for new "in field scan" tests will appear soon.
If a CPU fails such a test it will be useful to provide the ppin
along with the test failure data.

Changes since V2:
----------------
1) Part 1 of V2 (adding ICELAKE_D) merged upstream, so dropped here

2) Rebased to v5.17-rc2 (to build on top of that merged patch)

3) Fixed bisection breakage reported by Boris where .msr_ppin
   structure fields were initialized two patches before the
   field was added.

4) Add Ack's from GregKH to parts 4 & 5

Tony Luck (5):
  x86/cpu: Merge Intel and AMD ppin_init() functions
  x86/cpu: X86_FEATURE_INTEL_PPIN finally has a CPUID bit
  x86/cpu: Read/save PPIN MSR during initialization
  topology/sysfs: Add format parameter to macro defining "show"
    functions for proc
  topology/sysfs: Add PPIN in sysfs under cpu topology

 .../ABI/stable/sysfs-devices-system-cpu       |  4 +
 .../ABI/testing/sysfs-devices-system-cpu      |  6 ++
 arch/x86/include/asm/processor.h              |  2 +
 arch/x86/include/asm/topology.h               |  1 +
 arch/x86/kernel/cpu/amd.c                     | 30 -------
 arch/x86/kernel/cpu/common.c                  | 79 +++++++++++++++++++
 arch/x86/kernel/cpu/mce/core.c                |  7 +-
 arch/x86/kernel/cpu/mce/intel.c               | 42 ----------
 arch/x86/kernel/cpu/scattered.c               |  1 +
 drivers/base/topology.c                       | 20 +++--
 include/linux/topology.h                      |  3 +
 11 files changed, 109 insertions(+), 86 deletions(-)


base-commit: 26291c54e111ff6ba87a164d85d4a4e134b7315c
-- 
2.31.1

