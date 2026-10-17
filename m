Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236133A0E85;
	Sat, 17 Oct 2026 16:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255086; cv=none; b=S7DpmCqjE+LQ7fkHVh5j8gg+LE39Gpj/uy19q3Q/v20Y2/gFENlZn1al2cp647WidJlfj+nMJrkq8W6I48bn8QrjFSf9zt03qHUTj9IXf4e9L9mXGVzS3GKo9DGleomwHVkewN9YurRvQOI33hFrupGli73zaa2v/poBiMBwPHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255086; c=relaxed/simple;
	bh=r4TAE8LbsNg5QaZb28zSPKvXSclyspZnKpSHeXyu9M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bqs06FABiqy67gLHzpgnYwDxQiojB7cRPXdftADUEDta37vL/LasBdPRAzv+VjgHVPqZhLwX0DgIndgPX+upjk4hWWn/8eP5wM7EfgZWZpzUKEpM/YdjJSQEpSCPuqxb1QcMOKMR8nPwuJYAl5x/ajWudBQa5GtSjulUCIe17i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tONTB5qs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tONTB5qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DB81F000C4;
	Sat, 17 Oct 2026 16:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255085;
	bh=ABZlsvyEQQEICWj9DrR9doZibh+dhZSzGzIf5byB/8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tONTB5qs3pEW/obAxlT2YDcjU4Ycs23yLkKQkOTi46ed3C1Mhx9ZzHXfyTfEa9WZe
	 PNArQ7odObJQsumgnFXVxU1fToAWxmVDic0n6RdHJvWfzLsSogWBypkUul2d7D9upR
	 rqLMh4wQFx2JD1N758fjaWcc9WQGvW9L1O6boCmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 653/869] bpf: Factor callchain_store function from __bpf_get_stack
Date: Sat, 17 Oct 2026 17:58:14 +0200
Message-ID: <20261017160053.745953340@linuxfoundation.org>
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

[ Upstream commit cbb99938e7935c9f62c891573a4b09690e5e22de ]

The new callchain_store function stores trace entries buffer into
user supplied buffer. It covers both just-ip and buildid data.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260803210149.296496-7-jolsa@kernel.org
Stable-dep-of: f5d242825ca4 ("bpf: Clear buf on error in __bpf_get_task_stack")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index ebab2f0374b88..db6d6bfecbad4 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -488,6 +488,29 @@ const struct bpf_func_proto bpf_get_stackid_proto_pe = {
 	.arg3_type	= ARG_ANYTHING,
 };
 
+static u32 callchain_store(struct perf_callchain_entry *trace, void *buf,
+			   u32 elem_size, u64 flags)
+{
+	bool user_build_id = flags & BPF_F_USER_BUILD_ID;
+	u32 skip = flags & BPF_F_SKIP_FIELD_MASK;
+	u32 trace_nr, copy_len;
+	u64 *ips;
+
+	trace_nr = trace->nr - skip;
+	copy_len = trace_nr * elem_size;
+
+	ips = trace->ip + skip;
+	if (user_build_id) {
+		struct bpf_stack_build_id *id_offs = buf;
+
+		for (u32 i = 0; i < trace_nr; i++)
+			id_offs[i].ip = ips[i];
+	} else {
+		memcpy(buf, ips, copy_len);
+	}
+	return trace_nr;
+}
+
 static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 			    struct perf_callchain_entry *trace_in,
 			    void *buf, u32 size, u64 flags, bool may_fault)
@@ -500,7 +523,6 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 	struct perf_callchain_entry *trace;
 	bool kernel = !user;
 	int err = -EINVAL;
-	u64 *ips;
 
 	if (unlikely(flags & ~(BPF_F_SKIP_FIELD_MASK | BPF_F_USER_STACK |
 			       BPF_F_USER_BUILD_ID)))
@@ -547,21 +569,10 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 		goto err_fault;
 	}
 
-	trace_nr = trace->nr - skip;
+	trace_nr = callchain_store(trace, buf, elem_size, flags);
 	copy_len = trace_nr * elem_size;
 
-	ips = trace->ip + skip;
-	if (user_build_id) {
-		struct bpf_stack_build_id *id_offs = buf;
-		u32 i;
-
-		for (i = 0; i < trace_nr; i++)
-			id_offs[i].ip = ips[i];
-	} else {
-		memcpy(buf, ips, copy_len);
-	}
-
-	/* trace/ips should not be dereferenced after this point */
+	/* trace should not be dereferenced after this point */
 	if (may_fault)
 		rcu_read_unlock();
 	preempt_enable();
-- 
2.53.0



