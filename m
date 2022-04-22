Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BAC2F25
	for <patches@lists.linux.dev>; Fri, 22 Apr 2022 20:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650657747; x=1682193747;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=66e0gas27WRp3ksBUhkcYZ1nbpEm7fWfloenmE7L+68=;
  b=MR9yfoZfut6a7kGdhYSTM9y3dcJjnakgIMF5z1ehPooEVY6q2ifvq5md
   b0zwKAFVg2JPFQFTKdvHfJxX6d3FE4OVfM8mKUOAjoxR70E7ruY85wR6f
   83s+e57pt063Q8woL2KFWnVChsmSUAGlYn9HBe+poX1bek1ja7dxQ3P4M
   X4rYAJTQ4KwBmrlUiEOeWe5uJKDFQM9kD7mCU7ciuUpT/zQTnO+YvtVqH
   3aAf4McakIUCC/XdDcG1ai/NZ+DYQeyRkxXhEQP0rBhAr0qam+6zWEuOn
   y0qi8jakwBvwSndUBSZOSmU2rR2ZaBbzhb3bjwUK3TrrL0MHvEcg4pxAs
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="289897433"
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="289897433"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 13:02:26 -0700
X-IronPort-AV: E=Sophos;i="5.90,282,1643702400"; 
   d="scan'208";a="511719312"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2022 13:02:25 -0700
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
Subject: [PATCH v4 00/10] Introduce In Field Scan driver
Date: Fri, 22 Apr 2022 13:02:09 -0700
Message-Id: <20220422200219.2843823-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419163859.2228874-1-tony.luck@intel.com>
References: <20220419163859.2228874-1-tony.luck@intel.com>
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

Changes since v3:

Thomas Gleixner:
----------------
1) intel_collect_cpu_info_early() ... function name doesn't make sense
   in context of this driver

   True: Dropped the "_early" suffix from the name.

Greg Kroah-Hartman:
-------------------
1) "Ick, why?" and "pmem.c should not be used as a good example of anything"
   and "Why not just use a misc device?"

   Now using a misc device.

2) "So even if everything fails, you succeed?"

   This was w.r.t. the "pmem"-like driver, which is completely gone in
   v4. New driver succeeds if any of the test-types enumerate as present
   on the system. Fails with -ENODEV if no test types found.

3) "sysfs documentation belongs in Documentation/ABI/"

   See patch 10 of this series.

4) "And why not just include this whole thing in the driver itself and suck
   the documentation out of that?  No need to have a separate file."

   Dropped Documentation/x86/ifs.rst from v4. People should be able to
   figure out how to use it from the ABI docs for the sysfs files. If
   that turns out to be wrong, we can revisit.

5) "int load_ifs_binary(struct device *dev)
    Shouldn't all of your global symbols start with "ifs_"?  Your other ones
    seem to, what went wrong here?
    Also, how about "ifs_load_firmware()" makes more sense."

    Changed name to ifs_load_firmware()

6) "static bool ifs_image_sanity_check(struct device *dev, void *data)
    u8 *data?"  and
   "if (!ifs_image_sanity_check(dev, (void *)fw->data)) {
    It's not a void pointer, it's a pointer to u8.  Why cast it away?"

   Changed the top of that call stack to cast to "(struct microcode_header_intel *)
   which is what the lower level functions all want.

7) "if (!sysfs_streq(buf, "1"))
   kstrtobool()?

   Changed from sysfs_streq() to kstrtobool()

8) "ATTRIBUTE_GROUPS()?"

   Now using this macro.

Steven Rostedt:
---------------
1) "TP_PROTO(union ifs_scan activate, union ifs_status status),

   Really, you want to pass the structure in by value, so that we have two
   copies? One to get to this function and then one to write to the ring
   buffer?"

   Discussion on list resolved because these "pass by value" objects are
   just wrappers around a u64. Passing pointers wouldn't make any real
   difference. No code change.

Jithu Joseph (7):
  x86/microcode/intel: Expose collect_cpu_info_early() for IFS
  platform/x86/intel/ifs: Read IFS firmware image
  platform/x86/intel/ifs: Check IFS Image sanity
  platform/x86/intel/ifs: Authenticate and copy to secured memory
  platform/x86/intel/ifs: Add scan test support
  platform/x86/intel/ifs: Add IFS sysfs interface
  platform/x86/intel/ifs: add ABI documentation for IFS

Tony Luck (3):
  x86/msr-index: Define INTEGRITY_CAPABILITIES MSR
  platform/x86/intel/ifs: Add stub driver for In-Field Scan
  trace: platform/x86/intel/ifs: Add trace point to track Intel IFS
    operations

 .../ABI/testing/sysfs-platform-intel-ifs      |  39 ++
 MAINTAINERS                                   |   8 +
 arch/x86/include/asm/cpu.h                    |  18 +
 arch/x86/include/asm/msr-index.h              |   7 +
 arch/x86/kernel/cpu/intel.c                   |  32 ++
 arch/x86/kernel/cpu/microcode/intel.c         |  59 +---
 drivers/platform/x86/intel/Kconfig            |   1 +
 drivers/platform/x86/intel/Makefile           |   1 +
 drivers/platform/x86/intel/ifs/Kconfig        |  13 +
 drivers/platform/x86/intel/ifs/Makefile       |   3 +
 drivers/platform/x86/intel/ifs/core.c         |  97 +++++
 drivers/platform/x86/intel/ifs/ifs.h          | 123 +++++++
 drivers/platform/x86/intel/ifs/load.c         | 262 ++++++++++++++
 drivers/platform/x86/intel/ifs/runtest.c      | 332 ++++++++++++++++++
 drivers/platform/x86/intel/ifs/sysfs.c        | 147 ++++++++
 include/trace/events/intel_ifs.h              |  38 ++
 16 files changed, 1128 insertions(+), 52 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-ifs
 create mode 100644 drivers/platform/x86/intel/ifs/Kconfig
 create mode 100644 drivers/platform/x86/intel/ifs/Makefile
 create mode 100644 drivers/platform/x86/intel/ifs/core.c
 create mode 100644 drivers/platform/x86/intel/ifs/ifs.h
 create mode 100644 drivers/platform/x86/intel/ifs/load.c
 create mode 100644 drivers/platform/x86/intel/ifs/runtest.c
 create mode 100644 drivers/platform/x86/intel/ifs/sysfs.c
 create mode 100644 include/trace/events/intel_ifs.h


base-commit: b2d229d4ddb17db541098b83524d901257e93845
-- 
2.35.1

