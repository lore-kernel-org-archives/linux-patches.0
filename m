Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925F43E557C
	for <patches@lists.linux.dev>; Mon,  6 Jul 2026 22:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783378018; cv=none; b=P7KS/roxDREt8NbIFQgvZIw3JMHhNC0boCv8H4cv91Rtr+s1WFy50kgSNVbGfur5XtCtGO7vP58pqWLh+iGoYFeJ7P5+4PpYvzqVIRlDn3wEGYl6yZA+iD2ThxqsoESjCYERoYL7oRBYSFz5TEpqL9YXFy0Hnr05gT6Ds1SHoug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783378018; c=relaxed/simple;
	bh=DnqtYXfZPaaIE6G4pJXdl2AkJoFS8eHrvWsFS0K/OqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lW9Qq4Sor6R9uU+7i079TKES/w1FkTVTaPfp8h886hiA4ufTN1ql492t0ko7TlcyXKLxSemLLxqBDD7pMAgO5aYMZm8+/gsug796R3icVj0PGzhTA1iyaQuKBzxNoWzMSWpnQmiFULX7XtloFa1ptvOpOUULYYQHvdu8jHquY5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mbr+1JAz; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mbr+1JAz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783378006; x=1814914006;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DnqtYXfZPaaIE6G4pJXdl2AkJoFS8eHrvWsFS0K/OqI=;
  b=mbr+1JAzbtQFdfioaYDSvfY2GEGkqgQnLk6VJTpRSYuALyoNWcM+lF2c
   AXPvZF0dYPcROYb47MC4h8AAqc1T7kPIxSHUibVzoD2BpYYpld7Xx8qna
   LNmixOAXPIsYhqH3V5oi6lcPP0z3WF3+cxAiY+OEcoDdATNLBlvQPVmxi
   CLQNuH7QsjUQKlyd2D7o1BSPYfhHw6yyrmYstVBLq+j8EfTMi+i5aUZSk
   m6b1DFD3jxEuL/Xk+KhXlQ1PKrxt9pmV+wGI9WrKl/Lf5Ed8J8OHtzxL1
   2OjMahoSxOzyhx/z/Gdtg8H09xYoRNmEnRIVGJKL/AdA2kyISYjarjfzG
   g==;
X-CSE-ConnectionGUID: 9/nogbNGTO+tCW7khAXwwg==
X-CSE-MsgGUID: E3L46NlDT6Kxed/oG6mb+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11839"; a="95401532"
X-IronPort-AV: E=Sophos;i="6.25,151,1779174000"; 
   d="scan'208";a="95401532"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 15:46:41 -0700
X-CSE-ConnectionGUID: SFAAQeaHQ5CUSUkDbKH9fw==
X-CSE-MsgGUID: 69Agv5S/S2OOGCOUJkT++g==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 15:46:41 -0700
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
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v6 07/10] fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()
Date: Mon,  6 Jul 2026 15:46:27 -0700
Message-ID: <9c33a0e589538e8f20ce823440fadc0a0d0662ec.1783377598.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783377598.git.reinette.chatre@intel.com>
References: <cover.1783377598.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A struct rdtgroup is reference counted via rdtgroup::waitcount. Callers
that need the structure to remain valid across a sleep (while waiting on
acquiring rdtgroup_mutex) take a reference with rdtgroup_kn_get() and
release it with rdtgroup_kn_put(). The release path is intended to serve
as the fallback freer: if the count drops to zero and the group has
already been marked RDT_DELETED, rdtgroup_kn_put() frees the structure.
The bulk teardown paths free_all_child_rdtgrp() and rmdir_all_sub()
resulting from a resctrl directory remove or resctrl fs unmount act as
the primary freer: they hold rdtgroup_mutex and free each rdtgroup whose
waitcount is zero, otherwise they set RDT_DELETED and leave the freeing
to the last waiter.

These two freers race. rdtgroup_kn_put() commits waitcount == 0 with
atomic_dec_and_test() outside rdtgroup_mutex, then reads rdtgroup::flags.
Between those two operations a concurrent caller of free_all_child_rdtgrp()
or rmdir_all_sub() (which holds the mutex) can observe waitcount == 0 via
atomic_read(), call rdtgroup_remove(), and kfree() the structure. The
subsequent read of rdtgroup::flags in rdtgroup_kn_put() is then a
use-after-free, and the structure may even be freed twice if the freed
memory happens to satisfy the RDT_DELETED flag check.

Replace the bare atomic_dec_and_test() with atomic_dec_and_mutex_lock()
so that the decrement-to-zero takes rdtgroup_mutex before the count
becomes globally visible. The inspection of rdtgroup::flags then runs
under the same mutex held by the bulk freers, making the two paths
mutually exclusive. The common case where the count does not reach
zero remains lock-free. Defer kernfs_unbreak_active_protection() until
after the mutex is dropped since kernfs active protections functionally
wrap rdtgroup_mutex. Remove resource group, which in turn drops its kernfs
reference, after kernfs protection is restored.

Fixes: b8511ccc75c0 ("x86/resctrl: Fix use-after-free when deleting resource groups")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260515193944.15114-1-tony.luck%40intel.com?part=1
Assisted-by: GitHub_Copilot:gemini-3.1-pro
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since V2:
- New patch

Changes since V3:
- Add Ben's Reviewed-by tag.
- Add Tony's Reviewed-by tag.
---
 fs/resctrl/rdtgroup.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index ce964721ba8e..77c9d22017bc 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2606,15 +2606,24 @@ static void rdtgroup_kn_get(struct rdtgroup *rdtgrp, struct kernfs_node *kn)
 
 static void rdtgroup_kn_put(struct rdtgroup *rdtgrp, struct kernfs_node *kn)
 {
-	if (atomic_dec_and_test(&rdtgrp->waitcount) &&
-	    (rdtgrp->flags & RDT_DELETED)) {
+	bool needs_free;
+
+	if (!atomic_dec_and_mutex_lock(&rdtgrp->waitcount, &rdtgroup_mutex)) {
+		kernfs_unbreak_active_protection(kn);
+		return;
+	}
+
+	needs_free = rdtgrp->flags & RDT_DELETED;
+
+	mutex_unlock(&rdtgroup_mutex);
+
+	kernfs_unbreak_active_protection(kn);
+
+	if (needs_free) {
 		if (rdtgrp->mode == RDT_MODE_PSEUDO_LOCKSETUP ||
 		    rdtgrp->mode == RDT_MODE_PSEUDO_LOCKED)
 			rdtgroup_pseudo_lock_remove(rdtgrp);
-		kernfs_unbreak_active_protection(kn);
 		rdtgroup_remove(rdtgrp);
-	} else {
-		kernfs_unbreak_active_protection(kn);
 	}
 }
 
-- 
2.54.0

