Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEA12CA7
	for <patches@lists.linux.dev>; Fri, 21 Jan 2022 17:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642787290; x=1674323290;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UAyI52FCx96k8VRzDcHGmpH8szZg3JfuUuvUpzTqOPQ=;
  b=mtl+sMUdOGFQgHAL02epMhmAPjuoHs2SQG+A6ybGcwevXBlwdKRtXWn1
   AW+xABrZI5kbbMiN6jLb/ZS5VDQ7/R8bIPV3xuFcDe1pSEM6YByF/5MrF
   VW28ZIpnOEBHIlwS+KZHNoXHCtW7LzzSz0XTyjeIkDzNbi/DYCxq7exbL
   xdQjUO3i3wzYYoOmMX1/fgljBcYNvetOC+uJUUtRiD3ROpoOompV1o5LA
   COewSaKX6XlkC5zYeSxStndLcpxifrglQKLgce1iV0PeqlWBbnvKsti+P
   3HImqPbpTItyq84OvUo1WzfQMngP3ScTyCmh3Li3svU1mPNtl3yMISpU6
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10234"; a="225694167"
X-IronPort-AV: E=Sophos;i="5.88,306,1635231600"; 
   d="scan'208";a="225694167"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 09:47:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,306,1635231600"; 
   d="scan'208";a="623394786"
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
Subject: [PATCH v2 0/6] PPIN (Protected Processor Inventory Number) updates
Date: Fri, 21 Jan 2022 09:47:37 -0800
Message-Id: <20220121174743.1875294-1-tony.luck@intel.com>
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

v2 starts with an extra patch over v1. Adding INTEL_FAM6_ICELAKE_D
to the list of legacy processors that support PPIN. I've marked
this patch for stable. I don't think the rest of the patches are
candidates for stable or long term support kernels.

The rest of the patches are updates from v1 of the series starts out
with two changes that I expect are uncontroversial. Later parts get
progressively more "RFC".

1) Simple cleanup to merge Intel and AMD duplicated code to test for
   presence of PPIN and check whether it is enabled.

2) Long overdue update from Intel to enumerate the PPIN and PPIN_CTL
   MSRs. See the December 2021 Software Developers Manual

{RFC factor moves to medium here}

3) Code to scan machine check banks re-reads the PPIN every time banks
   are scanned (whether for a machine check, a CMCI, or just a periodic
   poll). Since PPIN never changes, this seems like unnecessary overhead.
   Read the MSR once (per CPU) and save to memory.

{RFC factor moves to high for last two parts}

4) Refactor as prep for last part.

5) Add "ppin" to /sys/devices/system/cpu/cpu*/topology/ppin

The big question for this part is whether there is a better
place to expose this value. I'm open to other suggestions.

I do think it is useful to do so. An "inventory" number
that stays hidden until there is an error that causes it to show
up in a machine check log is user hostile.

Changes since V1:
-----------------
Added INTEL_FAM6_ICELAKE_D
Use X86_MATCH_FEATURE() instead of X86_MATCH_VENDOR_FEATURE
Spelling: s/prescence/presence/ s/CPUS/CPUs/
Print the hex value of PPIN with a leading "0x"
Fix the Subject line commit prefixes to use "x86/cpu" and
"topology/sysfs"
Move the introduction of the "msr_ppin" field to the patch where used.

Rewrite the commit comment justifying adding ppin to /sys/.../topology

Upcoming use case for user accessible ppin is for reporting issues
found by on-line testing of CPU cores. The MSRs for this are public
in the latest SDM (look for MSR_ACTIVATE_SCAN and a bunch of others in
the same section) but the SDM is currently light on details on what
it does or how to use it.  Linux patches to enable coming soon.

Tony Luck (6):
  x86/cpu: Add Xeon Icelake-D to list of CPUs that support PPIN
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
 arch/x86/kernel/cpu/mce/intel.c               | 41 ----------
 arch/x86/kernel/cpu/scattered.c               |  1 +
 drivers/base/topology.c                       | 20 +++--
 include/linux/topology.h                      |  3 +
 11 files changed, 109 insertions(+), 85 deletions(-)


base-commit: 2c271fe77d52a0555161926c232cd5bc07178b39
-- 
2.31.1

