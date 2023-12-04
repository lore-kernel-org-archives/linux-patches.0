Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F112FC26
	for <patches@lists.linux.dev>; Mon,  4 Dec 2023 18:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rn/OuE0t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701716052; x=1733252052;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TkM1/qfG9rVOu2jJBDBlxItgf0eq8sR4sTuDIQX/ctA=;
  b=Rn/OuE0tznkJ7WC1J6daOozcqAPBn1vD7EUu/Tm3u77jW+ivzgcmFgaa
   NW9ShojWmUfC/zG7tlewJRrcl2TTdT8yvzTO42RO1KPhL2g1w0QYgMHD2
   hkZRS9aiTKPmm2ZCjHS27j2jxDsBK7Dy4jRoTmuqaYxoVVlRJ7228XPEO
   d4cqCpKs2GV3r62hSCFmvMsEY4MJRTmgVrvj+O6X/wGteb/RyoHCQob+n
   Jd0YSSD44KKLF/YznQHJuIXYQJWguE8s8FjXemgMndakSZW7S/f45uEgk
   n+EMFBGNuavFySBmwIsahOponA5xh+vr1U4voNimoDtE6pEHO6X73UQRT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="838502"
X-IronPort-AV: E=Sophos;i="6.04,250,1695711600"; 
   d="scan'208";a="838502"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 10:54:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="836687201"
X-IronPort-AV: E=Sophos;i="6.04,250,1695711600"; 
   d="scan'208";a="836687201"
Received: from agluck-desk3.sc.intel.com ([172.25.222.74])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 10:54:07 -0800
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
	Tony Luck <tony.luck@intel.com>,
	Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Subject: [PATCH v13 5/8] x86/resctrl: Add node-scope to the options for feature scope
Date: Mon,  4 Dec 2023 10:53:54 -0800
Message-ID: <20231204185357.120501-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231204185357.120501-1-tony.luck@intel.com>
References: <20231130003418.89964-1-tony.luck@intel.com>
 <20231204185357.120501-1-tony.luck@intel.com>
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

Signed-off-by: Tony Luck <tony.luck@intel.com>
Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Reviewed-by: Peter Newman <peternewman@google.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
---
 include/linux/resctrl.h            | 1 +
 arch/x86/kernel/cpu/resctrl/core.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 058a940c3239..b8a3a11b970d 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -170,6 +170,7 @@ struct resctrl_schema;
 enum resctrl_scope {
 	RESCTRL_L2_CACHE = 2,
 	RESCTRL_L3_CACHE = 3,
+	RESCTRL_NODE,
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 797cb3bf417a..c9315ce8f7bd 100644
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

