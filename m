Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF4D1F4735
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 23:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741044891; cv=none; b=Fr08SVp+tdAy/nHQ9unkAKfbBE4dkUACk5PR5b6x1vNZ4PTbYApcMdBAW8f61qQSWhR/ix+fuRQFzE5sy7XRWIQ7vYp+jzjV/r3Gwe5WoX2OKL7GfWee0pZWmj3OwSFoK2UtlyjGe1GXy/YUvtCUlYsIy59txbPLURNNknp1ZuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741044891; c=relaxed/simple;
	bh=JfoVoPIdOcRTWbvU2KmotoxxGNbMBxHZgXS9IFYAuVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ni1BnXRNcq5T8QZWqh+pdkkikZaI4GPYBPSDz8FzXbCQ5ahwwnM/XG00ryl6oamuCYE4Qmp6DzSHsrWyZ/oQwu+hrrYwdi3b+Rwo5tScQ3y1vys+0b8X+PcpW4TlXBqv+IvEum+Sowop9GUTgmFSAveHeAuKup7mIE+VX79vDdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BKX8TKt7; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BKX8TKt7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741044889; x=1772580889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JfoVoPIdOcRTWbvU2KmotoxxGNbMBxHZgXS9IFYAuVA=;
  b=BKX8TKt71jF77Yu48+dhmn6rNNzbN/G2ET05m5I5DgtqjyFXx4q6WDGd
   GKmOuNc2+QXnmJHPn/45GtY0/QdH5MCJjM5uHGLXq8vqSgQ0GIuwNjlIA
   VrMWrwZ8iq5moTQQ/GBQZ0KsJzJP+4G0wGdiM1Enhsup/x/YuQPUXBNC5
   yTYyMn4idj7/68T0dK6iqnjsqDyIUbBIDU8fszO1L6bOX+cAvcHAqq5tf
   HBh52PyMqjHgUpIM2GqkK3sdIIM2NyjbyfS0Mynwxk7wsH7f/+vmETy8X
   hScIuiEsAICqlFbQG2JF5NXf6KzYh8x/dqzhiDTMN3L0eGlzXMQm6R2r2
   Q==;
X-CSE-ConnectionGUID: FU+crs1iRhG14Czjc/s1Eg==
X-CSE-MsgGUID: MCZzBHUST7SICA1s7qD/pw==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41835916"
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="41835916"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:34:46 -0800
X-CSE-ConnectionGUID: 61PsCt7vT4Wx5OAgLtS5Xg==
X-CSE-MsgGUID: hHRiyU94ROawEDseHp97yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="117982282"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:33:50 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 03/17] x86/resctrl: Refactor domain_remove_cpu_mon() ready for new domain types
Date: Mon,  3 Mar 2025 15:33:23 -0800
Message-ID: <20250303233340.333743-4-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250303233340.333743-1-tony.luck@intel.com>
References: <20250303233340.333743-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Different types of domains require different actions when the last
CPU in the domain is removed.

Refactor to make it easy to add new actions for new types of domains.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index dd694958df5a..4974cbb842c1 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -726,20 +726,20 @@ static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
 		return;
 	}
 
-	if (WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN))
+	cpumask_clear_cpu(cpu, &hdr->cpu_mask);
+	if (!cpumask_empty(&hdr->cpu_mask))
 		return;
 
-	d = container_of(hdr, struct rdt_mon_domain, hdr);
-	hw_dom = resctrl_to_arch_mon_dom(d);
+	switch (r->rid) {
+	case RDT_RESOURCE_L3:
+		d = container_of(hdr, struct rdt_mon_domain, hdr);
+		hw_dom = resctrl_to_arch_mon_dom(d);
 
-	cpumask_clear_cpu(cpu, &d->hdr.cpu_mask);
-	if (cpumask_empty(&d->hdr.cpu_mask)) {
 		resctrl_offline_mon_domain(r, d);
-		list_del_rcu(&d->hdr.list);
+		list_del_rcu(&hdr->list);
 		synchronize_rcu();
 		mon_domain_free(hw_dom);
-
-		return;
+		break;
 	}
 }
 
-- 
2.48.1

