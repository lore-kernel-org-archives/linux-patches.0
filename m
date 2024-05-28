Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C815814290E
	for <patches@lists.linux.dev>; Tue, 28 May 2024 22:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716934828; cv=none; b=HEymU2RoujyQPGSLqxdJz2gtbcgl8GRcbYDWT7UF0MDos1CEPMwnbCoO2zoxZC7aF/CoxU4RBCZ4pues5QszSpAySBXoOoy1ahgflYdGHBH3hlKWxkzwo0qbGCynDCK9vL69ZSP1dbY7yugSmR1xHhdLZCHfe8DVhJw5qD/2i/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716934828; c=relaxed/simple;
	bh=ae2net2an2bG2zA//O2uZIIe0Gsj90vooANwSwQeDp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MH/v0y5swyVbqu+f4ISF/6+ZY4ruBhlVHmHF3Y3x388K9li7pH5Pdyu1XwpU7+N5sZkfuDvbT0/7LH9Tv5JJIU9KbAim2zjkpaZXA4xjIjOvw+77AWKWUl5QS06Zf7x3WbSCAyOpmkeiMLDkbpUHBpF1l2jvoSXH4s9cP/PgP0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N0w7KIyI; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N0w7KIyI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716934827; x=1748470827;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ae2net2an2bG2zA//O2uZIIe0Gsj90vooANwSwQeDp0=;
  b=N0w7KIyIfdb/GIQrxjdA2XnTsuDS7Ku8q7aeGRYoccXlcbUg6T/GLivi
   ryfGP4Z+zMyOpAKihGEz+UXWqdvZ/i0zruiJl8EUjSW+mbuynUl6om9Im
   z+vB6qwWiaN4yOfTDt9KZqNLjl+bX/JubOJSk2iuq8cRlCSgmamyRI6G6
   M4x7dxeib29gTRMqqO3xn3EZ65hCZ/rkBIkX8XMaUkEiK8Cx9el+5ArKG
   FOPuCFXWSA0NjlpVQukWRS+n4wEXiUDUqk/ebvkuI1VtwMhqGYUc7qrIr
   t4cf9lduD5lP1LU2JqhtqtrQMsabKVgWL+oer1/pb0ueLnIzWFrSbJVik
   Q==;
X-CSE-ConnectionGUID: l811+k34TPGdLRjxe/Hmtw==
X-CSE-MsgGUID: QbrL3h/5THGSo8Sta/1b5A==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30812255"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="30812255"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:20 -0700
X-CSE-ConnectionGUID: QD3PTiOTSc2KlcgwAcUijA==
X-CSE-MsgGUID: 7T08vKT8SCKRDTa9rx+H2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="40090773"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v19 17/20] x86/resctrl: Update CPU sanity checks when reading RMID counters
Date: Tue, 28 May 2024 15:20:02 -0700
Message-ID: <20240528222006.58283-18-tony.luck@intel.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240528222006.58283-1-tony.luck@intel.com>
References: <20240528222006.58283-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When reading from a single domain the existing check that current CPU is
in the domain is accurate.

But when summing across multiple domains that share an L3 cache instance
it is sufficient to run on any CPU in the shared_map for that cache.

Split the check into the two separate cases.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index c9dd6ec68fcd..e7a8e96821e5 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -308,9 +308,6 @@ static int resctrl_arch_rmid_read_one(struct rdt_resource *r, struct rdt_mon_dom
 
 	resctrl_arch_rmid_read_context_check();
 
-	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
-		return -EINVAL;
-
 	ret = __rmid_read(cpu, rmid, eventid, &msr_val);
 	if (ret)
 		return ret;
@@ -338,8 +335,15 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
 	int ret;
 
 	*val = 0;
-	if (!sum)
+	if (!sum) {
+		if (!cpumask_test_cpu(cpu, &d->hdr.cpu_mask))
+			return -EINVAL;
+
 		return resctrl_arch_rmid_read_one(r, d, cpu, rmid, eventid, val);
+	}
+
+	if (!cpumask_test_cpu(cpu, &ci->shared_cpu_map))
+		return -EINVAL;
 
 	list_for_each_entry(d, &r->mon_domains, hdr.list) {
 		if (d->ci->id != ci->id)
-- 
2.45.0

