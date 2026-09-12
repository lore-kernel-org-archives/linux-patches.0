Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D123541687C;
	Sat, 12 Sep 2026 10:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210523; cv=none; b=PWmJ6lTBBK0+xT85vp4uZ5FVHlKPloTaiTquFHe1F/S0OyuLLo22UF9S+18O2izkOdJ4cVWYXFGm6FMkd/KD0TApghfG7DMnJ+bIxCONHTfo6xTksXi5OoPqa5t2vhquzbStvTpKfNlBV01gcvJ9E1jEgNDLULmmExjAWTkxXvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210523; c=relaxed/simple;
	bh=MZggI8RDpbZSoddGBncbS0NimwCMM63YfaB44xwH4sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvNvktUN8y7/JcTL+qVQYURoTJOTpll/G8lW9LqayIaAL62Acho/5RCPaN5mPIcQuiKhf6umalOU3hoOSQNL02P3u2X9naC/l5TYgoS5hZgGxjnGTgdfXi1W4L7JaTvfNdsncFPZal9dCyMeBLDPzPRxxnahkdizEZQkqfIl1NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0wQvMAj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0wQvMAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EDC1F000FF;
	Sat, 12 Sep 2026 10:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210521;
	bh=1v6LT3SZQDTPmtk5/GdJTUTVApGj2wMekXNklrWAZ+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X0wQvMAjz1MN2S4zYUviDHBHDA3LkWjsVXkFgDLh8Ym1J4hRqsYToWJ7zTTwn1lx6
	 JMd5pYvIMGOPr957hiVg/zMJWOoSWqLrT3pDRzpfQ4QM+T61nNsGbE0/PVeLPwpTPa
	 LjnhcXKnn1fxTIyVgIL2oZdFn5jN4ZPbh5qsJM5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cdd6c0925e12b0af60cc@syzkaller.appspotmail.com,
	sashiko-bot@kernel.org,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1042/1518] bpf: Fix mmap_lock leak in irq_work path
Date: Sat, 12 Sep 2026 08:53:31 +0200
Message-ID: <20260912065647.024148407@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Sanghyun Park <sanghyun.park.cnu@gmail.com>

[ Upstream commit fa9dcacdcdf487f0ffef64bf67622f1caed509f1 ]

stack_map_get_build_id_offset() introduced a per-CPU irq_work to defer
mmap_read_unlock() from NMI context, and bpf_find_vma() later reused the
same mmap_unlock_work. Both callers only check whether the work is busy
before taking mmap_lock, so a nested caller can reuse the slot before the
first caller queues it. Two read locks may then be acquired while only one
deferred unlock runs, leaking a read lock and blocking exit_mmap().

Reserve the per-CPU slot before mmap_read_trylock(). Use the same wrapper
in stackmap and bpf_find_vma() so both callers release the reservation on
trylock failure. Keep rejecting the slot while the irq_work remains busy.
Release it after the irq_work callback unlocks the mm.

Fixes: eac9153f2b58 ("bpf/stackmap: Fix deadlock with rq_lock in bpf_get_stack()")
Reported-by: syzbot+cdd6c0925e12b0af60cc@syzkaller.appspotmail.com
Reported-by: sashiko-bot@kernel.org
Signed-off-by: Sanghyun Park <sanghyun.park.cnu@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Closes: https://syzkaller.appspot.com/bug?extid=cdd6c0925e12b0af60cc
Closes: https://lore.kernel.org/r/20260630033745.B80201F000E9@smtp.kernel.org
Link: https://lore.kernel.org/bpf/20260805031425.2157475-2-sanghyun.park.cnu@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/mmap_unlock_work.h | 51 ++++++++++++++++++++---------------
 kernel/bpf/stackmap.c         | 28 +++++++++++--------
 kernel/bpf/task_iter.c        | 14 +++++++---
 3 files changed, 56 insertions(+), 37 deletions(-)

diff --git a/kernel/bpf/mmap_unlock_work.h b/kernel/bpf/mmap_unlock_work.h
index 5d18d7d85bef9..1834db20b8612 100644
--- a/kernel/bpf/mmap_unlock_work.h
+++ b/kernel/bpf/mmap_unlock_work.h
@@ -4,12 +4,15 @@
 
 #ifndef __MMAP_UNLOCK_WORK_H__
 #define __MMAP_UNLOCK_WORK_H__
+#include <linux/atomic.h>
+#include <linux/err.h>
 #include <linux/irq_work.h>
 
 /* irq_work to run mmap_read_unlock() in irq_work */
 struct mmap_unlock_irq_work {
 	struct irq_work irq_work;
 	struct mm_struct *mm;
+	atomic_t active;
 };
 
 DECLARE_PER_CPU(struct mmap_unlock_irq_work, mmap_unlock_work);
@@ -18,32 +21,36 @@ DECLARE_PER_CPU(struct mmap_unlock_irq_work, mmap_unlock_work);
  * We cannot do mmap_read_unlock() when the irq is disabled, because of
  * risk to deadlock with rq_lock. To look up vma when the irqs are
  * disabled, we need to run mmap_read_unlock() in irq_work. We use a
- * percpu variable to do the irq_work. If the irq_work is already used
- * by another lookup, we fall over.
+ * percpu variable to do the irq_work. The active flag reserves the slot
+ * before mmap_read_trylock() and until the irq_work callback consumes mm.
  */
