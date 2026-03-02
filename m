Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C333F375ADC
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 18:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772477192; cv=none; b=Q1HQ+vVqykwGtkq6U13DMeP4rMqE2Gtwnq42byem7Tsl3eIKc5/gA/vljXmwi7QWL70TOY4pfjDgALQebBJhajkL+1Ix2G2p+tEOP9emQI5lJY64eMu1o8jEjQz17Ri8kbJYYCGY22rqXIXTB/U54LCU/nEf7Py26XrbTE89Hrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772477192; c=relaxed/simple;
	bh=dWQkMySV2jYd0tvpllHLWFB4pHJJvS5dZ9FwHlCFYDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+8NIY8XajymGd81IiitrwlXRQPtlP5+bxUZDD208ttyhi6t0Q8eT6nur2tKNlVWFU6w4wQ1uVvhChTKhtuBMSZ3rjYG606HFQX8EviqD0H3AJmXWF5d0IKl1JKVUnMbXYQrQ3g/VZuDytD9RISt3Xs7sm8KrimRPNWrnO4EYF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MeDWd75d; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MeDWd75d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772477191; x=1804013191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dWQkMySV2jYd0tvpllHLWFB4pHJJvS5dZ9FwHlCFYDI=;
  b=MeDWd75dkKvd9eWGoC/D2ZGnX40x6LRzCclFvDTWY3T148afpM6nU2SJ
   qN/QXKap3WeupXFAd/48kTCFF2OtoDBTnSwe1uD6efBxhvJ+ltNKR6R8X
   Nb5AOBeilDLv0CcQzgANI5+z30+MTU6wJgPsnbnNvWy4zc1T3GzKHv2NZ
   0f8mbPOYWxzkCmiQM8XwglCLSkqXXHv0FbH4b8gai9E+v4WcU3Ufumj8O
   D8OFhshrydq7BEs7c2gGpLtEhxHpmAM31dN1fyEH3dSqRl1MIbNIA+YAF
   Jb37wZyf7nFkiVrT1J8Toi9wjS2gvVv1LKGt/1e1yDqHLHGPuT2cV/I2T
   Q==;
X-CSE-ConnectionGUID: yNYJrWEBQnO8GqcR4qNRvg==
X-CSE-MsgGUID: TiFtBaHhT4ObgyCRzh5jfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="84135478"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="84135478"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
X-CSE-ConnectionGUID: 64mwtmaoQHWPDdNYmebMbw==
X-CSE-MsgGUID: r4CXWXiVRtuVf3SPHYe7Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255604092"
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
Subject: [PATCH 06/11] fs/resctrl: Pass error reading event through to user space
Date: Mon,  2 Mar 2026 10:46:12 -0800
Message-ID: <6ceb56817d137bee96a5e4508657bf9080cb4acf.1772476561.git.reinette.chatre@intel.com>
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

Reading of event data is managed through populating a struct rmid_read with
properties of event needing to be read. This data is dispatched to an
appropriate CPU and upon completion any error can be found in rmid_read::err,
or on success the event data will be in rmid_read::val.

rmid_read::err is not updated in the unlikely scenario that the reading
of the event was dispatched to a wrong CPU. If this ever occurs due to
a bug in resctrl the user space read will return "success" but the data
reported will be invalid.

Ensure accurate error reporting so that if there may be an issue with
how resctrl picks a CPU it could be learned with an error to user space
instead of silent failure.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 fs/resctrl/monitor.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 421c70f96426..f1a08fdbdd61 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -453,8 +453,10 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
 	}
 
 	/* Reading a single domain, must be on a CPU in that domain. */
-	if (!cpumask_test_cpu(cpu, &d->hdr.cpu_mask))
+	if (!cpumask_test_cpu(cpu, &d->hdr.cpu_mask)) {
+		rr->err = -EIO;
 		return -EINVAL;
+	}
 	if (rr->is_mbm_cntr)
 		rr->err = resctrl_arch_cntr_read(rr->r, d, closid, rmid, cntr_id,
 						 rr->evt->evtid, &tval);
@@ -491,8 +493,10 @@ static int __l3_mon_event_count_sum(struct rdtgroup *rdtgrp, struct rmid_read *r
 	}
 
 	/* Summing domains that share a cache, must be on a CPU for that cache. */
-	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
+	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map)) {
+		rr->err = -EIO;
 		return -EINVAL;
+	}
 
 	/*
 	 * Legacy files must report the sum of an event across all
-- 
2.50.1

