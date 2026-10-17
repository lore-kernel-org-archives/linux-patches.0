Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EBE3A0E85;
	Sat, 17 Oct 2026 16:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255119; cv=none; b=p+tLs9G5VvpKR1yY6mTBHfZaWfL1F5pM4iYWyU8VzP3JGkt0MBuykU+qb+Bzo3hz9MQEcz6PhjeSa2uZ1wjGZH0xOMtzMk/d6GkdHUbe5kajzUZ8Jt3Uu8noBRnuG+aalEQ6cS7Q6gWh279segScdlIcV5rszKSowP38MFnzbSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255119; c=relaxed/simple;
	bh=3W2h8hqP+qI7Loe3MXakbbPxfAbFfSV2yKAgarCgvKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5g8WW3ljkBd1ayW0ZiWjgW1bolIOOQqtBhYcXtWF1f/q5qldoXX/RP2y2xOAirrJweFadPZVchDIyk9EJk33TT18xKpjkcYL2kwL474HgHnpdkiyJbTzssL23BNgpflNVr/nuuqn8SfWnaXY0EApzDGYRBcGUi4JM1s8jawq44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyXujWe0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyXujWe0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE031F000C4;
	Sat, 17 Oct 2026 16:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255117;
	bh=yoNPxh1LBxKQoAjCksVg03fvXgTl33vfr4UKBa1zGAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fyXujWe0gpG/gmf7mOUOr13qbI223lzsF1LVjJvGcWGaeZ4/iAG0bU5o9oV5e4l03
	 XCgIt5eXKg8lcHx+gysTRjqcoqBB9/wR9Ecj14dKhOV+s+fJzVLIEqe2Ns38WgF0Ec
	 JMMmH7CSqQyZ/1IB//GslQS/QmottWZQwglQYUYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 654/869] bpf: Factor callchain_finalize function from __bpf_get_stack
Date: Sat, 17 Oct 2026 17:58:15 +0200
Message-ID: <20261017160053.771372783@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index db6d6bfecbad4..7818b124d9d6e 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -511,16 +511,31 @@ static u32 callchain_store(struct perf_callchain_entry *trace, void *buf,
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
 
@@ -570,19 +585,13 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
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



