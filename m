Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403E72C028B
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 00:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772583589; cv=none; b=Lqu/I374a/GIRKowb59sU5jKNhLFsUKEAtRqzlaS5ZaQjJY8/Yde88AJeyDCA828aFKXovq/tGgQIUEMN+pGuzi+d1FVREcc1j9YCL9lXte4L+jq666wIdvyH3lXmIvMPzYjlvOJ5L/WXeTvg/ZSttGatvg3KS9t4GU3JiccB5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772583589; c=relaxed/simple;
	bh=nxf43kamxazjMsxMuuiU2UtYRi3XjR/XIy+ZjiDgMPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuCL52FwUF/YEvVNBkyBPgzYd93D3txauETq8dX25KOoZSDFJXxPoktT7vJQa1nOtrlIteAA5yfwu4MaOyR7vjZuxa62ez8rh+Ae2mg5n4IxTMW66V/4CNZtszP6ODcO8fhl4oUh1fsxM/2A9EqSRlNZKuR0F9jDNaETtBdG1qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nw7LExd8; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nw7LExd8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772583588; x=1804119588;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nxf43kamxazjMsxMuuiU2UtYRi3XjR/XIy+ZjiDgMPg=;
  b=nw7LExd8utqAyjjKYSUFdsLD1OIxyrxiaqJoLLyIafPucn6RdlEDn4U+
   EIUXuHSTlHwpN+vwbOpgFqENNSpLXZ2Y75Re4iNcorPJkhLNSyVtTBJvL
   MqU/R9+yuLOXfdOPTWz2l/kcir+6o0nNAFgnLi0vo96LXT6IOrdr1Yv9h
   yzQalrblplnuwov9HiDYUHxq06KIQmBQt0jBYUnfydu56qTbro+LQ6Awh
   8ENJnopSWkWZ23RMNPsHCyPz4silq0nZy0YmKgW93bvBsww2acSqfxMgZ
   gavRdyzw7o+804fbZ9KOoIbcbXFarRcl/bJCfJy97CUR8YxzCHf9mzHyp
   A==;
X-CSE-ConnectionGUID: nzNN7Oe4SYef5hK1erKUFQ==
X-CSE-MsgGUID: luVnD+mhQBKcjhEyrHz/SQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="73544997"
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="73544997"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 16:19:44 -0800
X-CSE-ConnectionGUID: l0BkX0olSI2PVg6Pm+IXgA==
X-CSE-MsgGUID: f5sCj29FTBK0lIcHNmS7Jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="218120384"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 16:19:44 -0800
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
Subject: [PATCH v2 1/9] selftests/resctrl: Improve accuracy of cache occupancy test
Date: Tue,  3 Mar 2026 16:19:30 -0800
Message-ID: <a43f404b9fdcf01d8c8cd825c17f39f95083c813.1772582958.git.reinette.chatre@intel.com>
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
    # Cache size :56623104
    # Writing benchmark parameters to resctrl FS
    # Benchmark PID: 3275
    # Checking for pass/fail
    # Fail: Check cache miss rate within 15%
    # Percent diff=97
    # Number of bits: 5
    # Average LLC val: 501350
    # Cache span (bytes): 23592960
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

Take the L2 cache into account to further improve test accuracy.
By default the buffer size is the same as the L3 portion that the workload
can allocate into. This buffer size does not take into account that some
of the workload's data may land in L2/L1. Address this in two ways:
 - Reduce the amount of L2 cache the workload can allocate into to the
   minimum on systems that support L2 cache allocation.
 - Increase the buffer size to accommodate data that may be allocated into
   the L2 cache. Use a buffer size double the L3 portion to keep using the
   L3 portion size as goal for L3 occupancy while taking into account that
   some of the data may be in L2.

