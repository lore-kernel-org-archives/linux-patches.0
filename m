Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FD13F412A
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 03:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780457285; cv=none; b=WvefqqWbpkGCWLXLIQDSCUTsxA53wBHHhEf7Z3HGIZeobfh/1VpgwHBdRcDMA9pkanDjNNXkJLShJ5Ynfs/bg3ZQZbk63ppRlAow5tvWxXV7TLa17fZrQ+xtEI+yy3+PuBboX8zkwtAy989zGGJtaavgzMIQwvYiEhw5aW15MYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780457285; c=relaxed/simple;
	bh=bQGZ3Gi1hecEzRonc8KkP4mUrFcfRliOT9dqTRLLRN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwiNzCo5OZAMrTBiB+jH+q1xSdmrcFy1G+EJaxrn078SniPeGHN2pw3yRiRI2z4SX23qMnGwddhwL4wzT/BG4YPLzx+ll36gcHwqqzFJ19CRozwx26tqNNS4306FwdGpA8CxrDY8BPq56JOgkN5OLrl/2ZJ+eQhFPkCZZ4HWB9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e1hdAnrT; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e1hdAnrT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780457283; x=1811993283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bQGZ3Gi1hecEzRonc8KkP4mUrFcfRliOT9dqTRLLRN4=;
  b=e1hdAnrTjtQEQ4Nemj5kpeNULYTnNHH2RIVftI0KR7LDdCXeT5YZwZ60
   AC0ALDs9kaM0EbZ49Pn3rOHZKj7uJvn5X+l0uEmCy+eLuazljBUiLOw6Z
   sQrIsghn1tI4z8vbKxIEJEUATb9/JrB/pi9ISqV7JIyV+zNRzPQqSw5MN
   7FzQMlWoNOGlmy/809/exonzGS5igOwBNIebwQNe0QpFeydAAsVKuilte
   PQvIrHMQnE0KOwbjgZEAKK5WJLpHu05jxaUGzh7FsFm+VuKVnmepa75gj
   uU0FiyZF96Z7diZLTw8QKzfDGxNalR8YqPgZ1BZ4QsUdHdDxfYxsiRAu+
   Q==;
X-CSE-ConnectionGUID: 0jyA7ywQQau+CCXsjyILaA==
X-CSE-MsgGUID: dH2kXmArTFKjiLzacGWn5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="91939020"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="91939020"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 20:28:01 -0700
X-CSE-ConnectionGUID: 4atK+GKBRHKn7zvQjHHrYw==
X-CSE-MsgGUID: s45oagcsQGuyrH3D8BLmQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="241110114"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 20:28:00 -0700
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
Subject: [PATCH v4 06/10] fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()
Date: Tue,  2 Jun 2026 20:27:34 -0700
Message-ID: <a2ba7d12c8dae5c4d04ea0bbda6bf4340f5b0d27.1780456704.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1780456704.git.reinette.chatre@intel.com>
References: <cover.1780456704.git.reinette.chatre@intel.com>
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
index 0d073d4db734..c04424c081a4 100644
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
2.50.1

