Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3D2377553
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 15:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777475213; cv=none; b=J2kWITxtmXGLhSYqmH4ChOjaV8NfVj1EKqAwE4T9L1Uf1eBchs3LKL7kvbVBhry9emGEDovpV6vO/Wm0TDE1qig/nG7vK9FUpcs1C5Zxl671PMWxyUfzCXowoSs68YL0F4tYF1/B/GvMtbG2Qa+Yc3D0srX+0Wn1wReFQpdOYMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777475213; c=relaxed/simple;
	bh=A21P6fI2hgZ/+eGK6RsbbZ/oeCdwqcvHzTT8GH5JBd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghfoqTFugzCKY/z031QnNtBZOhemJovwt6Wx1VENA47J3Ijpmj1drmLxGWOKLg10PfgRdtu9Y6h6cGJEzzTutep0cNH6CUmXTG1kwPcVdTk5UNA/V1qRm/vnETgUCVxSmw50ZSe/GnIotHZUJOkKlyIo+vsu50QB3QqYZfJ3VUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mrpxT7Q0; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mrpxT7Q0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777475212; x=1809011212;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A21P6fI2hgZ/+eGK6RsbbZ/oeCdwqcvHzTT8GH5JBd0=;
  b=mrpxT7Q02EQ+/uyAuCganpOKDCaOwCdcxaCwz2FefdRE5rkDguU0/n0d
   XkNvGOswyb+mNEX116aJAToEhnu3DhnjCEXWCShOj5/WzObdZJ9ITp9I9
   VRKwu5jJvc6ZWRypTd67oCtFsR8MkRQtkcZEQ0lm3n0rMBDA8YX6ecC59
   8USi/GR9HxhzoICIC+wXTjqTQynbEGqcqHGc7ROBjDhgvrI1bHEw/VpD8
   rEZHDvmavAzgl8t3F8rcs+MSKPHpcjB4xdhP/RwciGozJFo55/RhW9htF
   Con9QPWMItqGFrWNqqU5VBDo3BE4scXW4n/3vsHCPxnB+plavZPhvreHZ
   g==;
X-CSE-ConnectionGUID: RLDlOpRlQxmwuuqHpba+sQ==
X-CSE-MsgGUID: OoRAFOOGTQ6Aia8EuNVtvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="78424368"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="78424368"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:47 -0700
X-CSE-ConnectionGUID: HAUSJ3mWS1qiz7HZts3IVg==
X-CSE-MsgGUID: bDVjghwDR9mHkQ+l7IJUNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="233445012"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:47 -0700
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
Subject: [PATCH v4 05/10] fs/resctrl: Pass error reading event through to user space
Date: Wed, 29 Apr 2026 08:06:35 -0700
Message-ID: <a9c09f6e5193d85d4ec8b98bbe67ab39316d0f27.1777419024.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1777419024.git.reinette.chatre@intel.com>
References: <cover.1777419024.git.reinette.chatre@intel.com>
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

