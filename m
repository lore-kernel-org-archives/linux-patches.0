Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7703F58F7;
	Sat, 12 Sep 2026 08:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202028; cv=none; b=LO04IQyTRHQ84XsyvhO43e2fW9b6MW5q/Mlk0yKGV8fsvCLTdcL5PBWIY4O33RPkH93uaT4xJjNphcN/EWzBXR1kmQZmb5oVHmtDfF4OM6poqQVkC96fYgj6j0l5gwfZKBCBYZsyo3pixn4IYoxDH71udAc6pd0Y+z4BP8it+eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202028; c=relaxed/simple;
	bh=FbTSgiEhdMQg08Zx+T3Utjx+pcsGE7Jk3yEe7Ebu/0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hbw6XUlNB+Q4uFlFWV/iXDPMdL/w37HLIikNKk0TKaXtzD+KSnuBNwd0iLD1GUgCajWiRe1j+stb/L4U8C3OvvA3vfPwxzDtNZ+L62E/1thIzn9OngVBC8/6gQVuzAPWPMi5OhXvSRVi/OKiJOZ5vHTJ+1rSWnbzn6RGCKVRSPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1EOa14u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1EOa14u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB941F000FF;
	Sat, 12 Sep 2026 08:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202027;
	bh=uuHaUF3+IJubUVGWUkCBhQEZFf03CKmClxoM4g+vb6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1EOa14uWrAGhJiN9VUkI0WctAPBQHhpP9TAdZvt5zmt1e+OR9j/EZKDWg4nBY7X9
	 VhH1gq/zgXFq13m4A1/8fAF4xZIiUy6U7+uBlXmNPrR5MXWFfDVWexMuOILXjJSkQS
	 q9ivOvPj85dgnTH9MtKxcP3Bud/WebW+iiapgj+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1118/1815] bpf: Factor callchain_finalize function from __bpf_get_stack
Date: Sat, 12 Sep 2026 08:47:48 +0200
Message-ID: <20260912065715.265215118@linuxfoundation.org>
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
index e953c3105ca0a..5611ad5ff98df 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -764,16 +764,31 @@ static u32 callchain_store(struct perf_callchain_entry *trace, void *buf,
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
 
@@ -823,19 +838,13 @@ static long __bpf_get_stack(struct pt_regs *regs, struct task_struct *task,
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



