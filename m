Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C59F1632DA;
	Wed,  5 Feb 2025 15:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768315; cv=none; b=K5P7cOiJevn0I4/P5oljve8r48SCTK4NAblWB5p1p5LD8QW2U6ZhHxo2KoZUA0dWEoImOPSWR0KESWRIYMkTF+6GAQwFVHSzEEGLZnlL//C+Rru7K8pjZzSFV0Akr/OSi3w50pE5TjrFonM9GsmI2pCuNAw4Rh6WpsL8Swx+ZVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768315; c=relaxed/simple;
	bh=JrFJ0BTv9jrvRmqlt1oK3M3qv8qLBBRJuKSnvrrTiDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0vWNR/CJFArsyqOUHJdrU/lefSx7qn4YlWvNRLVCAy/OWvRvwKhaChZ2e70Vn7ImdlUd7rqHv5Jsy3qbaSFhzkv+XennZ43aZJQXrg2xTqCRr7tHdxo1Up9X/1MTHeZsxYu/dT5S9BMZnBm8kFqO6S2Gm0wtGwk6OuygED9U6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5OhJKeO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5OhJKeO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0EB9C4CED1;
	Wed,  5 Feb 2025 15:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768315;
	bh=JrFJ0BTv9jrvRmqlt1oK3M3qv8qLBBRJuKSnvrrTiDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5OhJKeO9D1hj+KnZF11YhD0xNM4BIPraIaK+EKjqqQ3ePX9hb2sg56eIV8Za/a4C
	 KslxynHuti53c7EausHUwuadCT7GfIgubKjUkC9NXuIhNdGUkG1GtVo+A5ptlFkybI
	 vd6kPceBcsC4Fp6gjk/N5H1kQ87HDE7kaQmZyEBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Yifei Liu <yifei.l.liu@oracle.com>
Subject: [PATCH 6.12 583/590] selftests/bpf: Add test to verify tailcall and freplace restrictions
Date: Wed,  5 Feb 2025 14:45:38 +0100
Message-ID: <20250205134517.568156238@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Leon Hwang <leon.hwang@linux.dev>

commit 021611d33e78694f4bd54573093c6fc70a812644 upstream.

Add a test case to ensure that attaching a tail callee program with an
freplace program fails, and that updating an extended program to a
prog_array map is also prohibited.

This test is designed to prevent the potential infinite loop issue caused
by the combination of tail calls and freplace, ensuring the correct
behavior and stability of the system.

Additionally, fix the broken tailcalls/tailcall_freplace selftest
because an extension prog should not be tailcalled.

cd tools/testing/selftests/bpf; ./test_progs -t tailcalls
337/25  tailcalls/tailcall_freplace:OK
337/26  tailcalls/tailcall_bpf2bpf_freplace:OK
337     tailcalls:OK
Summary: 1/26 PASSED, 0 SKIPPED, 0 FAILED

Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/r/20241015150207.70264-3-leon.hwang@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[ Yifei: bpf freplace update is backported to linux-6.12 by commit 987aa730bad3
  ("bpf: Prevent tailcall infinite loop caused by freplace"). It will cause
  selftest #336/25 failed. ]
Signed-off-by: Yifei Liu <yifei.l.liu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/tailcalls.c |  120 ++++++++++++++++++---
 tools/testing/selftests/bpf/progs/tc_bpf2bpf.c     |    5 
 2 files changed, 109 insertions(+), 16 deletions(-)

--- a/tools/testing/selftests/bpf/prog_tests/tailcalls.c
+++ b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
@@ -1496,8 +1496,8 @@ static void test_tailcall_bpf2bpf_hierar
 	RUN_TESTS(tailcall_bpf2bpf_hierarchy3);
 }
 
