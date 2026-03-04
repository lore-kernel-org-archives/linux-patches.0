Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2352F3C22
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 00:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772583591; cv=none; b=l9nfrDgCi9kRmXC829kjU9hADlPG27v6vgPQbHFFV1rLq4jtjlahBtzzRuccLXOO4zy6xWYlnldEYjVYdtIypPMQvH+5o9rymFwCfzhgq/NOIWB7HVsXmr6ckcS82AtqG5YKWthEtzDe7KxNlSIvRYGXNyPY36jUpoF15h1B4xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772583591; c=relaxed/simple;
	bh=uBBHGG+Pb79Ww3RCSOJRUJ3SLe13CGVilpi6FeCHHrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwQtliluDRyKXgAVK3YMZ5yTnNayYioNJVDi2wDpA2TG8SIhNm2HMtB7u0SEcBkriRdEc0t84wAZY5LVF2/5ctXTrkdGQEIB1dIo703D38RFIPvjcwbdrbVW36Wr6haoub0U0Spudy+uWLBcWbcYl+MubdZboJYYBvCKPcS/T8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UXoMTAsl; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UXoMTAsl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772583590; x=1804119590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uBBHGG+Pb79Ww3RCSOJRUJ3SLe13CGVilpi6FeCHHrg=;
  b=UXoMTAslpLy/HbyQ/cTnwN20VwoNY6GqvsHX7P6EAgZalIeN1GIYd3on
   9tAaPkE4jSpbKRfVfgnPZaMXQnBrlYTFriX2Is50KuXJE+yESTX2gK5FU
   wBPQLgtOg8V+dHDVbg2d60z5FiZFc0XiFSxldnuyUzVo58WPoNfVsyhJ4
   R9li+zxqhsaTt94Hqru0g5BE0gT5unBWkHjpTVLvXtjtqNFj37UWdgFuI
   pJDJ6jhBE4VACZmuj7MymnQweDSryxYymqOwZ3+RqytnmcuXjCTzVZ+ZA
   wJGY1aUk4TvEtHNEOeoHvaDeOLFP9VyAj8zzDWfMx/50IvvM8I6JlcKLO
   A==;
X-CSE-ConnectionGUID: ZUxZ9IvWQoKX8tkxXjjecw==
X-CSE-MsgGUID: 4BXDYe/pTvmIZhdhG6PrgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="73545032"
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="73545032"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 16:19:45 -0800
X-CSE-ConnectionGUID: JzEu9NjmSzqK5+ttesUJJw==
X-CSE-MsgGUID: secPCcrnQgKSXJbGaKZ05Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="218120400"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 16:19:45 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: shuah@kernel.org,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	tony.luck@intel.com,
	babu.moger@amd.com,
	ilpo.jarvinen@linux.intel.com
Cc: fenghuay@nvidia.com,
	peternewman@google.com,
	zide.chen@intel.com,
	dapeng1.mi@linux.intel.com,
	ben.horgan@arm.com,
	yu.c.chen@intel.com,
	reinette.chatre@intel.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 6/9] selftests/resctrl: Raise threshold at which MBM and PMU values are compared
Date: Tue,  3 Mar 2026 16:19:35 -0800
Message-ID: <a54d4c502d3367ec9fe0c2d11bf7c0e2ac0235f8.1772582958.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1772582958.git.reinette.chatre@intel.com>
References: <cover.1772582958.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 501cfdba0a40 ("selftests/resctrl: Do not compare performance
counters and resctrl at low bandwidth") introduced a threshold under which
memory bandwidth values from MBM and performance counters are not compared.
This is needed because MBM and the PMUs do not have an identical view of
memory bandwidth since PMUs can count all memory traffic while MBM does not
count "overhead" (for example RAS) traffic that cannot be attributed to an
RMID. As a ratio this difference in view of memory bandwidth is pronounced
at low memory bandwidths.

The 750MiB threshold was chosen arbitrarily after comparisons on different
platforms. Exposed to more platforms after introduction this threshold has
proven to be inadequate.

Having accurate comparison between performance counters and MBM requires
careful management of system load as well as control of features that
introduce extra memory traffic, for example, patrol scrub. This is not
appropriate for the resctrl selftests that are intended to run on a
variety of systems with various configurations.

Increase the memory bandwidth threshold under which no comparison is made
between performance counters and MBM. Add additional leniency by increasing
the percentage of difference that will be tolerated between these counts.

There is no impact to the validity of the resctrl selftests results as a
measure of resctrl subsystem health.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 tools/testing/selftests/resctrl/mba_test.c | 2 +-
 tools/testing/selftests/resctrl/mbm_test.c | 2 +-
 tools/testing/selftests/resctrl/resctrl.h  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/resctrl/mba_test.c b/tools/testing/selftests/resctrl/mba_test.c
index cd4c715b7ffd..39cee9898359 100644
--- a/tools/testing/selftests/resctrl/mba_test.c
+++ b/tools/testing/selftests/resctrl/mba_test.c
@@ -12,7 +12,7 @@
 
 #define RESULT_FILE_NAME	"result_mba"
 #define NUM_OF_RUNS		5
-#define MAX_DIFF_PERCENT	8
+#define MAX_DIFF_PERCENT	15
 #define ALLOCATION_MAX		100
 #define ALLOCATION_MIN		10
 #define ALLOCATION_STEP		10
diff --git a/tools/testing/selftests/resctrl/mbm_test.c b/tools/testing/selftests/resctrl/mbm_test.c
index 58201f844740..6dbbc3b76003 100644
--- a/tools/testing/selftests/resctrl/mbm_test.c
+++ b/tools/testing/selftests/resctrl/mbm_test.c
@@ -11,7 +11,7 @@
 #include "resctrl.h"
 
 #define RESULT_FILE_NAME	"result_mbm"
-#define MAX_DIFF_PERCENT	8
+#define MAX_DIFF_PERCENT	15
 #define NUM_OF_RUNS		5
 
 static int
diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/selftests/resctrl/resctrl.h
index c72045c74ac4..861bf25f2f28 100644
--- a/tools/testing/selftests/resctrl/resctrl.h
+++ b/tools/testing/selftests/resctrl/resctrl.h
@@ -55,7 +55,7 @@
  * and MBM respectively, for instance generating "overhead" traffic which
  * is not counted against any specific RMID.
  */
-#define THROTTLE_THRESHOLD	750
+#define THROTTLE_THRESHOLD	2500
 
 /*
  * fill_buf_param:	"fill_buf" benchmark parameters
-- 
2.50.1

