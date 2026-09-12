Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF635384233;
	Sat, 12 Sep 2026 09:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204115; cv=none; b=VFjNkqFea1YH35LQCn6aUCmVK2E4JVxtJt30wmsy2RRpxb6EvqZd5haJmGPnjxlUNMQzlsQzmOGZF7XBoLLydVUnm6gohFLof6e5Wpp++8BHnuTamvyJJ4Q4mkwYoDcM3MOJ77PXa7uHUUUmi64TPLKKUoxpdsmucx7WThoMOdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204115; c=relaxed/simple;
	bh=UZBpSf0wPtHy1dwVrlMnPQzaujCXJaEHG2ZUxqXkEkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJOKH+A8w+l/J/aBqZrHLbkIQxEEV0W8jMoLBK1g2YmzJuBrcA5+B4isHT9HGxWVWnRVKrZDllvqjRuPjEGWUjFWjKbf9xmqoy12jKuOd6Cq1GK55YCwQHBqt849CJF8/sPN3K/hg8ORXc/K91vd7+WI8/myAAkIMvkiiO9RrD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KILXweSj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KILXweSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011631F000FF;
	Sat, 12 Sep 2026 09:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204113;
	bh=AHGkTzOAn5q4CPlDBulgrnLPNSCCbd0P+GnJ2uJGbiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KILXweSjUw9oRklyyQRHlhiLUXOpk+NkTKH2G10hWzs8/PVWA09yKWPtfHNNOqsXR
	 dTCohxqV17hsRE8k9Ykn1API7Yxc4Fo+Sf8iV/RKrlZco/0eMg3aS7TEHq/fP9ELou
	 aNg/gG6Ad3Zjjtj1HgqD+Q44cCCcy/FuKe7TNuB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1545/1815] selftests/bpf: Retry stat generation in cgroup_iter_memcg
Date: Sat, 12 Sep 2026 08:54:55 +0200
Message-ID: <20260912065725.273814892@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 3d9393ff98ca9a132c7a0778436f5ed856fb3dc6 ]

Each cgroup_iter_memcg subtest touches 1024 pages and expects the matching
memcg counter to be non-zero. On a host with many CPUs it reads zero
instead:

  test_anon:FAIL:final anon mapped val: actual 0 <= expected 0

memcg stats are cached per-cpu and only become visible once the periodic
flusher runs (FLUSH_TIME, 2s), or once pending updates cross
MEMCG_CHARGE_BATCH * num_online_cpus(). That threshold is 512 pages at 8
CPUs but 8192 at 128, so a single pass no longer reaches it and
bpf_mem_cgroup_flush_stats() returns without flushing anything.

Retry the stat generation, sleeping in between, so that a flusher cycle is
always covered. Sleep before dropping the mapping, so that a flusher cycle
landing in the sleep observes the mapped state. nr_anon_mapped and
nr_file_mapped are rmap gauges, and unmapping first would post a matching
negative delta for the flusher to aggregate to a net zero.

test_file asserts on both nr_file_pages and nr_file_mapped, which have
different lifetimes, as page cache pages outlive the mapping. Retry
while either one is still zero.

Fixes: 6bce6ddbe634 ("bpf: selftests: selftests for memcg stat kfuncs")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20260814232017.2839959-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/prog_tests/cgroup_iter_memcg.c        | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
index b7c18d590b993..5a1e08d39a06b 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
@@ -10,6 +10,17 @@
 #include "cgroup_iter_memcg.h"
 #include "cgroup_iter_memcg.skel.h"
 
