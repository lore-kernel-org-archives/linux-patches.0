Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C011AC8A2;
	Mon, 14 Oct 2024 14:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917969; cv=none; b=Q1YBjqJCtzoIDN+3+z3JU28TqFjAj95M+L0k/7TVLLzGRNiiL8cNGfmQpJtts9K84JoXroT710pN8FAiOviK4S/OnOKg2JQ29EnROLOs8qCRZ1PSmMvxFishUmh1HfaLjpf7d0sHCd9bT97bxhMsZlSGD8IhvhH9/hS8vW4YHd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917969; c=relaxed/simple;
	bh=d6+Be0FgZeGR6n2N+WlbL3qKgKUkqPnbxcVKUHthStk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIG+VWWcNpXUYj+dWRmvryjzcVl4j67l6yCY5C8Yu4Mjg9Lw2Dfw5n6qlAQt6eMbgBHcPfw9MHaZXZxfqAF59cb7P38rbqovCl/6teQ6oQzMeasa5Oqum7oY95vCjALeVO/3GClNPMP7WaKefPzWMglnjea1JyuwGEnI/S++ikM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sL7FD0NE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sL7FD0NE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A5CC4CEC3;
	Mon, 14 Oct 2024 14:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917968;
	bh=d6+Be0FgZeGR6n2N+WlbL3qKgKUkqPnbxcVKUHthStk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sL7FD0NEefRvNnFgZtPlt1uC0bWNIFjSkpZcKxikjMUc8xsKNvwSmGMvTi6/HENyu
	 7BZ9yzXgb+KmLAGZ1Dufr2dZEtR90qK7d2VBvPQHxvYr9gMPXaoCZkta4p+KeKExow
	 UFMeqH3sLEtxluxXlmUvQB196VHLX4WatIDo6BB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/798] selftests/bpf: Replace extract_build_id with read_build_id
Date: Mon, 14 Oct 2024 16:11:52 +0200
Message-ID: <20241014141224.121098980@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit dcc46f51d770bde625e4845cac42e808b3302b62 ]

Replacing extract_build_id with read_build_id that parses out
build id directly from elf without using readelf tool.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20230331093157.1749137-4-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: c9a83e76b5a9 ("selftests/bpf: Fix compile if backtrace support missing in libc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/prog_tests/stacktrace_build_id.c      | 19 ++++++--------
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  | 17 +++++--------
 tools/testing/selftests/bpf/test_progs.c      | 25 -------------------
 tools/testing/selftests/bpf/test_progs.h      |  1 -
 4 files changed, 13 insertions(+), 49 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
index 9ad09a6c538a5..b7ba5cd47d96f 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id.c
@@ -7,13 +7,12 @@ void test_stacktrace_build_id(void)
 
 	int control_map_fd, stackid_hmap_fd, stackmap_fd, stack_amap_fd;
 	struct test_stacktrace_build_id *skel;
-	int err, stack_trace_len;
+	int err, stack_trace_len, build_id_size;
 	__u32 key, prev_key, val, duration = 0;
-	char buf[256];
-	int i, j;
+	char buf[BPF_BUILD_ID_SIZE];
 	struct bpf_stack_build_id id_offs[PERF_MAX_STACK_DEPTH];
 	int build_id_matches = 0;
-	int retry = 1;
+	int i, retry = 1;
 
 retry:
 	skel = test_stacktrace_build_id__open_and_load();
@@ -52,9 +51,10 @@ void test_stacktrace_build_id(void)
 		  "err %d errno %d\n", err, errno))
 		goto cleanup;
 
-	err = extract_build_id(buf, 256);
+	build_id_size = read_build_id("urandom_read", buf, sizeof(buf));
+	err = build_id_size < 0 ? build_id_size : 0;
 
