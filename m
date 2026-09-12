Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FF623BD06;
	Sat, 12 Sep 2026 14:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224726; cv=none; b=a9ITxAP1gx1gkZXt5C+dbZlIgm0SFpqt/EqHgLjiFkQR6UHdvxTWNB5zRaPjwhMho+DdtKox9dgu6U4/Coz9pAqokA+BDrksSJ+Ni3uqjR3CaR+7IEoioxLxSp7e1o3iCqlMerNZF6SYVMnanx/nZdG0F8t1vLkY8bqeuTqQVv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224726; c=relaxed/simple;
	bh=yE13IFDaS3d++PwR1ZmS2UcePyUFmJ2AWDp7UB49uok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5DM9U9woh7C1F+gO/m4F0/dAKRVt5aqcWN4PqpnL6ppCfwrqLsqVGLbx8toPT9+YgyZtCaFyjR738oAnK0gY2QjBHzdUG6ndS8Yu80teXwXA+AeOgrnj1ST3yOb+IjhMx+9x08Ef/7hp26bDjglcgr0LvCxj3hr5euI3MTKbX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RO/fsLEE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RO/fsLEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D371F000FF;
	Sat, 12 Sep 2026 14:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224725;
	bh=8DRC/yusmrvyfwjRQuHNQK1GOcbFoJ5YTt6pyGGjA+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RO/fsLEE0mUL5UAKYyyFOsR75LwuagrAEfluOfza9sqHDw9HNImn+ssBE3vFAMqDw
	 WjhsVUAWscoIUaIfUca1ptxUbd0hY0puCGdfHnkgIpj5zcvtpLVJovV30HU9qoqzx/
	 +h5jMZ5h9NW4gfe+pd+bGsQbvT3Uqz8Y5YIYLrhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Barry Song <v-songbaohua@oppo.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Hildenbrand <david@redhat.com>,
	David Rientjes <rientjes@google.com>,
	"Huang, Ying" <ying.huang@intel.com>,
	Hugh Dickins <hughd@google.com>,
	Itaru Kitayama <itaru.kitayama@gmail.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Yang Shi <shy828301@gmail.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	Yu Zhao <yuzhao@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1053/1424] selftests/mm/khugepaged: enlighten for multi-size THP
Date: Sat, 12 Sep 2026 08:58:05 +0200
Message-ID: <20260912065630.887178318@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit 9f0704eae8a4edc8dca9c8a297f798d505a4103a ]

The `collapse_max_ptes_none` test was previously failing when a THP size
less than PMD-size had enabled="always".  The root cause is because the
test faults in 1 page less than the threshold it set for collapsing.  But
when THP is enabled always, we "over allocate" and therefore the threshold
is passed, and collapse unexpectedly succeeds.

Solve this by enlightening khugepaged selftest.  Add a command line option
to pass in the desired THP size that should be used for all anonymous
allocations.  The harness will then explicitly configure a THP size as
requested and modify the `collapse_max_ptes_none` test so that it faults
in the threshold minus the number of pages in the configured THP size.  If
no command line option is provided, default to order 0, as per previous
behaviour.

I chose to use an order in the command line interface, since this makes
the interface agnostic of base page size, making it easier to invoke from
run_vmtests.sh.

Link: https://lkml.kernel.org/r/20231207161211.2374093-9-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 15828a150c58 ("selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c   | 48 +++++++++++++++++------
 tools/testing/selftests/mm/run_vmtests.sh |  2 +
 2 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 7bd3baa9d34b4..829320a519e72 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -28,6 +28,7 @@
 static unsigned long hpage_pmd_size;
 static unsigned long page_size;
 static int hpage_pmd_nr;
+static int anon_order;
 
 #define PID_SMAPS "/proc/self/smaps"
 #define TEST_FILE "collapse_test_file"
@@ -607,6 +608,11 @@ static bool is_tmpfs(struct mem_ops *ops)
 	return ops == &__file_ops && finfo.type == VMA_SHMEM;
 }
 
