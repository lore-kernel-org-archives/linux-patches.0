Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30C7330D51
	for <patches@lists.linux.dev>; Wed, 29 Oct 2025 16:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761754890; cv=none; b=J5H38JRADzypWrnJRU/m7ouv6jhWxtxRVbkjFlBUbf6sm8n82+8pGKS3931goKbyq52gqNhHJ1dPtuNk1e0IPGFV21NO4nmnxqKC7LNt0vTwb0ApBUa5p4jvXk5dwLISH+q3np99qnjOQoNqJwaYVwps75kxkYafUTGdgx9O0R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761754890; c=relaxed/simple;
	bh=/hGO1ZbmzYgehJkTwqb+3EV+zea9ICizU5V8kIZ5Fpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJtxUsV8VIKSr7DCnA7uczFYAwBm1R/Mh2IGZELxKorKX4MUAjBC+4SfUyHO109g2M1uVpsWVPdPxrtFgmRzKGIjv0tDPphlOOY+eucAnDBifMt6433hE71xFOKKLuJQTPMYuUfCRVOJ3VBFum5sSisnBsEXXIn3K99Z819zLnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cAtqZKxA; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cAtqZKxA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761754889; x=1793290889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/hGO1ZbmzYgehJkTwqb+3EV+zea9ICizU5V8kIZ5Fpc=;
  b=cAtqZKxAx1Uvni+TLFPpmAfXFSq32bbAvYk9Otqouy8L4fsNlRtAda5G
   rQ1fTXMAvhUBomUyrrWScLn1KD1RRYsMhTtRf1ljxgXIwhcKLEW9Vvtpm
   Ipz4T0VmQKmemMMjbPcsUVDpOY8xYGd1x1t5kQPmZwqFSJTGxVvehO7nz
   wDcdlqZvTnrEAoihZFfWAh5kJqGLEbsGytFcOS0bGWpRh3hJLnz3QR+FQ
   czz045TvD6Ca/CLQSaLSLDndru6qxxkfRdsac+p6o2c0PlgOMykkLw/DD
   TpwLlM3Ci7E8wE72oxBUlKgZ9/4rux1XJLxucBVDfGttSplCQgVcoVxPB
   w==;
X-CSE-ConnectionGUID: uiMHMNzARdSBB0m2dkOfng==
X-CSE-MsgGUID: fv4pAOrnRQG8QRTSZReE+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="74481314"
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="74481314"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:26 -0700
X-CSE-ConnectionGUID: bD7OVxDCRM6IIsKt/WwVFQ==
X-CSE-MsgGUID: I7iEMrTwS62UkQ51tDEiTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="184901308"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.223.146])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 09:21:26 -0700
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
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v13 04/32] x86/resctrl: Clean up domain_remove_cpu_ctrl()
Date: Wed, 29 Oct 2025 09:20:47 -0700
Message-ID: <20251029162118.40604-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029162118.40604-1-tony.luck@intel.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For symmetry with domain_remove_cpu_mon() refactor domain_remove_cpu_ctrl()
to take an early return when removing a CPU does not empty the domain.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index c7bfaa391e9f..b28663757dcf 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -599,28 +599,27 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
 		return;
 	}
 
+	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
+	if (!cpumask_empty(&hdr->cpu_mask))
+		return;
+
 	if (!domain_header_is_valid(hdr, RESCTRL_CTRL_DOMAIN, r->rid))
 		return;
 
 	d = container_of(hdr, struct rdt_ctrl_domain, hdr);
 	hw_dom = resctrl_to_arch_ctrl_dom(d);
 
-	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
-	if (cpumask_empty(&d->hdr.cpu_mask)) {
-		resctrl_offline_ctrl_domain(r, d);
-		list_del_rcu(&d->hdr.list);
-		synchronize_rcu();
-
-		/*
-		 * rdt_ctrl_domain "d" is going to be freed below, so clear
-		 * its pointer from pseudo_lock_region struct.
-		 */
-		if (d->plr)
-			d->plr->d = NULL;
-		ctrl_domain_free(hw_dom);
+	resctrl_offline_ctrl_domain(r, d);
+	list_del_rcu(&hdr->list);
+	synchronize_rcu();
 
-		return;
-	}
+	/*
+	 * rdt_ctrl_domain "d" is going to be freed below, so clear
+	 * its pointer from pseudo_lock_region struct.
+	 */
+	if (d->plr)
+		d->plr->d = NULL;
+	ctrl_domain_free(hw_dom);
 }
 
 static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
-- 
2.51.0

