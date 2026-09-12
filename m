Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D781EB5FD;
	Sat, 12 Sep 2026 07:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197715; cv=none; b=Wuoa/78HNvTRBagbTTsiNwQYQvdNfW/pUC6yxg7ynnCWTTRGP3zxJPlJ9rtQHQWPIEwxVyoiSk74EaWOxxdXz2mzK+FgQE3lwUUh6P0lUt1BXGJ0b7TjmVxNUXwbOllubQhUhLbkexrU4uCEt3Zr/3nPZj81Z1ejQNXbP47S1g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197715; c=relaxed/simple;
	bh=3KxsZjFUoijPFZqCQSMO+raaw8ADrJC5n7NbW2vgMVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ri1YcTQ2mdFR7aV1EWtg0K3aorpd/nalYHjF0dsDgnWxOjjQ73GeNtDwMlZJQUC+JcnyJvQD2145YK8CsPRjrIkecff3CJJ4hhI7mbDgZAwColhjc484fm7y1ctZxWRbv78iUpWDi4ptAFQeqUoe9Z4ieqxqt3N1iTUFF6CM3g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u895u61A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u895u61A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C611F000FF;
	Sat, 12 Sep 2026 07:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197714;
	bh=dyjtpxdcZcQaHyxaJVDfaIP6efN7YYuoFtICLrWWyrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u895u61AhfoEB11CjvfoFA1JIGd+of+uefU5T1pIaNR0i9MPr02woa1aRhgzdLad7
	 R7pN7c4fTgejYIR7B4paHy7FJ6zvtXQwOSyhtMFwhEfrRZGqgfEkmwN3y3VcnVm0dn
	 3KjeXs7jpl99njHbq42NKKewn2jMFbqkzLcpRsCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@linaro.org>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0180/1815] perf cs-etm: Filter synthesized branch samples
Date: Sat, 12 Sep 2026 08:32:10 +0200
Message-ID: <20260912065653.232957374@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit a9e99b860fb6dfdc9a17d7c63b84fd5647f1f44c ]

The itrace 'c' and 'r' options request synthesized branch events for
calls and returns only. For perf script the default itrace options are
"--itrace=ce", so CS ETM should emit call branches and error events by
default.

CS ETM currently synthesizes a branch sample for every decoded taken
branch whenever branch synthesis is enabled. This produces redundant
jump and conditional branch samples.

Add a branch filter derived from the itrace calls and returns options.
When neither option is set, keep the existing behavior and synthesize all
branch samples. When calls or returns are requested, emit only branch
samples whose flags match the selected branch type, while preserving trace
begin/end markers.

Also update test_arm_coresight_disasm.sh and arm-cs-trace-disasm.py
to use the --itrace=b option for generating branch samples.

