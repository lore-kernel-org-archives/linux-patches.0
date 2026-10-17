Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4BF3B42DE;
	Sat, 17 Oct 2026 17:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259704; cv=none; b=nfIAykubK8bqBV+QeLOUXLKydIyDq0psMePJ01e4ytasgaOxGJ2jbYKht+mG8CshBHBAA1a57qB5aD8ktSsZwY2GrNhyS7rshRd7XT1UpP53BgYRJKZmrUHNH9/o8PMyTeoqLiJcLkp43rADhtpsvYJyWfF94ezmZS8T9NFNPYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259704; c=relaxed/simple;
	bh=Ev5kdQnxEL5IWMnhi7BsJyxiWb7OnrnkeZfHp26gUa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrTvZ1beOdUnlP8WZHqSQB112FGoWkZHR+Q5hrX0L2pqXyC8QgLg6qLHaUrdDFdij6GKgFe/mahRSprPfwaVhXdPpikCph+JRolR1SzLMfIEgdaWrKYr7vu+Yk6M3DWvUE9/jJiv31dtBsj/QvpRR6einctf5yQBN2WOGwM960E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMyaRKQ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMyaRKQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2F31F000C4;
	Sat, 17 Oct 2026 17:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259703;
	bh=UOXkDurJbb9LcZrLaa6BF0AU3TNV1pWD95EP2TSUbN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMyaRKQ/vFdlTUlVZTOuXLQ2rJnUAf1wrza8dWftfyb+Hh7febM+s1I9/Bum0UGbZ
	 uCh2UxCFwHuGxkZvhOQEdrTjUdWvsC5Q4GdlnHkQ3eqDk6KEb2pvzFFh5BTSZyjg0n
	 9m1zRQjJ61/LwBw/WNhhcU4/zwPmPpems9KRMlHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <borkmann@iogearbox.net>,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1302/1674] bpf: Disable preemption in __bpf_get_stack
Date: Sat, 17 Oct 2026 17:59:34 +0200
Message-ID: <20261017160504.566071453@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Daniel Borkmann <borkmann@iogearbox.net>

[ Upstream commit b1a47b2708d4e95dbd23aee2ec83752190897b3f ]

get_perf_callchain() returns a per-CPU perf_callchain_entry buffer and
releases its recursion slot via put_callchain_entry() before returning,
so nothing keeps the entry reserved while __bpf_get_stack() consumes
it below.

A preemptible BPF program (e.g. a non-sleepable raw tracepoint program
on a PREEMPT kernel, which runs under migrate_disable() but not
preempt_disable()) can be scheduled out between obtaining the entry
and the copy. Another task scheduled on the same CPU then reuses the
same per-CPU buffer and overwrites trace->nr with a larger value.
copy_len is then computed from the inflated trace->nr and can exceed
the caller's buffer, causing an out-of-bounds write in the memcpy()
and in the build_id path.

The rcu_read_lock() taken here alone does not prevent this. It is
only taken on the may_fault path, and under CONFIG_PREEMPT_RCU it does
not disable preemption; it merely keeps perf's callchain buffer array
alive (freed via call_rcu()) and does nothing to stop another task
from reusing the entry.

Disable preemption around obtaining the callchain entry and copying
it into the caller's buffer, so the entry cannot be reused underneath
us and trace->nr stays bounded by max_depth. Build ID resolution may
fault and is therefore deferred until after preemption is re-enabled;
by then the instruction pointers have already been copied into buf,
so it operates only on that private copy. Note, preempt_disable() also
subsumes the buffer-lifetime guarantee the rcu_read_lock() provided,
since a preempt-disabled section is an RCU read-side critical section
for the callchain buffers' call_rcu() reclaim.

Fixes: c195651e565a ("bpf: add bpf_get_stack helper")
Reported-by: Tao Chen <chen.dylane@linux.dev>
Reported-by: STAR Labs SG <info@starlabs.sg>
Signed-off-by: Daniel Borkmann <borkmann@iogearbox.net>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20260803210149.296496-11-jolsa@kernel.org

Closes: https://lore.kernel.org/bpf/20260206090653.1336687-1-chen.dylane@linux.dev/
[ changed Fixes: commit ]

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 2f89588872a50..cf079fbfcc6f2 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -430,6 +430,7 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 	if (sysctl_perf_event_max_stack < max_depth)
 		max_depth = sysctl_perf_event_max_stack;
 
+	preempt_disable();
 	if (trace_in)
 		trace = trace_in;
 	else if (kernel && task)
@@ -437,11 +438,10 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 	else
 		trace = get_perf_callchain(regs, 0, kernel, user, max_depth,
 					   crosstask, false);
-	if (unlikely(!trace))
-		goto err_fault;
-
-	if (trace->nr < skip)
+	if (unlikely(!trace) || trace->nr < skip) {
+		preempt_enable();
 		goto err_fault;
+	}
 
 	trace_nr = trace->nr - skip;
 	trace_nr = (trace_nr <= num_elem) ? trace_nr : num_elem;
@@ -452,6 +452,7 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 		stack_map_get_build_id_offset(buf, ips, trace_nr, user);
 	else
 		memcpy(buf, ips, copy_len);
+	preempt_enable();
 
 	if (size > copy_len)
 		memset(buf + copy_len, 0, size - copy_len);
-- 
2.53.0



