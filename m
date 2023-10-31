Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5279C249EE
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 21:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mLfaPMkv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698787043; x=1730323043;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1NTG/xepP6sAVh64jc/TfBIlrbQchIPazZnyN72Ffzs=;
  b=mLfaPMkvRU2yQIX4cxFBQP/NOcOl3w+dbPd8Y+gclfQ0VmIBKuMjejn8
   GEvl8R/nOkrYxED4sA76lqp+1vTUYfolS5/VsKgypsEohwA/3VYmRCKeL
   IIl1QuMhBNH0X27WPaEkRr1+cY5/fodNRJpjso3AYpwpBtq0S0NwmnOUe
   /UVsAgfYqbPRkh0q+wX9EXHDxWEhkw2lzOSRNtC2ZnKRGKDih2uBzIf/O
   5OIXAxD698/cbHgNy9f3H7ALs9St8rB6VjfvdssYGM/An/p21v+IX18mq
   SQeCMOXOQda+FR10XqJbjSZQPVKVOyYtZvYFVexBELxRhblJtXYcvWRB0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="388197111"
X-IronPort-AV: E=Sophos;i="6.03,266,1694761200"; 
   d="scan'208";a="388197111"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 14:17:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="884335004"
X-IronPort-AV: E=Sophos;i="6.03,266,1694761200"; 
   d="scan'208";a="884335004"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 14:17:19 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v10 5/8] x86/resctrl: Add node-scope to the options for feature scope
Date: Tue, 31 Oct 2023 14:17:05 -0700
Message-ID: <20231031211708.37390-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231031211708.37390-1-tony.luck@intel.com>
References: <20231020213100.123598-1-tony.luck@intel.com>
 <20231031211708.37390-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently supported resctrl features are all domain scoped the same as the
scope of the L2 or L3 caches.

Add RESCTRL_NODE as a new option for features that are scoped at the
same granularity as NUMA nodes. This is needed for Intel's Sub-NUMA
Cluster (SNC) feature where monitoring features are node scoped.

Reviewed-by: Peter Newman <peternewman@google.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
No changes since v9

 include/linux/resctrl.h            | 1 +
 arch/x86/kernel/cpu/resctrl/core.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 36503e8870cd..f42a5e59027b 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -172,6 +172,7 @@ struct resctrl_schema;
 enum resctrl_scope {
 	RESCTRL_L2_CACHE = 2,
 	RESCTRL_L3_CACHE = 3,
+	RESCTRL_NODE,
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 6bae0a658b94..d2c1aa8411a3 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -502,6 +502,8 @@ static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
 	case RESCTRL_L2_CACHE:
 	case RESCTRL_L3_CACHE:
 		return get_cpu_cacheinfo_id(cpu, scope);
+	case RESCTRL_NODE:
+		return cpu_to_node(cpu);
 	default:
 		break;
 	}
-- 
2.41.0