-static inline bool bpf_mmap_unlock_get_irq_work(struct mmap_unlock_irq_work **work_ptr)
+static inline struct mmap_unlock_irq_work *bpf_mmap_unlock_guard_get(void)
 {
-	struct mmap_unlock_irq_work *work = NULL;
-	bool irq_work_busy = false;
+	struct mmap_unlock_irq_work *work;
 
-	if (irqs_disabled()) {
-		if (!IS_ENABLED(CONFIG_PREEMPT_RT)) {
-			work = this_cpu_ptr(&mmap_unlock_work);
-			if (irq_work_is_busy(&work->irq_work)) {
-				/* cannot queue more up_read, fallback */
-				irq_work_busy = true;
-			}
-		} else {
-			/*
-			 * PREEMPT_RT does not allow to trylock mmap sem in
-			 * interrupt disabled context. Force the fallback code.
-			 */
-			irq_work_busy = true;
-		}
-	}
+	if (!irqs_disabled())
+		return NULL;
+
+	/*
+	 * PREEMPT_RT does not allow to trylock mmap sem in interrupt
+	 * disabled context. Force the fallback code.
+	 */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT))
+		return ERR_PTR(-EBUSY);
+
+	work = this_cpu_ptr(&mmap_unlock_work);
+	if (irq_work_is_busy(&work->irq_work) ||
+	    atomic_cmpxchg_acquire(&work->active, 0, 1))
+		return ERR_PTR(-EBUSY);
 
-	*work_ptr = work;
-	return irq_work_busy;
+	return work;
+}
+
+static inline void
+bpf_mmap_unlock_guard_put(struct mmap_unlock_irq_work *work)
+{
+	if (work)
+		atomic_set_release(&work->active, 0);
 }
 
 static inline void bpf_mmap_unlock_mm(struct mmap_unlock_irq_work *work, struct mm_struct *mm)
diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index bd4c0e8163516..4f33c547a0947 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -291,8 +291,7 @@ static void stack_map_get_build_id_offset_sleepable(struct bpf_stack_build_id *i
 static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
 					  u32 trace_nr, bool user, bool may_fault)
 {
-	struct mmap_unlock_irq_work *work = NULL;
-	bool irq_work_busy = bpf_mmap_unlock_get_irq_work(&work);
+	struct mmap_unlock_irq_work *work;
 	bool has_user_ctx = user && current && current->mm;
 	struct vm_area_struct *vma, *prev_vma = NULL;
 	const unsigned char *prev_build_id = NULL;
@@ -303,15 +302,16 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
 		return;
 	}
 
-	/* If the irq_work is in use, fall back to report ips. Same
-	 * fallback is used for kernel stack (!user) on a stackmap with
-	 * build_id.
-	 */
-	if (!has_user_ctx || irq_work_busy || !mmap_read_trylock(current->mm)) {
-		/* cannot access current->mm, fall back to ips */
-		for (i = 0; i < trace_nr; i++)
-			stack_map_build_id_set_ip(&id_offs[i]);
-		return;
+	if (!has_user_ctx)
+		goto fallback;
+
+	work = bpf_mmap_unlock_guard_get();
+	if (IS_ERR(work))
+		goto fallback;
+
+	if (!mmap_read_trylock(current->mm)) {
+		bpf_mmap_unlock_guard_put(work);
+		goto fallback;
 	}
 
 	for (i = 0; i < trace_nr; i++) {
@@ -339,6 +339,12 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
 		prev_build_id = id_offs[i].build_id;
 	}
 	bpf_mmap_unlock_mm(work, current->mm);
+	return;
+
+fallback:
+	/* cannot access current->mm, fall back to ips */
+	for (i = 0; i < trace_nr; i++)
+		stack_map_build_id_set_ip(&id_offs[i]);
 }
 
 static struct perf_callchain_entry *
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index b256fb9c1214e..13e1aabe6f886 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -753,9 +753,8 @@ static struct bpf_iter_reg task_vma_reg_info = {
 BPF_CALL_5(bpf_find_vma, struct task_struct *, task, u64, start,
 	   bpf_callback_t, callback_fn, void *, callback_ctx, u64, flags)
 {
-	struct mmap_unlock_irq_work *work = NULL;
+	struct mmap_unlock_irq_work *work;
 	struct vm_area_struct *vma;
-	bool irq_work_busy = false;
 	bool __maybe_unused mmput_needed = false;
 	struct mm_struct *mm;
 	int ret = -ENOENT;
@@ -792,9 +791,14 @@ BPF_CALL_5(bpf_find_vma, struct task_struct *, task, u64, start,
 	if (!mm)
 		return -ENOENT;
 
-	irq_work_busy = bpf_mmap_unlock_get_irq_work(&work);
+	work = bpf_mmap_unlock_guard_get();
+	if (IS_ERR(work)) {
+		ret = PTR_ERR(work);
+		goto out;
+	}
 
-	if (irq_work_busy || !mmap_read_trylock(mm)) {
+	if (!mmap_read_trylock(mm)) {
+		bpf_mmap_unlock_guard_put(work);
 		ret = -EBUSY;
 		goto out;
 	}
@@ -1191,6 +1195,8 @@ static void do_mmap_read_unlock(struct irq_work *entry)
 
 	work = container_of(entry, struct mmap_unlock_irq_work, irq_work);
 	mmap_read_unlock_non_owner(work->mm);
+	work->mm = NULL;
+	bpf_mmap_unlock_guard_put(work);
 }
 
 static int __init task_iter_init(void)
-- 
2.53.0



