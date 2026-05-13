Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE68184
	for <patches@lists.linux.dev>; Wed, 13 May 2026 22:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778712057; cv=none; b=hxirG9brj6NVG8UguH0dJrpq8v88irC7bnjGBSy9Ft3JuppiDXBXonlESwh/8M1YY3QDvmxdvhG7JY6/1tulRpy45qEsnoI/i6iKV25Q1tfbrkqAnwEEpUCSoC4gGl0QZxWysko57VZZro831tltuZgCTgx/kgjVQBkCBurObd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778712057; c=relaxed/simple;
	bh=Y5RIrXog4qurIC0+jIWOAu9O5muVdejdJtcAbubIcfM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mO2x7fXJGczHx9cvcJaYqCTcOM5W0afN2Te8Dl2vmiHkz9Hd9xl1acOglX8urLPc7c2GVEH1KxVVMxxWyBYybu2nViwNsh+lEhYoUh8V8vsqvYq6zGoil2NlMK3wFKgV5wwdBbXy5IFU2p8+67WF8T9iuxFTGbUp3qf7waCnAUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AfJCtquB; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AfJCtquB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778712055; x=1810248055;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Y5RIrXog4qurIC0+jIWOAu9O5muVdejdJtcAbubIcfM=;
  b=AfJCtquBD2P+aFJSLDQvGZYMBUojT7LD4k1b8Jbk3mz26Acpg81GBkGX
   dFqzowKCgjcaV/gyM9R6idj4ULcOxrZhyus2we+TeZyG+1YUocjScJak3
   k1gobLfbw92FFgJ8rsOHT7IRBkvCyOk2mFheV6s0p93jl/YZmRTAzdphA
   T27PsLHyBId9XPHbYW8T6xgNty6ap04h2EMzh6sf+EQW2/13lQ1fjRSYw
   qqrRZ8PnB/EpcV76hoKkEOfzI1bvYfJtQ9ueAS9o5DrEZCYFBLEaQrsdi
   XmGCdzD1jjtaEfqhzPisvaYT9j7p8YNJH9UaGZJ1pix3VZGD/hFB55Phv
   Q==;
X-CSE-ConnectionGUID: IlmWwm5NRUeJ/e6F6ckYiw==
X-CSE-MsgGUID: B6HAZWDLRG6eqhaaEsNGmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="78794451"
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="78794451"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 15:40:54 -0700
X-CSE-ConnectionGUID: c36fJNXuSneE1FtQz0kibA==
X-CSE-MsgGUID: amUaQGrwT8uXrm52hxfouA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="276309673"
Received: from inaky-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.114])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 15:40:54 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH] fs/resctrl: Fix use-after-free during unmount
Date: Wed, 13 May 2026 15:40:44 -0700
Message-ID: <20260513224044.17167-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko reported[1] this issue:

  During unmount or failure teardown, resctrl_fs_teardown() calls
  mon_put_kn_priv() (which frees all mon_data structures) followed
  by rdtgroup_destroy_root() (which destroys kernfs nodes). However, the
  RDT_DELETED flag is never set for rdtgroup_default.

  If a concurrent reader (e.g., rdtgroup_mondata_show()) invokes
  rdtgroup_kn_lock_live(), it drops kernfs active protection and blocks on
  rdtgroup_mutex. resctrl_fs_teardown() (holding the mutex) proceeds to free
  the private data and destroy the nodes without waiting for the reader.

  When the mutex is released, the reader wakes up, observes that RDT_DELETED is
  not set for the default group, and dereferences the already-freed of->kn->priv
  pointer.

Set RDT_DELETED for the default group (if there are any tasks waiting).

Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://sashiko.dev/#/patchset/20260508182143.14592-1-tony.luck%40intel.com?part=2 [1]
---

Yet another side-quest from Sashiko. RFC for some human eyes before I
add to my series and post a new version;

1) Is this real? It looks like it is to me.
2) Is my fix reasonable?
3) Better way to fix it?

 fs/resctrl/rdtgroup.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index eac7e4f8574d..668ebe0b0ec6 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -594,7 +594,8 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 static void rdtgroup_remove(struct rdtgroup *rdtgrp)
 {
 	kernfs_put(rdtgrp->kn);
-	kfree(rdtgrp);
+	if (rdtgrp != &rdtgroup_default)
+		kfree(rdtgrp);
 }
 
 static void _update_task_closid_rmid(void *task)
@@ -2965,6 +2966,8 @@ static void resctrl_fs_teardown(void)
 	mon_put_kn_priv();
 	rdt_pseudo_lock_release();
 	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
+	if (atomic_read(&rdtgroup_default.waitcount) != 0)
+		rdtgroup_default.flags = RDT_DELETED;
 	closid_exit();
 	schemata_list_destroy();
 	rdtgroup_destroy_root();
@@ -4291,6 +4294,7 @@ static int rdtgroup_setup_root(struct rdt_fs_context *ctx)
 
 	ctx->kfc.root = rdt_root;
 	rdtgroup_default.kn = kernfs_root_to_node(rdt_root);
+	rdtgroup_default.flags = 0;
 
 	return 0;
 }
-- 
2.54.0

