Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4172566;
	Tue, 27 May 2025 17:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367045; cv=none; b=ISYSG1CbiNRsMBY8T5DKPr1jGoeMxdr0CVOzvj/MGKrzMYObNJI3xzoo6o3nF5QDvy/yJMz+ANGMP3i4b9zFm0FJRePx/f31lB4J0LZduf/ihm9pF2P1pdJeQtwijohlmbCyHKr2BWTu7/PAgfPnczGi76Wi/8MbE9d1/Q0kvIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367045; c=relaxed/simple;
	bh=YE7qOHBYCXaT5PwKcdf81L+R+WrLZw94ww344ZV8CXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvOsh6i5hC/T5BXLzAkZu/Q5M71NqwFkVbWhMQjW2FcrpJ+ai0OzDvjAgvjlKXz0b8dQNzAto9JE1UWRUJ1tMwWLuELBE5TlShhfKbpiCYsWjsb9U8M+sEU8/RXstWiSKQZdrOR5Dw9wpRPl+SQb2q453vML3WTH4NhE6xZkcZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3dsJ9bj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3dsJ9bj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E766AC4CEE9;
	Tue, 27 May 2025 17:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367045;
	bh=YE7qOHBYCXaT5PwKcdf81L+R+WrLZw94ww344ZV8CXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R3dsJ9bj11cp31lsFt+Ea/JsYmFPdzjvcWnDddK08JuMLjrphUUjRp8ABH/IFQbl6
	 gpHGjR5l34tZUpPDHeR2WB/KBNm1tJBWtuJk68GsxWEq+/1rJHjwz6BMnq2bueV12Q
	 zcEo3dOsPZble1pkkUzKqr7jcqML1cs6OnJ52xS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Jeanson <mjeanson@efficios.com>,
	Ingo Molnar <mingo@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 261/783] rseq: Fix segfault on registration when rseq_cs is non-zero
Date: Tue, 27 May 2025 18:20:58 +0200
Message-ID: <20250527162523.719256997@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

[ Upstream commit fd881d0a085fc54354414aed990ccf05f282ba53 ]

The rseq_cs field is documented as being set to 0 by user-space prior to
registration, however this is not currently enforced by the kernel. This
can result in a segfault on return to user-space if the value stored in
the rseq_cs field doesn't point to a valid struct rseq_cs.

The correct solution to this would be to fail the rseq registration when
the rseq_cs field is non-zero. However, some older versions of glibc
will reuse the rseq area of previous threads without clearing the
rseq_cs field and will also terminate the process if the rseq
registration fails in a secondary thread. This wasn't caught in testing
because in this case the leftover rseq_cs does point to a valid struct
rseq_cs.

What we can do is clear the rseq_cs field on registration when it's
non-zero which will prevent segfaults on registration and won't break
the glibc versions that reuse rseq areas on thread creation.

Signed-off-by: Michael Jeanson <mjeanson@efficios.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20250306211223.109455-1-mjeanson@efficios.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rseq.c | 60 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 12 deletions(-)

diff --git a/kernel/rseq.c b/kernel/rseq.c
index a7d81229eda04..b7a1ec327e811 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -236,6 +236,29 @@ static int rseq_reset_rseq_cpu_node_id(struct task_struct *t)
 	return -EFAULT;
 }
 
