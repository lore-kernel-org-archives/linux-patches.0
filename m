Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D48811
	for <patches@lists.linux.dev>; Fri,  6 May 2022 22:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651877658; x=1683413658;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K49HW2lGdqLpqgHUeIlMgvOoThkBm11e0LDnwNiLuac=;
  b=X6GL947XMZzfx2c5mHhT4xgEMHP1v54HFIwU1EiG/D+11jZDgSFJ+FxA
   1Vcagb7OtMFEyr+YmPiPPTyEXZdjj5aTbK1Voul9ld4lS+Nx793R3sVSg
   RqvunAOg9qv3LEReOGGFB/AZ/XiPwwPc/NGypFiPDWVIB1RBK6zlzpghC
   yY0DgenO/3EHsBt4iJK+LSKx7bW6saoItExTWcwEBomaytJRY8SJkRtRO
   KJtCpe65W/i+wKykOh2vS/ZsajbKmOaeNFruBgG0eV+OoV8kwlhlFDpmG
   au0KPbJVrFG1dLBFvzqBS6nNnhYR+ewXSi9Gq6yAnpZVxtyG1AOyP3BNB
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="355030687"
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="355030687"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 15:54:17 -0700
X-IronPort-AV: E=Sophos;i="5.91,205,1647327600"; 
   d="scan'208";a="695383613"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 15:54:16 -0700
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
Subject: [PATCH v7 00/12] Introduce In Field Scan driver
Date: Fri,  6 May 2022 15:53:58 -0700
Message-Id: <20220506225410.1652287-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220506014035.1173578-1-tony.luck@intel.com>
References: <20220506014035.1173578-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TL;DR this driver loads scan test files that can check whether silicon
in a CPU core is still running correctly. It is expected that these tests
would be run several times per day to catch problems as silicon ages.

Changes since v6

Thomas Gleixner
---------------
"struct workqueue_struct *ifs_wq; Seems to be unused."

True. Deleted.

"static bool oscan_enabled = true; What changes this?"

Code that cleared it deleted. Drop this too.

"Please add curly brackets as these are not one-line statements"

Added

cpumask_first(topology_sibling_cpumask(cpu)); Shouldn't that be cpu_smt_mask()?"

Changed (and several other places)

"take up to 200 milliseconds before it retires.  200ms per test chunk?"

Updated comment to note that 200ms is for all chunks.

"Documentation lost in the intertubes"

Dredged up the version from v3 series and changed:
1) Fixed pathnames now this is a virtual misc device instead of platform
device
2) Put all the text into a "/** DOC:" comment section in ifs.h with just
a "kernel-doc:: drivers/platform/x86/intel/ifs/ifs.h" in the ifs.rst
file under Documentation/x86.
3) Added a "big fat warning" (in all CAPS) pointing out that a core test
can take up to 200 milliseconds. So admins must take extra steps if they
are running latency sensitive workloads.
4) Added note that all HT threads of a core must be online to run a
test.

Tony Luck
---------
Off-by-one on retries check (#define set to 5, but tried 6 times). Fixed
Fixed kerneldoc description of "integrity_cap_bit" (was missing a ":")

Jithu Joseph (7):
  x86/microcode/intel: Expose collect_cpu_info_early() for IFS
  platform/x86/intel/ifs: Read IFS firmware image
  platform/x86/intel/ifs: Check IFS Image sanity
  platform/x86/intel/ifs: Authenticate and copy to secured memory
  platform/x86/intel/ifs: Add scan test support
  platform/x86/intel/ifs: Add IFS sysfs interface
  platform/x86/intel/ifs: add ABI documentation for IFS

Peter Zijlstra (1):
  stop_machine: Add stop_core_cpuslocked() for per-core operations

Tony Luck (4):
  x86/msr-index: Define INTEGRITY_CAPABILITIES MSR
  platform/x86/intel/ifs: Add stub driver for In-Field Scan
  trace: platform/x86/intel/ifs: Add trace point to track Intel IFS
    operations
  Documentation: In-Field Scan

 .../ABI/testing/sysfs-platform-intel-ifs      |  39 +++
 Documentation/x86/ifs.rst                     |   2 +
 Documentation/x86/index.rst                   |   1 +
 MAINTAINERS                                   |   8 +
 arch/x86/include/asm/cpu.h                    |  18 ++
 arch/x86/include/asm/msr-index.h              |   7 +
 arch/x86/kernel/cpu/intel.c                   |  32 +++
 arch/x86/kernel/cpu/microcode/intel.c         |  59 +---
 drivers/platform/x86/intel/Kconfig            |   1 +
 drivers/platform/x86/intel/Makefile           |   1 +
 drivers/platform/x86/intel/ifs/Kconfig        |  13 +
 drivers/platform/x86/intel/ifs/Makefile       |   3 +
 drivers/platform/x86/intel/ifs/core.c         |  73 +++++
 drivers/platform/x86/intel/ifs/ifs.h          | 234 +++++++++++++++
 drivers/platform/x86/intel/ifs/load.c         | 266 ++++++++++++++++++
 drivers/platform/x86/intel/ifs/runtest.c      | 252 +++++++++++++++++
 drivers/platform/x86/intel/ifs/sysfs.c        | 149 ++++++++++
 include/linux/stop_machine.h                  |  16 ++
 include/trace/events/intel_ifs.h              |  41 +++
 kernel/stop_machine.c                         |  19 ++
 20 files changed, 1182 insertions(+), 52 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-ifs
 create mode 100644 Documentation/x86/ifs.rst
 create mode 100644 drivers/platform/x86/intel/ifs/Kconfig
 create mode 100644 drivers/platform/x86/intel/ifs/Makefile
 create mode 100644 drivers/platform/x86/intel/ifs/core.c
 create mode 100644 drivers/platform/x86/intel/ifs/ifs.h
 create mode 100644 drivers/platform/x86/intel/ifs/load.c
 create mode 100644 drivers/platform/x86/intel/ifs/runtest.c
 create mode 100644 drivers/platform/x86/intel/ifs/sysfs.c
 create mode 100644 include/trace/events/intel_ifs.h


base-commit: 672c0c5173427e6b3e2a9bbb7be51ceeec78093a
-- 
2.35.1

