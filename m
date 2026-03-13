Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2C1375ADA
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 20:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773433976; cv=none; b=btA/Sm08kHXtzr7A+2FEftPe/PtLHrWopawg7WagvClvxGGn6Lk8DJZJSvNMCfYd1eWp+CDkol2EFwhceRZ2h0MtsmYXjoRQ2GpOjkFuGh45ntwsCXaXeKy6N0/OwmeE/WRvz4RbagkUeuyVyO2aOkDzv1ON1+j3rnla4ejfk2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773433976; c=relaxed/simple;
	bh=K0sRnBTzLAKEaUFmotmN9mOQL4fHuh6XPiToj5j1qV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMw9vYk/jrXqmMc2O2mZPaA6hSdujoMwUpWc8TrHxs9MhjmFNvMnkjScpVdU6toDJxR2HgC+jOOCAo7GFW3TVRiSeYMULfiBuQZ2/M9THB+AqQ20M3I+I1mjPEzZ5jUZ1LRkP9jfLiH6nikDTi7+yL8Ejqs0JElzpCG8iKJqXrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=At0b/Ewy; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="At0b/Ewy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773433973; x=1804969973;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K0sRnBTzLAKEaUFmotmN9mOQL4fHuh6XPiToj5j1qV0=;
  b=At0b/EwyMVsYHu9wpsOODUSKwD2MB++XvTGQudt57rgV56SkNzC987E7
   xLLWZPcx/aE72N/o7jryvqc61r5rFWkJpiYf7RH3nniQHjuXUY4qBm28d
   XKacX5odZ1UbrcOwF5NGbg6yjKXTFXRI83clI0u3yTDHd5cDKh8L/1WV8
   uwewRAxPjYa5oLOqlzZkj+8SdHsgLt1E2w91K72XgwUTpAPfxquB49l+9
   1Kucso37qnF0z3wDqd1S/1SLjXrOVgE/OxuSrR+PbqOegI4I4Q8Rf1Q4r
   YbMniAuuxCPaehkYG0s7SUojKL8FoIFUG4/Az1Fb/dmnzC1KwpAmywS7p
   w==;
X-CSE-ConnectionGUID: ZmSOGqUhScevUo6Omk5/1w==
X-CSE-MsgGUID: ns7CaUSwQ3y4HkCY4qnnYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11728"; a="74519245"
X-IronPort-AV: E=Sophos;i="6.23,118,1770624000"; 
   d="scan'208";a="74519245"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 13:32:51 -0700
X-CSE-ConnectionGUID: fhwvXaVXTmGnGmIoOMHcJw==
X-CSE-MsgGUID: 4EluSVhMR2OJdgfcmCC20g==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 13:32:51 -0700
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
	jason.zeng@intel.com,
	reinette.chatre@intel.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v3 01/10] selftests/resctrl: Improve accuracy of cache occupancy test
Date: Fri, 13 Mar 2026 13:32:28 -0700
Message-ID: <b632cf0bad98f501079748346cb2e1dae120237d.1773432891.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1773432891.git.reinette.chatre@intel.com>
References: <cover.1773432891.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Dave Martin reported inconsistent CMT test failures. In one experiment
the first run of the CMT test failed because of too large (24%) difference
between measured and achievable cache occupancy while the second run passed
with an acceptable 4% difference.

The CMT test is susceptible to interference from the rest of the system.
This can be demonstrated with a utility like stress-ng by running the CMT
test while introducing cache misses using:

   stress-ng --matrix-3d 0 --matrix-3d-zyx

Below shows an example of the CMT test failing because of a significant
difference between measured and achievable cache occupancy when run with
interference:
    # Starting CMT test ...
    # Mounting resctrl to "/sys/fs/resctrl"
    # Cache size :335544320
    # Writing benchmark parameters to resctrl FS
    # Benchmark PID: 7011
    # Checking for pass/fail
    # Fail: Check cache miss rate within 15%
    # Percent diff=99
    # Number of bits: 5
    # Average LLC val: 235929
    # Cache span (bytes): 83886080
    not ok 1 CMT: test

The CMT test creates a new control group that is also capable of monitoring
and assigns the workload to it. The workload allocates a buffer that by
default fills a portion of the L3 and keeps reading from the buffer,
measuring the L3 occupancy at intervals. The test passes if the workload's
L3 occupancy is within 15% of the buffer size.

By not adjusting any capacity bitmasks the workload shares the cache with
the rest of the system. Any other task that may be running could evict
the workload's data from the cache causing it to have low cache occupancy.

Reduce interference from the rest of the system by ensuring that the
workload's control group uses the capacity bitmask found in the user
parameters for L3 and that the rest of the system can only allocate into
the inverse of the workload's L3 cache portion. Other tasks can thus no
longer evict the workload's data from L3.

With the above adjustments the CMT test is more consistent. Repeating the
CMT test while generating interference with stress-ng on a sample
system after applying the fixes show significant improvement in test
accuracy:

    # Starting CMT test ...
    # Mounting resctrl to "/sys/fs/resctrl"
    # Cache size :335544320
    # Writing benchmark parameters to resctrl FS
    # Write schema "L3:0=fffe0" to resctrl FS
    # Write schema "L3:0=1f" to resctrl FS
    # Benchmark PID: 7089
    # Checking for pass/fail
    # Pass: Check cache miss rate within 15%
    # Percent diff=12
    # Number of bits: 5
    # Average LLC val: 73269248
    # Cache span (bytes): 83886080
    ok 1 CMT: test

