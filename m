Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A72D288D0
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 18:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772477192; cv=none; b=Q/IoyJojNhqC6mo3uz2+/WUhsSK6r0cdIEEALwBbhMbv/m+hXcg+g3xP35Hrn+8A0QV1yGNhtoEN2ikOZEpFE5+93YPpGJLvxSPppWy8oy8Ompbf8Clsq3vT+FrGc3hoVDE0uqG23xZRsvMPi2ZbXehXye7X/4NBaPKCC2n8Q4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772477192; c=relaxed/simple;
	bh=XQbrDtV7kC3BagIoRNk2xRfz81oxluInULTjgTirvbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3XoZRAcwvm22u1Je91wKb/VhUp8y/cjPgr/Be+GMFcsJmjvFKRExlocdadlXzuCRkKbKEFKwx2wNJU35pQwgn5GqDhS19b4weTswrmphDTnpt6oadqVLLwiaG8+zNQXU8iw1U/iXDHF/YHES0vyi3izPBpFvRex1BgkI+u6QLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PX178H/t; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PX178H/t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772477190; x=1804013190;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XQbrDtV7kC3BagIoRNk2xRfz81oxluInULTjgTirvbA=;
  b=PX178H/txyS0O95ZkDpHIB6ekxXFZwVSl+9k3lxnVukt8igbddXnsJBP
   TAa04J2lAoewwObWBy16QEJ+UfrDoxd1ZlGDHEkdm9p6jwospxKsy+FSW
   KoPb/TuJbTjY/vk0UQ1b62huyEmPdWaG8Vjhyb2IlrPpEBYPThQBiAm+j
   HGn1upH/QjORZqS50sXz2xiYIErlVz4PC5Zi4wn0BYEW6O9dczy6LtPOq
   qhAYXrYK2Xnuptu7O2N2P25Fs+OE5DhXgDP/8fnnMM0TrlET8ydn/yk/g
   dHUGPBGxtf45EQwU8zAkBQBaaGhIQDS5J//8UyKS0JJdCi/CK7OBdRHN0
   Q==;
X-CSE-ConnectionGUID: E7eGZ3ShTO61PdCqeVFZ8g==
X-CSE-MsgGUID: 1r7pIo87RvmrjNv6c+eHUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="84135456"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="84135456"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
X-CSE-ConnectionGUID: DgXG0t+RSA2FtlD8thqVmw==
X-CSE-MsgGUID: dVCDayM6RgGTiMCd1ME1vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255604086"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH 04/11] x86/resctrl: Protect against bad shift
Date: Mon,  2 Mar 2026 10:46:10 -0800
Message-ID: <36e7f922c6779ffccd007bd7be6b33e0e1b7f9f9.1772476561.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1772476561.git.reinette.chatre@intel.com>
References: <cover.1772476561.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The size of the bandwidth specifier field is enumerated from AMD hardware.
resctrl uses this field width to determine the maximum bandwidth supported
that is stored in resctrl_membw::max_bw to which user space allocation
requests are compared for validity.

resctrl_membw::max_bw is of type u32 while the register containing the
bandwidth specifier field, L3QOS_BW_CONTROL_n, is 64 bits. While not an
issue with current hardware it is theoretically possible that enumeration
of maximum bandwidth may trigger invalid behavior if a future system can
use a bandwidth specifier field larger than 32 bits. Whether this could
ever represent a reasonable bandwidth value is unknown but addressing the
issue will appease static checkers.

Ensure resctrl can accommodate the hardware's bandwidth specifier field
width with an additional check. Switch to BIT() instead of open-coding the
bitshift to avoid signed integer overflow if the number of bits is a
valid 31.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 7667cf7c4e94..db787c4dee61 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -246,7 +246,9 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
 
 	cpuid_count(0x80000020, subleaf, &eax, &ebx, &ecx, &edx);
 	hw_res->num_closid = edx + 1;
-	r->membw.max_bw = 1 << eax;
+	if (WARN_ON(BITS_PER_TYPE(r->membw.max_bw) <= eax))
+		return false;
+	r->membw.max_bw = BIT(eax);
 
 	/* AMD does not use delay */
 	r->membw.delay_linear = false;
-- 
2.50.1

