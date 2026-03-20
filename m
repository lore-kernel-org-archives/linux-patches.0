Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771063542CA
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 22:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774044243; cv=none; b=QIXl/ZseDndh+sdOwKGmsebOSYe/fhh3bZ8fdZAC9YSW8xDC9Ih0b7/vg/6RBcoQSa8nOYfxAAYdHAtq6RiSn5qPqxr/xlxnEZrbBCcZcGbiYTYiErKJUAbQJrdm+mD2Seb4WV7l7l/x395qUNDm8gCVE6dn27uygYwePYq/aig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774044243; c=relaxed/simple;
	bh=A21P6fI2hgZ/+eGK6RsbbZ/oeCdwqcvHzTT8GH5JBd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfdrlbjOfoZFqGFbfC+LneGqI4oPKWFAtRqqwIDCnXlz9XnUeehQWvvAkHsH+oEJHE/xwkb0Ue5fijrlRaRjXeg0vaz8CW9N4qcY/nzDwb9JqpsATTPvwbmvKky6pjLokH0cb9LrMUhmWRiHmOQ6XgI8392oSc3OSye0SfWkbyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L4c1tsV7; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L4c1tsV7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774044239; x=1805580239;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A21P6fI2hgZ/+eGK6RsbbZ/oeCdwqcvHzTT8GH5JBd0=;
  b=L4c1tsV7QMSTDOStau5hMre3FoMpez1LCJGpxXYN0sXbgsE+REr9+w1Y
   OnBjkJS+19AP6JwOzBnqkElD26OYuxZd5J5lxqsLYpZkCl1gSIDUS3+i1
   rLfqwTc2oUsjqypzDHvaT0JRs9MZx/rS6UlfiyOnnD04wi7uq7JutGp3+
   99pxX10jETqnkj80u3QEAHXf/8DvvayIOpWaors1sh0Oq0oBX3kUacJ65
   a4BgvzOaVPGqlH6dDdXUkB9qLNrnB/zb0zPqsGCY3RC/B/NC0wtEass4d
   LKLpfQFyx+5vU+jbQQy9JS2OPgk2eQTciIgW1r4ZomXUnjB5P0MH/5kKp
   A==;
X-CSE-ConnectionGUID: 6hdGDTr9QbKUt+zEuciioQ==
X-CSE-MsgGUID: DO343f9uTrS08Zm7erytcQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="97758409"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="97758409"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:55 -0700
X-CSE-ConnectionGUID: e4cAP81TTAiJddZq0V4Bjg==
X-CSE-MsgGUID: TzSsMQ1jRQulBuQ+wuk3tg==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:55 -0700
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
Subject: [PATCH v2 08/14] fs/resctrl: Pass error reading event through to user space
Date: Fri, 20 Mar 2026 15:03:18 -0700
Message-ID: <38f8735190251f75e2e8b33861cc86135aefb748.1774043709.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1774043709.git.reinette.chatre@intel.com>
References: <cover.1774043709.git.reinette.chatre@intel.com>
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

