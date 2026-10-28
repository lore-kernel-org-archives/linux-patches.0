Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216461;
	b=GOVQ2v/gPHhRGrK1D2OpfshLkD69DJT0H+RvSC3d3VF7JRRWpj0odMc0q5uU4YqqJYal
	 rxi5AFwLRzu/I1e6a3IgDzWASN4vhEHRrHTr5KShdcsfafFKdg4gzF20KQVSZC+zyYbip
	 V091rbFzUCL/HcwhessncMdIXSqmrPEPHTYY475BZiZs7ifMBNdGRPmuylPI/RNnZlE+q
	 9srSaVYnqU9S6rhU+o8IbuUefqtHoxc5SvQyGX/vocmxYvLbZkMfP7XigAKSYyshESU/T
	 WrV0Q90aguHr6hN8q3PbmXBihi7PkV5nHc7cJtYUsIkdW4ry5fLD/624arj7bqUVUvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IFQbBfbuldmeizcF6nqS7/ExQRpGDuVzW58N/IUPMtI=;
	b=TY4nkQOxsI7cg+LFHFl7gpUAo4Io98fRe4kwz3JHuLPja7KGr+famkkORG9qYOYdWoNr
	 e33KOg2/tS9s+FtM/Cb/oqHPOLgNywGuQlzRzdbiQXVkTDTJw1M+1SQU85k+zMkeyHLjs
	 /yf2RMUNPG1UWJLzDDDWVem4VbBSv7qTCjMEMMDZvTtkRfzQVG1Jsl74R7t45PNwdPdBL
	 OTw/eoe7jUX+CV40Q9mefvvyJKY9S5Ks6EHhUpc4EexLkxLkLa1KwCBJT21W7LPg0Ocyl
	 ADFcRoW4Nz4K3ve+GtR7xDPJ5xrvpo1tFrBejjJcmoozNJwmd//XU32APwdp6HqwyCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xm/QVM3y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D154606A331;
	Wed, 28 Oct 2026 19:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xm/QVM3y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285071F01828;
	Wed, 28 Oct 2026 19:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216460;
	bh=IFQbBfbuldmeizcF6nqS7/ExQRpGDuVzW58N/IUPMtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xm/QVM3yoAtqIGoGcBehQwkK7PEOTFmngkRZHOmzYljoHENYI3KevHfwpNmdT5iIx
	 3w2pc4kJudiqPuqGQjfT/rOW9vwNqQcwYsbWrYyh323CSd+sPK6BdIEMmheJz0ogyn
	 Pr/A/mgs4gCDALbHpqw8O/ap0AeI1U0Pg0VKAjvM=
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
Subject: [PATCH 6.1 1565/1887] bpf: Fix mmap_lock leak in irq_work path
Date: Wed, 28 Oct 2026 18:01:01 +0100
Message-ID: <20261028170535.078787238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 kernel/bpf/stackmap.c         | 35 +++++++++++++-----------
 kernel/bpf/task_iter.c        | 14 +++++++---
 3 files changed, 59 insertions(+), 41 deletions(-)

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
index a8d54f650ff90..b8df42496f4fe 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -131,24 +131,20 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
 					  u64 *ips, u32 trace_nr, bool user)
 {
 	int i;
-	struct mmap_unlock_irq_work *work = NULL;
-	bool irq_work_busy = bpf_mmap_unlock_get_irq_work(&work);
+	struct mmap_unlock_irq_work *work;
 	struct vm_area_struct *vma, *prev_vma = NULL;
 	const char *prev_build_id;
 
-	/* If the irq_work is in use, fall back to report ips. Same
-	 * fallback is used for kernel stack (!user) on a stackmap with
-	 * build_id.
-	 */
-	if (!user || !current || !current->mm || irq_work_busy ||
-	    !mmap_read_trylock(current->mm)) {
-		/* cannot access current->mm, fall back to ips */
-		for (i = 0; i < trace_nr; i++) {
-			id_offs[i].status = BPF_STACK_BUILD_ID_IP;
-			id_offs[i].ip = ips[i];
-			memset(id_offs[i].build_id, 0, BUILD_ID_SIZE_MAX);
-		}
-		return;
+	if (!user || !current || !current->mm)
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
@@ -174,6 +170,15 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
 		prev_build_id = id_offs[i].build_id;
 	}
 	bpf_mmap_unlock_mm(work, current->mm);
+	return;
+
+fallback:
+	/* cannot access current->mm, fall back to ips */
+	for (i = 0; i < trace_nr; i++) {
+		id_offs[i].status = BPF_STACK_BUILD_ID_IP;
+		id_offs[i].ip = ips[i];
+		memset(id_offs[i].build_id, 0, BUILD_ID_SIZE_MAX);
+	}
 }
 
 static struct perf_callchain_entry *
diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index 30dd2b31a38d9..481e2b43f0ed1 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -780,9 +780,8 @@ static struct bpf_iter_reg task_vma_reg_info = {
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
@@ -819,9 +818,14 @@ BPF_CALL_5(bpf_find_vma, struct task_struct *, task, u64, start,
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
@@ -864,6 +868,8 @@ static void do_mmap_read_unlock(struct irq_work *entry)
 
 	work = container_of(entry, struct mmap_unlock_irq_work, irq_work);
 	mmap_read_unlock_non_owner(work->mm);
+	work->mm = NULL;
+	bpf_mmap_unlock_guard_put(work);
 }
 
 static int __init task_iter_init(void)
-- 
2.53.0