-/* test_tailcall_freplace checks that the attached freplace prog is OK to
- * update the prog_array map.
+/* test_tailcall_freplace checks that the freplace prog fails to update the
+ * prog_array map, no matter whether the freplace prog attaches to its target.
  */
 static void test_tailcall_freplace(void)
 {
@@ -1505,7 +1505,7 @@ static void test_tailcall_freplace(void)
 	struct bpf_link *freplace_link = NULL;
 	struct bpf_program *freplace_prog;
 	struct tc_bpf2bpf *tc_skel = NULL;
-	int prog_fd, map_fd;
+	int prog_fd, tc_prog_fd, map_fd;
 	char buff[128] = {};
 	int err, key;
 
@@ -1523,9 +1523,10 @@ static void test_tailcall_freplace(void)
 	if (!ASSERT_OK_PTR(tc_skel, "tc_bpf2bpf__open_and_load"))
 		goto out;
 
-	prog_fd = bpf_program__fd(tc_skel->progs.entry_tc);
+	tc_prog_fd = bpf_program__fd(tc_skel->progs.entry_tc);
 	freplace_prog = freplace_skel->progs.entry_freplace;
-	err = bpf_program__set_attach_target(freplace_prog, prog_fd, "subprog");
+	err = bpf_program__set_attach_target(freplace_prog, tc_prog_fd,
+					     "subprog_tc");
 	if (!ASSERT_OK(err, "set_attach_target"))
 		goto out;
 
@@ -1533,27 +1534,116 @@ static void test_tailcall_freplace(void)
 	if (!ASSERT_OK(err, "tailcall_freplace__load"))
 		goto out;
 
-	freplace_link = bpf_program__attach_freplace(freplace_prog, prog_fd,
-						     "subprog");
+	map_fd = bpf_map__fd(freplace_skel->maps.jmp_table);
+	prog_fd = bpf_program__fd(freplace_prog);
+	key = 0;
+	err = bpf_map_update_elem(map_fd, &key, &prog_fd, BPF_ANY);
+	ASSERT_ERR(err, "update jmp_table failure");
+
+	freplace_link = bpf_program__attach_freplace(freplace_prog, tc_prog_fd,
+						     "subprog_tc");
 	if (!ASSERT_OK_PTR(freplace_link, "attach_freplace"))
 		goto out;
 
-	map_fd = bpf_map__fd(freplace_skel->maps.jmp_table);
-	prog_fd = bpf_program__fd(freplace_prog);
+	err = bpf_map_update_elem(map_fd, &key, &prog_fd, BPF_ANY);
+	ASSERT_ERR(err, "update jmp_table failure");
+
+out:
+	bpf_link__destroy(freplace_link);
+	tailcall_freplace__destroy(freplace_skel);
+	tc_bpf2bpf__destroy(tc_skel);
+}
+
+/* test_tailcall_bpf2bpf_freplace checks the failure that fails to attach a tail
+ * callee prog with freplace prog or fails to update an extended prog to
+ * prog_array map.
+ */
+static void test_tailcall_bpf2bpf_freplace(void)
+{
+	struct tailcall_freplace *freplace_skel = NULL;
+	struct bpf_link *freplace_link = NULL;
+	struct tc_bpf2bpf *tc_skel = NULL;
+	char buff[128] = {};
+	int prog_fd, map_fd;
+	int err, key;
+
+	LIBBPF_OPTS(bpf_test_run_opts, topts,
+		    .data_in = buff,
+		    .data_size_in = sizeof(buff),
+		    .repeat = 1,
+	);
+
+	tc_skel = tc_bpf2bpf__open_and_load();
+	if (!ASSERT_OK_PTR(tc_skel, "tc_bpf2bpf__open_and_load"))
+		goto out;
+
+	prog_fd = bpf_program__fd(tc_skel->progs.entry_tc);
+	freplace_skel = tailcall_freplace__open();
+	if (!ASSERT_OK_PTR(freplace_skel, "tailcall_freplace__open"))
+		goto out;
+
+	err = bpf_program__set_attach_target(freplace_skel->progs.entry_freplace,
+					     prog_fd, "subprog_tc");
+	if (!ASSERT_OK(err, "set_attach_target"))
+		goto out;
+
+	err = tailcall_freplace__load(freplace_skel);
+	if (!ASSERT_OK(err, "tailcall_freplace__load"))
+		goto out;
+
+	/* OK to attach then detach freplace prog. */
+
+	freplace_link = bpf_program__attach_freplace(freplace_skel->progs.entry_freplace,
+						     prog_fd, "subprog_tc");
+	if (!ASSERT_OK_PTR(freplace_link, "attach_freplace"))
+		goto out;
+
+	err = bpf_link__destroy(freplace_link);
+	if (!ASSERT_OK(err, "destroy link"))
+		goto out;
+
+	/* OK to update prog_array map then delete element from the map. */
+
 	key = 0;
+	map_fd = bpf_map__fd(freplace_skel->maps.jmp_table);
 	err = bpf_map_update_elem(map_fd, &key, &prog_fd, BPF_ANY);
 	if (!ASSERT_OK(err, "update jmp_table"))
 		goto out;
 
-	prog_fd = bpf_program__fd(tc_skel->progs.entry_tc);
-	err = bpf_prog_test_run_opts(prog_fd, &topts);
-	ASSERT_OK(err, "test_run");
-	ASSERT_EQ(topts.retval, 34, "test_run retval");
+	err = bpf_map_delete_elem(map_fd, &key);
+	if (!ASSERT_OK(err, "delete_elem from jmp_table"))
+		goto out;
+
+	/* Fail to attach a tail callee prog with freplace prog. */
+
+	err = bpf_map_update_elem(map_fd, &key, &prog_fd, BPF_ANY);
+	if (!ASSERT_OK(err, "update jmp_table"))
+		goto out;
+
+	freplace_link = bpf_program__attach_freplace(freplace_skel->progs.entry_freplace,
+						     prog_fd, "subprog_tc");
+	if (!ASSERT_ERR_PTR(freplace_link, "attach_freplace failure"))
+		goto out;
+
+	err = bpf_map_delete_elem(map_fd, &key);
+	if (!ASSERT_OK(err, "delete_elem from jmp_table"))
+		goto out;
+
+	/* Fail to update an extended prog to prog_array map. */
+
+	freplace_link = bpf_program__attach_freplace(freplace_skel->progs.entry_freplace,
+						     prog_fd, "subprog_tc");
+	if (!ASSERT_OK_PTR(freplace_link, "attach_freplace"))
+		goto out;
+
+	err = bpf_map_update_elem(map_fd, &key, &prog_fd, BPF_ANY);
+	if (!ASSERT_ERR(err, "update jmp_table failure"))
+		goto out;
 
 out:
 	bpf_link__destroy(freplace_link);
-	tc_bpf2bpf__destroy(tc_skel);
 	tailcall_freplace__destroy(freplace_skel);
+	tc_bpf2bpf__destroy(tc_skel);
 }
 
 void test_tailcalls(void)
@@ -1606,4 +1696,6 @@ void test_tailcalls(void)
 	test_tailcall_bpf2bpf_hierarchy_3();
 	if (test__start_subtest("tailcall_freplace"))
 		test_tailcall_freplace();
+	if (test__start_subtest("tailcall_bpf2bpf_freplace"))
+		test_tailcall_bpf2bpf_freplace();
 }
--- a/tools/testing/selftests/bpf/progs/tc_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/progs/tc_bpf2bpf.c
@@ -5,10 +5,11 @@
 #include "bpf_misc.h"
 
 __noinline
-int subprog(struct __sk_buff *skb)
+int subprog_tc(struct __sk_buff *skb)
 {
 	int ret = 1;
 
+	__sink(skb);
 	__sink(ret);
 	/* let verifier know that 'subprog_tc' can change pointers to skb->data */
 	bpf_skb_change_proto(skb, 0, 0);
@@ -18,7 +19,7 @@ int subprog(struct __sk_buff *skb)
 SEC("tc")
 int entry_tc(struct __sk_buff *skb)
 {
-	return subprog(skb);
+	return subprog_tc(skb);
 }
 
 char __license[] SEC("license") = "GPL";


