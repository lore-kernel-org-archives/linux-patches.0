Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DEF4C94
	for <patches@lists.linux.dev>; Thu, 26 Jan 2023 18:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674758555; x=1706294555;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ivyLAdBKqYQLl3lR+fj5FZ2eFkx8GG4TgMFpd25I12Y=;
  b=F3rM1pQkV0DgwVlJNCeIsIAYOD9baLIhrCjk3cjhyLvaA1TA1JZWn4Pf
   DMRZQPZXZw3OCs4Jfv9B+LNRnHLOcc8ov+LlGLKTbfa/JTq+Qw85l21Lu
   1aEXseRPqQ9U/4SHtgg9KllBfY7FQT/d1/6dGROufV4ZpZOnvz24hn+UL
   3EY0cuzt4twwo4ZORnOJe5vNJjQIMWr0lRzAgVWIiqxVd0VsB+hjWNqB5
   VjPdw0XeUC5ouSnnyI+pf8MGftJgskLCJqq5kE9lTjdIW4FvEDxFK9Ds4
   hTR3UWLOBcZ+94xmsdxYGWfZJEwZeZZajy8mOMCMidR6z/OK9UNRW68+z
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="354203372"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="354203372"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 10:42:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10602"; a="991745455"
X-IronPort-AV: E=Sophos;i="5.97,249,1669104000"; 
   d="scan'208";a="991745455"
Received: from agluck-desk3.sc.intel.com ([172.25.222.78])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2023 10:42:06 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Peter Newman <peternewman@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	x86@kernel.org
Cc: Shaopeng Tan <tan.shaopeng@fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH 6/7] x86/resctrl: Update documentation with Sub-NUMA cluster changes
Date: Thu, 26 Jan 2023 10:41:56 -0800
Message-Id: <20230126184157.27626-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126184157.27626-1-tony.luck@intel.com>
References: <20230126184157.27626-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With Sub-NUMA Cluster mode enabled the scope of monitoring resources is
per-NODE instead of per-L3 cache. Suffices of directories with "L3" in
their name refer to Sun-NUMA nodes instead of L3 cache ids.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/x86/resctrl.rst | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/resctrl.rst b/Documentation/x86/resctrl.rst
index 71a531061e4e..9043a2d2f2d3 100644
--- a/Documentation/x86/resctrl.rst
+++ b/Documentation/x86/resctrl.rst
@@ -167,6 +167,11 @@ with the following files:
 		bytes) at which a previously used LLC_occupancy
 		counter can be considered for re-use.
 
+"snc_ways":
+                A value of "1" marks that SNC mode is disabled.
+                Values of "2" or "4" indicate how many NUMA
+                nodes share an L3 cache.
+
 Finally, in the top level of the "info" directory there is a file
 named "last_cmd_status". This is reset with every "command" issued
 via the file system (making new directories or writing to any of the
@@ -254,9 +259,13 @@ When control is enabled all CTRL_MON groups will also contain:
 When monitoring is enabled all MON groups will also contain:
 
 "mon_data":
-	This contains a set of files organized by L3 domain and by
-	RDT event. E.g. on a system with two L3 domains there will
-	be subdirectories "mon_L3_00" and "mon_L3_01".	Each of these
+	This contains a set of files organized by L3 domain or by NUMA
+	node (depending on whether SNC mode is disabled or enabled
+	respectively) and by RDT event. E.g. on a system with SNC
+	mode disabled with two L3 domains there will be subdirectories
+	"mon_L3_00" and "mon_L3_01" the numerical suffix refers to the
+        L3 cache id.  With SNC enabled the directory names are the same,
+        but the numerical suffix refers to the node id.  Each of these
 	directories have one file per event (e.g. "llc_occupancy",
 	"mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
 	files provide a read out of the current value of the event for
-- 
2.39.1

