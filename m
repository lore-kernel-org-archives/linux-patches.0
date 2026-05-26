Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980EE3C9ED6
	for <patches@lists.linux.dev>; Tue, 26 May 2026 22:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779835113; cv=none; b=TKOXWsw/MGno4lzsaIm9jNkduhbQOKNVikuoE5DS8xsHIVF/6P1/BDKB8kz/fsTa2FDiacpihzHrQTtRVP8pcQPnetTsih5FD/jrDKU66qtxckU/JypHH7QSpSJq2yuSkQXD8sW8ALgf7Mz7oTUIw9lx/XVH7VnAWSHKjxovNLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779835113; c=relaxed/simple;
	bh=A57HiSxjNqKJqDXgdMhSnYriKAUcfwvXgqhJF5zeRkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCNnzQYFC29Qr9gcVBDxy8vRtR3Riy9/q+pWgtafZvKRt8HGFVt11TDoQqycrrS8/hFJa3lgmx3U0pn73Jdl4b1U3opC9XNEuMHEd7CQ9Kg2gOTiMcXQBouG+RNR2Y74PkX7+eDuVyRRswSXYXc2FK8vzscmGS5NAkNz8M613v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cPRWFgof; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cPRWFgof"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779835110; x=1811371110;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A57HiSxjNqKJqDXgdMhSnYriKAUcfwvXgqhJF5zeRkY=;
  b=cPRWFgofsAXGIFQ7PaC6N3EOQZZM8kc1yomVBAp07wSH4Tl/LJ2VBe3r
   0gVkJ2ujDhc+zFmgvi87mdb4DP7b3hObNNgqINh6S4zKSAi9eZ6oZ0Hek
   OYe6glgvv46Zqcs20/gCYkcWHC9qyblaAeZKwAdXUjzHmItBnYrH6IE5P
   0SOw826eyJa3Mud7hDiyijLkUwCEF5NoywBFpwucF3l8qv7qs3azmTjVf
   Tb3xPhaGfM8QpMHKHVQwJ0+79dM5V93RMO8krjjOD0n9p0xlNZ2HmDArL
   Tfb6pmweyb8PfYj5W7LvrdWrXQLjJC0d6QB5f/E4pedEVYRZeHuH/VD9W
   g==;
X-CSE-ConnectionGUID: edC9sS/OQ9WNP7wySV1UUg==
X-CSE-MsgGUID: 1oFM5dvMQZqKoKUDAxdZgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="79808487"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="79808487"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 15:38:28 -0700
X-CSE-ConnectionGUID: LDa9dKxSTxeZiqCqKpXK6Q==
X-CSE-MsgGUID: 8ePYcTw6TMa+W7J3TxPVGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="242217087"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 15:38:28 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: reinette.chatre@intel.com
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH RESEND v3 2/3] x86/resctrl: Ensure domain fully initialized before placed on RCU list
Date: Tue, 26 May 2026 15:38:21 -0700
Message-ID: <640368f8f4a5db4c359ae603ff624487a103abdd.1779834897.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1779834897.git.reinette.chatre@intel.com>
References: <cover.1779834897.git.reinette.chatre@intel.com>
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

The domains are placed on an RCU protected list so that readers could
access domains via cpus_read_lock() or from an RCU read-side critical
section.

A reader accessing a domain via the RCU list expects that the domain and
all its dynamically allocated data is accessible.  Only place domain on RCU
list when all its dynamically allocated data is ready, similarly unlink
from RCU list before removing any of its dynamically allocated data.

There are no readers accessing a domain via RCU list. Ensure safety of
access when such reader arrives.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since V2:
- New patch
---
 arch/x86/kernel/cpu/resctrl/core.c      | 18 +++++++-----------
 arch/x86/kernel/cpu/resctrl/intel_aet.c |  5 ++---
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 7667cf7c4e94..c6c887b2b6bc 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -514,14 +514,12 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
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
@@ -555,14 +553,12 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
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
@@ -641,9 +637,9 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
 	hw_dom = resctrl_to_arch_ctrl_dom(d);
 
-	resctrl_offline_ctrl_domain(r, d);
 	list_del_rcu(&hdr->list);
 	synchronize_rcu();
+	resctrl_offline_ctrl_domain(r, d);
 
 	/*
 	 * rdt_ctrl_domain "d" is going to be freed below, so clear
@@ -688,9 +684,9 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 
 		d = container_of(hdr, struct rdt_l3_mon_domain, hdr);
 		hw_dom = resctrl_to_arch_mon_dom(d);
-		resctrl_offline_mon_domain(r, hdr);
 		list_del_rcu(&hdr->list);
 		synchronize_rcu();
+		resctrl_offline_mon_domain(r, hdr);
 		l3_mon_domain_free(hw_dom);
 		break;
 	}
@@ -701,9 +697,9 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
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
2.50.1

