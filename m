Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2964A34D4F9
	for <patches@lists.linux.dev>; Mon, 13 Jul 2026 17:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783964433; cv=none; b=lDoUg+v8ZwF11d7ZAtYbozmJnbh5UI17FiKae4ivCijh95britqDKJYQ42wKAGI8qPOx4kBvpN3hx1BhlGGV7xEZQxlVztBqrNyA+2bG51cjf00olVjLjSX1blogf2s3a+C8vIKQy0hMKF9mWLPyvwoNDb2lOyx5cuDUzH96zGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783964433; c=relaxed/simple;
	bh=dP3KjWFniCitNcWSqDpJrcpW0nvmc823CtAqQ9/WR5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GojZOcwWIX/vOPKFKe0Zh6sm5o61J1GABmF8L7wtdZgGQriAnlxaDSOaRDblaoyfEFiZkfJLQuE84uDVmCPGKhI9D/DF4F5qfRm/lE811UNNMmGl/QWmZSk6hH9xN294IcDQWATnV0USm01YSriV2Kxhi4iCFRMbP+cDBd3xd2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hVXtzrIy; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hVXtzrIy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783964431; x=1815500431;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dP3KjWFniCitNcWSqDpJrcpW0nvmc823CtAqQ9/WR5I=;
  b=hVXtzrIynr17NjWMfiDp1iO8plXL/QQnxsqXLVK/4li7Ac1sZsfIjA65
   2eylkjU/1s2VprIV8tYinkIbrffeNaXad2YbhDyFE2P7ObBHorWkLi/nT
   iqVwcnIvjRATfUM3YAu4FvlbhWeKQcX3UOMDjz4xoKR241R2ISU+SiFEZ
   sM+imvW95VOSB2v/bvnsKB1PJqM7IHaaY9rZsKy1/NHZuNcOexdfd0lp+
   o9coZE3Bp/H52XG0UISJ/dJ5Hur19+hq4c+dUEvan5wXnn4Z9nnGlWPSe
   vGdjQ+97NMx4n1ADXf+fsx4MUWJ9eGIr5MU18c/SDXxI2ZP71Q3nWg7pw
   g==;
X-CSE-ConnectionGUID: pGog8AxEQqmihsYHhy54bQ==
X-CSE-MsgGUID: 6qT+hWVARaiNLBrrYFmV4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="107375573"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="107375573"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 10:40:26 -0700
X-CSE-ConnectionGUID: 3FwKWdhAT8iLP9m5K7JzbA==
X-CSE-MsgGUID: ZhTnGPs8Se+rIMlgOA9Ocg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="254483898"
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
Subject: [PATCH v7 6/7] x86/resctrl: Ensure domain fully initialized before placed on RCU list
Date: Mon, 13 Jul 2026 10:39:42 -0700
Message-ID: <31ae67084c983e8cb8c5ef2c65e1096de5e8f9b0.1783963505.git.reinette.chatre@intel.com>
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

A resctrl domain consists of the domain structure self that includes
pointers to dynamically allocated filesystem as well as architecture
specific data. For example, the L3 monitoring domain structure consists
of the architecture specific struct rdt_hw_l3_mon_domain that contains
the dynamically allocated rdt_hw_l3_mon_domain::arch_mbm_states
architectural state and the embedded struct rdt_l3_mon_domain contains
the dynamically allocated rdt_l3_mon_domain::mbm_states resctrl fs state.

The domains are added to and removed from an RCU protected list while
cpus_write_lock() is held so that readers could access domains via
cpus_read_lock() or from an RCU read-side critical section.

A reader accessing a domain via the RCU list expects that the domain and
all its dynamically allocated data is accessible. Only place the domain on
the RCU list when all its dynamically allocated data is ready, similarly
unlink it from RCU list (again with cpus_write_lock() held) before removing
any of its dynamically allocated data.

Calling resctrl_online_mon_domain() before adding the domain to the RCU
list creates the kernfs files that expose the domain's monitoring data to
user space before adding the domain to the RCU list. This is safe because
rdtgroup_mondata_show() acquires cpus_read_lock() before it traverses the
RCU list and will thus block until the domain is added to the RCU list.

There are no readers accessing a domain via RCU list. Ensure safety of
access when such a reader arrives.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
---
Changes since V2:
- New patch

Changes since V3:
- Add Tony's Reviewed-by tag.
- Add Chenyu's Reviewed-by tag.
- Grammar fixes in changelog.
- Add snippet to changelog about possible race with rdtgroup_mondata_show().
---
 arch/x86/kernel/cpu/resctrl/core.c      | 18 +++++++-----------
 arch/x86/kernel/cpu/resctrl/intel_aet.c |  5 ++---
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 9c01d2562b7a..bca782050198 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -515,14 +515,12 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
 		return;
 	}
 
-	list_add_tail_rcu(&d->hdr.list, add_pos);
-
 	err = resctrl_online_ctrl_domain(r, d);
 	if (err) {
-		list_del_rcu(&d->hdr.list);
-		synchronize_rcu();
 		ctrl_domain_free(hw_dom);
+		return;
 	}
+	list_add_tail_rcu(&d->hdr.list, add_pos);
 }
 
 static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
@@ -556,14 +554,12 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
 		return;
 	}
 
-	list_add_tail_rcu(&d->hdr.list, add_pos);
-
 	err = resctrl_online_mon_domain(r, &d->hdr);
 	if (err) {
-		list_del_rcu(&d->hdr.list);
-		synchronize_rcu();
 		l3_mon_domain_free(hw_dom);
+		return;
 	}
+	list_add_tail_rcu(&d->hdr.list, add_pos);
 }
 
 static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
@@ -642,9 +638,9 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
 	hw_dom = resctrl_to_arch_ctrl_dom(d);
 
-	resctrl_offline_ctrl_domain(r, d);
 	list_del_rcu(&hdr->list);
 	synchronize_rcu();
+	resctrl_offline_ctrl_domain(r, d);
 
 	/*
 	 * rdt_ctrl_domain "d" is going to be freed below, so clear
@@ -689,9 +685,9 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 
 		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 		hw_dom = resctrl_to_arch_mon_dom(d);
-		resctrl_offline_mon_domain(r, hdr);
 		list_del_rcu(&hdr->list);
 		synchronize_rcu();
+		resctrl_offline_mon_domain(r, hdr);
 		l3_mon_domain_free(hw_dom);
 		break;
 	}
@@ -702,9 +698,9 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 			return;
 
 		pkgd = container_of(hdr, struct rdt_perf_pkg_mon_domain, hdr);
-		resctrl_offline_mon_domain(r, hdr);
 		list_del_rcu(&hdr->list);
 		synchronize_rcu();
+		resctrl_offline_mon_domain(r, hdr);
 		kfree(pkgd);
 		break;
 	}
diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index 89b8b619d5d5..c22c3cf5167d 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -398,12 +398,11 @@ void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
 	d->hdr.type = RESCTRL_MON_DOMAIN;
 	d->hdr.rid = RDT_RESOURCE_PERF_PKG;
 	cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
-	list_add_tail_rcu(&d->hdr.list, add_pos);
 
 	err = resctrl_online_mon_domain(r, &d->hdr);
 	if (err) {
-		list_del_rcu(&d->hdr.list);
-		synchronize_rcu();
 		kfree(d);
+		return;
 	}
+	list_add_tail_rcu(&d->hdr.list, add_pos);
 }
-- 
2.54.0

