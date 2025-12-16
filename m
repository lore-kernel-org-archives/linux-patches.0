Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C9B3148B8;
	Tue, 16 Dec 2025 12:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887889; cv=none; b=R0719exJv7AzKwKSEheSbh6wUUpwSCCQOcVpSvYvSo4W6khATUT7UvPg5zCWDKqtLwy0XHN1ksmltZzorSZ79OkqUGJeQGs5a+bt+FYi7jn5bcDrPgEe0f3QNC3xKWnz8Rq971BBfB6/n3x1Om2SXHaMem9Kahycj9/FCgnwJkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887889; c=relaxed/simple;
	bh=KcLGxSKuzM+861STHxn59mn/rxtUm8Ug48jqCXKtuTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUupmGCY6RM5iWXReabh1VDW0XpVCwcanLhER0unqw2RSUzhzCZckgsee3PKop7GAv+8z0xpYqdsxbFjz5QXeulNIe4VuUEsEI3je3bhS2JAQEor11LRD0bwvRqdqtsLLlpdIe8M6hlIZ0CyrqcIzEXk9ZciWE7q37u7kr76dVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+ScjGqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+ScjGqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55EFC4CEF1;
	Tue, 16 Dec 2025 12:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887889;
	bh=KcLGxSKuzM+861STHxn59mn/rxtUm8Ug48jqCXKtuTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+ScjGqmuAsmcaZ/KfsmnKU6NvBPs94+kgzBK0UUW8bMn+nEBdQ5OG6d2qeeeFJLf
	 Oiri425PjLztEPxt0pf+PtL4uNQI7GcrKYWQxhiZP6SKU3pDFI9FZBk1o32jDqScOI
	 mIcY7ybmtEytaD7Aguo70PAnz631igC/TZKQ7JS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Bobrowski <mattbobrowski@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 368/614] selftests/bpf: Improve reliability of test_perf_branches_no_hw()
Date: Tue, 16 Dec 2025 12:12:15 +0100
Message-ID: <20251216111414.692421876@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Bobrowski <mattbobrowski@google.com>

[ Upstream commit ae24fc8a16b0481ea8c5acbc66453c49ec0431c4 ]

Currently, test_perf_branches_no_hw() relies on the busy loop within
test_perf_branches_common() being slow enough to allow at least one
perf event sample tick to occur before starting to tear down the
backing perf event BPF program. With a relatively small fixed
iteration count of 1,000,000, this is not guaranteed on modern fast
CPUs, resulting in the test run to subsequently fail with the
following:

bpf_testmod.ko is already unloaded.
Loading bpf_testmod.ko...
Successfully loaded bpf_testmod.ko.
test_perf_branches_common:PASS:test_perf_branches_load 0 nsec
test_perf_branches_common:PASS:attach_perf_event 0 nsec
test_perf_branches_common:PASS:set_affinity 0 nsec
check_good_sample:PASS:output not valid 0 nsec
check_good_sample:PASS:read_branches_size 0 nsec
check_good_sample:PASS:read_branches_stack 0 nsec
check_good_sample:PASS:read_branches_stack 0 nsec
check_good_sample:PASS:read_branches_global 0 nsec
check_good_sample:PASS:read_branches_global 0 nsec
check_good_sample:PASS:read_branches_size 0 nsec
test_perf_branches_no_hw:PASS:perf_event_open 0 nsec
test_perf_branches_common:PASS:test_perf_branches_load 0 nsec
test_perf_branches_common:PASS:attach_perf_event 0 nsec
test_perf_branches_common:PASS:set_affinity 0 nsec
check_bad_sample:FAIL:output not valid no valid sample from prog
Summary: 0/1 PASSED, 0 SKIPPED, 1 FAILED
Successfully unloaded bpf_testmod.ko.

