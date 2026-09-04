Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447294CCDC7;
	Fri,  4 Sep 2026 05:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500286; cv=none; b=XAtbnM7fAJfYe1KQWXggh78cYRHYCa9Tukal+RAAdq+yMb+Dqw+rRZXzoCz2C7Oi6prnuNNX7trvzFo1Qwf+5tTbeiEz8XGtXJGhfrtcknLZCgswW7cHrBqBzg8ba6n0YpREC2/hUa8mVhB6RquBvfiCBXm7l6I3Ds6HIaKQ4to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500286; c=relaxed/simple;
	bh=ARXIecUWJisEVPabMYagT7Ld0qW4YRYH+LbDNPQsNnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cec0SMjNKTv/5cZyCpNBPFgnDuhBNN3OjgskeedqHPk0ODmSnsYUtVzjxBus/w5cjdHAq9LTB2ux89Jm9hwq3G22wu6mAdkCL7g6z7JitYMVTsZ2GOjYFxJzzRuEy+Gdt0+uFAqd4CSnGT+RHPR+qNpEkR/6ORjk1rP4rmgS9fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXIL5zX1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXIL5zX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F3F1F00A3D;
	Fri,  4 Sep 2026 05:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500284;
	bh=5s3TYO5qVHmrQIKuDiw1Gbca13mHlenMKklToxVCJpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HXIL5zX1WyiDl2BzO7PNTZFUaQHzGDvhdu3LlstkH4fNlnIf6O45g0q+9Uwg9UL3/
	 p6J45IJXmwAv5Jv5hdVThMFApUrlBqRoBSJJwExNdit+6uMjVlJM4EDl9y+ieqDZoX
	 GvG6kuMsrm3630obzjTxr6jPjX7HXOERDHxHofPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Lance Yang <lance.yang@linux.dev>,
	Qian Cai <cai@lca.pw>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 683/713] mm/kmemleak: stop the task stack scan early when interrupted
Date: Fri,  4 Sep 2026 07:00:51 +0200
Message-ID: <20260904045819.150125416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit eb11f56eeca56069613d00bf623607e305b271d9 ]

scan_block() already checks scan_should_stop() for every pointer and bails
out of the current block, but the task stack walk cannot tell and keeps
issuing a separate scan_should_stop() between every task.

Return that status from scan_block() and use it as the task stack loop
condition, so the walk stops as soon as a scan is interrupted.

Link: https://lore.kernel.org/20260615-kmemleak-stack-resched-v3-2-acecd7d7fd92@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Qian Cai <cai@lca.pw>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 3541a2b06ecd ("mm/kmemleak: report RCU-tasks quiescent states during the scan")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmemleak.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1525,22 +1525,25 @@ static int scan_should_stop(void)
 
 /*
  * Scan a memory block (exclusive range) for valid pointers and add those
- * found to the gray list.
+ * found to the gray list. Return non-zero if the scan was interrupted.
  */
-static void scan_block(void *_start, void *_end,
-		       struct kmemleak_object *scanned)
+static int scan_block(void *_start, void *_end,
+		      struct kmemleak_object *scanned)
 {
 	unsigned long *ptr;
 	unsigned long *start = PTR_ALIGN(_start, BYTES_PER_POINTER);
 	unsigned long *end = _end - (BYTES_PER_POINTER - 1);
 	unsigned long flags;
+	int stop = 0;
 
 	raw_spin_lock_irqsave(&kmemleak_lock, flags);
 	for (ptr = start; ptr < end; ptr++) {
 		unsigned long pointer;
 
-		if (scan_should_stop())
+		if (scan_should_stop()) {
+			stop = 1;
 			break;
+		}
 
 		kasan_disable_current();
 		pointer = *(unsigned long *)kasan_reset_tag((void *)ptr);
@@ -1550,6 +1553,8 @@ static void scan_block(void *_start, voi
 		pointer_update_refs(scanned, pointer, OBJECT_PERCPU);
 	}
 	raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
+
+	return stop;
 }
 
 /*
@@ -1705,6 +1710,7 @@ static void kmemleak_scan_task_stacks(vo
 {
 	struct pid *pid;
 	int nr = 1;
+	int stop = 0;
 
 	do {
 		struct task_struct *p = NULL;
@@ -1723,13 +1729,13 @@ static void kmemleak_scan_task_stacks(vo
 			void *stack = try_get_task_stack(p);
 
 			if (stack) {
-				scan_block(stack, stack + THREAD_SIZE, NULL);
+				stop = scan_block(stack, stack + THREAD_SIZE, NULL);
 				put_task_stack(p);
 			}
 			put_task_struct(p);
 		}
 		cond_resched();
-	} while (pid && !scan_should_stop());
+	} while (pid && !stop);
 }
 
 /*


