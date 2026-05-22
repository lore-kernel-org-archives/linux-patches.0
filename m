Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146F637B00C
	for <patches@lists.linux.dev>; Fri, 22 May 2026 19:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779477330; cv=none; b=Pxz8kDi0EgopSCycggQdiTjkQm8G+QWjRRqZ6m8MQsjHNKEak0acgbCASiJ7WK6wM13vHbnEB8/at0dT2DJcHaHKzxVrXM11DnnrqClIMI49nxKfY8hcXeUAgdDzS7ELYZr8fb0hfln3nd8tm3c+JI6h1IxAdJUOW/KlHHR3+QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779477330; c=relaxed/simple;
	bh=ew9Innih+s619jXBAPyHY9uGpf+Yd02UdujYYwkihAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9rr05FSat3CzrN80d5IYm7g2gEkoheEwYZMfWBPqD1KoxU7FTm2iAHZmZAbkradxpPb1ozb667UTOogOxKT/BoG+u+r1s/tr20E0stCOi5EmOtzyoEPeG1IC3t1NJZodJ4dL0/WebR8TxD944VWs6WBLlXu/FaSEGPVwUQ814c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I1eU63OB; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I1eU63OB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779477328; x=1811013328;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ew9Innih+s619jXBAPyHY9uGpf+Yd02UdujYYwkihAM=;
  b=I1eU63OB5YRM5johREKO5x1QwCyg/xGSfMiEFaw6xlBro8Qh7ifxbraf
   fhSOLyH+49LZ/JpMyT4vHRud9xQctEfOv4N2Bh3zAP1YCzv9/cyz88P4i
   Q1EzHBnMhzPrxeb/acAPPjbnfgyjSS/a3RxipnK8kZcNZxjeXVsjrNwRC
   CVi+1lRyAkktjmswj4ALBxdf3abFJ0lvJc7lcouJDV9JURAdMkVhGBLcP
   kaZ9YCU00RlAs+dG6CKZLYx5WOStLP0ufnqv9vpsj62EalQ+Oqm5CiwU0
   kgapauZNEdqaq8x7m1wlLYkKSMyDa2XC9pikZf6lwby9sKIoJ0gpiFoE9
   g==;
X-CSE-ConnectionGUID: VhE81kFfQFyxRhCcxkBx6A==
X-CSE-MsgGUID: KXaWw8gPS5qD8XGA8MadGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11794"; a="80140476"
X-IronPort-AV: E=Sophos;i="6.24,162,1774335600"; 
   d="scan'208";a="80140476"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2026 12:15:24 -0700
X-CSE-ConnectionGUID: 61Rmk+E5QMmOvH4ltkKeJA==
X-CSE-MsgGUID: oVDU+U/uThyVX7sY/HeWvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,162,1774335600"; 
   d="scan'208";a="271336471"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2026 12:15:24 -0700
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
Subject: [PATCH v3 5/9] fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()
Date: Fri, 22 May 2026 12:15:09 -0700
Message-ID: <f4e57df85e7aa7e6055b1765530bba900685045b.1779476724.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1779476724.git.reinette.chatre@intel.com>
References: <cover.1779476724.git.reinette.chatre@intel.com>
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
---
Changes since V2:
- New patch
---
 fs/resctrl/rdtgroup.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index d323b515060b..6418395877cf 100644
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

