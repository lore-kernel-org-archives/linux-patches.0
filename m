Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2326A33FB
	for <patches@lists.linux.dev>; Mon, 27 Jun 2022 17:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656351372; x=1687887372;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Em0msSweJpuFDsPd3dCpZXzqrTObd8eQjNQD6ivh7qM=;
  b=aHSCJ/lFsLSldjTo1W/Lidim4lnQmrNbsHEYbVdmIoe9eY3Mk2jsWV+I
   5TtLSk/rQzSnkuM8ATPFu/1po4K69EURgzW+uyv2jUWbFsHQrp31o8hKJ
   bLIoQg5A8RAXR4gVuHJ2H76SkuYDg0AUkPmWiv9ddf+Yet/k7zxhEgr3c
   ZHY9GxLDSfAZMVYPr/yPUOtlNNTUtzWnc3mp2SRUDH6nEF3g76I2BT3ZJ
   AhJHuwA4wmI1FdqoQQL1357wSBJQrkUB4a+Z1pH5xPDgh/BugQXio/ntA
   ajyTQ3SWkS/Fsk/Me3izIkupMAVRdqJfRWeMkiIgNoprTy2wctZvVeJmV
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="282250791"
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="282250791"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 10:36:11 -0700
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="594399442"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 10:36:11 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Smita.KoralahalliChannabasappa@amd.com,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yazen.ghannam@amd.com,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 0/5] Handle corrected machine check interrupt storms
Date: Mon, 27 Jun 2022 10:36:00 -0700
Message-Id: <20220627173605.514504-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <YrFSSZqjtWlm9rUr@agluck-desk3.sc.intel.com>
References: <YrFSSZqjtWlm9rUr@agluck-desk3.sc.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend the logic of handling Intel's corrected machine check interrupt
storms to AMD's threshold interrupts.

First two patches are from Tony which cleans up the existing storm
handling for Intel and proposes per CPU per bank storm handling.

Third and fourth patches do some cleanup and refactoring on the CMCI
storm handling in order to extend similar workaround for AMD's threshold
interrupt storms. These two patches could be merged into Tony's second
patch of CMCI storm mitigation.

AMD's storm mitigation for threshold interrupts also relies on per CPU
per bank approach similar to Intel. But unlike CMCI storm handling it does
not set thresholds to reduce rate of interrupts on a storm. Rather it
turns off the interrupt on the current CPU and bank if there is a storm
and re-enables back the interrupts when the storm subsides.

It is okay to turn off threshold interrupts on AMD systems as other error
severities continue to be handled even if the threshold interrupts are
turned off. Uncorrected errors will generate a #MC and deferred errors
have a unique separate deferred error interrupt. The final patch adds
support for handling threshold interrupt storms on AMD systems.

Changes since v1:

1) Fix shift computation when keeping track of bank history. Shift
should be "1" when a storm is in progress (because polling once per
second). When a storm is not in progress shift should be based on
number of seconds since the bank was last checked.

2) Changed Smita's code in part 0003 to avoid use of a function pointer
(since the kernel is avoiding indirect branch points that might be
trainable for various Spectre-like issues).

Smita Koralahalli (2):
  x86/mce: Introduce mce_handle_storm() to deal with begin/end of storms
  x86/mce: Handle AMD threshold interrupt storms
  x86/mce: Move storm handling to core.

Tony Luck (3):
  x86/mce: Remove old CMCI storm mitigation code
  x86/mce: Add per-bank CMCI storm mitigation

 arch/x86/kernel/cpu/mce/amd.c      |  49 ++++++++
 arch/x86/kernel/cpu/mce/core.c     | 139 +++++++++++++++++-----
 arch/x86/kernel/cpu/mce/intel.c    | 179 +++++++----------------------
 arch/x86/kernel/cpu/mce/internal.h |  33 ++++--
 4 files changed, 230 insertions(+), 170 deletions(-)

-- 
2.35.3

