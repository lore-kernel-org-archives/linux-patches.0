Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8045634C9A6
	for <patches@lists.linux.dev>; Mon, 13 Jul 2026 17:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783964431; cv=none; b=YotXrXj4/6RD3Pgg5CAbT5GRuZ+uFDsdnVkKGW/hjVaavI0Kd3+mF69K52CIv98jSEMqddExlFn4CV8ZXjs30dWJKmki22L5v2eeywFsrYxc+QexyFF3QhcF7dUxUEa/PbQpfs+PwOZMjA3l88GdUVodz61mwcT0WkWd2Otn8J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783964431; c=relaxed/simple;
	bh=DnqtYXfZPaaIE6G4pJXdl2AkJoFS8eHrvWsFS0K/OqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9AJGZgWVKVkxaG3uTlzUGgiH4SOFA6kWHXidwql3JG66UuIhMUai251rzyac5Fwb4P9kzWi9WwXbfpd5rl6opgmZFNY9qM7JtUQaSPdu3V4vWereTWXfbSbQGMVK29ENmJ/KsYql6N2vNlxKMyfcu37t8ta72OYOr7V8bcCEtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jDNofLqU; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jDNofLqU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783964430; x=1815500430;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DnqtYXfZPaaIE6G4pJXdl2AkJoFS8eHrvWsFS0K/OqI=;
  b=jDNofLqUXyzeJj0ABzpziANd76fyoC3BVWJPqI788MF1FEfwrU+YzzQ+
   jnEiPXs/RnxYK070hv9jMghiWs/PQjbDzDhnIJDK2oE3z5uEPp0UIFKZh
   Z+s1dIDFYF6X29LbQ42ILJMcCCZ3PGLiIc9eSjGnRe0W2I48M2fgL8JHk
   yFtCdEgV8DT+ttvZ1l9sYuE3g3MLCbPRwNfn3onXXYi3P9wVgkb/CqHRl
   41ZXAZZv2zCzH6cGrqm7PyK2SwrNE1Mp5DXZKxGwhirQbsgjbgqlkgqgI
   fHy3s51MI8nwB5X8F8AqkVpRweasRWgkPUGfA3BAlaZumNup8xUXGMCZZ
   A==;
X-CSE-ConnectionGUID: bv0FcVLQR36GVwz/PnwTLA==
X-CSE-MsgGUID: j3BTnSRTSnSWIawxFKPCQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="107375550"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="107375550"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 10:40:26 -0700
X-CSE-ConnectionGUID: pHBJqJXGSmKoGZQ5mZHwAw==
X-CSE-MsgGUID: Eas+m9eRSTeSEh488DQIFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="254483889"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 10:40:25 -0700
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
Subject: [PATCH v7 4/7] fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()
Date: Mon, 13 Jul 2026 10:39:40 -0700
Message-ID: <8d028bbea582dc382a4cc166b235f75bd5901aea.1783963505.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1783963505.git.reinette.chatre@intel.com>
References: <cover.1783963505.git.reinette.chatre@intel.com>
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

