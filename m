Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F39846B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE32C433EF;
	Mon, 16 Jan 2023 16:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886175;
	bh=bcpIxDuQB++Lo7gyPINE1+bnQNi96HkfACVCosJP0D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X1h8GtVO4zxuUWlDiO/HVBUcbATVFtC1GwC0szAOoxMhUTThKUfsBtnHzRYSxi5dF
	 UMhbaN0qDuwLBEp5gbZwIilOS8n4zFOFa0RXZz05Ld7QhJuSSA2Ie5BWGlNlTlRfI6
	 JvewITldHCguuA6HLw1DiCsPjS+jp1rRfKPKoE7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	bpf@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 331/658] perf trace: Handle failure when trace point folder is missed
Date: Mon, 16 Jan 2023 16:46:59 +0100
Message-Id: <20230116154924.694358142@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit 03e9a5d8eb552a1bf692a9c8a5ecd50f4e428006 ]

On Arm64 a case is perf tools fails to find the corresponding trace
point folder for system calls listed in the table 'syscalltbl_arm64',
e.g. the generated system call table contains "lookup_dcookie" but we
cannot find out the matched trace point folder for it.

We need to figure out if there have any issue for the generated system
call table, on the other hand, we need to handle the case when trace
point folder is missed under sysfs, this patch sets the flag
syscall::nonexistent as true and returns the error from
trace__read_syscall_info().

Another problem is for trace__syscall_info(), it returns two different
values if a system call doesn't exist: at the first time calling
trace__syscall_info() it returns NULL when the system call doesn't exist,
later if call trace__syscall_info() again for the same missed system
call, it returns pointer of syscall.  trace__syscall_info() checks the
condition 'syscalls.table[id].name == NULL', but the name will be
assigned in the first invoking even the system call is not found.

So checking system call's name in trace__syscall_info() is not the right
thing to do, this patch simply checks flag syscall::nonexistent to make
decision if a system call exists or not, finally trace__syscall_info()
returns the consistent result (NULL) if a system call doesn't existed.

Fixes: b8b1033fcaa091d8 ("perf trace: Mark syscall ids that are not allocated to avoid unnecessary error messages")
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: bpf@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20221121075237.127706-4-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index e41b6ffafbd3..6052eb057821 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1573,13 +1573,19 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 		sc->tp_format = trace_event__tp_format("syscalls", tp_name);
 	}
 
+	/*
+	 * Fails to read trace point format via sysfs node, so the trace point
+	 * doesn't exist.  Set the 'nonexistent' flag as true.
+	 */
+	if (IS_ERR(sc->tp_format)) {
+		sc->nonexistent = true;
+		return PTR_ERR(sc->tp_format);
+	}
+
 	if (syscall__alloc_arg_fmts(sc, IS_ERR(sc->tp_format) ?
 					RAW_SYSCALL_ARGS_NUM : sc->tp_format->format.nr_fields))
 		return -ENOMEM;
 
-	if (IS_ERR(sc->tp_format))
-		return PTR_ERR(sc->tp_format);
-
 	sc->args = sc->tp_format->format.fields;
 	/*
 	 * We need to check and discard the first variable '__syscall_nr'
@@ -1871,11 +1877,8 @@ static struct syscall *trace__syscall_info(struct trace *trace,
 	    (err = trace__read_syscall_info(trace, id)) != 0)
 		goto out_cant_read;
 
-	if (trace->syscalls.table[id].name == NULL) {
-		if (trace->syscalls.table[id].nonexistent)
-			return NULL;
+	if (trace->syscalls.table && trace->syscalls.table[id].nonexistent)
 		goto out_cant_read;
-	}
 
 	return &trace->syscalls.table[id];
 
-- 
2.35.1



