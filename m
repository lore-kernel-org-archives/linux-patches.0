Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43744344DBD;
	Sat, 12 Sep 2026 16:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229306; cv=none; b=jvYBMawZ+7o4na3lBbVDvc/mKu3wpTLLWJop0Ziy9HgPTHLeqN06+nXSzoB6j1yhSyFvz3k5jKHR5zq7uYlc6rINe6ipyU3VRCjBabB7RrIGRw1+3qbg0ToyIFN3hTAzyFAbdJNO04tCtbBdbLfR8p8uHdM6mvxnFfhXng2QdyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229306; c=relaxed/simple;
	bh=+DmqVqVIW/6qmJmrSUPsHHOuJQOiWNtvGFPbeXUyj7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFL02zDLQ24sQJ3H17RD1y/YjHlf3P4W2hKRVZtoYdPPaN3sadJ1ZHn0VqHaO55y50K6eM5jev7VEtpx4Q1Q8i/PhrrQ8guISjrYuUZ/WveAEmWJj1KvBprAgyOTK+bm9augL5kAeyqvdkLVRqSt+eDh6AI2br24v1QX0OAzGy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ygGG1EvG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ygGG1EvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A8E1F000FF;
	Sat, 12 Sep 2026 16:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229305;
	bh=q5mTjw2xSdpKFlxKN8JblKJ0Vo8YBdEZt42ZNKgIffI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ygGG1EvG0b2FSQwwsDyp9FTqwl/ZgsJlfyCX7VveU/2dFdOsoZv7BrJtjJR23We29
	 4E1Q7YBNW/L/6AZEe4dRnpTXNb7Ow8w1ABoR9U0v44xLhnA9fR8yp6x3NXoZIUsRn2
	 IJTtPKRU5wusAcxJeEax/fcrOQYlPLhQDYGmExGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0564/1191] bpf: Fix use-after-free on mm_struct in bpf_find_vma()
Date: Sat, 12 Sep 2026 08:54:52 +0200
Message-ID: <20260912065600.913651883@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanghyun Park <sanghyun.park.cnu@gmail.com>

[ Upstream commit 47b079e2117a2ee52e21f8b72935900c702fc0b5 ]

bpf_find_vma() reads task->mm and calls mmap_read_trylock(mm) without
holding a reference on the mm. On a foreign task, a concurrent exit_mm()
can free the mm_struct between the lockless read and the trylock,
resulting in a use-after-free. mm_struct is not SLAB_TYPESAFE_BY_RCU.

For the current task, task->mm is stable. For a foreign task, pin the mm
under task->alloc_lock and release it with mmput_async(), mirroring commit
d8e27d2d22b6 ("bpf: fix mm lifecycle in open-coded task_vma iterator").
Use spin_trylock() instead of get_task_mm() so BPF context does not block
on alloc_lock. Reject irqs-disabled contexts and !CONFIG_MMU on the
foreign-task path because dropping the mm reference is not safe there.

Race:

  CPU0 (BPF program)                  CPU1 (exiting task)
  ============================        ==========================
  bpf_find_vma(foreign_task):
    mm = task->mm
                                      exit_mm():
                                        task->mm = NULL
                                        mmput(mm) -> frees mm_struct
    mmap_read_trylock(mm)
        // UAF on mm

Fixes: 7c7e3d31e785 ("bpf: Introduce helper bpf_find_vma")
Signed-off-by: Sanghyun Park <sanghyun.park.cnu@gmail.com>
Reviewed-by: Puranjay Mohan <puranjay@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/bpf/20260708072106.199637-2-sanghyun.park.cnu@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/task_iter.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
index f7ef58090c7d0..30dd2b31a38d9 100644
--- a/kernel/bpf/task_iter.c
+++ b/kernel/bpf/task_iter.c
@@ -783,6 +783,7 @@ BPF_CALL_5(bpf_find_vma, struct task_struct *, task, u64, start,
 	struct mmap_unlock_irq_work *work = NULL;
 	struct vm_area_struct *vma;
 	bool irq_work_busy = false;
+	bool __maybe_unused mmput_needed = false;
 	struct mm_struct *mm;
 	int ret = -ENOENT;
 
@@ -792,14 +793,38 @@ BPF_CALL_5(bpf_find_vma, struct task_struct *, task, u64, start,
 	if (!task)
 		return -ENOENT;
 
-	mm = task->mm;
+	if (task == current) {
+		mm = task->mm;
+	} else {
+		/*
+		 * Foreign task: pin task->mm against a concurrent exit_mm().
+		 * Use trylock on alloc_lock instead of get_task_mm()'s
+		 * blocking task_lock() to avoid deadlocking the target task.
+		 */
+		if (!IS_ENABLED(CONFIG_MMU))
+			return -EOPNOTSUPP;
+		if (irqs_disabled())
+			return -EBUSY;
+		if (!spin_trylock(&task->alloc_lock))
+			return -EBUSY;
+		mm = task->mm;
+		if (mm && !(task->flags & PF_KTHREAD)) {
+			mmget(mm);
+			mmput_needed = true;
+		} else {
+			mm = NULL;
+		}
+		spin_unlock(&task->alloc_lock);
+	}
 	if (!mm)
 		return -ENOENT;
 
 	irq_work_busy = bpf_mmap_unlock_get_irq_work(&work);
 
-	if (irq_work_busy || !mmap_read_trylock(mm))
-		return -EBUSY;
+	if (irq_work_busy || !mmap_read_trylock(mm)) {
+		ret = -EBUSY;
+		goto out;
+	}
 
 	vma = find_vma(mm, start);
 
@@ -809,6 +834,11 @@ BPF_CALL_5(bpf_find_vma, struct task_struct *, task, u64, start,
 		ret = 0;
 	}
 	bpf_mmap_unlock_mm(work, mm);
+out:
+#ifdef CONFIG_MMU
+	if (mmput_needed)
+		mmput_async(mm);
+#endif
 	return ret;
 }
 
-- 
2.53.0



