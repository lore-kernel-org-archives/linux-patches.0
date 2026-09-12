Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C444C368D5A;
	Sat, 12 Sep 2026 08:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201751; cv=none; b=hPIqzBTZeacSQdFN0XU9Lh+8ynuSKrHIIvOD7L4oY7zWGYFfT5EK0JNWuVLpqmJvnKtdbofL1w+zev/9h7zqXSUPWr2GD/HRGEa29h8f5Tj3qjXK4FbyGTjVDtvAX83qrUUqkbuDS1dCqWdh/lSyvyad6RXcs71Zd6DZL2WE6Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201751; c=relaxed/simple;
	bh=UYwLx0koHJ3fvZZuJXMVASjXluXk9AQF6acZPKU+0lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxZnTsX5ZgqyH6nu1qiTHPENpQKPMOpd4Hl2/x7hVj7HeSOXp3bthX3Ulha6rekgrI5m4N+JKjj7UKp1VBprJk9mq44v2NP3jeLhE4aE/jTZ+Vy9ZEF/NoyiNvpxiMCqR4GoJdlG6pRO3PhMgbYGUgU4oamGlxEALK1cXJ1W+Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhZBj6xE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhZBj6xE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A761F000FF;
	Sat, 12 Sep 2026 08:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201749;
	bh=Odtf3lvXSQz4uvYp66IYVQ4cLQc8vmpQB4dIGJCp8Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZhZBj6xEX45PVBiDjU3TNODdsad8RQIe8amenct0d0Kq54qaM5ydKyQJR8duzzOoc
	 15LFeLZbvsI8gxF0mL15dZeFYsg9O0JKlaSLd5q/zu/Iy0iXROsAxbd6d8lKMwB/5u
	 n0kgs3wVO5jMKwaojoQe0oc8IfIHH/gPx7Xf5kho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sayali Patil <sayalip@linux.ibm.com>,
	Dev Jain <dev.jain@arm.com>,
	Liam Howlett <liam@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1061/1815] selftests/mm: handle EINVAL when configuring gigantic hugepages
Date: Sat, 12 Sep 2026 08:46:51 +0200
Message-ID: <20260912065713.927025854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sayali Patil <sayalip@linux.ibm.com>

[ Upstream commit 5c4c48ff5aa1240a689d6508326a0ce42a71e9c4 ]

Patch series "selftests/mm: avoid false failures in hugetlb and KSM
tests", v3.

This series fixes issues in the hugetlb and KSM MM selftest categories
that can report failures when the prerequisites for the tests are not
satisfied.

Patch 1 updates the hugetlb selftest helpers to handle -EINVAL when
attempting to configure gigantic HugeTLB pages via nr_hugepages.  PowerPC
hash MMU pSeries systems expose gigantic hugepage sizes but do not allow
runtime allocation of such pages, causing the sysfs write to fail.  Handle
this case gracefully and continue running the test instead of aborting.

Patch 2 fixes the KSM NUMA merge test on systems with memoryless NUMA
nodes.  The test currently relies on the number of configured NUMA nodes
and may attempt allocations on nodes that have no memory, resulting in
spurious failures.  Use the existing helpers to identify NUMA nodes that
contain memory and skip the test when fewer than two such nodes are
available.

Patch 3 fixes a pre-existing operator precedence issue in ksm_tests, where
a ternary expression combined with logical OR operators could be evaluated
differently than intended.  Added parentheses to ensure the correct
evaluation order.

These changes improve handling of unsupported test configurations and
unmet test prerequisites, avoiding spurious failures.

This patch (of 3):

Some MM selftests attempt to configure the amount of HugeTLB pages of
different sizes by writing to nr_hugepages.

PowerPC hash MMU pSeries systems advertise gigantic hugepage sizes but do
not support runtime allocation of such pages, writes to the corresponding
nr_hugepages file fail with -EINVAL.  This causes the test to bail out
even though the failure is due to a platform limitation rather than the
functionality being tested.

Ignore -EINVAL when configuring nr_hugepages so that tests continue to run
on systems where gigantic hugepage allocation is unsupported.

