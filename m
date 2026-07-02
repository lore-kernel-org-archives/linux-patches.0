Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C12336897;
	Thu,  2 Jul 2026 16:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010749; cv=none; b=IQTpRPoeoHsYP6gz3FU3CG6bhoem2NhmxujBU9eiXn0WIc3ujlTqFt4MnPD1psAwqdJOnebtkhY5hOCuGsc0yQ65VZDGAWyhIxI7uoJgRtbMRSvw9Qz4NZozQHGh1QBTdKrFT5sS8SL2DXcDWDTCzYQiY0ArVGA06kibchFkSJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010749; c=relaxed/simple;
	bh=qX3s4VM/7CMWHJ/Xtnp+CjIQVi0QuAdur7kbtJufcVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgDIg0UZ4tJwLS/4IyljVy68lJU7CedC0k6U/HCOZLt+7AEgArFYoCSKryfkyFeyEFgBTLUIlqbpqRLIlw7EfS8chfJ1guwqJQFsSSNa+JSbhPokKA+zZB8YuGkUF87tMiPO35YefgSnOvf5kT7VHpx9UlDfyTnWeCfGrfOboGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+E7Oc4I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+E7Oc4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8737F1F00A3A;
	Thu,  2 Jul 2026 16:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010748;
	bh=5UnREXNPO1Co2HKzEi64MahpSV0unsFrYEOHaC2p3y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+E7Oc4I/tVKB8YQNwAQ73u89ddNri54oW0elfpjhdiHOhCWzGbFwsq1/Y7ur7FKv
	 jpbZ6q7IGHpWDWi/9CIdfimSxKTnGlIoEMVUB1KF0H8yKo7GmWvornliqEDNDtYwXA
	 gik49drqMgXc2aVc6N9YIuYijfth63W8Ecacxhzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Varun R Mallya <varunrmallya@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/175] selftests/bpf: Add test to ensure kprobe_multi is not sleepable
Date: Thu,  2 Jul 2026 18:18:43 +0200
Message-ID: <20260702155116.254578541@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Varun R Mallya <varunrmallya@gmail.com>

commit c7cab53f9d5273f0cf2a26bdf178c4e074bdfb50 upstream.

Add a selftest to ensure that kprobe_multi programs cannot be attached
using the BPF_F_SLEEPABLE flag. This test succeeds when the kernel
rejects attachment of kprobe_multi when the BPF_F_SLEEPABLE flag is set.

Suggested-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Varun R Mallya <varunrmallya@gmail.com>
Link: https://lore.kernel.org/r/20260408190137.101418-3-varunrmallya@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[shung-hsi.yu: borrowed 'saved_error' variable from commit 00cdcd2900bd
("selftests/bpf: Don't use libbpf_get_error() in kprobe_multi_test"). ]
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/prog_tests/kprobe_multi_test.c        | 34 +++++++++++++++++++
 .../bpf/progs/kprobe_multi_sleepable.c        | 25 ++++++++++++++
 2 files changed, 59 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi_sleepable.c

diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index 4041cfa670eb4c..d41e140c315083 100644
--- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -4,6 +4,7 @@
 #include "trace_helpers.h"
 #include "kprobe_multi_empty.skel.h"
 #include "kprobe_multi_override.skel.h"
+#include "kprobe_multi_sleepable.skel.h"
 #include "bpf/libbpf_internal.h"
 #include "bpf/hashmap.h"
 
@@ -214,7 +215,9 @@ static void test_attach_api_syms(void)
 static void test_attach_api_fails(void)
 {
 	LIBBPF_OPTS(bpf_kprobe_multi_opts, opts);
+	LIBBPF_OPTS(bpf_test_run_opts, topts);
 	struct kprobe_multi *skel = NULL;
+	struct kprobe_multi_sleepable *sl_skel = NULL;
 	struct bpf_link *link = NULL;
 	unsigned long long addrs[2];
 	const char *syms[2] = {
@@ -222,6 +225,7 @@ static void test_attach_api_fails(void)
 		"bpf_fentry_test2",
 	};
 	__u64 cookies[2];
+	int saved_error, err;
 
 	addrs[0] = ksym_get_addr("bpf_fentry_test1");
 	addrs[1] = ksym_get_addr("bpf_fentry_test2");
@@ -300,9 +304,39 @@ static void test_attach_api_fails(void)
 	if (!ASSERT_EQ(libbpf_get_error(link), -EINVAL, "fail_5_error"))
 		goto cleanup;
 
+	/* fail_9 - sleepable kprobe multi should not attach */
+	sl_skel = kprobe_multi_sleepable__open();
+	if (!ASSERT_OK_PTR(sl_skel, "sleep_skel_open"))
+		goto cleanup;
+
+	sl_skel->bss->user_ptr = sl_skel;
+
+	err = bpf_program__set_flags(sl_skel->progs.handle_kprobe_multi_sleepable,
+				     BPF_F_SLEEPABLE);
+	if (!ASSERT_OK(err, "sleep_skel_set_flags"))
+		goto cleanup;
+
+	err = kprobe_multi_sleepable__load(sl_skel);
+	if (!ASSERT_OK(err, "sleep_skel_load"))
+		goto cleanup;
+
+	link = bpf_program__attach_kprobe_multi_opts(sl_skel->progs.handle_kprobe_multi_sleepable,
+						     "bpf_fentry_test1", NULL);
+	saved_error = -errno;
+
+	if (!ASSERT_ERR_PTR(link, "fail_9"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(saved_error, -EINVAL, "fail_9_error"))
+		goto cleanup;
+
+	err = bpf_prog_test_run_opts(bpf_program__fd(sl_skel->progs.fentry), &topts);
+	ASSERT_OK(err, "bpf_prog_test_run_opts");
+
 cleanup:
 	bpf_link__destroy(link);
 	kprobe_multi__destroy(skel);
+	kprobe_multi_sleepable__destroy(sl_skel);
 }
 
 static size_t symbol_hash(long key, void *ctx __maybe_unused)
diff --git a/tools/testing/selftests/bpf/progs/kprobe_multi_sleepable.c b/tools/testing/selftests/bpf/progs/kprobe_multi_sleepable.c
new file mode 100644
index 00000000000000..932e1d9c72e2d0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/kprobe_multi_sleepable.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+void *user_ptr = 0;
+
+SEC("kprobe.multi")
+int handle_kprobe_multi_sleepable(struct pt_regs *ctx)
+{
+	int a, err;
+
+	err = bpf_copy_from_user(&a, sizeof(a), user_ptr);
+	barrier_var(a);
+	return err;
+}
+
+SEC("fentry/bpf_fentry_test1")
+int BPF_PROG(fentry)
+{
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.53.0



