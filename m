Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD341FBCB2;
	Tue,  8 Apr 2025 11:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110324; cv=none; b=Atam2RZqYK9A/FhRlPDiNh7HlsLnMIzbMZnGEuFuepkH8KShxaPRPQsn2kMXMYeFwBzLnox2Hw+JtZeGzqG/dj2+5o6Ol8ypu8oVKIByQrmBKezDGYaHQoFQQlntUw83yBv4CQT6/iLf1Y4cIt1MGo645/706uHVMCMwjcRWQnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110324; c=relaxed/simple;
	bh=hyZB7mgl9KQCYHpHpdaNbivoSVC//w+Zyxt4kNZpvug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpvm79ryrQVtEqT7/PuMiL+glndhl6wd3IFBp/zA+tAP9rauimJO+XE4dXfHtGyCsB+mQYaq+PNg8IWq0n5gZHIuqzT+nUQG9KSG3fBcudYgtkP8gdhDAkzbzXJ39YQDToNqaVphstda0ELXPmNTZTM11GY8D1Nkc5B+zaKimWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWwr0vyv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWwr0vyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00B2C4CEE7;
	Tue,  8 Apr 2025 11:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110324;
	bh=hyZB7mgl9KQCYHpHpdaNbivoSVC//w+Zyxt4kNZpvug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWwr0vyvlZWEGpj6q3/AshRuKZg8SGMMp8IPI7Nmz2n7vA3qlbQzFBbmLPkNQa52w
	 +euerk16DE6Pjceln1pm9JiAf2+tBbSnVhSXnKTL/miAlWVuzYKaZQ+IOZkPMjpjRZ
	 nnU7LwSIwLTeg2b7cyVk8NP4w/Dmpb07dhfAcuRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Jeanson <mjeanson@efficios.com>,
	Ingo Molnar <mingo@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 022/731] rseq: Update kernel fields in lockstep with CONFIG_DEBUG_RSEQ=y
Date: Tue,  8 Apr 2025 12:38:39 +0200
Message-ID: <20250408104914.782368533@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Jeanson <mjeanson@efficios.com>

[ Upstream commit 79e10dad1ce3feac7937bedf911d92f486a9e76a ]

With CONFIG_DEBUG_RSEQ=y, an in-kernel copy of the read-only fields is
kept synchronized with the user-space fields. Ensure the updates are
done in lockstep in case we error out on a write to user-space.

Fixes: 7d5265ffcd8b ("rseq: Validate read-only fields under DEBUG_RSEQ config")
Signed-off-by: Michael Jeanson <mjeanson@efficios.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/r/20250225202500.731245-1-mjeanson@efficios.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rseq.c | 80 +++++++++++++++++++++++++--------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/kernel/rseq.c b/kernel/rseq.c
index 2cb16091ec0ae..a7d81229eda04 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -78,24 +78,24 @@ static int rseq_validate_ro_fields(struct task_struct *t)
 	return -EFAULT;
 }
 
-static void rseq_set_ro_fields(struct task_struct *t, u32 cpu_id_start, u32 cpu_id,
-			       u32 node_id, u32 mm_cid)
-{
-	rseq_kernel_fields(t)->cpu_id_start = cpu_id;
-	rseq_kernel_fields(t)->cpu_id = cpu_id;
-	rseq_kernel_fields(t)->node_id = node_id;
-	rseq_kernel_fields(t)->mm_cid = mm_cid;
-}
+/*
+ * Update an rseq field and its in-kernel copy in lock-step to keep a coherent
+ * state.
+ */
+#define rseq_unsafe_put_user(t, value, field, error_label)		\
+	do {								\
+		unsafe_put_user(value, &t->rseq->field, error_label);	\
+		rseq_kernel_fields(t)->field = value;			\
+	} while (0)
+
 #else
 static int rseq_validate_ro_fields(struct task_struct *t)
 {
 	return 0;
 }
 