Before:

  perf script -F,+flags

  callchain_test    6114 [005] 331519.825214:          1 branches:   tr strt jmp                           0 [unknown] ([unknown]) => ffff8000803a3a68 perf_report_aux_output_id+0x50 ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   call                   ffff8000803a3a74 perf_report_aux_output_id+0x5c ([kernel.kallsyms]) => ffff8000817f4d88 memset+0x0 ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   jmp                    ffff8000817f4d8c memset+0x4 ([kernel.kallsyms]) => ffff8000817f4c00 __pi_memset_generic+0x0 ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   jcc                    ffff8000817f4c1c __pi_memset_generic+0x1c ([kernel.kallsyms]) => ffff8000817f4c44 __pi_memset_generic+0x44 ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   jcc                    ffff8000817f4c4c __pi_memset_generic+0x4c ([kernel.kallsyms]) => ffff8000817f4c5c __pi_memset_generic+0x5c ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   jcc                    ffff8000817f4c5c __pi_memset_generic+0x5c ([kernel.kallsyms]) => ffff8000817f4cf0 __pi_memset_generic+0xf0 ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   jcc                    ffff8000817f4d30 __pi_memset_generic+0x130 ([kernel.kallsyms]) => ffff8000817f4d68 __pi_memset_generic+0x168 ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   jcc                    ffff8000817f4d78 __pi_memset_generic+0x178 ([kernel.kallsyms]) => ffff8000817f4d6c __pi_memset_generic+0x16c ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   jcc                    ffff8000817f4d78 __pi_memset_generic+0x178 ([kernel.kallsyms]) => ffff8000817f4d6c __pi_memset_generic+0x16c ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   jcc                    ffff8000817f4d78 __pi_memset_generic+0x178 ([kernel.kallsyms]) => ffff8000817f4d6c __pi_memset_generic+0x16c ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   return                 ffff8000817f4d84 __pi_memset_generic+0x184 ([kernel.kallsyms]) => ffff8000803a3a78 perf_report_aux_output_id+0x60 ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   jcc                    ffff8000803a3a98 perf_report_aux_output_id+0x80 ([kernel.kallsyms]) => ffff8000803a3b04 perf_report_aux_output_id+0xec ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   call                   ffff8000803a3b1c perf_report_aux_output_id+0x104 ([kernel.kallsyms]) => ffff8000803a38f8 __perf_event_header__init_id+0x0 ([kernel.kallsyms])

After:

  callchain_test    6114 [005] 331519.825214:          1 branches:   tr strt jmp                           0 [unknown] ([unknown]) => ffff8000803a3a68 perf_report_aux_output_id+0x50 ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   call                   ffff8000803a3a74 perf_report_aux_output_id+0x5c ([kernel.kallsyms]) => ffff8000817f4d88 memset+0x0 ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   call                   ffff8000803a3b1c perf_report_aux_output_id+0x104 ([kernel.kallsyms]) => ffff8000803a38f8 __perf_event_header__init_id+0x0 ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   call                   ffff8000803a39c0 __perf_event_header__init_id+0xc8 ([kernel.kallsyms]) => ffff800080105258 __task_pid_nr_ns+0x0 ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   call                   ffff80008010528c __task_pid_nr_ns+0x34 ([kernel.kallsyms]) => ffff8000801d5610 __rcu_read_lock+0x0 ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   call                   ffff8000801052b0 __task_pid_nr_ns+0x58 ([kernel.kallsyms]) => ffff800080192078 lock_acquire+0x0 ([kernel.kallsyms])
  callchain_test    6114 [005] 331519.825214:          1 branches:   call                   ffff8000801923f4 lock_acquire+0x37c ([kernel.kallsyms]) => ffff8000801d6da0 rcu_is_watching+0x0 ([kernel.kallsyms])

Fixes: b12235b113cf ("perf tools: Add mechanic to synthesise CoreSight trace packets")
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/scripts/python/arm-cs-trace-disasm.py  |  9 +++++----
 .../shell/coresight/test_arm_coresight_disasm.sh  |  4 ++--
 tools/perf/util/cs-etm.c                          | 15 +++++++++++++++
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/tools/perf/scripts/python/arm-cs-trace-disasm.py b/tools/perf/scripts/python/arm-cs-trace-disasm.py
index 8f6fa4a007b42..42579f8586842 100755
--- a/tools/perf/scripts/python/arm-cs-trace-disasm.py
+++ b/tools/perf/scripts/python/arm-cs-trace-disasm.py
@@ -31,18 +31,19 @@ from perf_trace_context import perf_sample_srccode, perf_config_get
 #
 # Output disassembly with objdump and auto detect vmlinux
 # (when running on same machine.):
-#  perf script -s scripts/python/arm-cs-trace-disasm.py -d
+#  perf script --itrace=b -s scripts/python/arm-cs-trace-disasm.py \
+#       -- -d
 #
 # Output disassembly with llvm-objdump:
-#  perf script -s scripts/python/arm-cs-trace-disasm.py \
+#  perf script --itrace=b -s scripts/python/arm-cs-trace-disasm.py \
 #		-- -d llvm-objdump-11 -k path/to/vmlinux
 #
 # Output accurate disassembly by passing kcore to script:
