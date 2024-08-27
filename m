Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10DC1C4ED4;
	Tue, 27 Aug 2024 15:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771583; cv=none; b=BMIkV79rEhrJvvI3wQq3f7Mn90wZFZGd5Fuwcwj6f0HmLilamhVJxJeOucQLETrS/NxdFrCxSUFDuZeg0M9fW0MRMien4wz4SLie2UDFapnsPp+uZ7Ro8NknkyRe8Tjs3OMDdDh9C5/ARIT4v233Ja9AQJB/biYhWhEKvOTt0FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771583; c=relaxed/simple;
	bh=aEEO0acm+otKyM4T6X0KzvwTh8rEc04PaWRBuxEX8h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFu0TtNumAQQtGRF2C4CojyGGk2/BRh5KDm1wgPqmv0z0ns1LuDdeme8K5IxWNHCD/Ly1inm4QJcVF3isflyj0F3TPwGQ9sDcbrfNWmAOpran7oLQH5q6aodMTYmMyFuUStmS/4FoANFpO/WSwI8G2/J4HiJvkVenb94tWjblWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2y/XB28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2y/XB28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56862C61048;
	Tue, 27 Aug 2024 15:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771583;
	bh=aEEO0acm+otKyM4T6X0KzvwTh8rEc04PaWRBuxEX8h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2y/XB28WhY5Ox/8GCbS8baJ4qoUd62hTWygvBOXzSKuM9X0mvJ0YT3iVXXLkORTW
	 czwU+5ALyLK7Wx+TaSDjMRq9c7ukTA3csRjhjy5aZaSyKcBp+8ZD9DhSQw1GGrUlEP
	 580saGPqpJQIW6YshJBdmRQG0jXH8VGw4L9DpZsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	syzbot+b3e4f2f51ed645fd5df2@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 201/273] workqueue: Fix spruious data race in __flush_work()
Date: Tue, 27 Aug 2024 16:38:45 +0200
Message-ID: <20240827143841.058564614@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 8bc35475ef1a23b0e224f3242eb11c76cab0ea88 ]

When flushing a work item for cancellation, __flush_work() knows that it
exclusively owns the work item through its PENDING bit. 134874e2eee9
("workqueue: Allow cancel_work_sync() and disable_work() from atomic
contexts on BH work items") added a read of @work->data to determine whether
to use busy wait for BH work items that are being canceled. While the read
is safe when @from_cancel, @work->data was read before testing @from_cancel
to simplify code structure:

	data = *work_data_bits(work);
	if (from_cancel &&
	    !WARN_ON_ONCE(data & WORK_STRUCT_PWQ) && (data & WORK_OFFQ_BH)) {

While the read data was never used if !@from_cancel, this could trigger
KCSAN data race detection spuriously:

  ==================================================================
  BUG: KCSAN: data-race in __flush_work / __flush_work

  write to 0xffff8881223aa3e8 of 8 bytes by task 3998 on cpu 0:
   instrument_write include/linux/instrumented.h:41 [inline]
   ___set_bit include/asm-generic/bitops/instrumented-non-atomic.h:28 [inline]
   insert_wq_barrier kernel/workqueue.c:3790 [inline]
   start_flush_work kernel/workqueue.c:4142 [inline]
   __flush_work+0x30b/0x570 kernel/workqueue.c:4178
   flush_work kernel/workqueue.c:4229 [inline]
   ...

  read to 0xffff8881223aa3e8 of 8 bytes by task 50 on cpu 1:
   __flush_work+0x42a/0x570 kernel/workqueue.c:4188
   flush_work kernel/workqueue.c:4229 [inline]
   flush_delayed_work+0x66/0x70 kernel/workqueue.c:4251
   ...

  value changed: 0x0000000000400000 -> 0xffff88810006c00d

Reorganize the code so that @from_cancel is tested before @work->data is
accessed. The only problem is triggering KCSAN detection spuriously. This
shouldn't need READ_ONCE() or other access qualifiers.

No functional changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: syzbot+b3e4f2f51ed645fd5df2@syzkaller.appspotmail.com
Fixes: 134874e2eee9 ("workqueue: Allow cancel_work_sync() and disable_work() from atomic contexts on BH work items")
Link: http://lkml.kernel.org/r/000000000000ae429e061eea2157@google.com
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c8687c0ab3645..c970eec25c5a0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4190,7 +4190,6 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 static bool __flush_work(struct work_struct *work, bool from_cancel)
 {
 	struct wq_barrier barr;
-	unsigned long data;
 
 	if (WARN_ON(!wq_online))
 		return false;
@@ -4208,29 +4207,35 @@ static bool __flush_work(struct work_struct *work, bool from_cancel)
 	 * was queued on a BH workqueue, we also know that it was running in the
 	 * BH context and thus can be busy-waited.
 	 */
-	data = *work_data_bits(work);
-	if (from_cancel &&
-	    !WARN_ON_ONCE(data & WORK_STRUCT_PWQ) && (data & WORK_OFFQ_BH)) {
-		/*
-		 * On RT, prevent a live lock when %current preempted soft
-		 * interrupt processing or prevents ksoftirqd from running by
-		 * keeping flipping BH. If the BH work item runs on a different
-		 * CPU then this has no effect other than doing the BH
-		 * disable/enable dance for nothing. This is copied from
-		 * kernel/softirq.c::tasklet_unlock_spin_wait().
-		 */
-		while (!try_wait_for_completion(&barr.done)) {
-			if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
-				local_bh_disable();
-				local_bh_enable();
-			} else {
-				cpu_relax();
+	if (from_cancel) {
+		unsigned long data = *work_data_bits(work);
+
+		if (!WARN_ON_ONCE(data & WORK_STRUCT_PWQ) &&
+		    (data & WORK_OFFQ_BH)) {
+			/*
+			 * On RT, prevent a live lock when %current preempted
+			 * soft interrupt processing or prevents ksoftirqd from
+			 * running by keeping flipping BH. If the BH work item
+			 * runs on a different CPU then this has no effect other
+			 * than doing the BH disable/enable dance for nothing.
+			 * This is copied from
+			 * kernel/softirq.c::tasklet_unlock_spin_wait().
+			 */
+			while (!try_wait_for_completion(&barr.done)) {
+				if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
+					local_bh_disable();
+					local_bh_enable();
+				} else {
+					cpu_relax();
+				}
 			}
+			goto out_destroy;
 		}
-	} else {
-		wait_for_completion(&barr.done);
 	}
 
+	wait_for_completion(&barr.done);
+
+out_destroy:
 	destroy_work_on_stack(&barr.work);
 	return true;
 }
-- 
2.43.0



