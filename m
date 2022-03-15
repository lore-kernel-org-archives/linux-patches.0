Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9AB23CC
	for <patches@lists.linux.dev>; Tue, 15 Mar 2022 18:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647368131; x=1678904131;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cBl7++E0lyz16jxeiMNZ6a6aEo5QRd5rFAMudPSZAW0=;
  b=mFxrcPUcv+e6MIpfFKx3cqoYXw92JQfc6H0LVR/fI2CzxxZ1poG0YgT7
   RYa8l6k6dTS59zNjIFc6jludoc/IlbYUsg5kaHjDJ8Vo5pU7jgU9I7yLH
   rPrUxqk5nUjgRq2J2WzDCO8wf3a1rLlmUX6paTIVvOUdsB6XPS4zNSZBv
   rEity41vIuWsJxe7VGe+oCR1aPVEaN0/+JQ0H9hhwLmxgSEp4IwmdwKOS
   rdIIArZ901ZBT3vBGYH5Rdsn7lO5ztzplEu+xkWhhvvsnsmlSDjK4zusl
   f8wXBdLJqPjypS/sMhpqjR8yTIovMtB2cgsGXDXAJPtnQo6n64iFReBj5
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="236337986"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="236337986"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 11:15:16 -0700
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="512713792"
Received: from agluck-desk3.sc.intel.com ([172.25.222.60])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 11:15:16 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	hpa@zytor.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	linux-edac@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2 0/2] New CMCI storm mitigation for Intel CPUs
Date: Tue, 15 Mar 2022 11:15:07 -0700
Message-Id: <20220315181509.351704-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <Yg6FqR2cMZDwdBdi@agluck-desk3.sc.intel.com>
References: <Yg6FqR2cMZDwdBdi@agluck-desk3.sc.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two-part motivation:

1) Disabling CMCI globally is an overly big hammer

2) Intel signals some UNCORRECTED errors using CMCI (yes, turns
out that was a poorly chosen name given the later evolution of
the architecture). Since we don't want to miss those, the proposed
storm code just bumps the threshold to (almost) maximum to mitigate,
but not eliminate the storm. Note that the threshold only applies
to corrected errors.

Patch 1 deletes the parts of the old storm code that are no
longer needed.

Patch 2 adds the new per-bank mitigation.

Smita: Unless Boris finds a some more stuff for me to fix, this
version will be a better starting point to merge with your changes.

Changes since v1 (based on feedback from Boris)

- Spelling fixes in commit message
- Many more comments explaining what is going on
- Change name of function that does tracking
- Change names for #defines for storm BEGIN/END
- #define for high threshold in decimal, not hex

Tony Luck (2):
  x86/mce: Remove old CMCI storm mitigation code
  x86/mce: Add per-bank CMCI storm mitigation

 arch/x86/kernel/cpu/mce/core.c     |  46 +++---
 arch/x86/kernel/cpu/mce/intel.c    | 241 ++++++++++++++---------------
 arch/x86/kernel/cpu/mce/internal.h |  10 +-
 3 files changed, 141 insertions(+), 156 deletions(-)


base-commit: ffb217a13a2eaf6d5bd974fc83036a53ca69f1e2
-- 
2.35.1

