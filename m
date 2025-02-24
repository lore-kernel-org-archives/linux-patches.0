Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15B4146A63;
	Mon, 24 Feb 2025 14:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408533; cv=none; b=mbMELjIa+IYxK3tzw2iKMasDAFvHJ/8tRKQit5cMnKWhZkbuazQMQ6/H14g72pSie+SPReVaXSXa7waqEImevePR1LXglVoS56y1qxLOis3Jqz0O2mKUCF9dm0LmHJ6K78bzAw9oNopmwc/MB72zrmybpnIDEY+WK4wreAHfYzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408533; c=relaxed/simple;
	bh=efl7r/jRX17MuKHd7GnKCHWw4rS0hP1fzi5tShJxnyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+LHJKRo8VY4/9nb89Sx14Z/SSeJkLPrzRKXvdvKeG6tlOJCOCpX0jR2HfRj6Xe3T3eaHR/xh73hpg+/LSZLPlVXUYyAJ0NVwKOogPhlL7gYoIq/3dajaswc2xOfl6LbG5IEDPvwnhs6BxF8EOFBrrED9lsZIDSbywF4vXsP3K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zYiAS+UJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYiAS+UJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D34BC4CED6;
	Mon, 24 Feb 2025 14:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408532;
	bh=efl7r/jRX17MuKHd7GnKCHWw4rS0hP1fzi5tShJxnyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYiAS+UJ2xRXPKgBmMrNn4ZrdInNPvKgfOppPQeqfDV0k86WuRHAGdtOn7WZvelYW
	 /XeJUBYMms3l/PWch/Iqw/+zv0JKi7bPEmJj2sOgfXaq8tHac7jaNG3plrsmbx3/Qj
	 oC3jK2xvmm8YBQkoETE4MOjr56AqMAZsSQVVWUWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/154] selftests/bpf: Add tests for raw_tp null handling
Date: Mon, 24 Feb 2025 15:34:43 +0100
Message-ID: <20250224142610.366275364@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit d798ce3f4cab1b0d886b19ec5cc8e6b3d7e35081 ]

Ensure that trusted PTR_TO_BTF_ID accesses perform PROBE_MEM handling in
raw_tp program. Without the previous fix, this selftest crashes the
kernel due to a NULL-pointer dereference. Also ensure that dead code
elimination does not kick in for checks on the pointer.

Reviewed-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20241104171959.2938862-4-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 5da7e15fb5a1 ("net: Add rx_skb of kfree_skb to raw_tp_null_args[].")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/bpf_testmod/bpf_testmod-events.h      |  8 +++++
 .../selftests/bpf/bpf_testmod/bpf_testmod.c   |  2 ++
 .../selftests/bpf/prog_tests/raw_tp_null.c    | 25 +++++++++++++++
 .../testing/selftests/bpf/progs/raw_tp_null.c | 32 +++++++++++++++++++
 4 files changed, 67 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/raw_tp_null.c
 create mode 100644 tools/testing/selftests/bpf/progs/raw_tp_null.c

diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
index 6c3b4d4f173ac..aeef86b3da747 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
@@ -40,6 +40,14 @@ DECLARE_TRACE(bpf_testmod_test_nullable_bare,
 	TP_ARGS(ctx__nullable)
 );
 
+struct sk_buff;
+
+DECLARE_TRACE(bpf_testmod_test_raw_tp_null,
+	TP_PROTO(struct sk_buff *skb),
+	TP_ARGS(skb)
+);
+
+
 #undef BPF_TESTMOD_DECLARE_TRACE
 #ifdef DECLARE_TRACE_WRITABLE
 #define BPF_TESTMOD_DECLARE_TRACE(call, proto, args, size) \
diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
index 8835761d9a126..4e6a9e9c03687 100644
--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -380,6 +380,8 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 
 	(void)bpf_testmod_test_arg_ptr_to_struct(&struct_arg1_2);
 
+	(void)trace_bpf_testmod_test_raw_tp_null(NULL);
+
 	struct_arg3 = kmalloc((sizeof(struct bpf_testmod_struct_arg_3) +
 				sizeof(int)), GFP_KERNEL);
 	if (struct_arg3 != NULL) {
diff --git a/tools/testing/selftests/bpf/prog_tests/raw_tp_null.c b/tools/testing/selftests/bpf/prog_tests/raw_tp_null.c
new file mode 100644
index 0000000000000..6fa19449297e9
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/raw_tp_null.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2024 Meta Platforms, Inc. and affiliates. */
+
+#include <test_progs.h>
+#include "raw_tp_null.skel.h"
+
+void test_raw_tp_null(void)
+{
+	struct raw_tp_null *skel;
+
+	skel = raw_tp_null__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "raw_tp_null__open_and_load"))
+		return;
+
+	skel->bss->tid = sys_gettid();
+
+	if (!ASSERT_OK(raw_tp_null__attach(skel), "raw_tp_null__attach"))
+		goto end;
+
+	ASSERT_OK(trigger_module_test_read(2), "trigger testmod read");
+	ASSERT_EQ(skel->bss->i, 3, "invocations");
+
+end:
+	raw_tp_null__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/raw_tp_null.c b/tools/testing/selftests/bpf/progs/raw_tp_null.c
new file mode 100644
index 0000000000000..457f34c151e32
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/raw_tp_null.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2024 Meta Platforms, Inc. and affiliates. */
+
+#include <vmlinux.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+int tid;
+int i;
+
+SEC("tp_btf/bpf_testmod_test_raw_tp_null")
+int BPF_PROG(test_raw_tp_null, struct sk_buff *skb)
+{
+	struct task_struct *task = bpf_get_current_task_btf();
+
+	if (task->pid != tid)
+		return 0;
+
+	i = i + skb->mark + 1;
+	/* The compiler may move the NULL check before this deref, which causes
+	 * the load to fail as deref of scalar. Prevent that by using a barrier.
+	 */
+	barrier();
+	/* If dead code elimination kicks in, the increment below will
+	 * be removed. For raw_tp programs, we mark input arguments as
+	 * PTR_MAYBE_NULL, so branch prediction should never kick in.
+	 */
+	if (!skb)
+		i += 2;
+	return 0;
+}
-- 
2.39.5



