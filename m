Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE57A157466;
	Tue, 30 Jul 2024 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360622; cv=none; b=Kjfn5HSEpm096hQOhGDymAzwnO+WQvCB/mUv0BiNHKvwU3VnKWEnwneQoqpFnCXanA/kntQ11blW0+QkcujFTdEWjHaIuSQxJBuDeIQG57GK7Vd72IRbbU7jyrV8picSIO5h4iFhhVUe/zDR5DgxfziXgkJ2S6q3Ian+72ORkpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360622; c=relaxed/simple;
	bh=qj0jaemDEad8lXeX7CsQkrF2Z3A11kckzu/gPaTIA9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QoSpaBYMJt5ZGFJ21SNKrKFn3JkOz+OTwaeh4g4TWnRK1Tpzv+J7R5SEfPeRNrUy85fXCx8NGLrJEiWMsvYFyr9Taciv7j4/3JeISyNFd3krarg4jmkJfcImKu4R3nEulLXo8s09+v00opYuB/Fb6URBd0yW663xEAU3btzLbyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kpnLs4y0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kpnLs4y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F39C32782;
	Tue, 30 Jul 2024 17:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360621;
	bh=qj0jaemDEad8lXeX7CsQkrF2Z3A11kckzu/gPaTIA9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kpnLs4y0B7A5t361nv60O7u7B82W45qG42LPagdXH5bQ+JvFFYRNERhU683RWgG9H
	 jEfS5KePBAJ3a7Lfv9pCkb68M2QkRscIf8P4rJXmrUmfsjEmO9tFyhL+PS98y0WBi6
	 r6dBj36NqZKDHkKeMYtbMFg++3r03fHKrV/kjvDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 754/809] selftests/bpf: fexit_sleep: Fix stack allocation for arm64
Date: Tue, 30 Jul 2024 17:50:30 +0200
Message-ID: <20240730151754.739738087@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit e1ef78dce9b7b0fa7f9d88bb3554441d74d33b34 ]

On ARM64 the stack pointer should be aligned at a 16 byte boundary or
the SPAlignmentFault can occur. The fexit_sleep selftest allocates the
stack for the child process as a character array, this is not guaranteed
to be aligned at 16 bytes.

Because of the SPAlignmentFault, the child process is killed before it
can do the nanosleep call and hence fentry_cnt remains as 0. This causes
the main thread to hang on the following line:

while (READ_ONCE(fexit_skel->bss->fentry_cnt) != 2);

Fix this by allocating the stack using mmap() as described in the
example in the man page of clone().

Remove the fexit_sleep test from the DENYLIST of arm64.

Fixes: eddbe8e65214 ("selftest/bpf: Add a test to check trampoline freeing logic.")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240715173327.8657-1-puranjay@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/DENYLIST.aarch64         | 1 -
 tools/testing/selftests/bpf/prog_tests/fexit_sleep.c | 8 +++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/DENYLIST.aarch64 b/tools/testing/selftests/bpf/DENYLIST.aarch64
index 0445ac38bc07d..3a2261248e9af 100644
--- a/tools/testing/selftests/bpf/DENYLIST.aarch64
+++ b/tools/testing/selftests/bpf/DENYLIST.aarch64
@@ -1,6 +1,5 @@
 bpf_cookie/multi_kprobe_attach_api               # kprobe_multi_link_api_subtest:FAIL:fentry_raw_skel_load unexpected error: -3
 bpf_cookie/multi_kprobe_link_api                 # kprobe_multi_link_api_subtest:FAIL:fentry_raw_skel_load unexpected error: -3
-fexit_sleep                                      # The test never returns. The remaining tests cannot start.
 kprobe_multi_bench_attach                        # needs CONFIG_FPROBE
 kprobe_multi_test                                # needs CONFIG_FPROBE
 module_attach                                    # prog 'kprobe_multi': failed to auto-attach: -95
diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_sleep.c b/tools/testing/selftests/bpf/prog_tests/fexit_sleep.c
index f949647dbbc21..552a0875ca6db 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_sleep.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_sleep.c
@@ -21,13 +21,13 @@ static int do_sleep(void *skel)
 }
 
 #define STACK_SIZE (1024 * 1024)
-static char child_stack[STACK_SIZE];
 
 void test_fexit_sleep(void)
 {
 	struct fexit_sleep_lskel *fexit_skel = NULL;
 	int wstatus, duration = 0;
 	pid_t cpid;
+	char *child_stack = NULL;
 	int err, fexit_cnt;
 
 	fexit_skel = fexit_sleep_lskel__open_and_load();
@@ -38,6 +38,11 @@ void test_fexit_sleep(void)
 	if (CHECK(err, "fexit_attach", "fexit attach failed: %d\n", err))
 		goto cleanup;
 
+	child_stack = mmap(NULL, STACK_SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE |
+			   MAP_ANONYMOUS | MAP_STACK, -1, 0);
+	if (!ASSERT_NEQ(child_stack, MAP_FAILED, "mmap"))
+		goto cleanup;
+
 	cpid = clone(do_sleep, child_stack + STACK_SIZE, CLONE_FILES | SIGCHLD, fexit_skel);
 	if (CHECK(cpid == -1, "clone", "%s\n", strerror(errno)))
 		goto cleanup;
@@ -78,5 +83,6 @@ void test_fexit_sleep(void)
 		goto cleanup;
 
 cleanup:
+	munmap(child_stack, STACK_SIZE);
 	fexit_sleep_lskel__destroy(fexit_skel);
 }
-- 
2.43.0



