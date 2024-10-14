Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D490E1CC154;
	Mon, 14 Oct 2024 15:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919665; cv=none; b=cFBCIs8VXOxCJE3mkGNG5u8Afs0V3azD1SxNdadGE0wP6BmOXv2KzuB/mouVlCRhgG9zMbcYESU11E/u0K3NT8d6ZCW/Y1OFj2j0u8s68qU7495vfZBapE9cyCfca2vl0LTRljhFp5C7nFBCu4mCkIxe6ECnQErTst/35l5O+oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919665; c=relaxed/simple;
	bh=2CEzetiLcKmt7LjOOge3CHj7ZGxtO9DlvF4Nbza2YNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGxlq3LFyZpRxyuYbolKrp0CacrlmKGahhMXRaTgFlWA/FqJsQzQiL/fE0EheWkC7Kg7FwG+TJDncpzCi85jzbGyV06CNg9HdvFSDGfnhAIeN0XNqChtvxpV2HCy7BK4cVRHY9Qv9fm2FXn/6Yupo7PN3nSCg7ZnO4mkEzBvTK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgPu5ls6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgPu5ls6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06FEC4CEC7;
	Mon, 14 Oct 2024 15:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919665;
	bh=2CEzetiLcKmt7LjOOge3CHj7ZGxtO9DlvF4Nbza2YNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgPu5ls6Hx5TfxPRDu9ZtoATbusKyTHFhdHN39z+8Gj7I60SV/DTeEFAHVGbQS5JN
	 x3Fd8CMkC/yfrJG07PBp+A54jm+QodNRChh4EXPamzYUFt7csms8lvQ6KEoF9oGNxe
	 x6cRbDeUmb/sh+qg/l3ky3ad7D7A1VzsniqnMxus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 673/798] perf sched: Avoid large stack allocations
Date: Mon, 14 Oct 2024 16:20:27 +0200
Message-ID: <20241014141244.505741581@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 232418a0b2e8b8e72dac003b19352f1b647cdb31 ]

Commit 5ded57ac1bdb ("perf inject: Remove static variables") moved
static variables to local, however, in this case 3 MAX_CPUS (4096)
sized arrays were moved onto the stack making the stack frame quite
large. Avoid the stack usage by dynamically allocating the arrays.

Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230527034324.2597593-2-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 1a5efc9e13f3 ("libsubcmd: Don't free the usage string")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index d83a7569db0e2..3eff78e7b67a2 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -193,8 +193,8 @@ struct perf_sched {
  * weird events, such as a task being switched away that is not current.
  */
 	struct perf_cpu	 max_cpu;
-	u32		 curr_pid[MAX_CPUS];
-	struct thread	 *curr_thread[MAX_CPUS];
+	u32		 *curr_pid;
+	struct thread	 **curr_thread;
 	char		 next_shortname1;
 	char		 next_shortname2;
 	unsigned int	 replay_repeat;
@@ -224,7 +224,7 @@ struct perf_sched {
 	u64		 run_avg;
 	u64		 all_runtime;
 	u64		 all_count;
-	u64		 cpu_last_switched[MAX_CPUS];
+	u64		 *cpu_last_switched;
 	struct rb_root_cached atom_root, sorted_atom_root, merged_atom_root;
 	struct list_head sort_list, cmp_pid;
 	bool force;
@@ -3590,7 +3590,22 @@ int cmd_sched(int argc, const char **argv)
 
 	mutex_init(&sched.start_work_mutex);
 	mutex_init(&sched.work_done_wait_mutex);
-	for (i = 0; i < ARRAY_SIZE(sched.curr_pid); i++)
+	sched.curr_thread = calloc(MAX_CPUS, sizeof(*sched.curr_thread));
+	if (!sched.curr_thread) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	sched.cpu_last_switched = calloc(MAX_CPUS, sizeof(*sched.cpu_last_switched));
+	if (!sched.cpu_last_switched) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	sched.curr_pid = malloc(MAX_CPUS * sizeof(*sched.curr_pid));
+	if (!sched.curr_pid) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	for (i = 0; i < MAX_CPUS; i++)
 		sched.curr_pid[i] = -1;
 
 	argc = parse_options_subcommand(argc, argv, sched_options, sched_subcommands,
@@ -3659,6 +3674,9 @@ int cmd_sched(int argc, const char **argv)
 	}
 
 out:
+	free(sched.curr_pid);
+	free(sched.cpu_last_switched);
+	free(sched.curr_thread);
 	mutex_destroy(&sched.start_work_mutex);
 	mutex_destroy(&sched.work_done_wait_mutex);
 
-- 
2.43.0



