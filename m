Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD0478B73;
	Wed, 21 Feb 2024 13:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523546; cv=none; b=IVlOa39LSPCvzzeWg2w9YqU9j4OOKP5g5fu+8beFjl9d+/Ekkjh4qyvxzp7J2PGBu58BAbDtz/8MJyrSesfCLpVFOqkX+uzoxf/1Gw77e/GeNIs6U0Uj08eG2Kt4zkGfD34Ef+vZlAB3yqNgnIOjXHXuYe3gcTWFbO81Bk//rAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523546; c=relaxed/simple;
	bh=rzYFQLQVj6ZD5eU75DVP0UOO85A4RAvYdXzSz6TFIDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLSrzWIvbco+ks3VWYrORNhdwLJswz63Nc6veOd2bsgonrKbUoUPwMy5gP6GvZ++a8w6XnDxN3YPYm51E6HRon/mQT/bx9RnEM15SIzmd8BypnH+7acg2K4DKLGNZSlOYleKowCpuEPbqjUKDgWa9tm77VYBT97R3ZeXdzaQQGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/n11ySU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/n11ySU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F58C43394;
	Wed, 21 Feb 2024 13:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523546;
	bh=rzYFQLQVj6ZD5eU75DVP0UOO85A4RAvYdXzSz6TFIDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u/n11ySUqjAxRZQ/zXxsR3VBMsJHkbpLYrkIUFmrpnlcwJ33qzX0xw7exCsaDRY2+
	 3GwzZyoJdFZYeeT+vmCA2PDLxhhevF9OEsPlA9JsWWuK9ER6I9jNtfizILwLMpeqwO
	 GMb+Mv+14G2UL2b/UqSYHbg1XhDX1bRluMqe/7Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Subject: [PATCH 5.15 468/476] Revert "selftests/bpf: Test tail call counting with bpf2bpf and data on stack"
Date: Wed, 21 Feb 2024 14:08:39 +0100
Message-ID: <20240221130025.325787931@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

This reverts commit 3eefb2fbf4ec1c1ff239b8b65e6e78aae335e4a6.

libbpf support for "tc" progs doesn't exist for the linux-5.15.y tree.
This commit was backported too far back in upstream, to a kernel where
the libbpf support was not there for the test.

Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/tailcalls.c    |   55 ------------------
 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf6.c |   42 -------------
 2 files changed, 97 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf6.c

--- a/tools/testing/selftests/bpf/prog_tests/tailcalls.c
+++ b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
@@ -810,59 +810,6 @@ out:
 	bpf_object__close(obj);
 }
 
-#include "tailcall_bpf2bpf6.skel.h"
-
-/* Tail call counting works even when there is data on stack which is
- * not aligned to 8 bytes.
- */
-static void test_tailcall_bpf2bpf_6(void)
-{
-	struct tailcall_bpf2bpf6 *obj;
-	int err, map_fd, prog_fd, main_fd, data_fd, i, val;
-	LIBBPF_OPTS(bpf_test_run_opts, topts,
-		.data_in = &pkt_v4,
-		.data_size_in = sizeof(pkt_v4),
-		.repeat = 1,
-	);
-
-	obj = tailcall_bpf2bpf6__open_and_load();
-	if (!ASSERT_OK_PTR(obj, "open and load"))
-		return;
-
-	main_fd = bpf_program__fd(obj->progs.entry);
-	if (!ASSERT_GE(main_fd, 0, "entry prog fd"))
-		goto out;
-
-	map_fd = bpf_map__fd(obj->maps.jmp_table);
-	if (!ASSERT_GE(map_fd, 0, "jmp_table map fd"))
-		goto out;
-
-	prog_fd = bpf_program__fd(obj->progs.classifier_0);
-	if (!ASSERT_GE(prog_fd, 0, "classifier_0 prog fd"))
-		goto out;
-
-	i = 0;
-	err = bpf_map_update_elem(map_fd, &i, &prog_fd, BPF_ANY);
-	if (!ASSERT_OK(err, "jmp_table map update"))
-		goto out;
-
-	err = bpf_prog_test_run_opts(main_fd, &topts);
-	ASSERT_OK(err, "entry prog test run");
-	ASSERT_EQ(topts.retval, 0, "tailcall retval");
-
-	data_fd = bpf_map__fd(obj->maps.bss);
-	if (!ASSERT_GE(data_fd, 0, "bss map fd"))
-		goto out;
-
-	i = 0;
-	err = bpf_map_lookup_elem(data_fd, &i, &val);
-	ASSERT_OK(err, "bss map lookup");
-	ASSERT_EQ(val, 1, "done flag is set");
-
-out:
-	tailcall_bpf2bpf6__destroy(obj);
-}
-
 void test_tailcalls(void)
 {
 	if (test__start_subtest("tailcall_1"))
@@ -885,6 +832,4 @@ void test_tailcalls(void)
 		test_tailcall_bpf2bpf_4(false);
 	if (test__start_subtest("tailcall_bpf2bpf_5"))
 		test_tailcall_bpf2bpf_4(true);
-	if (test__start_subtest("tailcall_bpf2bpf_6"))
-		test_tailcall_bpf2bpf_6();
 }
--- a/tools/testing/selftests/bpf/progs/tailcall_bpf2bpf6.c
+++ /dev/null
@@ -1,42 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/bpf.h>
-#include <bpf/bpf_helpers.h>
-
-#define __unused __attribute__((unused))
-
-struct {
-	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
-	__uint(max_entries, 1);
-	__uint(key_size, sizeof(__u32));
-	__uint(value_size, sizeof(__u32));
-} jmp_table SEC(".maps");
-
-int done = 0;
-
-SEC("tc")
-int classifier_0(struct __sk_buff *skb __unused)
-{
-	done = 1;
-	return 0;
-}
-
-static __noinline
-int subprog_tail(struct __sk_buff *skb)
-{
-	/* Don't propagate the constant to the caller */
-	volatile int ret = 1;
-
-	bpf_tail_call_static(skb, &jmp_table, 0);
-	return ret;
-}
-
-SEC("tc")
-int entry(struct __sk_buff *skb)
-{
-	/* Have data on stack which size is not a multiple of 8 */
-	volatile char arr[1] = {};
-
-	return subprog_tail(skb);
-}
-
-char __license[] SEC("license") = "GPL";