-#  perf script -s scripts/python/arm-cs-trace-disasm.py \
+#  perf script --itrace=b -s scripts/python/arm-cs-trace-disasm.py \
 #		-- -d -k perf.data/kcore_dir/kcore
 #
 # Output only source line and symbols:
-#  perf script -s scripts/python/arm-cs-trace-disasm.py
+#  perf script --itrace=b -s scripts/python/arm-cs-trace-disasm.py
 
 def default_objdump():
 	config = perf_config_get("annotate.objdump")
diff --git a/tools/perf/tests/shell/coresight/test_arm_coresight_disasm.sh b/tools/perf/tests/shell/coresight/test_arm_coresight_disasm.sh
index ccb90dda24758..f3ebad5963783 100755
--- a/tools/perf/tests/shell/coresight/test_arm_coresight_disasm.sh
+++ b/tools/perf/tests/shell/coresight/test_arm_coresight_disasm.sh
@@ -44,7 +44,7 @@ branch_search='[[:space:]](bl|b(\.(eq|ne|cs|cc|mi|pl|vs|vc|hi|ls|ge|lt|gt|le|al)
 if [ "$(id -u)" == 0 ] && [ -e /proc/kcore ]; then
 	echo "Testing kernel disassembly"
 	perf record -o ${perfdata} -e cs_etm//k --kcore -Se -m,64K -- touch $file > /dev/null 2>&1
-	perf script -i ${perfdata} -s python:${script_path} -- \
+	perf script -i ${perfdata} --itrace=b -s python:${script_path} -- \
 		-d --stop-sample=2 -k ${perfdata}/kcore_dir/kcore 2> /dev/null > ${file}
 	grep -q -E ${branch_search} ${file}
 	echo "Found kernel branches"
@@ -56,7 +56,7 @@ fi
 ## Test user ##
 echo "Testing userspace disassembly"
 perf record -o ${perfdata} -e cs_etm//u -Se -m,64K -- touch $file > /dev/null 2>&1
-perf script -i ${perfdata} -s python:${script_path} -- \
+perf script -i ${perfdata} --itrace=b -s python:${script_path} -- \
 	-d --stop-sample=2 2> /dev/null > ${file}
 grep -q -E ${branch_search} ${file}
 echo "Found userspace branches"
diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index deca07d57282e..95530e10e010c 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -71,6 +71,7 @@ struct cs_etm_auxtrace {
 	int num_cpu;
 	u64 latest_kernel_timestamp;
 	u32 auxtrace_type;
+	u32 branches_filter;
 	u64 branches_sample_type;
 	u64 branches_id;
 	u64 instructions_sample_type;
@@ -1705,6 +1706,10 @@ static int cs_etm__synth_branch_sample(struct cs_etm_queue *etmq,
 	} dummy_bs;
 	u64 ip;
 
+	if (etm->branches_filter &&
+		!(etm->branches_filter & tidq->prev_packet->flags))
+		return 0;
+
 	perf_sample__init(&sample, /*all=*/true);
 	ip = cs_etm__last_executed_instr(tidq->prev_packet);
 
@@ -3564,6 +3569,16 @@ int cs_etm__process_auxtrace_info_full(union perf_event *event,
 		etm->synth_opts.callchain = false;
 	}
 
+	if (etm->synth_opts.calls)
+		etm->branches_filter |= PERF_IP_FLAG_CALL |
+					PERF_IP_FLAG_TRACE_BEGIN |
+					PERF_IP_FLAG_TRACE_END;
+
+	if (etm->synth_opts.returns)
+		etm->branches_filter |= PERF_IP_FLAG_RETURN |
+					PERF_IP_FLAG_TRACE_BEGIN |
+					PERF_IP_FLAG_TRACE_END;
+
 	etm->session = session;
 
 	etm->num_cpu = num_cpu;
-- 
2.53.0



