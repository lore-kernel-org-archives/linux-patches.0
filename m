Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2960F1E86F;
	Tue, 30 Jul 2024 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359737; cv=none; b=bORrH36QFBU8wha5EEqdgjMO43aN7xW35oc5RacM5Fo3g7z1B2HTR91SD93oCSJ3R60/r/GFDOcaI3BxPrH6CG3wNdSskhW3ut7m37YB/XnMAyxNtFQYwFNCzXccsmqSnbKvgAXZsaFgnQu8/lD2fPB44dwPA6Zcq6ovWJ5S2yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359737; c=relaxed/simple;
	bh=ntAk8dutVIqMcbyLMtN1hphevWD4BWU5GNRaWkv+Q/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nprvrsh6ElKsprpGNh/QLGDpVJ5c72ltbkL+45IPUo1SJIazvvQtgKeQ77oj24okZI6r9qPikJOUwHHVJqMhytzqVH4Neesju4YThW3YbI7+fBY1xVWikg06t0U38icOSD93E55IJKZtwTEvnmPZl+/xZTarSaSiWhUtP5T+CfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qqg9LXqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qqg9LXqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65E0C32782;
	Tue, 30 Jul 2024 17:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359737;
	bh=ntAk8dutVIqMcbyLMtN1hphevWD4BWU5GNRaWkv+Q/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qqg9LXqwk0DXNen6xGP/HfvB/eGMID1uTIpEjNjf4h0cu38ngwuEbiPZVky93Bm61
	 f/RIS5IaW3nkWMy3mtF5asIOxLsaj2bM+y0zU1w4Iu9O+zdEyL0cKWLXnnyPUfu8rG
	 smYkEFt3R96/LnMThThejQLtycpFeA0WSGfVC+9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 529/568] selftests/bpf: fexit_sleep: Fix stack allocation for arm64
Date: Tue, 30 Jul 2024 17:50:36 +0200
Message-ID: <20240730151700.833504344@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index 3babaf3eee5c4..ec6aa58fb1810 100644
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



