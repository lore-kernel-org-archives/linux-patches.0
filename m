Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19437111BB
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 23:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693352685; x=1724888685;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S/EXhJCpyz3uBL/oEdqmrNfXk9bhwq1mYy59t3f/24c=;
  b=k61pWCz//Ioq4fRIpwxiYxob8ykJak7oa2Va7l6Kmn1J2tuO+dix9omc
   AgslA4v/5+NRhjtg8MwT4Ywypd1tpG49lMrCezS2zC/RTgC12QmusNOHP
   a2Yzt0qK91UniJck1J7hwetJnG1cuQv1qoysfjYrL0vP3UuNfZXMqaWP1
   1FWXZq67E4ddkhh6w2G0g6nE3ZkRn47vMnVPP6illH4MSqcURSTAXVPeQ
   hoPH5RRtkQmAoOyq46cEeV399DiMdcS9nWqtYisFxGsbVPCIxyJbOpPN7
   Ufwngfq5M4wYf8mQOmxvMOMa8ibyI7cVA9r2aPMShruQNiy+PQdA4+DDx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="355015449"
X-IronPort-AV: E=Sophos;i="6.02,211,1688454000"; 
   d="scan'208";a="355015449"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2023 16:44:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10817"; a="688691030"
X-IronPort-AV: E=Sophos;i="6.02,211,1688454000"; 
   d="scan'208";a="688691030"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2023 16:44:39 -0700
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
Subject: [PATCH v5 4/8] x86/resctrl: Add node-scope to the options for feature scope
Date: Tue, 29 Aug 2023 16:44:22 -0700
Message-ID: <20230829234426.64421-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230829234426.64421-1-tony.luck@intel.com>
References: <20230722190740.326190-1-tony.luck@intel.com>
 <20230829234426.64421-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently supported resctrl features are all domain scoped the same as the
scope of the L2 or L3 caches.

Add "node" as a new option for domain scope.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 include/linux/resctrl.h            | 1 +
 arch/x86/kernel/cpu/resctrl/core.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 08382548571e..f55cf7afd4eb 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -163,6 +163,7 @@ struct resctrl_schema;
 enum resctrl_scope {
 	RESCTRL_L3_CACHE,
 	RESCTRL_L2_CACHE,
+	RESCTRL_NODE,
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 3e08aa04a7ff..9fcc264fac6c 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -514,6 +514,8 @@ static int get_domain_id_from_scope(int cpu, enum resctrl_scope scope)
 		return get_cpu_cacheinfo_id(cpu, 3);
 	case RESCTRL_L2_CACHE:
 		return get_cpu_cacheinfo_id(cpu, 2);
+	case RESCTRL_NODE:
+		return cpu_to_node(cpu);
 	default:
 		WARN_ON_ONCE(1);
 		break;
-- 
2.41.0

