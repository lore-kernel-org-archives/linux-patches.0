Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7A736C9CC
	for <patches@lists.linux.dev>; Mon,  4 May 2026 22:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777932118; cv=none; b=qhbuqdrxGWF5Bf/AmrgRYCoyqsOlQg4xd74m1vO3kIT+ezdSW6qUkTp8D9fZVhD+1QoZ0p2Osov7lIjznyksxKwGsgtqi33U8M1aPQ2kWi49JvOwQqav2EvEcahXBYGzKWMr7ssPOPDLyQdL6d4knvxob8b+NmD/IHyAM8bZ0+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777932118; c=relaxed/simple;
	bh=gpCBfrDNn41t9SezRyHAzzYotLwKuRhzYO/fi3whyZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KgsGzG/rlQfjeVRWKXiSbywa6ZAJGtZXncUmXJh3yrWelSDgzUvA8H3c2nvj7bdQRo+fte0wxLALG0fY6PW5P6fDWOT/BTw+YoUEJQKHwV2iTQYWsA+om4c1vxW2/8diauRiOq/1ak2s8XlOOZg/H8XwNB80LT50+8q8s539NJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MQOhvU1k; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MQOhvU1k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777932117; x=1809468117;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gpCBfrDNn41t9SezRyHAzzYotLwKuRhzYO/fi3whyZY=;
  b=MQOhvU1kEObLgJHBNXgiQPU5nOXI2VSQZv+bxvl7CO8J/dodEw9aupy6
   SJDJoWY8W1HYJ1C1Nusbu3xObdcOSuy7pDzEnUq1QnQieM50PxANlgb+q
   zBAP+ZJDPnB/SfafALraEnxysSYjtL1wYFO3q2Tq5/ZSkxw1vbzyS1BqL
   B94pWWlhJX0LLUc2RvSgziq3c8pQLM8MECyyKlViBZfM3wx17koeHXwNm
   Vudh6K+JvCok2OjmR0ASCQ+eNjrjxYkDd/YAAbIA2rSgCYaBIqX+8yISr
   su6atf++GMGH6EvxY7XGGazEi7/pjXJEVm3cNwnZ6DHPRBh9+uFTv5K1C
   w==;
X-CSE-ConnectionGUID: AuI0+GVMR9KzBtUwxKR38A==
X-CSE-MsgGUID: ZO5NvRPxQyKcW+bDXUhKoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="78731090"
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="78731090"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 15:01:56 -0700
X-CSE-ConnectionGUID: X2R0pxN8R7a428Cpr3IvTQ==
X-CSE-MsgGUID: c1FMLVmCQ0WJjTEwJCSRRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="265976101"
Received: from jjgreens-desk20.amr.corp.intel.com (HELO agluck-desk3.intel.com) ([10.124.223.16])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 15:01:56 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	x86@kernel.org
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v2] fs/resctrl: Fix deadlock for errors during mount
Date: Mon,  4 May 2026 15:01:49 -0700
Message-ID: <20260504220149.157753-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko noticed[1] a deadlock in the resctrl mount code.

rdt_get_tree() acquires rdtgroup_mutex before calling kernfs_get_tree(). If
superblock setup fails inside kernfs_get_tree(), the VFS calls kill_sb on
the same thread before the call returns.  rdt_kill_sb() unconditionally
attempts to acquire rdtgroup_mutex and deadlock occurs.

Move the call to kernfs_get_tree() outside of locks.

If kernfs_get_tree() fails and ctx->kfc.new_sb_created is set, then rdt_kill_sb()
has already been called and no further cleanup is needed.

Fixes: 5ff193fbde20 ("x86/intel_rdt: Add basic resctrl filesystem support")
Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com [1]
---

Changes since v1:
Link: https://lore.kernel.org/all/20260501185612.14442-1-tony.luck@intel.com/

AI solution from Claude abandoned after human (Reinette) and AI (Sashiko)
reviews found it lacking.

Reinette: Feel free to claim full authorship of this fix since you
provided direction for every aspect. At minimum the "Suggested-by:"
should be "Co-authored-by:" (with your sign-off).

 fs/resctrl/rdtgroup.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5dfdaa6f9d8f..6709b74bd655 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -2855,10 +2855,6 @@ static int rdt_get_tree(struct fs_context *fc)
 	if (ret)
 		goto out_mondata;
 
-	ret = kernfs_get_tree(fc);
-	if (ret < 0)
-		goto out_psl;
-
 	if (resctrl_arch_alloc_capable())
 		resctrl_arch_enable_alloc();
 	if (resctrl_arch_mon_capable())
@@ -2874,10 +2870,26 @@ static int rdt_get_tree(struct fs_context *fc)
 						   RESCTRL_PICK_ANY_CPU);
 	}
 
-	goto out;
+	/* Release locks because kernfs_get_tree() may call rdt_kill_sb() */
+	mutex_unlock(&rdtgroup_mutex);
+	cpus_read_unlock();
+	ret = kernfs_get_tree(fc);
+	if (!ret || ctx->kfc.new_sb_created) {
+		/* mount succeeded, or failed and already cleaned up */
+		return ret;
+	}
+	cpus_read_lock();
+	mutex_lock(&rdtgroup_mutex);
+
+	if (resctrl_arch_alloc_capable())
+		resctrl_arch_disable_alloc();
+	if (resctrl_arch_mon_capable())
+		resctrl_arch_disable_mon();
+
+	resctrl_mounted = false;
 
-out_psl:
 	rdt_pseudo_lock_release();
+
 out_mondata:
 	if (resctrl_arch_mon_capable())
 		kernfs_remove(kn_mondata);
-- 
2.54.0

