Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A8518C03D;
	Mon, 28 Oct 2024 06:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097492; cv=none; b=g5QGEk9eOJjYpo6CPV5OiePrKbFfxFOFQre//usCK1qap/5r2N1k2vWuSVrnCoKRSgfanZ1VQeu79d/CVpZt1o76/5ChkUyBtyrILIk1FVPd6gVjywF6EGTDMSy3aPkjRXHpbO4JyBTFUPN3X4FREYxzUOtUAoTktpc92TTji9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097492; c=relaxed/simple;
	bh=xvuClqpS7sVb8zhWL8bZ5nOcg7AbkmM/EnMWsQwdr1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFy+CAe+D2TZKLWEk7tiP0KEwvM2+iP8Dnf2Rm3YhsNz2xoj6kIiOcpHLbUAXVSqC/mYz9ddhJY5PKk/ndu/SZyVykneyzM1MfXVNo4jlTY8zTJDsJaaqUJrbe6zLhnWmAKSOsyRnlgedUav/AELTC0LBPp4JtlnK0htNFoL2G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yAKZscu2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yAKZscu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A34C4CEC3;
	Mon, 28 Oct 2024 06:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097492;
	bh=xvuClqpS7sVb8zhWL8bZ5nOcg7AbkmM/EnMWsQwdr1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yAKZscu2GGtPS3UM+o/LDTPnh9fzSwwDwtOpMokI+DQ7i3aCXN9stEDnnNtNqd9Ae
	 u0Bm3XeWxIcS1yfNNz0LDEuZnKy98Zlf65q5wUkrHFj8QUZYyE73uBgxazWFOnzX1j
	 oBLwQiyrWC6ZDiD6rgG1J9qp8xag5ddJHSLet8bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/208] selftests/bpf: Add cookies check for perf_event fill_link_info test
Date: Mon, 28 Oct 2024 07:23:17 +0100
Message-ID: <20241028062307.083165221@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit d74179708473c649c653f1db280e29875a532e99 ]

Now that we get cookies for perf_event probes, adding tests
for cookie for kprobe/uprobe/tracepoint.

The perf_event test needs to be added completely and is coming
in following change.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240119110505.400573-6-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 4538a38f654a ("selftests/bpf: fix perf_event link info name_len assertion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/fill_link_info.c | 26 +++++++++++++++----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fill_link_info.c b/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
index 7db7f9bd9d58e..9eb93258614f9 100644
--- a/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
+++ b/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
@@ -30,6 +30,8 @@ static noinline void uprobe_func(void)
 	asm volatile ("");
 }
 
+#define PERF_EVENT_COOKIE 0xdeadbeef
+
 static int verify_perf_link_info(int fd, enum bpf_perf_event_type type, long addr,
 				 ssize_t offset, ssize_t entry_offset)
 {
@@ -61,6 +63,8 @@ static int verify_perf_link_info(int fd, enum bpf_perf_event_type type, long add
 			ASSERT_EQ(info.perf_event.kprobe.addr, addr + entry_offset,
 				  "kprobe_addr");
 
+		ASSERT_EQ(info.perf_event.kprobe.cookie, PERF_EVENT_COOKIE, "kprobe_cookie");
+
 		if (!info.perf_event.kprobe.func_name) {
 			ASSERT_EQ(info.perf_event.kprobe.name_len, 0, "name_len");
 			info.perf_event.kprobe.func_name = ptr_to_u64(&buf);
@@ -80,6 +84,8 @@ static int verify_perf_link_info(int fd, enum bpf_perf_event_type type, long add
 			goto again;
 		}
 
+		ASSERT_EQ(info.perf_event.tracepoint.cookie, PERF_EVENT_COOKIE, "tracepoint_cookie");
+
 		err = strncmp(u64_to_ptr(info.perf_event.tracepoint.tp_name), TP_NAME,
 			      strlen(TP_NAME));
 		ASSERT_EQ(err, 0, "cmp_tp_name");
@@ -95,6 +101,8 @@ static int verify_perf_link_info(int fd, enum bpf_perf_event_type type, long add
 			goto again;
 		}
 
+		ASSERT_EQ(info.perf_event.uprobe.cookie, PERF_EVENT_COOKIE, "uprobe_cookie");
+
 		err = strncmp(u64_to_ptr(info.perf_event.uprobe.file_name), UPROBE_FILE,
 			      strlen(UPROBE_FILE));
 			ASSERT_EQ(err, 0, "cmp_file_name");
@@ -138,6 +146,7 @@ static void test_kprobe_fill_link_info(struct test_fill_link_info *skel,
 	DECLARE_LIBBPF_OPTS(bpf_kprobe_opts, opts,
 		.attach_mode = PROBE_ATTACH_MODE_LINK,
 		.retprobe = type == BPF_PERF_EVENT_KRETPROBE,
+		.bpf_cookie = PERF_EVENT_COOKIE,
 	);
 	ssize_t entry_offset = 0;
 	struct bpf_link *link;
@@ -162,10 +171,13 @@ static void test_kprobe_fill_link_info(struct test_fill_link_info *skel,
 
 static void test_tp_fill_link_info(struct test_fill_link_info *skel)
 {
+	DECLARE_LIBBPF_OPTS(bpf_tracepoint_opts, opts,
+		.bpf_cookie = PERF_EVENT_COOKIE,
+	);
 	struct bpf_link *link;
 	int link_fd, err;
 
-	link = bpf_program__attach_tracepoint(skel->progs.tp_run, TP_CAT, TP_NAME);
+	link = bpf_program__attach_tracepoint_opts(skel->progs.tp_run, TP_CAT, TP_NAME, &opts);
 	if (!ASSERT_OK_PTR(link, "attach_tp"))
 		return;
 
@@ -178,13 +190,17 @@ static void test_tp_fill_link_info(struct test_fill_link_info *skel)
 static void test_uprobe_fill_link_info(struct test_fill_link_info *skel,
 				       enum bpf_perf_event_type type)
 {
+	DECLARE_LIBBPF_OPTS(bpf_uprobe_opts, opts,
+		.retprobe = type == BPF_PERF_EVENT_URETPROBE,
+		.bpf_cookie = PERF_EVENT_COOKIE,
+	);
 	struct bpf_link *link;
 	int link_fd, err;
 
-	link = bpf_program__attach_uprobe(skel->progs.uprobe_run,
-					  type == BPF_PERF_EVENT_URETPROBE,
-					  0, /* self pid */
-					  UPROBE_FILE, uprobe_offset);
+	link = bpf_program__attach_uprobe_opts(skel->progs.uprobe_run,
+					       0, /* self pid */
+					       UPROBE_FILE, uprobe_offset,
+					       &opts);
 	if (!ASSERT_OK_PTR(link, "attach_uprobe"))
 		return;
 
-- 
2.43.0