Before patch:
   -------------------------
   running ./hugetlb-madvise
   -------------------------
   TAP version 13
   1..1
     [INFO] detected hugetlb page size: 16777216 KiB
     [INFO] detected hugetlb page size: 16384 KiB
    ok 1 MADV_DONTNEED and MADV_REMOVE on hugetlb
    Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
    Bail out! /sys/kernel/mm/hugepages/hugepages-16777216kB/nr_hugepages
    write(0) failed: Invalid argument
    Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
    [FAIL]

After patch:
   -------------------------
   running ./hugetlb-madvise
   -------------------------
   TAP version 13
   1..1
    [INFO] detected hugetlb page size: 16777216 KiB
    [INFO] detected hugetlb page size: 16384 KiB
   ok 1 MADV_DONTNEED and MADV_REMOVE on hugetlb
   Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
   [PASS]

Link: https://lore.kernel.org/cover.1783446924.git.sayalip@linux.ibm.com
Link: https://lore.kernel.org/2e3b585cbb30b2fc495dcd49d75de6f6da61861c.1783446924.git.sayalip@linux.ibm.com
Fixes: 27477b28b74f ("selftests/mm: hugepage_settings: add APIs to get and set nr_hugepages")
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/mm/hugepage_settings.c  |  2 +-
 tools/testing/selftests/mm/vm_util.c          | 26 ++++++++++++++++---
 tools/testing/selftests/mm/vm_util.h          |  1 +
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 2eab2110ac6a4..d7917dce3abac 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -437,7 +437,7 @@ void hugetlb_set_nr_pages(unsigned long size, unsigned long nr)
 
 	hugetlb_sysfs_path(path, sizeof(path), size, "nr_hugepages");
 
-	write_num(path, nr);
+	write_num_ignore_einval(path, nr);
 }
 
 unsigned long hugetlb_free_pages(unsigned long size)
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 311fc5b4513eb..ef1ea11981a74 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -719,7 +719,7 @@ int read_file(const char *path, char *buf, size_t buflen)
 	return (unsigned int) numread;
 }
 
-void write_file(const char *path, const char *buf, size_t buflen)
+static void __write_file(const char *path, const char *buf, size_t buflen, bool ignore_einval)
 {
 	int fd, saved_errno;
 	ssize_t numwritten;
@@ -735,14 +735,22 @@ void write_file(const char *path, const char *buf, size_t buflen)
 	saved_errno = errno;
 	close(fd);
 	errno = saved_errno;
-	if (numwritten < 0)
+	if (numwritten < 0) {
+		if (ignore_einval && errno == EINVAL)
+			return;
 		ksft_exit_fail_msg("%s write(%.*s) failed: %s\n", path, (int)(buflen - 1),
 				buf, strerror(errno));
+	}
 	if (numwritten != buflen - 1)
 		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
 				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
 }
 
+void write_file(const char *path, const char *buf, size_t buflen)
+{
+	__write_file(path, buf, buflen, /* ignore_einval = */ false);
+}
+
 unsigned long read_num(const char *path)
 {
 	char buf[21];
@@ -753,12 +761,22 @@ unsigned long read_num(const char *path)
 	return strtoul(buf, NULL, 10);
 }
 
-void write_num(const char *path, unsigned long num)
+static void __write_num(const char *path, unsigned long num, bool ignore_einval)
 {
 	char buf[21];
 
 	sprintf(buf, "%lu", num);
-	write_file(path, buf, strlen(buf) + 1);
+	__write_file(path, buf, strlen(buf) + 1, ignore_einval);
+}
+
+void write_num(const char *path, unsigned long num)
+{
+	return __write_num(path, num, /* ignore_einval = */ false);
+}
+
+void write_num_ignore_einval(const char *path, unsigned long num)
+{
+	return __write_num(path, num, /* ignore_einval = */ true);
 }
 
 static unsigned long shmall, shmmax;
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index ea8fc8fdf0eb0..7799154b67eed 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -168,6 +168,7 @@ void write_file(const char *path, const char *buf, size_t buflen);
 int read_file(const char *path, char *buf, size_t buflen);
 unsigned long read_num(const char *path);
 void write_num(const char *path, unsigned long num);
+void write_num_ignore_einval(const char *path, unsigned long num);
 
 void shm_limits_prepare(unsigned long length);
 void __shm_limits_restore(void);
-- 
2.53.0