-static void rseq_set_ro_fields(struct task_struct *t, u32 cpu_id_start, u32 cpu_id,
-			       u32 node_id, u32 mm_cid)
-{
-}
+#define rseq_unsafe_put_user(t, value, field, error_label)		\
+	unsafe_put_user(value, &t->rseq->field, error_label)
 #endif
 
 /*
@@ -173,17 +173,18 @@ static int rseq_update_cpu_node_id(struct task_struct *t)
 	WARN_ON_ONCE((int) mm_cid < 0);
 	if (!user_write_access_begin(rseq, t->rseq_len))
 		goto efault;
-	unsafe_put_user(cpu_id, &rseq->cpu_id_start, efault_end);
-	unsafe_put_user(cpu_id, &rseq->cpu_id, efault_end);
-	unsafe_put_user(node_id, &rseq->node_id, efault_end);
-	unsafe_put_user(mm_cid, &rseq->mm_cid, efault_end);
+
+	rseq_unsafe_put_user(t, cpu_id, cpu_id_start, efault_end);
+	rseq_unsafe_put_user(t, cpu_id, cpu_id, efault_end);
+	rseq_unsafe_put_user(t, node_id, node_id, efault_end);
+	rseq_unsafe_put_user(t, mm_cid, mm_cid, efault_end);
+
 	/*
 	 * Additional feature fields added after ORIG_RSEQ_SIZE
 	 * need to be conditionally updated only if
 	 * t->rseq_len != ORIG_RSEQ_SIZE.
 	 */
 	user_write_access_end();
-	rseq_set_ro_fields(t, cpu_id, cpu_id, node_id, mm_cid);
 	trace_rseq_update(t);
 	return 0;
 
@@ -195,6 +196,7 @@ static int rseq_update_cpu_node_id(struct task_struct *t)
 
 static int rseq_reset_rseq_cpu_node_id(struct task_struct *t)
 {
+	struct rseq __user *rseq = t->rseq;
 	u32 cpu_id_start = 0, cpu_id = RSEQ_CPU_ID_UNINITIALIZED, node_id = 0,
 	    mm_cid = 0;
 
@@ -202,38 +204,36 @@ static int rseq_reset_rseq_cpu_node_id(struct task_struct *t)
 	 * Validate read-only rseq fields.
 	 */
 	if (rseq_validate_ro_fields(t))
-		return -EFAULT;
-	/*
-	 * Reset cpu_id_start to its initial state (0).
-	 */
-	if (put_user(cpu_id_start, &t->rseq->cpu_id_start))
-		return -EFAULT;
-	/*
-	 * Reset cpu_id to RSEQ_CPU_ID_UNINITIALIZED, so any user coming
-	 * in after unregistration can figure out that rseq needs to be
-	 * registered again.
-	 */
-	if (put_user(cpu_id, &t->rseq->cpu_id))
-		return -EFAULT;
-	/*
-	 * Reset node_id to its initial state (0).
-	 */
-	if (put_user(node_id, &t->rseq->node_id))
-		return -EFAULT;
+		goto efault;
+
+	if (!user_write_access_begin(rseq, t->rseq_len))
+		goto efault;
+
 	/*
-	 * Reset mm_cid to its initial state (0).
+	 * Reset all fields to their initial state.
+	 *
+	 * All fields have an initial state of 0 except cpu_id which is set to
+	 * RSEQ_CPU_ID_UNINITIALIZED, so that any user coming in after
+	 * unregistration can figure out that rseq needs to be registered
+	 * again.
 	 */
-	if (put_user(mm_cid, &t->rseq->mm_cid))
-		return -EFAULT;
-
-	rseq_set_ro_fields(t, cpu_id_start, cpu_id, node_id, mm_cid);
+	rseq_unsafe_put_user(t, cpu_id_start, cpu_id_start, efault_end);
+	rseq_unsafe_put_user(t, cpu_id, cpu_id, efault_end);
+	rseq_unsafe_put_user(t, node_id, node_id, efault_end);
+	rseq_unsafe_put_user(t, mm_cid, mm_cid, efault_end);
 
 	/*
 	 * Additional feature fields added after ORIG_RSEQ_SIZE
 	 * need to be conditionally reset only if
 	 * t->rseq_len != ORIG_RSEQ_SIZE.
 	 */
+	user_write_access_end();
 	return 0;
+
+efault_end:
+	user_write_access_end();
+efault:
+	return -EFAULT;
 }
 
 static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
-- 
2.39.5