On a modern CPU (i.e. one with a 3.5 GHz clock rate), executing 1
million increments of a volatile integer can take significantly less
than 1 millisecond. If the spin loop and detachment of the perf event
BPF program elapses before the first 1 ms sampling interval elapses,
the perf event will never end up firing. Fix this by bumping the loop
iteration counter a little within test_perf_branches_common(), along
with ensuring adding another loop termination condition which is
directly influenced by the backing perf event BPF program
executing. Notably, a concious decision was made to not adjust the
sample_freq value as that is just not a reliable way to go about
fixing the problem. It effectively still leaves the race window open.

Fixes: 67306f84ca78c ("selftests/bpf: Add bpf_read_branch_records() selftest")
Signed-off-by: Matt Bobrowski <mattbobrowski@google.com>
Reviewed-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20251119143540.2911424-1-mattbobrowski@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/perf_branches.c     | 16 ++++++++++++++--
 .../selftests/bpf/progs/test_perf_branches.c     |  3 +++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/perf_branches.c b/tools/testing/selftests/bpf/prog_tests/perf_branches.c
index 06c7986131d96..0a7ef770c487c 100644
--- a/tools/testing/selftests/bpf/prog_tests/perf_branches.c
+++ b/tools/testing/selftests/bpf/prog_tests/perf_branches.c
@@ -15,6 +15,10 @@ static void check_good_sample(struct test_perf_branches *skel)
 	int pbe_size = sizeof(struct perf_branch_entry);
 	int duration = 0;
 
+	if (CHECK(!skel->bss->run_cnt, "invalid run_cnt",
+		  "checked sample validity before prog run"))
+		return;
+
 	if (CHECK(!skel->bss->valid, "output not valid",
 		 "no valid sample from prog"))
 		return;
@@ -45,6 +49,10 @@ static void check_bad_sample(struct test_perf_branches *skel)
 	int written_stack = skel->bss->written_stack_out;
 	int duration = 0;
 
+	if (CHECK(!skel->bss->run_cnt, "invalid run_cnt",
+		  "checked sample validity before prog run"))
+		return;
+
 	if (CHECK(!skel->bss->valid, "output not valid",
 		 "no valid sample from prog"))
 		return;
@@ -83,8 +91,12 @@ static void test_perf_branches_common(int perf_fd,
 	err = pthread_setaffinity_np(pthread_self(), sizeof(cpu_set), &cpu_set);
 	if (CHECK(err, "set_affinity", "cpu #0, err %d\n", err))
 		goto out_destroy;
-	/* spin the loop for a while (random high number) */
-	for (i = 0; i < 1000000; ++i)
+
+	/* Spin the loop for a while by using a high iteration count, and by
+	 * checking whether the specific run count marker has been explicitly
+	 * incremented at least once by the backing perf_event BPF program.
+	 */
+	for (i = 0; i < 100000000 && !*(volatile int *)&skel->bss->run_cnt; ++i)
 		++j;
 
 	test_perf_branches__detach(skel);
diff --git a/tools/testing/selftests/bpf/progs/test_perf_branches.c b/tools/testing/selftests/bpf/progs/test_perf_branches.c
index a1ccc831c882f..05ac9410cd68c 100644
--- a/tools/testing/selftests/bpf/progs/test_perf_branches.c
+++ b/tools/testing/selftests/bpf/progs/test_perf_branches.c
@@ -8,6 +8,7 @@
 #include <bpf/bpf_tracing.h>
 
 int valid = 0;
+int run_cnt = 0;
 int required_size_out = 0;
 int written_stack_out = 0;
 int written_global_out = 0;
@@ -24,6 +25,8 @@ int perf_branches(void *ctx)
 	__u64 entries[4 * 3] = {0};
 	int required_size, written_stack, written_global;
 
+	++run_cnt;
+
 	/* write to stack */
 	written_stack = bpf_read_branch_records(ctx, entries, sizeof(entries), 0);
 	/* ignore spurious events */
-- 
2.51.0



