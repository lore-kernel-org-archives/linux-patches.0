Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857DB3BB673
	for <patches@lists.linux.dev>; Tue, 26 May 2026 22:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779832924; cv=none; b=c5MAWvItXQ0yBayXgElzfCv1pcJiQkNO7BFMgbEUcsx04jY9FajMRt3mwe29xqKc9z59jsgMY+4DlGgDoaLJK1bzXmv64RvSbIhn2Ut3VOVqT5utBkJzrhe8f+g7Y6aAACmX2SEZ0eFqLiH82YxkEl/aMn8U5xjchHOStFlRFFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779832924; c=relaxed/simple;
	bh=1iXFgQCwrYTU794BU7ayq2EciWf+wRYONptSagDlmxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMGDx2B61qz29753iFNzJ2DirMWhruMw50cyqwHTsyrxyPXb7VAgbUQURopyOs2D/T3m3eKJ51yROqLYyXns/eKoPnwFKvwKpw8RXlxRGMlWWkoPF/ebCq/0Ya3bgKcLfFoZK6bcqgzOFqSURHSb9AuBK2high9K5IR0OyJT6jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SL+4tVrW; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SL+4tVrW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779832923; x=1811368923;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1iXFgQCwrYTU794BU7ayq2EciWf+wRYONptSagDlmxY=;
  b=SL+4tVrWJFH9D1tgwgcy8SCHCUh6GZI9yFTllwIDkdTanVNVMZ3ZRi2Z
   Ud2d+2JcjTaVsCF54Fu7ODeEGgf3wqu0Q2XpD6jum36fM6zZ6WK53D0aa
   ytgYXhw/ooPSaXUs/Kd7omx7O618gzoB599BOOAodDdKoZDFe9oh3BRn8
   kEs0vW0ggbk6rwtiOJ7IThG8hNrUHA2Sf3naoe8Dv8CRlY0QotwIzz2/S
   wgYBwXK8p96/tXvTGK968bja/SGPxqnOe++0vq3K59KRhd3sQ2G3K3qFJ
   LfnMFAPrUMUOwfJ2Pfke9u6tvxIR66Hz3S3Jt0BKeDYP1hI13XzHHDjgD
   w==;
X-CSE-ConnectionGUID: i4tCYkI5R7SDfhfupeG26w==
X-CSE-MsgGUID: cfCH7bkSRLaXBkQ1xVOvWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="80846266"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="80846266"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 15:02:01 -0700
X-CSE-ConnectionGUID: 5TtLTAxbQU6X+MEJ4TeZlQ==
X-CSE-MsgGUID: oDWYwg4mSYCR3wxjUBRwPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="246076939"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 15:02:00 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: reinette.chatre@intel.com
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH RESEND v3 8/9] x86/resctrl: Ensure domain fully initialized before placed on RCU list
Date: Tue, 26 May 2026 15:01:51 -0700
Message-ID: <3ba2959b1cd3596e1e340eaee6b43487edaec0a4.1779832265.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1779832265.git.reinette.chatre@intel.com>
References: <cover.1779832265.git.reinette.chatre@intel.com>
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
2.50.1

