Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27DF37AA64
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 20:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773433983; cv=none; b=HXTpGzPBecZMFiGutWMJSDpsyFWEW3Xn0uc5BZz2GHnvGDxj8j9f/nTDa2Nz/U3p/ykrbZMFOeShukgLzlnsGhVkOnnczA4MJdiALjLS2y4yxFMM3QVaevxySu19/qqDs5Tedj0SAqeIypTZGf6tmEvjqgxcrup4c1PUZnmppvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773433983; c=relaxed/simple;
	bh=5icHJepnYg/ZGdiimsTcVy+sqKzRjjaidfvA4uhUzMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eELrSSlVyzy/MOiWyGJinqrKoPRNYDk9WRZMVEPz+ZQt7hj5UVJcWVAIctzXmPdex7L+d4QjISHJTOi+ecKVpSbJIBAJDjFX5bRDFB1mE6EBu6e8TDsSDkTtxtyhgTxuCtEzmy0CaEJ36Qk11DS4OFUUlhjMVaAszyE7X4Hakcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d10HXwlj; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d10HXwlj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773433981; x=1804969981;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5icHJepnYg/ZGdiimsTcVy+sqKzRjjaidfvA4uhUzMI=;
  b=d10HXwljvuP3arG+fJdVnPbCu3+qBO3DwPXprUFn7YlAM/Tgxa2M2YwE
   Ul7cdzJUocG2eBImc56pIxxFwIaTeYeJ65WEyOmUTtHZqrwsHPRwzLOCg
   wJT2Su6wUQCghzS4wkb8A/743GV6dlPgqAojDbMinYjHEpDM7mCPCNygy
   GQVtKbhPUc9lMflPoX4ti3JPLH1VochOEKZS0g0iD7S6TV53/HgwnQ2zh
   hczTiTyH1bRPkZh6Ps3s5avLcogB60K2VRAFtGO73myhCd6SGygq6NXog
   /dvlp4l9KplaiFzSLhy/vY4GDyc9xR0Ty05tFe/QPV9Fv9kEf88jGdWzk
   g==;
X-CSE-ConnectionGUID: SRUBEbxpTFW9kULQtyyCDA==
X-CSE-MsgGUID: B9nyFcAEQYuab8ZJXtdwaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11728"; a="74519313"
X-IronPort-AV: E=Sophos;i="6.23,118,1770624000"; 
   d="scan'208";a="74519313"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 13:32:55 -0700
X-CSE-ConnectionGUID: VK2yLEEkRh2JBJu+FHpNPg==
X-CSE-MsgGUID: DF8r4FVUT4iO25c6MgY6zg==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 13:32:55 -0700
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
Subject: [PATCH v3 09/10] selftests/resctrl: Simplify perf usage in CAT test
Date: Fri, 13 Mar 2026 13:32:36 -0700
Message-ID: <ff80aaca24d306435b72a1b53ef8fa01f2b5010f.1773432891.git.reinette.chatre@intel.com>
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

The CAT test relies on the PERF_COUNT_HW_CACHE_MISSES event to determine if
modifying a cache portion size is successful. This event is configured to
report the data as part of an event group, but no other events are added to
the group.

Remove the unnecessary PERF_FORMAT_GROUP format setting. This eliminates
the need for struct perf_event_read and results in read() of the associated
file descriptor to return just one value associated with the
PERF_COUNT_HW_CACHE_MISSES event of interest.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Chen Yu <yu.c.chen@intel.com>
---
Changes since v2:
- Add Chen Yu's tag.
---
 tools/testing/selftests/resctrl/cache.c    | 17 +++++------------
 tools/testing/selftests/resctrl/cat_test.c |  4 +---
 tools/testing/selftests/resctrl/resctrl.h  | 11 +----------
 3 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/resctrl/cache.c b/tools/testing/selftests/resctrl/cache.c
index bef71b6feacc..df9bea584a2d 100644
--- a/tools/testing/selftests/resctrl/cache.c
+++ b/tools/testing/selftests/resctrl/cache.c
@@ -10,7 +10,6 @@ void perf_event_attr_initialize(struct perf_event_attr *pea, __u64 config)
 	memset(pea, 0, sizeof(*pea));
 	pea->type = PERF_TYPE_HARDWARE;
 	pea->size = sizeof(*pea);
-	pea->read_format = PERF_FORMAT_GROUP;
 	pea->exclude_kernel = 1;
 	pea->exclude_hv = 1;
 	pea->exclude_idle = 1;
@@ -37,19 +36,13 @@ int perf_event_reset_enable(int pe_fd)
 	return 0;
 }
 