With the above adjustments the CMT test is more consistent. Repeating the
CMT test while generating interference with stress-ng on a sample
system after applying the fixes show significant improvement in test
accuracy:

    # Starting CMT test ...
    # Mounting resctrl to "/sys/fs/resctrl"
    # Cache size :56623104
    # Writing benchmark parameters to resctrl FS
    # Write schema "L3:0=fe0" to resctrl FS
    # Write schema "L3:0=1f" to resctrl FS
    # Benchmark PID: 3223
    # Checking for pass/fail
    # Pass: Check cache miss rate within 15%
    # Percent diff=3
    # Number of bits: 5
    # Average LLC val: 22811443
    # Cache span (bytes): 23592960
    ok 1 CMT: test

Reported-by: Dave Martin <Dave.Martin@arm.com>
Closes: https://lore.kernel.org/lkml/aO+7MeSMV29VdbQs@e133380.arm.com/
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes since v1:
- Fix typo in changelog: "data my be in L2" -> "data may be in L2".
---
 tools/testing/selftests/resctrl/cmt_test.c    | 35 ++++++++++++++++---
 tools/testing/selftests/resctrl/mba_test.c    |  4 ++-
 tools/testing/selftests/resctrl/mbm_test.c    |  4 ++-
 tools/testing/selftests/resctrl/resctrl.h     |  4 ++-
 tools/testing/selftests/resctrl/resctrl_val.c |  2 +-
 5 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/resctrl/cmt_test.c b/tools/testing/selftests/resctrl/cmt_test.c
index d09e693dc739..44e9938dfafd 100644
--- a/tools/testing/selftests/resctrl/cmt_test.c
+++ b/tools/testing/selftests/resctrl/cmt_test.c
@@ -19,12 +19,39 @@
 #define CON_MON_LCC_OCCUP_PATH		\
 	"%s/%s/mon_data/mon_L3_%02d/llc_occupancy"
 
-static int cmt_init(const struct resctrl_val_param *param, int domain_id)
+/*
+ * Initialize capacity bitmasks (CBMs) for control group being tested,
+ * default resource group to prevent its tasks from interfering with test,
+ * and L2 resource of control group to minimize allocations into L2 if
+ * possible to better predict L3 occupancy.
+ */
+static int cmt_init(const struct resctrl_test *test,
+		    const struct user_params *uparams,
+		    const struct resctrl_val_param *param, int domain_id)
 {
+	unsigned long long_mask;
+	char schemata[64];
+	int ret;
+
 	sprintf(llc_occup_path, CON_MON_LCC_OCCUP_PATH, RESCTRL_PATH,
 		param->ctrlgrp, domain_id);
 
-	return 0;
+	ret = get_full_cbm(test->resource, &long_mask);
+	if (ret)
+		return ret;
+
+	snprintf(schemata, sizeof(schemata), "%lx", ~param->mask & long_mask);
+	ret = write_schemata("", schemata, uparams->cpu, test->resource);
+	if (ret)
+		return ret;
+
+	snprintf(schemata, sizeof(schemata), "%lx", param->mask);
+	ret = write_schemata(param->ctrlgrp, schemata, uparams->cpu, test->resource);
+
+	if (!ret && !strcmp(test->resource, "L3") && resctrl_resource_exists("L2"))
+		ret = write_schemata(param->ctrlgrp, "0x1", uparams->cpu, "L2");
+
+	return ret;
 }
 
 static int cmt_setup(const struct resctrl_test *test,
@@ -153,11 +180,11 @@ static int cmt_run_test(const struct resctrl_test *test, const struct user_param
 	span = cache_portion_size(cache_total_size, param.mask, long_mask);
 
 	if (uparams->fill_buf) {
-		fill_buf.buf_size = span;
+		fill_buf.buf_size = span * 2;
 		fill_buf.memflush = uparams->fill_buf->memflush;
 		param.fill_buf = &fill_buf;
 	} else if (!uparams->benchmark_cmd[0]) {
-		fill_buf.buf_size = span;
+		fill_buf.buf_size = span * 2;
 		fill_buf.memflush = true;
 		param.fill_buf = &fill_buf;
 	}
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

