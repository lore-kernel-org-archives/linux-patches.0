Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DE8168
	for <patches@lists.linux.dev>; Fri,  7 Jan 2022 22:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641596089; x=1673132089;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GhKrc+4sAWUpP5n3cJ/0rirYUVFVTK+F0/y2R3Bnzoc=;
  b=dGKL+V8KqxoH1WZ39cfRAb1m8IgjtvGoXvO7u4fYS0sDn54ufXAkD2aZ
   bJfNdnXaV4EsIGozKAELgtCmRFh4ERRnUO6cr5KwHip4MR4SJ/x+SMWID
   LAlm/aTkBgArr8pizSaNuQfLXHVEY1vWjvoDbewer4lLONdeAH5zDz+3l
   fa2gaiwihh5IVVAcOSRohd92EaXuKB8yb4vIPgx006AyM31QlWfXF4V4c
   xjuW7sr8Lp2FxrTT8a3o4J0D2DkvwbW6FBQqy5lrcqFR6s4TTtR4q/HXa
   FO5zzbqObR6eHmTQ538JCdIeK56/21+jNB/AU95wqKkW64HOWshLH5TgA
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="242907957"
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="242907957"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 14:54:48 -0800
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="471452453"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 14:54:47 -0800
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
Subject: [PATCH 0/5] PPIN (Protected Processor Inventory Number) updates
Date: Fri,  7 Jan 2022 14:54:37 -0800
Message-Id: <20220107225442.1690165-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series starts out with two changes that I expect are
uncontroversial. Later parts get progressively more "RFC".

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

Tony Luck (5):
  x86/ras: Merge Intel and AMD ppin_init() functions
  x86/ras: X86_FEATURE_INTEL_PPIN finally has a CPUID bit
  x86/ras: Read/save PPIN MSR during initialization
  x86/sysfs: Add format parameter to macro defining "show" functions for
    proc
  x86/sysfs: Add PPIN in sysfs under cpu topology

 .../ABI/stable/sysfs-devices-system-cpu       |  4 +
 .../ABI/testing/sysfs-devices-system-cpu      |  6 ++
 arch/x86/include/asm/processor.h              |  2 +
 arch/x86/include/asm/topology.h               |  1 +
 arch/x86/kernel/cpu/amd.c                     | 30 -------
 arch/x86/kernel/cpu/common.c                  | 78 +++++++++++++++++++
 arch/x86/kernel/cpu/mce/core.c                |  7 +-
 arch/x86/kernel/cpu/mce/intel.c               | 41 ----------
 arch/x86/kernel/cpu/scattered.c               |  1 +
 drivers/base/topology.c                       | 20 +++--
 include/linux/topology.h                      |  3 +
 11 files changed, 108 insertions(+), 85 deletions(-)


base-commit: c9e6606c7fe92b50a02ce51dda82586ebdf99b48
-- 
2.31.1