-void perf_event_initialize_read_format(struct perf_event_read *pe_read)
-{
-	memset(pe_read, 0, sizeof(*pe_read));
-	pe_read->nr = 1;
-}
-
 int perf_open(struct perf_event_attr *pea, pid_t pid, int cpu_no)
 {
 	int pe_fd;
 
 	pe_fd = perf_event_open(pea, pid, cpu_no, -1, PERF_FLAG_FD_CLOEXEC);
 	if (pe_fd == -1) {
-		ksft_perror("Error opening leader");
+		ksft_perror("Unable to set up performance monitoring");
 		return -1;
 	}
 
@@ -132,9 +125,9 @@ static int print_results_cache(const char *filename, pid_t bm_pid, __u64 llc_val
  *
  * Return: =0 on success. <0 on failure.
  */
-int perf_event_measure(int pe_fd, struct perf_event_read *pe_read,
-		       const char *filename, pid_t bm_pid)
+int perf_event_measure(int pe_fd, const char *filename, pid_t bm_pid)
 {
+	__u64 value;
 	int ret;
 
 	/* Stop counters after one span to get miss rate */
@@ -142,13 +135,13 @@ int perf_event_measure(int pe_fd, struct perf_event_read *pe_read,
 	if (ret < 0)
 		return ret;
 
-	ret = read(pe_fd, pe_read, sizeof(*pe_read));
+	ret = read(pe_fd, &value, sizeof(value));
 	if (ret == -1) {
 		ksft_perror("Could not get perf value");
 		return -1;
 	}
 
-	return print_results_cache(filename, bm_pid, pe_read->values[0].value);
+	return print_results_cache(filename, bm_pid, value);
 }
 
 /*
diff --git a/tools/testing/selftests/resctrl/cat_test.c b/tools/testing/selftests/resctrl/cat_test.c
index 8bc47f06679a..6aac03147d41 100644
--- a/tools/testing/selftests/resctrl/cat_test.c
+++ b/tools/testing/selftests/resctrl/cat_test.c
@@ -135,7 +135,6 @@ static int cat_test(const struct resctrl_test *test,
 		    struct resctrl_val_param *param,
 		    size_t span, unsigned long current_mask)
 {
-	struct perf_event_read pe_read;
 	struct perf_event_attr pea;
 	cpu_set_t old_affinity;
 	unsigned char *buf;
@@ -159,7 +158,6 @@ static int cat_test(const struct resctrl_test *test,
 		goto reset_affinity;
 
 	perf_event_attr_initialize(&pea, PERF_COUNT_HW_CACHE_MISSES);
-	perf_event_initialize_read_format(&pe_read);
 	pe_fd = perf_open(&pea, bm_pid, uparams->cpu);
 	if (pe_fd < 0) {
 		ret = -1;
@@ -192,7 +190,7 @@ static int cat_test(const struct resctrl_test *test,
 
 			fill_cache_read(buf, span, true);
 
-			ret = perf_event_measure(pe_fd, &pe_read, param->filename, bm_pid);
+			ret = perf_event_measure(pe_fd, param->filename, bm_pid);
 			if (ret)
 				goto free_buf;
 		}
diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/selftests/resctrl/resctrl.h
index 3bad2d80c09b..175101022bf3 100644
--- a/tools/testing/selftests/resctrl/resctrl.h
+++ b/tools/testing/selftests/resctrl/resctrl.h
@@ -148,13 +148,6 @@ struct resctrl_val_param {
 	struct fill_buf_param	*fill_buf;
 };
 
-struct perf_event_read {
-	__u64 nr;			/* The number of events */
-	struct {
-		__u64 value;		/* The value of the event */
-	} values[2];
-};
-
 /*
  * Memory location that consumes values compiler must not optimize away.
  * Volatile ensures writes to this location cannot be optimized away by
@@ -210,11 +203,9 @@ unsigned int count_bits(unsigned long n);
 int snc_kernel_support(void);
 
 void perf_event_attr_initialize(struct perf_event_attr *pea, __u64 config);
-void perf_event_initialize_read_format(struct perf_event_read *pe_read);
 int perf_open(struct perf_event_attr *pea, pid_t pid, int cpu_no);
 int perf_event_reset_enable(int pe_fd);
-int perf_event_measure(int pe_fd, struct perf_event_read *pe_read,
-		       const char *filename, pid_t bm_pid);
+int perf_event_measure(int pe_fd, const char *filename, pid_t bm_pid);
 int measure_llc_resctrl(const char *filename, pid_t bm_pid);
 int minimize_l2_occupancy(const struct resctrl_test *test,
 			  const struct user_params *uparams,
-- 
2.50.1

