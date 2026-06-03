Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644CE3DD51F
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 03:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780457287; cv=none; b=BcCbkVqh3HUDh95haOeeYpho4k1gBVScL6rzxn6rFzVFIxdlGnIu1D9CyelCYdxVet6+Vx2GCdD9snzq63yuvA/7DwPA86I58t6RjVilFC4q6XrGOdovMHLMhIGBEiDFLxTG3qZXaiirRlDhVwJ8yIp2eeAaXbieUxspdvi7NQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780457287; c=relaxed/simple;
	bh=LI3fWkBiCZaOC31ilZkPdUqLlp43WfXVSeGsZHEYUvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHEzGW5vHrvF+TMdU4sEBuB+cqM7Z8Wn8oLa3t5Nsfwmo/f01Y8COwhq/4lZ7bpJplTDLTRt/JTlnfXZ9bDrozbMMzPINV+ViWwBy5cQkef/IlIzBoTRErS1Bk7A0jrX1WH5JftQ1fo4k6BkE4gAZkGjSXmIpuNEI5xTa7R+nH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iD3ttc/I; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iD3ttc/I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780457285; x=1811993285;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LI3fWkBiCZaOC31ilZkPdUqLlp43WfXVSeGsZHEYUvs=;
  b=iD3ttc/IubiGHOUpdhkUQ+45Tbe2RO3ALVaFepOnvdyLZw+5D3Jz4MfH
   1/5w4iR+DziILmJThevx5Xzd+izP1D9AQyuG/DJJwgGtDa/O2VrTyqri/
   bmGGCz3hAn3wI7GwEbm0+7TwlFhRu3ktUBLmnMasYMmzxTzV/NkgVCDxe
   k9ggHIUh7NNWR2NAynK2UEQbxUb2z6LdEZ1sKPhXfrjiuINq42lloBGZr
   KB9y8uwPTBgqSaP+ufjbcm7P+C4Zg33bog9cidgVL4H5HLKySiF04x24X
   YHY8OQbo2Nl8nQDCb2ZokJOKRSAZUFvL5H3RaJztWX0r/8z7PafjwWfvV
   g==;
X-CSE-ConnectionGUID: kS32Y5l1RxKi0BVlFGv+Cg==
X-CSE-MsgGUID: JVV/5hA0RPimHgipDj8k7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="91939051"
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="91939051"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 20:28:02 -0700
X-CSE-ConnectionGUID: Z1M80lUZRn2YTPwIH7PLPQ==
X-CSE-MsgGUID: N0pjBagxT+KsqCU8LKtwSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,184,1774335600"; 
   d="scan'208";a="241110144"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 20:28:01 -0700
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
Subject: [PATCH v4 09/10] x86/resctrl: Ensure domain fully initialized before placed on RCU list
Date: Tue,  2 Jun 2026 20:27:37 -0700
Message-ID: <b456813ba11633881b8feb12813b040647aacf44.1780456704.git.reinette.chatre@intel.com>
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
2.50.1

