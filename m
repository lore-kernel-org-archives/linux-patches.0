Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373DC3AA1BC;
	Tue, 13 Oct 2026 12:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894188; cv=none; b=KbbEz4zTv9x3Jj89e3fCS5eauwvdv9F0hX0hTnJPhmsJSAlB6CPp8pSlaXnCxOLgUjsbAuVyrUH/cZmweUd88ZJJDMGYfVtA7a3WNapp+cMjR2Gf4Uwzs4YN2AF3ARE3nSBGKN6bwaO1fUL9U7K876fofJbo586zj5Tjz/bgb2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894188; c=relaxed/simple;
	bh=NNLJ78zheIfN5QppIHTVdpb1JHg8caoyS7/v4rh3lzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=st5qkp+rou1//LpN7fyEq3sUPA8zXwU6WV/fkyLziJ32q9QgJleD+j2gSevf6lbKK0NurVF3VePB+uMTX8vGkMcH3eHz/dMQkTlEmnqN9GPVAqUap67xuo4VVjvmqtseV74JMqwwXG8apCy25m6MlLciR+TQC+IOqZbbwraJY5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKnCxb5f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKnCxb5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86EF91F000FF;
	Tue, 13 Oct 2026 12:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894187;
	bh=DqaoeI6an3CjmQE0jBoVnHN1fQnJnf9xVTX0In2sRE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKnCxb5fxN2LnWcp90sxEQPtCOpWgiyZ8cDtbUEMwxE0/KyZYf+VrPYMeb5uzA+kX
	 Nnq/Yf9WmZFEyv3jPW0otagadphYi4rvjQfRufc5lsgfJKfFyYANN8eQ4/GZvqNCqC
	 2GumMLEO4Szio1M9Wa0310LtZOhsokUg2GaCHnwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 439/621] bpf: Factor callchain_finalize function from __bpf_get_stack
Date: Tue, 13 Oct 2026 13:37:14 +0200
Message-ID: <20261013112931.250391894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 014fbe5902dccdaef69114abdcdb15e3dbe55e34 ]

The new callchain_finalize function calls the build-id retrieval
(if needed) and zeroes the buffer. This makes things easier for
preemption fix in following change.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260803210149.296496-8-jolsa@kernel.org
Stable-dep-of: f5d242825ca4 ("bpf: Clear buf on error in __bpf_get_task_stack")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 933edcbb92f56..8e4a716410494 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -644,16 +644,31 @@ static u32 callchain_store(struct perf_callchain_entry *trace, void *buf,
 	return trace_nr;
 }
 
+static long callchain_finalize(void *buf, u32 size, u32 trace_nr, u32 elem_size,
+			       u64 flags, bool may_fault)
+{
+	bool user_build_id = flags & BPF_F_USER_BUILD_ID;
+	bool user = flags & BPF_F_USER_STACK;
+	u32 copy_len = trace_nr * elem_size;
+
+	if (user_build_id)
+		stack_map_get_build_id_offset(buf, trace_nr, user, may_fault);
+
+	if (size > copy_len)
+		memset(buf + copy_len, 0, size - copy_len);
+	return copy_len;
+}
+
 static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 			    struct perf_callchain_entry *trace_in,
 			    void *buf, u32 size, u64 flags, bool may_fault)
 {
-	u32 trace_nr, copy_len, elem_size, max_depth;
 	bool user_build_id = flags & BPF_F_USER_BUILD_ID;
 	bool crosstask = task && task != current;
 	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
 	bool user = flags & BPF_F_USER_STACK;
 	struct perf_callchain_entry *trace;
+	u32 trace_nr, elem_size, max_depth;
 	bool kernel = !user;
 	int err = -EINVAL;
 
@@ -703,19 +718,13 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 	}
 
 	trace_nr = callchain_store(trace, buf, elem_size, flags);
-	copy_len = trace_nr * elem_size;
 
 	/* trace should not be dereferenced after this point */
 	if (may_fault)
 		rcu_read_unlock();
 	preempt_enable();
 
-	if (user_build_id)
-		stack_map_get_build_id_offset(buf, trace_nr, user, may_fault);
-
-	if (size > copy_len)
-		memset(buf + copy_len, 0, size - copy_len);
-	return copy_len;
+	return callchain_finalize(buf, size, trace_nr, elem_size, flags, may_fault);
 
 err_fault:
 	err = -EFAULT;
-- 
2.53.0