+/*
+ * memcg stats are cached per-cpu and only become visible once the periodic
+ * flusher runs (FLUSH_TIME, 2s), or once pending updates cross
+ * MEMCG_CHARGE_BATCH * num_online_cpus(). That threshold grows with the CPU
+ * count, so on a large machine a single pass does not reach it and
+ * bpf_mem_cgroup_flush_stats() returns without flushing anything. Retry for
+ * long enough to cover a flusher cycle.
+ */
+#define MEMCG_STAT_RETRIES		16
+#define MEMCG_STAT_RETRY_DELAY_US	(250 * 1000)
+
 static int read_stats(struct bpf_link *link)
 {
 	int fd, ret = 0;
@@ -35,11 +46,13 @@ static int read_stats(struct bpf_link *link)
 
 static void test_anon(struct bpf_link *link, struct memcg_query *memcg_query)
 {
+	int retries = 0;
 	void *map;
 	size_t len;
 
 	len = sysconf(_SC_PAGESIZE) * 1024;
 
+retry:
 	/*
 	 * Increase memcg anon usage by mapping and writing
 	 * to a new anon region.
@@ -53,6 +66,12 @@ static void test_anon(struct bpf_link *link, struct memcg_query *memcg_query)
 	if (!ASSERT_OK(read_stats(link), "read stats"))
 		goto cleanup;
 
+	if (!memcg_query->nr_anon_mapped && ++retries < MEMCG_STAT_RETRIES) {
+		usleep(MEMCG_STAT_RETRY_DELAY_US);
+		munmap(map, len);
+		goto retry;
+	}
+
 	ASSERT_GT(memcg_query->nr_anon_mapped, 0, "final anon mapped val");
 
 cleanup:
@@ -61,6 +80,7 @@ static void test_anon(struct bpf_link *link, struct memcg_query *memcg_query)
 
 static void test_file(struct bpf_link *link, struct memcg_query *memcg_query)
 {
+	int retries = 0;
 	void *map;
 	size_t len;
 	char *path;
@@ -76,6 +96,7 @@ static void test_file(struct bpf_link *link, struct memcg_query *memcg_query)
 	fd = open(path, O_CREAT | O_RDWR, 0644);
 	if (!ASSERT_OK_FD(fd, "open fd"))
 		return;
+retry:
 	if (!ASSERT_OK(ftruncate(fd, len), "ftruncate"))
 		goto cleanup_fd;
 
@@ -88,6 +109,13 @@ static void test_file(struct bpf_link *link, struct memcg_query *memcg_query)
 	if (!ASSERT_OK(read_stats(link), "read stats"))
 		goto cleanup_map;
 
+	if ((!memcg_query->nr_file_pages || !memcg_query->nr_file_mapped) &&
+	    ++retries < MEMCG_STAT_RETRIES) {
+		usleep(MEMCG_STAT_RETRY_DELAY_US);
+		munmap(map, len);
+		goto retry;
+	}
+
 	ASSERT_GT(memcg_query->nr_file_pages, 0, "final file value");
 	ASSERT_GT(memcg_query->nr_file_mapped, 0, "final file mapped value");
 
@@ -100,6 +128,7 @@ static void test_file(struct bpf_link *link, struct memcg_query *memcg_query)
 
 static void test_shmem(struct bpf_link *link, struct memcg_query *memcg_query)
 {
+	int retries = 0;
 	size_t len;
 	int fd;
 
@@ -113,12 +142,18 @@ static void test_shmem(struct bpf_link *link, struct memcg_query *memcg_query)
 	if (!ASSERT_OK_FD(fd, "memfd_create"))
 		return;
 
+retry:
 	if (!ASSERT_OK(fallocate(fd, 0, 0, len), "fallocate"))
 		goto cleanup;
 
 	if (!ASSERT_OK(read_stats(link), "read stats"))
 		goto cleanup;
 
+	if (!memcg_query->nr_shmem && ++retries < MEMCG_STAT_RETRIES) {
+		usleep(MEMCG_STAT_RETRY_DELAY_US);
+		goto retry;
+	}
+
 	ASSERT_GT(memcg_query->nr_shmem, 0, "final shmem value");
 
 cleanup:
@@ -127,11 +162,13 @@ static void test_shmem(struct bpf_link *link, struct memcg_query *memcg_query)
 
 static void test_pgfault(struct bpf_link *link, struct memcg_query *memcg_query)
 {
+	int retries = 0;
 	void *map;
 	size_t len;
 
 	len = sysconf(_SC_PAGESIZE) * 1024;
 
+retry:
 	/* Create region to use for triggering a page fault. */
 	map = mmap(NULL, len, PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
 	if (!ASSERT_NEQ(map, MAP_FAILED, "mmap anon"))
@@ -143,6 +180,12 @@ static void test_pgfault(struct bpf_link *link, struct memcg_query *memcg_query)
 	if (!ASSERT_OK(read_stats(link), "read stats"))
 		goto cleanup;
 
+	if (!memcg_query->pgfault && ++retries < MEMCG_STAT_RETRIES) {
+		usleep(MEMCG_STAT_RETRY_DELAY_US);
+		munmap(map, len);
+		goto retry;
+	}
+
 	ASSERT_GT(memcg_query->pgfault, 0, "final pgfault val");
 
 cleanup:
-- 
2.53.0