-	if (CHECK(err, "get build_id with readelf",
+	if (CHECK(err, "read_build_id",
 		  "err %d errno %d\n", err, errno))
 		goto cleanup;
 
@@ -64,8 +64,6 @@ void test_stacktrace_build_id(void)
 		goto cleanup;
 
 	do {
-		char build_id[64];
-
 		err = bpf_map_lookup_elem(stackmap_fd, &key, id_offs);
 		if (CHECK(err, "lookup_elem from stackmap",
 			  "err %d, errno %d\n", err, errno))
@@ -73,10 +71,7 @@ void test_stacktrace_build_id(void)
 		for (i = 0; i < PERF_MAX_STACK_DEPTH; ++i)
 			if (id_offs[i].status == BPF_STACK_BUILD_ID_VALID &&
 			    id_offs[i].offset != 0) {
-				for (j = 0; j < 20; ++j)
-					sprintf(build_id + 2 * j, "%02x",
-						id_offs[i].build_id[j] & 0xff);
-				if (strstr(buf, build_id) != NULL)
+				if (memcmp(buf, id_offs[i].build_id, build_id_size) == 0)
 					build_id_matches = 1;
 			}
 		prev_key = key;
diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
index 704f7f6c3704a..5db9eec24b5bd 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
@@ -13,11 +13,10 @@ void test_stacktrace_build_id_nmi(void)
 		.config = PERF_COUNT_HW_CPU_CYCLES,
 	};
 	__u32 key, prev_key, val, duration = 0;
-	char buf[256];
-	int i, j;
+	char buf[BPF_BUILD_ID_SIZE];
 	struct bpf_stack_build_id id_offs[PERF_MAX_STACK_DEPTH];
-	int build_id_matches = 0;
-	int retry = 1;
+	int build_id_matches = 0, build_id_size;
+	int i, retry = 1;
 
 	attr.sample_freq = read_perf_max_sample_freq();
 
@@ -79,7 +78,8 @@ void test_stacktrace_build_id_nmi(void)
 		  "err %d errno %d\n", err, errno))
 		goto cleanup;
 
-	err = extract_build_id(buf, 256);
+	build_id_size = read_build_id("urandom_read", buf, sizeof(buf));
+	err = build_id_size < 0 ? build_id_size : 0;
 
 	if (CHECK(err, "get build_id with readelf",
 		  "err %d errno %d\n", err, errno))
@@ -91,8 +91,6 @@ void test_stacktrace_build_id_nmi(void)
 		goto cleanup;
 
 	do {
-		char build_id[64];
-
 		err = bpf_map__lookup_elem(skel->maps.stackmap, &key, sizeof(key),
 					   id_offs, sizeof(id_offs), 0);
 		if (CHECK(err, "lookup_elem from stackmap",
@@ -101,10 +99,7 @@ void test_stacktrace_build_id_nmi(void)
 		for (i = 0; i < PERF_MAX_STACK_DEPTH; ++i)
 			if (id_offs[i].status == BPF_STACK_BUILD_ID_VALID &&
 			    id_offs[i].offset != 0) {
-				for (j = 0; j < 20; ++j)
-					sprintf(build_id + 2 * j, "%02x",
-						id_offs[i].build_id[j] & 0xff);
-				if (strstr(buf, build_id) != NULL)
+				if (memcmp(buf, id_offs[i].build_id, build_id_size) == 0)
 					build_id_matches = 1;
 			}
 		prev_key = key;
diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index a952d614ffbbd..513ee92e4f67c 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -583,31 +583,6 @@ int compare_stack_ips(int smap_fd, int amap_fd, int stack_trace_len)
 	return err;
 }
 
-int extract_build_id(char *build_id, size_t size)
-{
-	FILE *fp;
-	char *line = NULL;
-	size_t len = 0;
-
-	fp = popen("readelf -n ./urandom_read | grep 'Build ID'", "r");
-	if (fp == NULL)
-		return -1;
-
-	if (getline(&line, &len, fp) == -1)
-		goto err;
-	pclose(fp);
-
-	if (len > size)
-		len = size;
-	memcpy(build_id, line, len);
-	build_id[len] = '\0';
-	free(line);
-	return 0;
-err:
-	pclose(fp);
-	return -1;
-}
-
 static int finit_module(int fd, const char *param_values, int flags)
 {
 	return syscall(__NR_finit_module, fd, param_values, flags);
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index b090996daee5c..924764f6ba976 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -380,7 +380,6 @@ static inline void *u64_to_ptr(__u64 ptr)
 int bpf_find_map(const char *test, struct bpf_object *obj, const char *name);
 int compare_map_keys(int map1_fd, int map2_fd);
 int compare_stack_ips(int smap_fd, int amap_fd, int stack_trace_len);
-int extract_build_id(char *build_id, size_t size);
 int kern_sync_rcu(void);
 int trigger_module_test_read(int read_sz);
 int trigger_module_test_write(int write_sz);
-- 
2.43.0



