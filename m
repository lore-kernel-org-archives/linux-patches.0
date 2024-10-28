Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175D518E348;
	Mon, 28 Oct 2024 06:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097490; cv=none; b=uFEO3jkvlY2JcKCx9C0339F370J5xHuWgCwjRmQ7STJRo44uS9XNQCMdjiayr7V0UaFShXE0gZANfYKbDzhaXJutX91SZnk5aZihHgRL0QgDHhT2+VcaxTeC7x0Dpa+aRZRyQfxgAy4QUPlxhTvhFdGsR7/e+3mgD0kWwtfLY+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097490; c=relaxed/simple;
	bh=2nIE7uJr+WmHS9cD4x8CwFfUcFB24Li7JlpjokoxErs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iSdjm+8goCOO/Wyp7YJEykDqwPb4/hszdrWcNhnrdQtGT8uAi3ldWYho7pg+1SiCxCbtioLXDdctn1jCRyxJnX7hZuqEC6e6mbv5UypedADnzni+DTVMnbiKezmoNa/5SfUxAOZE9qMoBr+Pn6iB1QkZZWgDRGil6ZpV06QlP2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5OSrDq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5OSrDq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA74CC4CEC3;
	Mon, 28 Oct 2024 06:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097490;
	bh=2nIE7uJr+WmHS9cD4x8CwFfUcFB24Li7JlpjokoxErs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5OSrDq1Uezk5w/F4ZkTPPuYGVFw+6WBY5ppg76txjN0yRl4gT75OJVQnz5nlCeMF
	 /9WXBM8osjQwxtfgeLDHEoreE3qkV3JpXnkjSMW5cXreCHBTcF8hDKUZd6ldscjh2q
	 /oKXuQi9AijP+BT80wjuFqu6BamxKmGUezQhKRj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Yafang Shao <laoar.shao@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/208] selftests/bpf: Use bpf_link__destroy in fill_link_info tests
Date: Mon, 28 Oct 2024 07:23:16 +0100
Message-ID: <20241028062307.058263939@linuxfoundation.org>
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

[ Upstream commit 1703612885723869064f18e8816c6f3f87987748 ]