Reported-by: Dave Martin <Dave.Martin@arm.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Chen Yu <yu.c.chen@intel.com>
Link: https://lore.kernel.org/lkml/aO+7MeSMV29VdbQs@e133380.arm.com/
---
Changes since v1:
- Fix typo in changelog: "data my be in L2" -> "data may be in L2".

Changes since v2:
- Split patch to separate changes impacting L3 and L2 resource. (Ilpo)
- Re-run tests after patch split to ensure test impact match patch
  and update changelog with refreshed data.
- Since fix is now split across two patches: "Closes:" -> "Link:"
- Rename "long_mask" to "full_mask". (Ilpo)
- Add Chen Yu's tag.
---
 tools/testing/selftests/resctrl/cmt_test.c    | 26 +++++++++++++++++--
 tools/testing/selftests/resctrl/mba_test.c    |  4 ++-
 tools/testing/selftests/resctrl/mbm_test.c    |  4 ++-
 tools/testing/selftests/resctrl/resctrl.h     |  4 ++-
 tools/testing/selftests/resctrl/resctrl_val.c |  2 +-
 5 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/resctrl/cmt_test.c b/tools/testing/selftests/resctrl/cmt_test.c
index d09e693dc739..7bc6cf49c1c5 100644
--- a/tools/testing/selftests/resctrl/cmt_test.c
+++ b/tools/testing/selftests/resctrl/cmt_test.c
@@ -19,12 +19,34 @@
 #define CON_MON_LCC_OCCUP_PATH		\
 	"%s/%s/mon_data/mon_L3_%02d/llc_occupancy"
 
-static int cmt_init(const struct resctrl_val_param *param, int domain_id)
+/*
+ * Initialize capacity bitmasks (CBMs) of:
+ * - control group being tested per test parameters,
+ * - default resource group as inverse of control group being tested to prevent
+ *   other tasks from interfering with test.
+ */
+static int cmt_init(const struct resctrl_test *test,
+		    const struct user_params *uparams,
+		    const struct resctrl_val_param *param, int domain_id)
 {
+	unsigned long full_mask;
+	char schemata[64];
+	int ret;
+
 	sprintf(llc_occup_path, CON_MON_LCC_OCCUP_PATH, RESCTRL_PATH,
 		param->ctrlgrp, domain_id);
 
-	return 0;
+	ret = get_full_cbm(test->resource, &full_mask);
+	if (ret)
+		return ret;
+
+	snprintf(schemata, sizeof(schemata), "%lx", ~param->mask & full_mask);
+	ret = write_schemata("", schemata, uparams->cpu, test->resource);
+	if (ret)
+		return ret;
+
+	snprintf(schemata, sizeof(schemata), "%lx", param->mask);
+	return write_schemata(param->ctrlgrp, schemata, uparams->cpu, test->resource);
 }
 
 static int cmt_setup(const struct resctrl_test *test,
diff --git a/tools/testing/selftests/resctrl/mba_test.c b/tools/testing/selftests/resctrl/mba_test.c
index c7e9adc0368f..cd4c715b7ffd 100644
--- a/tools/testing/selftests/resctrl/mba_test.c
+++ b/tools/testing/selftests/resctrl/mba_test.c
@@ -17,7 +17,9 @@
 #define ALLOCATION_MIN		10
 #define ALLOCATION_STEP		10
 
-static int mba_init(const struct resctrl_val_param *param, int domain_id)
+static int mba_init(const struct resctrl_test *test,
+		    const struct user_params *uparams,
+		    const struct resctrl_val_param *param, int domain_id)
 {
 	int ret;
 
diff --git a/tools/testing/selftests/resctrl/mbm_test.c b/tools/testing/selftests/resctrl/mbm_test.c
index 84d8bc250539..58201f844740 100644
--- a/tools/testing/selftests/resctrl/mbm_test.c
+++ b/tools/testing/selftests/resctrl/mbm_test.c
@@ -83,7 +83,9 @@ static int check_results(size_t span)
 	return ret;
 }
 
-static int mbm_init(const struct resctrl_val_param *param, int domain_id)
+static int mbm_init(const struct resctrl_test *test,
+		    const struct user_params *uparams,
+		    const struct resctrl_val_param *param, int domain_id)
 {
 	int ret;
 
diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/selftests/resctrl/resctrl.h
index afe635b6e48d..c72045c74ac4 100644
--- a/tools/testing/selftests/resctrl/resctrl.h
+++ b/tools/testing/selftests/resctrl/resctrl.h
@@ -135,7 +135,9 @@ struct resctrl_val_param {
 	char			filename[64];
 	unsigned long		mask;
 	int			num_of_runs;
-	int			(*init)(const struct resctrl_val_param *param,
+	int			(*init)(const struct resctrl_test *test,
+					const struct user_params *uparams,
+					const struct resctrl_val_param *param,
 					int domain_id);
 	int			(*setup)(const struct resctrl_test *test,
 					 const struct user_params *uparams,
diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
index 7c08e936572d..a5a8badb83d4 100644
--- a/tools/testing/selftests/resctrl/resctrl_val.c
+++ b/tools/testing/selftests/resctrl/resctrl_val.c
@@ -569,7 +569,7 @@ int resctrl_val(const struct resctrl_test *test,
 		goto reset_affinity;
 
 	if (param->init) {
-		ret = param->init(param, domain_id);
+		ret = param->init(test, uparams, param, domain_id);
 		if (ret)
 			goto reset_affinity;
 	}
-- 
2.50.1