+static bool is_anon(struct mem_ops *ops)
+{
+	return ops == &__anon_ops;
+}
+
 static void alloc_at_fault(void)
 {
 	struct thp_settings settings = *thp_current_settings();
@@ -673,6 +679,7 @@ static void collapse_max_ptes_none(struct collapse_context *c, struct mem_ops *o
 	int max_ptes_none = hpage_pmd_nr / 2;
 	struct thp_settings settings = *thp_current_settings();
 	void *p;
+	int fault_nr_pages = is_anon(ops) ? 1 << anon_order : 1;
 
 	settings.khugepaged.max_ptes_none = max_ptes_none;
 	thp_push_settings(&settings);
@@ -686,10 +693,10 @@ static void collapse_max_ptes_none(struct collapse_context *c, struct mem_ops *o
 		goto skip;
 	}
 
-	ops->fault(p, 0, (hpage_pmd_nr - max_ptes_none - 1) * page_size);
+	ops->fault(p, 0, (hpage_pmd_nr - max_ptes_none - fault_nr_pages) * page_size);
 	c->collapse("Maybe collapse with max_ptes_none exceeded", p, 1,
 		    ops, !c->enforce_pte_scan_limits);
-	validate_memory(p, 0, (hpage_pmd_nr - max_ptes_none - 1) * page_size);
+	validate_memory(p, 0, (hpage_pmd_nr - max_ptes_none - fault_nr_pages) * page_size);
 
 	if (c->enforce_pte_scan_limits) {
 		ops->fault(p, 0, (hpage_pmd_nr - max_ptes_none) * page_size);
@@ -1076,7 +1083,7 @@ static void madvise_retracted_page_tables(struct collapse_context *c,
 
 static void usage(void)
 {
-	fprintf(stderr, "\nUsage: ./khugepaged <test type> [dir]\n\n");
+	fprintf(stderr, "\nUsage: ./khugepaged [OPTIONS] <test type> [dir]\n\n");
 	fprintf(stderr, "\t<test type>\t: <context>:<mem_type>\n");
 	fprintf(stderr, "\t<context>\t: [all|khugepaged|madvise]\n");
 	fprintf(stderr, "\t<mem_type>\t: [all|anon|file|shmem]\n");
@@ -1085,15 +1092,34 @@ static void usage(void)
 	fprintf(stderr,	"\tCONFIG_READ_ONLY_THP_FOR_FS=y\n");
 	fprintf(stderr, "\n\tif [dir] is a (sub)directory of a tmpfs mount, tmpfs must be\n");
 	fprintf(stderr,	"\tmounted with huge=madvise option for khugepaged tests to work\n");
+	fprintf(stderr,	"\n\tSupported Options:\n");
+	fprintf(stderr,	"\t\t-h: This help message.\n");
+	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
+	fprintf(stderr,	"\t\t    Defaults to 0. Use this size for anon allocations.\n");
 	exit(1);
 }
 
-static void parse_test_type(int argc, const char **argv)
+static void parse_test_type(int argc, char **argv)
 {
+	int opt;
 	char *buf;
 	const char *token;
 
-	if (argc == 1) {
+	while ((opt = getopt(argc, argv, "s:h")) != -1) {
+		switch (opt) {
+		case 's':
+			anon_order = atoi(optarg);
+			break;
+		case 'h':
+		default:
+			usage();
+		}
+	}
+
+	argv += optind;
+	argc -= optind;
+
+	if (argc == 0) {
 		/* Backwards compatibility */
 		khugepaged_context =  &__khugepaged_context;
 		madvise_context =  &__madvise_context;
@@ -1101,7 +1127,7 @@ static void parse_test_type(int argc, const char **argv)
 		return;
 	}
 
-	buf = strdup(argv[1]);
+	buf = strdup(argv[0]);
 	token = strsep(&buf, ":");
 
 	if (!strcmp(token, "all")) {
@@ -1135,11 +1161,13 @@ static void parse_test_type(int argc, const char **argv)
 	if (!file_ops)
 		return;
 
-	if (argc != 3)
+	if (argc != 2)
 		usage();
+
+	get_finfo(argv[1]);
 }
 
-int main(int argc, const char **argv)
+int main(int argc, char **argv)
 {
 	int hpage_pmd_order;
 	struct thp_settings default_settings = {
@@ -1164,9 +1192,6 @@ int main(int argc, const char **argv)
 
 	parse_test_type(argc, argv);
 
-	if (file_ops)
-		get_finfo(argv[2]);
-
 	setbuf(stdout, NULL);
 
 	page_size = getpagesize();
@@ -1183,6 +1208,7 @@ int main(int argc, const char **argv)
 	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
 	default_settings.khugepaged.pages_to_scan = hpage_pmd_nr * 8;
 	default_settings.hugepages[hpage_pmd_order].enabled = THP_INHERIT;
+	default_settings.hugepages[anon_order].enabled = THP_ALWAYS;
 
 	save_settings();
 	thp_push_settings(&default_settings);
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d7b2c9d07eec5..8ec99d704d06e 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -377,6 +377,8 @@ CATEGORY="cow" run_test ./cow
 
 CATEGORY="thp" run_test ./khugepaged
 
+CATEGORY="thp" run_test ./khugepaged -s 2
+
 CATEGORY="thp" run_test ./transhuge-stress -d 20
 
 CATEGORY="thp" run_test ./split_huge_page_test
-- 
2.53.0