+/*
+ * Get the user-space pointer value stored in the 'rseq_cs' field.
+ */
+static int rseq_get_rseq_cs_ptr_val(struct rseq __user *rseq, u64 *rseq_cs)
+{
+	if (!rseq_cs)
+		return -EFAULT;
+
+#ifdef CONFIG_64BIT
+	if (get_user(*rseq_cs, &rseq->rseq_cs))
+		return -EFAULT;
+#else
+	if (copy_from_user(rseq_cs, &rseq->rseq_cs, sizeof(*rseq_cs)))
+		return -EFAULT;
+#endif
+
+	return 0;
+}
+
+/*
+ * If the rseq_cs field of 'struct rseq' contains a valid pointer to
+ * user-space, copy 'struct rseq_cs' from user-space and validate its fields.
+ */
 static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
 {
 	struct rseq_cs __user *urseq_cs;
@@ -244,17 +267,16 @@ static int rseq_get_rseq_cs(struct task_struct *t, struct rseq_cs *rseq_cs)
 	u32 sig;
 	int ret;
 
-#ifdef CONFIG_64BIT
-	if (get_user(ptr, &t->rseq->rseq_cs))
-		return -EFAULT;
-#else
-	if (copy_from_user(&ptr, &t->rseq->rseq_cs, sizeof(ptr)))
-		return -EFAULT;
-#endif
+	ret = rseq_get_rseq_cs_ptr_val(t->rseq, &ptr);
+	if (ret)
+		return ret;
+
+	/* If the rseq_cs pointer is NULL, return a cleared struct rseq_cs. */
 	if (!ptr) {
 		memset(rseq_cs, 0, sizeof(*rseq_cs));
 		return 0;
 	}
+	/* Check that the pointer value fits in the user-space process space. */
 	if (ptr >= TASK_SIZE)
 		return -EINVAL;
 	urseq_cs = (struct rseq_cs __user *)(unsigned long)ptr;
@@ -330,7 +352,7 @@ static int rseq_need_restart(struct task_struct *t, u32 cs_flags)
 	return !!event_mask;
 }
 
-static int clear_rseq_cs(struct task_struct *t)
+static int clear_rseq_cs(struct rseq __user *rseq)
 {
 	/*
 	 * The rseq_cs field is set to NULL on preemption or signal
@@ -341,9 +363,9 @@ static int clear_rseq_cs(struct task_struct *t)
 	 * Set rseq_cs to NULL.
 	 */
 #ifdef CONFIG_64BIT
-	return put_user(0UL, &t->rseq->rseq_cs);
+	return put_user(0UL, &rseq->rseq_cs);
 #else
-	if (clear_user(&t->rseq->rseq_cs, sizeof(t->rseq->rseq_cs)))
+	if (clear_user(&rseq->rseq_cs, sizeof(rseq->rseq_cs)))
 		return -EFAULT;
 	return 0;
 #endif
@@ -375,11 +397,11 @@ static int rseq_ip_fixup(struct pt_regs *regs)
 	 * Clear the rseq_cs pointer and return.
 	 */
 	if (!in_rseq_cs(ip, &rseq_cs))
-		return clear_rseq_cs(t);
+		return clear_rseq_cs(t->rseq);
 	ret = rseq_need_restart(t, rseq_cs.flags);
 	if (ret <= 0)
 		return ret;
-	ret = clear_rseq_cs(t);
+	ret = clear_rseq_cs(t->rseq);
 	if (ret)
 		return ret;
 	trace_rseq_ip_fixup(ip, rseq_cs.start_ip, rseq_cs.post_commit_offset,
@@ -453,6 +475,7 @@ SYSCALL_DEFINE4(rseq, struct rseq __user *, rseq, u32, rseq_len,
 		int, flags, u32, sig)
 {
 	int ret;
+	u64 rseq_cs;
 
 	if (flags & RSEQ_FLAG_UNREGISTER) {
 		if (flags & ~RSEQ_FLAG_UNREGISTER)
@@ -507,6 +530,19 @@ SYSCALL_DEFINE4(rseq, struct rseq __user *, rseq, u32, rseq_len,
 		return -EINVAL;
 	if (!access_ok(rseq, rseq_len))
 		return -EFAULT;
+
+	/*
+	 * If the rseq_cs pointer is non-NULL on registration, clear it to
+	 * avoid a potential segfault on return to user-space. The proper thing
+	 * to do would have been to fail the registration but this would break
+	 * older libcs that reuse the rseq area for new threads without
+	 * clearing the fields.
+	 */
+	if (rseq_get_rseq_cs_ptr_val(rseq, &rseq_cs))
+	        return -EFAULT;
+	if (rseq_cs && clear_rseq_cs(rseq))
+		return -EFAULT;
+
 #ifdef CONFIG_DEBUG_RSEQ
 	/*
 	 * Initialize the in-kernel rseq fields copy for validation of
-- 
2.39.5



