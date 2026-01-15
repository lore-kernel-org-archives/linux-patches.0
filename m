Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4C03570AE;
	Thu, 15 Jan 2026 17:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497018; cv=none; b=PyTtUBhmw66wdSFiBYUXJ5EJQxxQuhUq/8vaE9SSPEq9at4yjrOlDBCsHEMWKZDABuZ78e5oxfGoPv0yc02BbX9Y1wuYGlmQlzpdJGfm1cnyaLynhGegbnqf69PI1QDJC9MC9OiPX4iv1YYWQEZcfKgHmCAJg7woxb+NAORqA98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497018; c=relaxed/simple;
	bh=O+i+S4NUI/S6quMssdBXb3sPv0GmH3S8ifPWpBZG8Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6wSGkPaEbVjzYV2bMkm8E9U+6xlf+VMk5tZ5h4NBnJQyaK0gbJNwEKULTKOMY4N2rQJdUkru3ber8k4U3DkMrXbY+rTyL7RiuOJ5Mo93jK3myEE+gCB/H/0j+LmH/HsLt16qc9R3mv/nhdgr+U4THNhbdrH2xXyFtzAipoxUd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPVApTvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPVApTvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72644C116D0;
	Thu, 15 Jan 2026 17:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497017;
	bh=O+i+S4NUI/S6quMssdBXb3sPv0GmH3S8ifPWpBZG8Ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPVApTvGs1Q03AILcsCA0uN4YnWQw4G5N9UkZBMrUN0MYfX7Z3YyNgWNOsQPOgdOr
	 hx0ycNGkvub0qUDlEa5vbthpsdzP2Ho1piY1aaNeijVTDC4O1ymI2WBtazyWvfew98
	 vmirOzqQuBKHnaJ1qpIhieAbDU6xS3c7QNbWg9x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 73/88] bpf: Fix an issue in bpf_prog_test_run_xdp when page size greater than 4K
Date: Thu, 15 Jan 2026 17:48:56 +0100
Message-ID: <20260115164148.961091883@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 4fc012daf9c074772421c904357abf586336b1ca ]

The bpf selftest xdp_adjust_tail/xdp_adjust_frags_tail_grow failed on
arm64 with 64KB page:
   xdp_adjust_tail/xdp_adjust_frags_tail_grow:FAIL

In bpf_prog_test_run_xdp(), the xdp->frame_sz is set to 4K, but later on
when constructing frags, with 64K page size, the frag data_len could
be more than 4K. This will cause problems in bpf_xdp_frags_increase_tail().

To fix the failure, the xdp->frame_sz is set to be PAGE_SIZE so kernel
can test different page size properly. With the kernel change, the user
space and bpf prog needs adjustment. Currently, the MAX_SKB_FRAGS default
value is 17, so for 4K page, the maximum packet size will be less than 68K.
To test 64K page, a bigger maximum packet size than 68K is desired. So two
different functions are implemented for subtest xdp_adjust_frags_tail_grow.
Depending on different page size, different data input/output sizes are used
to adapt with different page size.

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20250612035032.2207498-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: e558cca21779 ("bpf, test_run: Subtract size of xdp_frame from allowed metadata size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c                            |  2 +-
 .../bpf/prog_tests/xdp_adjust_tail.c          | 96 +++++++++++++++++--
 .../bpf/progs/test_xdp_adjust_tail_grow.c     |  8 +-
 3 files changed, 97 insertions(+), 9 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 73fb9db55798c..373ccb243545f 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1192,7 +1192,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		headroom -= ctx->data;
 	}
 
-	max_data_sz = 4096 - headroom - tailroom;
+	max_data_sz = PAGE_SIZE - headroom - tailroom;
 	if (size > max_data_sz) {
 		/* disallow live data mode for jumbo frames */
 		if (do_live)
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
index 53d6ad8c2257e..df90f5b4cee58 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -37,21 +37,26 @@ static void test_xdp_adjust_tail_shrink(void)
 	bpf_object__close(obj);
 }
 
-static void test_xdp_adjust_tail_grow(void)
+static void test_xdp_adjust_tail_grow(bool is_64k_pagesize)
 {
 	const char *file = "./test_xdp_adjust_tail_grow.bpf.o";
 	struct bpf_object *obj;
-	char buf[4096]; /* avoid segfault: large buf to hold grow results */
+	char buf[8192]; /* avoid segfault: large buf to hold grow results */
 	__u32 expect_sz;
 	int err, prog_fd;
 	LIBBPF_OPTS(bpf_test_run_opts, topts,
 		.data_in = &pkt_v4,
-		.data_size_in = sizeof(pkt_v4),
 		.data_out = buf,
 		.data_size_out = sizeof(buf),
 		.repeat = 1,
 	);
 
+	/* topts.data_size_in as a special signal to bpf prog */
+	if (is_64k_pagesize)
+		topts.data_size_in = sizeof(pkt_v4) - 1;
+	else
+		topts.data_size_in = sizeof(pkt_v4);
+
 	err = bpf_prog_test_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
 	if (!ASSERT_OK(err, "test_xdp_adjust_tail_grow"))
 		return;
@@ -206,7 +211,7 @@ static void test_xdp_adjust_frags_tail_shrink(void)
 	bpf_object__close(obj);
 }
 
