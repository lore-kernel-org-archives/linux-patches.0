Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C3F3B059F;
	Tue, 13 Oct 2026 12:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894155; cv=none; b=ZF5Z086scI8sYSXIrfpDXUuoocWk1LOAeoMxU+HVFwjS8pse6Mxn44Puvt+/VjPlihIYqd5ykyEtZKCWIuKehKeY/oZqaYzFMes9smAR6gGrESDcFcbYu2ZJcbUstKl7ed7cHAIZBdCcAZOnK1Hvzh4qSXP1cqxAMbjAIpMQlS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894155; c=relaxed/simple;
	bh=FxJXaBZKSmwHGYoDecuAt0fPJn+TNAbNh/PkfKC+R80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRTgLJrWvhZ2vKwvPBMoi3jIvL3qwptFGkAjMQns68SgZaB6gcrGnfM/peJBBNgdS6oWJem7Md3UPbx2FRhJmAb6bkJzM3fUtkcu1eenLDuqi5J0UxmKA0tnwmvP4hp32Qetr2+qWD2XUamb7jxi2sVhDvm7albabNc3HwK53Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NxXIEAPe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxXIEAPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A586B1F000FF;
	Tue, 13 Oct 2026 12:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894154;
	bh=Rucm0rBeQev4lHjERVDrhJi4QRorvKkgntO9LC3PmXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NxXIEAPe4md3tUi9DRfSt6Lg95WdPUvsPhoRNlfFSM4g/CZvD6UN57fSexMtZ+3+k
	 Sx9EaTYI9D8116CBdsEGtoB0JxOuYeGgw83TsR+VkB8LcbhJ8agqH01ouQNAfECEyh
	 07Jxdrw5671gsFlkm5sFoy+06WUFpemOcnrcSUK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 438/621] bpf: Factor callchain_store function from __bpf_get_stack
Date: Tue, 13 Oct 2026 13:37:13 +0200
Message-ID: <20261013112931.226825685@linuxfoundation.org>
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
index c479f649596f9..933edcbb92f56 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -621,6 +621,29 @@ const struct bpf_func_proto bpf_get_stackid_proto_pe = {
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
@@ -633,7 +656,6 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
 	struct perf_callchain_entry *trace;
 	bool kernel = !user;
 	int err = -EINVAL;
-	u64 *ips;
 
 	if (unlikely(flags & ~(BPF_F_SKIP_FIELD_MASK | BPF_F_USER_STACK |
 			       BPF_F_USER_BUILD_ID)))
@@ -680,21 +702,10 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
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



