Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868E0944C
	for <patches@lists.linux.dev>; Tue, 11 Apr 2023 17:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681234734; x=1712770734;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+SbdzhYn3/vVwe7Gp/znZG4uAAWSfvm2hHvt3FEGR0c=;
  b=cCGs0E/SMqKba6bYJVjoDQcFpXVd3xYie2jRPv8mYfe6fIXxPTTM3XtZ
   L/yjkcNW5GqMfI0GboPhT9LZSli/qAV3PBoYiYuPVPJMtxjcVAND0LGlF
   OhPFP7gTsAToKn9sNfFk2z1mSW9GIOMgghxNbOM9K9bKbtdcRSew3aUMe
   6i0mUeLiiV45zkKDP2y1VqcdtWKVH5ang9L2JzhWBC4gTGFND4WbqZThH
   n9j4o2lMhjLDKGSgPR7rM1Uc+xf8bMWBw5R1TFSwEsyChdzOz1u9MXqyh
   BGAG1inNAw/kdVs1SFgs5qWV2TaFUT5GDV3al36ecQbHFtE052LVmENtm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="346359953"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="346359953"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 10:38:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="638911756"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="638911756"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 10:38:53 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>,
	Smita.KoralahalliChannabasappa@amd.com,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 0/5] Handle corrected machine check interrupt storms
Date: Tue, 11 Apr 2023 10:38:36 -0700
Message-Id: <20230411173841.70491-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230403210716.347773-1-tony.luck@intel.com>
References: <20230403210716.347773-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Linux CMCI storm mitigation is a big hammer that just disables the CMCI
interrupt globally and switches to polling all banks.

There are two problems with this:
1) It really is a big hammer. It means that errors reported in other
banks from different functional units are all subject to the same
polling delay before being processed.
2) Intel systems signal some uncorrected errors using CMCI (e.g.
memory controller patrol scrub on Icelake Xeon and newer). Delaying
processing these error reports negates some of the benefit of the patrol
scrubber providing early notice of errors before they are consumed and
cause a machine check.

This series throws away the old storm implementation and replaces it
with one that keeps track of the weather on each separate machine check
bank. When a storm is detected from a bank. On Intel the storm is
mitigated by setting a very high threshold for corrected errors to
signal CMCI. This threshold does not affect signaling CMCI for
uncorrected errors.

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

Changes since last version:
Boris:	Build failure on part 2 with CONFIG_MCE_INTEL=n
	Fixed by adding necessary stub function for track_cmci_storm()

Smita Koralahalli (3):
  x86/mce: Introduce mce_handle_storm() to deal with begin/end of storms
  x86/mce: Move storm handling to core.
  x86/mce: Handle AMD threshold interrupt storms

Tony Luck (2):
  x86/mce: Remove old CMCI storm mitigation code
  x86/mce: Add per-bank CMCI storm mitigation

 arch/x86/kernel/cpu/mce/internal.h |  33 ++++--
 arch/x86/kernel/cpu/mce/amd.c      |  49 ++++++++
 arch/x86/kernel/cpu/mce/core.c     | 139 +++++++++++++++++-----
 arch/x86/kernel/cpu/mce/intel.c    | 179 +++++++----------------------
 4 files changed, 230 insertions(+), 170 deletions(-)


base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
-- 
2.39.2