The fill_link_info test keeps skeleton open and just creates
various links. We are wrongly calling bpf_link__detach after
each test to close them, we need to call bpf_link__destroy.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
Link: https://lore.kernel.org/bpf/20231125193130.834322-5-jolsa@kernel.org
Stable-dep-of: 4538a38f654a ("selftests/bpf: fix perf_event link info name_len assertion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/fill_link_info.c | 44 ++++++++++---------
 1 file changed, 23 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/fill_link_info.c b/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
index 9d768e0837149..7db7f9bd9d58e 100644
--- a/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
+++ b/tools/testing/selftests/bpf/prog_tests/fill_link_info.c
@@ -140,14 +140,14 @@ static void test_kprobe_fill_link_info(struct test_fill_link_info *skel,
 		.retprobe = type == BPF_PERF_EVENT_KRETPROBE,
 	);
 	ssize_t entry_offset = 0;
+	struct bpf_link *link;
 	int link_fd, err;
 
-	skel->links.kprobe_run = bpf_program__attach_kprobe_opts(skel->progs.kprobe_run,
-								 KPROBE_FUNC, &opts);
-	if (!ASSERT_OK_PTR(skel->links.kprobe_run, "attach_kprobe"))
+	link = bpf_program__attach_kprobe_opts(skel->progs.kprobe_run, KPROBE_FUNC, &opts);
+	if (!ASSERT_OK_PTR(link, "attach_kprobe"))
 		return;
 
-	link_fd = bpf_link__fd(skel->links.kprobe_run);
+	link_fd = bpf_link__fd(link);
 	if (!invalid) {
 		/* See also arch_adjust_kprobe_addr(). */
 		if (skel->kconfig->CONFIG_X86_KERNEL_IBT)
@@ -157,39 +157,41 @@ static void test_kprobe_fill_link_info(struct test_fill_link_info *skel,
 	} else {
 		kprobe_fill_invalid_user_buffer(link_fd);
 	}
-	bpf_link__detach(skel->links.kprobe_run);
+	bpf_link__destroy(link);
 }
 
 static void test_tp_fill_link_info(struct test_fill_link_info *skel)
 {
+	struct bpf_link *link;
 	int link_fd, err;
 
-	skel->links.tp_run = bpf_program__attach_tracepoint(skel->progs.tp_run, TP_CAT, TP_NAME);
-	if (!ASSERT_OK_PTR(skel->links.tp_run, "attach_tp"))
+	link = bpf_program__attach_tracepoint(skel->progs.tp_run, TP_CAT, TP_NAME);
+	if (!ASSERT_OK_PTR(link, "attach_tp"))
 		return;
 
-	link_fd = bpf_link__fd(skel->links.tp_run);
+	link_fd = bpf_link__fd(link);
 	err = verify_perf_link_info(link_fd, BPF_PERF_EVENT_TRACEPOINT, 0, 0, 0);
 	ASSERT_OK(err, "verify_perf_link_info");
-	bpf_link__detach(skel->links.tp_run);
+	bpf_link__destroy(link);
 }
 
 static void test_uprobe_fill_link_info(struct test_fill_link_info *skel,
 				       enum bpf_perf_event_type type)
 {
+	struct bpf_link *link;
 	int link_fd, err;
 
-	skel->links.uprobe_run = bpf_program__attach_uprobe(skel->progs.uprobe_run,
-							    type == BPF_PERF_EVENT_URETPROBE,
-							    0, /* self pid */
-							    UPROBE_FILE, uprobe_offset);
-	if (!ASSERT_OK_PTR(skel->links.uprobe_run, "attach_uprobe"))
+	link = bpf_program__attach_uprobe(skel->progs.uprobe_run,
+					  type == BPF_PERF_EVENT_URETPROBE,
+					  0, /* self pid */
+					  UPROBE_FILE, uprobe_offset);
+	if (!ASSERT_OK_PTR(link, "attach_uprobe"))
 		return;
 
-	link_fd = bpf_link__fd(skel->links.uprobe_run);
+	link_fd = bpf_link__fd(link);
 	err = verify_perf_link_info(link_fd, type, 0, uprobe_offset, 0);
 	ASSERT_OK(err, "verify_perf_link_info");
-	bpf_link__detach(skel->links.uprobe_run);
+	bpf_link__destroy(link);
 }
 
 static int verify_kmulti_link_info(int fd, bool retprobe)
@@ -278,24 +280,24 @@ static void test_kprobe_multi_fill_link_info(struct test_fill_link_info *skel,
 					     bool retprobe, bool invalid)
 {
 	LIBBPF_OPTS(bpf_kprobe_multi_opts, opts);
+	struct bpf_link *link;
 	int link_fd, err;
 
 	opts.syms = kmulti_syms;
 	opts.cnt = KMULTI_CNT;
 	opts.retprobe = retprobe;
-	skel->links.kmulti_run = bpf_program__attach_kprobe_multi_opts(skel->progs.kmulti_run,
-								       NULL, &opts);
-	if (!ASSERT_OK_PTR(skel->links.kmulti_run, "attach_kprobe_multi"))
+	link = bpf_program__attach_kprobe_multi_opts(skel->progs.kmulti_run, NULL, &opts);
+	if (!ASSERT_OK_PTR(link, "attach_kprobe_multi"))
 		return;
 
-	link_fd = bpf_link__fd(skel->links.kmulti_run);
+	link_fd = bpf_link__fd(link);
 	if (!invalid) {
 		err = verify_kmulti_link_info(link_fd, retprobe);
 		ASSERT_OK(err, "verify_kmulti_link_info");
 	} else {
 		verify_kmulti_invalid_user_buffer(link_fd);
 	}
-	bpf_link__detach(skel->links.kmulti_run);
+	bpf_link__destroy(link);
 }
 
 void test_fill_link_info(void)
-- 
2.43.0



