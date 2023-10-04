Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2EA1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="junTONro"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696444676; x=1727980676;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TTblblbDN1W4j6G8QhSl9EaeyJL5JAlnQkhiVd7lKhg=;
  b=junTONrorGgzqR5fK9w1JtZaX8G08Oc7AbXM2notOzHJFjzg1Lsl9Koq
   /RK8RuOdwKLaKEv8tzYWiZEzlcTmHMBIyabFya1vJT6+XpmEbuuwmu0X9
   FAnX9bmZPdKTsEdHVpSUMQDBXUyyi0n8/PWduwssGYXLUPphhMgIzg/A+
   YBcLAza5F4fLnvqU6JlQq7pFmB56D7996n1awGEvSrtE65pKPYYHWOIq1
   HIv0nsmMK5+evA577GHX6DIlfX9uiBJ4nDPvYfpDC7KWtBx3OEHubFSeb
   S13uRmeeqgV0lK9D635k5KVsBGwjG9c7j2EEfqYmZAokfJEz1e2RHgIfh
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="387133506"
X-IronPort-AV: E=Sophos;i="6.03,201,1694761200"; 
   d="scan'208";a="387133506"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2023 11:36:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10853"; a="701236050"
X-IronPort-AV: E=Sophos;i="6.03,201,1694761200"; 
   d="scan'208";a="701236050"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2023 11:36:32 -0700
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
Subject: [PATCH v9 0/3] Handle corrected machine check interrupt storms
Date: Wed,  4 Oct 2023 11:36:20 -0700
Message-ID: <20231004183623.17067-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230929181626.210782-1-tony.luck@intel.com>
References: <20230929181626.210782-1-tony.luck@intel.com>
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

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

Changes since v8:

Fixed issue reported by lkp with randconfig build with neither
CONFIG_X86_MCE_INTEL not CONFIG_X86_MCE_AMD set by making a
cleaner division between the storm tracking code in threshold.c
with the restof the code using more function accessors that can
be stubbed out.

Tony Luck (3):
  x86/mce: Remove old CMCI storm mitigation code
  x86/mce: Add per-bank CMCI storm mitigation
  x86/mce: Handle Intel threshold interrupt storms

 arch/x86/kernel/cpu/mce/internal.h  |  48 ++++-
 arch/x86/kernel/cpu/mce/core.c      |  45 ++---
 arch/x86/kernel/cpu/mce/intel.c     | 303 ++++++++++++----------------
 arch/x86/kernel/cpu/mce/threshold.c | 115 +++++++++++
 4 files changed, 304 insertions(+), 207 deletions(-)


base-commit: 6465e260f48790807eef06b583b38ca9789b6072
-- 
2.41.0

