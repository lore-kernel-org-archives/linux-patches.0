Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830FF3BB9E1
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 16:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775577773; cv=none; b=P6Wb6GBIs19FEqiBhGX9PWAn4Y31malq1NRAuT3QS4j/HDzY8a6lF8mHRMWPJ/YUE3Q/b4U8S/JAKn1RF25jFWWduiklJ75gwI+KfOeDzytxf6YmFLLeSB+xRYAC+fTk2fVHtclJxvaclNdjrWrNUJDp04v1iXZp9vncGIYTROw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775577773; c=relaxed/simple;
	bh=A21P6fI2hgZ/+eGK6RsbbZ/oeCdwqcvHzTT8GH5JBd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsq9DIMM1O3Ng5eijOvaa+5aBrN+knchFWIh2DBZvy3pfJvweYz/X8LoPY6ZXYxfJjhTr3iY//SQuuoS9gsDGH4J3EB3Eq3ObCZhpVez0PIyUXqld6jRh1MpBoV64Mo5Rk5CnJREccQejC2MnYRxkvZ7CTynLtN/1agH1PKGaa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hUmmvK1A; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hUmmvK1A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775577765; x=1807113765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A21P6fI2hgZ/+eGK6RsbbZ/oeCdwqcvHzTT8GH5JBd0=;
  b=hUmmvK1ApSsjk/jF8NipCP3dylAH8ALomUXzlEw5/2qXa5lBXfhrYtot
   I0oY1kmlu3WM4CEAKqqxOgecPV7ldFlSoiGG1L1ScvcqSQiGkyUa3ANH5
   4pRVz0Rp+eOLp5UoPb4P926nEFhQdBxUyOXJxIK23Ep0tOa9aAidzt898
   ZT7jsQLeJAi3dyPedgH4NHsSnHMRRFkBKh6pUZj7dY6X1ZZ6LP09ZlqmH
   zszDbvNwST0r+WVx58JDMbdvZemICrlZGJnmMACYxUXTB86bJmFdf9PtU
   v25cnbG3U76smmZrr/nrBtvb4/iq5oQDCh1qDR+/WYL7MRIjYUZf0M46Q
   w==;
X-CSE-ConnectionGUID: dksBEqN7QXOSr1diIAB0BA==
X-CSE-MsgGUID: yOryXFb5RY6ko6zKZvfO1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="80432729"
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="80432729"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:19 -0700
X-CSE-ConnectionGUID: NXCIx0clSHml5fMfsl7FJQ==
X-CSE-MsgGUID: zKgZjHhOSMKramdnomWG9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="228119053"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 09:02:18 -0700
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
Subject: [PATCH v3 08/13] fs/resctrl: Pass error reading event through to user space
Date: Tue,  7 Apr 2026 09:02:05 -0700
Message-ID: <839082c54e02953f60706854cc0d250949b6d71d.1775576382.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1775576382.git.reinette.chatre@intel.com>
References: <cover.1775576382.git.reinette.chatre@intel.com>
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
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v1:
- Add Ben's RB tag.
---
 fs/resctrl/monitor.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 8194fdfbea81..101b2911d582 100644
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