-static void test_xdp_adjust_frags_tail_grow(void)
+static void test_xdp_adjust_frags_tail_grow_4k(void)
 {
 	const char *file = "./test_xdp_adjust_tail_grow.bpf.o";
 	__u32 exp_size;
@@ -271,16 +276,93 @@ static void test_xdp_adjust_frags_tail_grow(void)
 	bpf_object__close(obj);
 }
 
+static void test_xdp_adjust_frags_tail_grow_64k(void)
+{
+	const char *file = "./test_xdp_adjust_tail_grow.bpf.o";
+	__u32 exp_size;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	int err, i, prog_fd;
+	__u8 *buf;
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
+
+	obj = bpf_object__open(file);
+	if (libbpf_get_error(obj))
+		return;
+
+	prog = bpf_object__next_program(obj, NULL);
+	if (bpf_object__load(obj))
+		goto out;
+
+	prog_fd = bpf_program__fd(prog);
+
+	buf = malloc(262144);
+	if (!ASSERT_OK_PTR(buf, "alloc buf 256Kb"))
+		goto out;
+
+	/* Test case add 10 bytes to last frag */
+	memset(buf, 1, 262144);
+	exp_size = 90000 + 10;
+
+	topts.data_in = buf;
+	topts.data_out = buf;
+	topts.data_size_in = 90000;
+	topts.data_size_out = 262144;
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+
+	ASSERT_OK(err, "90Kb+10b");
+	ASSERT_EQ(topts.retval, XDP_TX, "90Kb+10b retval");
+	ASSERT_EQ(topts.data_size_out, exp_size, "90Kb+10b size");
+
+	for (i = 0; i < 90000; i++) {
+		if (buf[i] != 1)
+			ASSERT_EQ(buf[i], 1, "90Kb+10b-old");
+	}
+
+	for (i = 90000; i < 90010; i++) {
+		if (buf[i] != 0)
+			ASSERT_EQ(buf[i], 0, "90Kb+10b-new");
+	}
+
+	for (i = 90010; i < 262144; i++) {
+		if (buf[i] != 1)
+			ASSERT_EQ(buf[i], 1, "90Kb+10b-untouched");
+	}
+
+	/* Test a too large grow */
+	memset(buf, 1, 262144);
+	exp_size = 90001;
+
+	topts.data_in = topts.data_out = buf;
+	topts.data_size_in = 90001;
+	topts.data_size_out = 262144;
+	err = bpf_prog_test_run_opts(prog_fd, &topts);
+
+	ASSERT_OK(err, "90Kb+10b");
+	ASSERT_EQ(topts.retval, XDP_DROP, "90Kb+10b retval");
+	ASSERT_EQ(topts.data_size_out, exp_size, "90Kb+10b size");
+
+	free(buf);
+out:
+	bpf_object__close(obj);
+}
+
 void test_xdp_adjust_tail(void)
 {
+	int page_size = getpagesize();
+
 	if (test__start_subtest("xdp_adjust_tail_shrink"))
 		test_xdp_adjust_tail_shrink();
 	if (test__start_subtest("xdp_adjust_tail_grow"))
-		test_xdp_adjust_tail_grow();
+		test_xdp_adjust_tail_grow(page_size == 65536);
 	if (test__start_subtest("xdp_adjust_tail_grow2"))
 		test_xdp_adjust_tail_grow2();
 	if (test__start_subtest("xdp_adjust_frags_tail_shrink"))
 		test_xdp_adjust_frags_tail_shrink();
-	if (test__start_subtest("xdp_adjust_frags_tail_grow"))
-		test_xdp_adjust_frags_tail_grow();
+	if (test__start_subtest("xdp_adjust_frags_tail_grow")) {
+		if (page_size == 65536)
+			test_xdp_adjust_frags_tail_grow_64k();
+		else
+			test_xdp_adjust_frags_tail_grow_4k();
+	}
 }
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c b/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c
index 81bb38d72cedd..e311e206be072 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_adjust_tail_grow.c
@@ -17,7 +17,9 @@ int _xdp_adjust_tail_grow(struct xdp_md *xdp)
 	/* Data length determine test case */
 
 	if (data_len == 54) { /* sizeof(pkt_v4) */
-		offset = 4096; /* test too large offset */
+		offset = 4096; /* test too large offset, 4k page size */
+	} else if (data_len == 53) { /* sizeof(pkt_v4) - 1 */
+		offset = 65536; /* test too large offset, 64k page size */
 	} else if (data_len == 74) { /* sizeof(pkt_v6) */
 		offset = 40;
 	} else if (data_len == 64) {
@@ -29,6 +31,10 @@ int _xdp_adjust_tail_grow(struct xdp_md *xdp)
 		offset = 10;
 	} else if (data_len == 9001) {
 		offset = 4096;
+	} else if (data_len == 90000) {
+		offset = 10; /* test a small offset, 64k page size */
+	} else if (data_len == 90001) {
+		offset = 65536; /* test too large offset, 64k page size */
 	} else {
 		return XDP_ABORTED; /* No matching test */
 	}
-- 
2.51.0



