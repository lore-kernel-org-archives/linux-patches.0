Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4466D7B
	for <patches@lists.linux.dev>; Fri, 21 Oct 2022 20:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666384550; x=1697920550;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xvwzs6JdNeO32KfigzubT6fCl2jWmlRjaM5tQL1JZ1I=;
  b=Dcl92wxvBT1ey4wvuQpJnUGUW8sR12Kmqecpci8BvSp1gZehS+B3HA1w
   fRrBRQGGaZGN77xW3veeABVW4mepNwChyXTG/FqIjBKGXCZGBt91iE8/K
   yAfTgsPeohTWnKyrTHlrxgBmYjFdw0gxhZEZWsUU67N3BAvRnsDQLsOf7
   MlYMOd6CdVc5mZZSEMdYdqnwupy2/qgvdhu4Ow/kBQxDzb56aan6l6Ccz
   O02QgYCza2P9sRmyQEeW5VFOJRiGgEExTzct+LxcbNXcaKO6cbnRDgy6S
   e0TbSt1aLoqI0jAHPOxYa5O/XmDsI8VNFLOoODSK8S+Hq/s2uMGV/i7ES
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="333675877"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="333675877"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:33 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10507"; a="735700991"
X-IronPort-AV: E=Sophos;i="5.95,203,1661842800"; 
   d="scan'208";a="735700991"
Received: from jithujos.sc.intel.com ([172.25.103.66])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 13:35:33 -0700
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
Subject: [PATCH 00/14] IFS multi test image support and misc changes
Date: Fri, 21 Oct 2022 13:33:59 -0700
Message-Id: <20221021203413.1220137-1-jithu.joseph@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Initial implementation of IFS driver assumed a single IFS test image
file with a fixed name.

Subsequently, it became evident that supporting more than one
test image file is needed to provide more comprehensive
test coverage. (Test coverage in this scenario refers to testing
more transistors in the core to identify faults).

This series makes the driver aware of multiple scan test image files,
modifies IFS test image file headers to make it fully compatible
with microcode headers and adds a few other bug fixes and changes.

Patch organization:
Patches 1, 2, and 3: bug fixes
Patch 4: Removes image loading during init path 
Patch 5, 6 and 7: exports a couple of microcode/intel.c functions
                  for use by driver
Patch 8: Adds Meta-data support in microcode file

Rest of them are IFS driver changes
Patches 9 and 10: IFS header format changes to make it fully compatible
 to intel microcode header format
Patches 11, 12 and 13: native support for multiple scan test image files
Patch 14: reverts the broken flag

Ashok Raj (1):
  x86/microcode/intel: Meta-data support in microcode file

Jithu Joseph (13):
  platform/x86/intel/ifs: Remove unused selection
  platform/x86/intel/ifs: Propagate load failure error code
  platform/x86/intel/ifs: return a more appropriate Error code
  platform/x86/intel/ifs: Remove image loading during init
  x86/microcode/intel: Expose find_matching_signature() for IFS
  x86/microcode/intel: Use appropriate type in microcode_sanity_check()
  x86/microcode/intel: Expose microcode_sanity_check()
  platform/x86/intel/ifs: Use generic microcode headers and functions
  platform/x86/intel/ifs: Add metadata validation
  platform/x86/intel/ifs: Remove reload sysfs entry
  platform/x86/intel/ifs: Add current_batch sysfs entry
  Documentation/ABI: Update IFS ABI doc
  Revert "platform/x86/intel/ifs: Mark as BROKEN"

 arch/x86/include/asm/microcode_intel.h        |  25 ++-
 drivers/platform/x86/intel/ifs/ifs.h          |  27 ++-
 arch/x86/kernel/cpu/microcode/intel.c         |  81 ++++++--
 drivers/platform/x86/intel/ifs/core.c         |   7 +-
 drivers/platform/x86/intel/ifs/load.c         | 174 +++++++++---------
 drivers/platform/x86/intel/ifs/runtest.c      |  10 +-
 drivers/platform/x86/intel/ifs/sysfs.c        |  41 +++--
 .../ABI/testing/sysfs-platform-intel-ifs      |  30 +--
 drivers/platform/x86/intel/ifs/Kconfig        |   4 -
 9 files changed, 243 insertions(+), 156 deletions(-)


base-commit: f76349cf41451c5c42a99f18a9163377e4b364ff
-- 
2.25.1

