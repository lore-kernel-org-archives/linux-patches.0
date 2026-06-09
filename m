Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BFD1F4C8E
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 21:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781038972; cv=none; b=DBbSY/2uYWYojftyYeMhRm5gIsNk6rMQZgrplyNCDN/q8wGLHexR3MZmjj9s7/cUtnyg18wmz0/hIdrIrAmF1gAZEuq+623cpp9s5jY+PCcm9Gc719P1nTSOgC1YhtD5n+s5N2k9kX2vOE5a9fCqhqbVziUUvbIC4HbSZR3f/EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781038972; c=relaxed/simple;
	bh=f/Q5dw5XVz+ZpO56KFHZP9zsoZeVoBUTIdNJsq6xYdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJ8Y2E3dWSuiFUhvQ44gcGJV+uDygEttaJ7RGBxqUWa95Bcrd3Z1cJQvUiV3RbZcP1+IByo6l0aDu94tEbgg86OS+mf3y07V+ldK13kIXEcpjoNumQl6AixYWNMHUTtsMuB6t5wouORYWY5Mw3x4V1GZH/CXK5USyBU0ia32pj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YEG8veQ8; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YEG8veQ8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781038972; x=1812574972;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f/Q5dw5XVz+ZpO56KFHZP9zsoZeVoBUTIdNJsq6xYdk=;
  b=YEG8veQ8bAw9Ke588T0il9LJNo022klHdXm5RkIMQYXINR6J4JLWTcxv
   LLzi+jj2iSgxaryiQyCC+mbZ72eERASg8zfhmNSJDj4F+z5/P9rLv/jqr
   r4PWL+Jv1G1r0jrijvpCUGbEJD0vLz6Bu/nXB6QZsJ9XVe6vLdYV+ug3U
   Z5zRqYj7K/aRa82VsYwKsYJyWBNYJxn5HP2IqDlG/p+KPoMnBGB5tltnD
   Q+zaLxKWPrbNzwRFCNkkZFAvAOH5sD9TItRWdy6s9lVUZpTTcQKnQD8ue
   GC57ULjwPqEWRRAi/gmq/oKuQUUixy49D6fYk645ys7OjwQXmPN3UVlSE
   Q==;
X-CSE-ConnectionGUID: 9CJqxCQATt244D10oUccIg==
X-CSE-MsgGUID: NszVOuI4RQ6HV1OXS0Ys5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="81725046"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="81725046"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:02:51 -0700
X-CSE-ConnectionGUID: wEv00hnMRoyHInxHDUY4gw==
X-CSE-MsgGUID: utlzelpgTnuL2HoRrTj/qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="251045646"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 14:02:49 -0700
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
Subject: [PATCH v5 01/11] x86,fs/resctrl: Prevent out-of-bounds access while offlining CPU when SNC enabled
Date: Tue,  9 Jun 2026 14:02:27 -0700
Message-ID: <16137433df42f85013b2f7a53626795cbd6637b9.1781029125.git.reinette.chatre@intel.com>
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

The architecture updates the cpu_mask in a domain's header to track which
online CPUs are associated with the domain. When this mask becomes empty
the architecture initiates offline of the domain that includes calling
on resctrl fs to offline the domain. If it is a monitoring domain in
which LLC occupancy is tracked resctrl fs forces the limbo handler to
clear all busy RMID state associated with the domain.

The limbo handler always reads the current event value associated with a
busy RMID irrespective of it being checked as part of regular "is it still
busy" check or whether it will be forced released anyway. When reading an
RMID on a system with SNC enabled the "logical RMID" is converted to the
"physical RMID" and this conversion requires the NUMA node ID of the
resctrl monitoring domain that is in turn determined by querying the NUMA
node ID of any CPU belonging to the monitoring domain.

When the monitoring domain is going offline its cpu_mask is empty causing
the NUMA node ID query via cpu_to_node() to be done with "nr_cpu_ids" as
argument resulting in an out-of-bounds access.

Refactor the limbo handler to skip reading the RMID when the RMID will
just be forced to no longer be dirty in the domain anyway. Add a safety
check to the architecture's RMID reader to protect against this scenario.

Fixes: e13db55b5a0d ("x86/resctrl: Introduce snc_nodes_per_l3_cache")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/cover.1780456704.git.reinette.chatre%40intel.com?part=9
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since v4:
- New patch
---
 arch/x86/kernel/cpu/resctrl/monitor.c |  5 ++++
 fs/resctrl/monitor.c                  | 39 +++++++++++++++------------
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 03ee6102ab07..569894d6e5c8 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -259,6 +259,11 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_domain_hdr *hdr,
 	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
 		return -EINVAL;
 
+	if (cpumask_empty(&hdr->cpu_mask)) {
+		pr_warn_once("Domain %d has no CPUs\n", hdr->id);
+		return -EINVAL;
+	}
+
 	d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 	hw_dom = resctrl_to_arch_mon_dom(d);
 	cpu = cpumask_any(&hdr->cpu_mask);
diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 0e6a389a16bf..a932a1fea818 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -135,10 +135,10 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
 	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
 	struct rmid_entry *entry;
+	bool rmid_dirty = true;
 	u32 idx, cur_idx = 1;
 	void *arch_mon_ctx;
 	void *arch_priv;
-	bool rmid_dirty;
 	u64 val = 0;
 
 	arch_priv = mon_event_all[QOS_L3_OCCUP_EVENT_ID].arch_priv;
@@ -161,22 +161,27 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
 			break;
 
 		entry = __rmid_entry(idx);
-		if (resctrl_arch_rmid_read(r, &d->hdr, entry->closid, entry->rmid,
-					   QOS_L3_OCCUP_EVENT_ID, arch_priv, &val,
-					   arch_mon_ctx)) {
-			rmid_dirty = true;
-		} else {
-			rmid_dirty = (val >= resctrl_rmid_realloc_threshold);
-
-			/*
-			 * x86's CLOSID and RMID are independent numbers, so the entry's
-			 * CLOSID is an empty CLOSID (X86_RESCTRL_EMPTY_CLOSID). On Arm the
-			 * RMID (PMG) extends the CLOSID (PARTID) space with bits that aren't
-			 * used to select the configuration. It is thus necessary to track both
-			 * CLOSID and RMID because there may be dependencies between them
-			 * on some architectures.
-			 */
-			trace_mon_llc_occupancy_limbo(entry->closid, entry->rmid, d->hdr.id, val);
+		if (!force_free) {
+			if (resctrl_arch_rmid_read(r, &d->hdr, entry->closid,
+						   entry->rmid, QOS_L3_OCCUP_EVENT_ID,
+						   arch_priv, &val, arch_mon_ctx)) {
+				rmid_dirty = true;
+			} else {
+				rmid_dirty = (val >= resctrl_rmid_realloc_threshold);
+
+				/*
+				 * x86's CLOSID and RMID are independent numbers,
+				 * so the entry's CLOSID is an empty CLOSID
+				 * (X86_RESCTRL_EMPTY_CLOSID). On Arm the RMID
+				 * (PMG) extends the CLOSID (PARTID) space with
+				 * bits that aren't used to select the configuration.
+				 * It is thus necessary to track both CLOSID and
+				 * RMID because there may be dependencies between
+				 * them on some architectures.
+				 */
+				trace_mon_llc_occupancy_limbo(entry->closid, entry->rmid,
+							      d->hdr.id, val);
+			}
 		}
 
 		if (force_free || !rmid_dirty) {
-- 
2.50.1

