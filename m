Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A26213E8B0
	for <patches@lists.linux.dev>; Tue, 28 May 2024 22:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716934822; cv=none; b=eSuv0WxiAgwBohFXO56KiiWRa4O1sX4+6wBVhHvM1jzyE3TSMVIkMIM7Ax+tNsj5lMo1jrsJwoBwqJf8QTU92MJcMoDoBUyD4o9JTnUkdIz4T0SHUIC+PCynxOjftyVGUHWfPI2DAPdMxREzf/Kli9Lw+UAJ4PHYglgqwMK+iuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716934822; c=relaxed/simple;
	bh=pOQZF8HFVACiDlR+DiYZ0BzMt0qWyIWt5Aigq+NSKkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UOxK8MbwBKtsILN4S+oFZLp8z2aOdS//FKxvY4JC7gEsoisPkCNXxzAk8hv5fZSAhJUxxCGHvBIgKIcauI1D4+/Cb89IIUecZvbTtXy5w/SO9yxP3o17m0r501C80dPw9pdMPbNI8rRfHpJeV5PiT9baSqPR7qs2A8qy9MJ/4BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UbgAYx7E; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UbgAYx7E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716934822; x=1748470822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pOQZF8HFVACiDlR+DiYZ0BzMt0qWyIWt5Aigq+NSKkw=;
  b=UbgAYx7E+V/jJioKhMB0bvLKCindYAF8SA0QQ1GTntVStmN4Pcr0xGDS
   EEMtK491IeQ6wadJpFFdd3ZX33jmaxhHHHtjfhHIQZTm0mfZ2GREUgMlD
   V4gOtIc8PrmL2/e6z+pR5aQvrSSrVSbUfE46lnf+KHaglXktnb0a0IxnY
   Lnx1ay8vpFqGiDkvG3aYEM7GMT1bUVCfNs1VebQeX0+lcSrO8KTcubKtf
   ETXxRnYgXB1TwqoELXm0o/E7Xbghvyel6yRy4wYymGEH9yQjydk/mCcGX
   9+DWC4hgnFpaFY/6C3I3C9N8Nr566p9ndbp9daHkzK2lYvUpv7/I6Q19U
   w==;
X-CSE-ConnectionGUID: AlAv+ULaQgi21/LdEs+vwg==
X-CSE-MsgGUID: Z5RkGcOgSn+5FEP/M2U0Iw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30812198"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="30812198"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:17 -0700
X-CSE-ConnectionGUID: FZvuxAP9StWnXt+DJU6LHg==
X-CSE-MsgGUID: Fg6efc1BTnyPVBiKm1F4Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="40090737"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 15:20:17 -0700
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
Subject: [PATCH v19 09/20] x86/resctrl: Add new fields to struct rmid_read for summation of domains
Date: Tue, 28 May 2024 15:19:54 -0700
Message-ID: <20240528222006.58283-10-tony.luck@intel.com>
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

rdtgroup_mondata_show() calls mon_event_read() which calls
mon_event_count() which packages up all the required details into an
rmid_read structure passed across the smp_call*() infrastructure.

Legacy files reporting for a single domain pass that domain in the
rmid_read structure. Files that need to sum multiple domains have
meta data that provides the L3 cache ID for domains that must be
summed.

Add the sumdomains and cacheinfo fields to the rmid_read structure.

Add kerneldoc comments for the rmid_read structure.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index eb70d3136ced..d8156d22cbdc 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -145,12 +145,28 @@ union mon_data_bits {
 	} u;
 };
 
+/**
+ * struct rmid_read - Data passed across smp_call*() to read event count
+ * @rgrp:	Resctrl group (provides RMID value)
+ * @r:		Resource
+ * @d:		Domain
+ * @evtid:	Which monitor event to read
+ * @first:	When true this just requests initialization of an MBM counter
+ * @sumdomains:	When false just return monitor count from domain @d. When true,
+ *		sum all domains in @r sharing L3 @ci.id
+ * @ci:		See @sumdomains
+ * @err:	Used to return error indication
+ * @val:	Used to return value of event counter
+ * @arch_mon_ctx: hardware monitor allocated for this read request (MPAM only)
+ */
 struct rmid_read {
 	struct rdtgroup		*rgrp;
 	struct rdt_resource	*r;
 	struct rdt_mon_domain	*d;
 	enum resctrl_event_id	evtid;
 	bool			first;
+	bool			sumdomains;
+	struct cacheinfo	*ci;
 	int			err;
 	u64			val;
 	void			*arch_mon_ctx;
-- 
2.45.0

