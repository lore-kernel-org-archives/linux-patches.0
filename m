Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F393DCD86
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 21:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781038982; cv=none; b=u39oAkYJtoSv19IcFu0hBwHAP9xOJs8fFCmgRdijzfwxgq47VmC6D34YLDzuzGYNLcZZevjjgsFKPxb66Spqgw7lKtmrlbMT5DNg8XNZtk4dwKoXUJwaFhvvK3YY5ntVFaatOXJv5hUtyb4TydaNF54R+INszRdiyBtiGhwo464=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781038982; c=relaxed/simple;
	bh=bQGZ3Gi1hecEzRonc8KkP4mUrFcfRliOT9dqTRLLRN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ik1o/Cp1ySXsmjy+Jg/kppcT1tNXL9YNat9kLtd2lzIQrTY8RNOcfppEEVxwMl2NvxBVduvskWu+Ef8OKCx9BfUmSaqae38yhOuTWriaBJGkvTnKYwMg16hBR/WGjXxMnuqSJtpZoRHjTKnb6ABeFazg2+sfeqLY2fDP81vR24w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Evfu3nvh; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Evfu3nvh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781038977; x=1812574977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bQGZ3Gi1hecEzRonc8KkP4mUrFcfRliOT9dqTRLLRN4=;
  b=Evfu3nvhFQk62Z75UYE+kQZDQs6qC5atr6E55E1BJrLLf1LUi/RfsHrY
   QJNCcYDaoCuRqMeE1CKQzxCk/DCOIsWdbIIJVm+4Bc55lgNHa6Q6psSMs
   fAHmlaKf6kHkkwLp/7T02o30F9GAICvbMzw2VC8SkqplFe4iS1hbuz9b2
   zaekRP9c833umwnA4cYLjoBw46Dkp9l5hNM5jnYYAmi+9YH8RgHp2yQWh
   BQdijdxLDFioGISk7Nu+4IJ0ZeeT2Cqz7VQna69GLItXu6sNR38iOLV3E
   430M7erTOjNu9YXzvy6VkXH3Ayqi+qSZ2B5nZPc5ne8ljbcWBiy0h0HjY
   w==;
X-CSE-ConnectionGUID: Tl6XkbmhQsGymDlDJQhQtg==
X-CSE-MsgGUID: tOw2Ybz4TN6HsT5IFNMd6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="81725079"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="81725079"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:02:56 -0700
X-CSE-ConnectionGUID: rq9mlczNR2C0OTwo24NvLA==
X-CSE-MsgGUID: JbXnfTi0STaH4dmC7jMfrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="251045719"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:02:54 -0700
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
Subject: [PATCH v5 07/11] fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()
Date: Tue,  9 Jun 2026 14:02:33 -0700
Message-ID: <9bfb3dc321d46b9d28d9952addc9c7e8a84437dc.1781029125.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1781029125.git.reinette.chatre@intel.com>
References: <cover.1781029125.git.reinette.chatre@intel.com>
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

