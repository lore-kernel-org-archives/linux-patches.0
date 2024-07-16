Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BF119AD46;
	Tue, 16 Jul 2024 15:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145227; cv=none; b=iwMxGUA/ITYWmLLRlLEulJRrN5pSYmxaD+Fa2G0UOE/z8/e41XAAJ8GmvIpFGLE3+TADoFlU/wuYtLc2qyuQgZhEVTdOBi0uWZ8y+xBIKOikYvaIGY/7WXAGqU+90xeR/dY83Ifeu8GVa4nRLMnatAPGsQZNtLt6EBAAPciVSS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145227; c=relaxed/simple;
	bh=YFYU7IdAo+0WOEw8UvVDAhJPdbOYjB8yIdhm5jX/yRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2nkqfHpg35xeQy5qjJ5c6fsQAm9MU01w5osrcITsG+2S3YTrGf1nnKZ5FYh9hpRJ7EpakD1605tt4ZUMT8Hc9W9D43aHmNHmh7FEMSiAZN/zC2aKGTmMv0M20LaQJpnnMmgag4AgHTPpYyZpNVGBLnjC2nzbvlM5x+9CaeWaTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vA6rdc18; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vA6rdc18"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814D7C116B1;
	Tue, 16 Jul 2024 15:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145226;
	bh=YFYU7IdAo+0WOEw8UvVDAhJPdbOYjB8yIdhm5jX/yRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vA6rdc18/F8RGt0Yh1qREZgLMIWk1mUT/Fa4H/EjqjPmWd2N+INhzYcUC6ZLzLg+Q
	 665+aOkTU3KmmE8o0sBiOJB+I4/ClbHyljIkX/dZA3A7RqKHB6MOj07e1ag1SYhvof
	 2KKgVmmnWADadEkg1Hsr1BFTU+FvtigXFA4u44mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 140/143] sched/deadline: Fix task_struct reference leak
Date: Tue, 16 Jul 2024 17:32:16 +0200
Message-ID: <20240716152801.381029278@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wander Lairson Costa <wander@redhat.com>

[ Upstream commit b58652db66c910c2245f5bee7deca41c12d707b9 ]

During the execution of the following stress test with linux-rt:

stress-ng --cyclic 30 --timeout 30 --minimize --quiet

kmemleak frequently reported a memory leak concerning the task_struct:

unreferenced object 0xffff8881305b8000 (size 16136):
  comm "stress-ng", pid 614, jiffies 4294883961 (age 286.412s)
  object hex dump (first 32 bytes):
    02 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00  .@..............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  debug hex dump (first 16 bytes):
    53 09 00 00 00 00 00 00 00 00 00 00 00 00 00 00  S...............
  backtrace:
    [<00000000046b6790>] dup_task_struct+0x30/0x540
    [<00000000c5ca0f0b>] copy_process+0x3d9/0x50e0
    [<00000000ced59777>] kernel_clone+0xb0/0x770
    [<00000000a50befdc>] __do_sys_clone+0xb6/0xf0
    [<000000001dbf2008>] do_syscall_64+0x5d/0xf0
    [<00000000552900ff>] entry_SYSCALL_64_after_hwframe+0x6e/0x76

The issue occurs in start_dl_timer(), which increments the task_struct
reference count and sets a timer. The timer callback, dl_task_timer,
is supposed to decrement the reference count upon expiration. However,
if enqueue_task_dl() is called before the timer expires and cancels it,
the reference count is not decremented, leading to the leak.

This patch fixes the reference leak by ensuring the task_struct
reference count is properly decremented when the timer is canceled.

Fixes: feff2e65efd8 ("sched/deadline: Unthrottle PI boosted threads while enqueuing")
Signed-off-by: Wander Lairson Costa <wander@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Juri Lelli <juri.lelli@redhat.com>
Link: https://lore.kernel.org/r/20240620125618.11419-1-wander@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index a04a436af8cc4..dce51bf2d3229 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1805,8 +1805,13 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 			 * The replenish timer needs to be canceled. No
 			 * problem if it fires concurrently: boosted threads
 			 * are ignored in dl_task_timer().
+			 *
+			 * If the timer callback was running (hrtimer_try_to_cancel == -1),
+			 * it will eventually call put_task_struct().
 			 */
-			hrtimer_try_to_cancel(&p->dl.dl_timer);
+			if (hrtimer_try_to_cancel(&p->dl.dl_timer) == 1 &&
+			    !dl_server(&p->dl))
+				put_task_struct(p);
 			p->dl.dl_throttled = 0;
 		}
 	} else if (!dl_prio(p->normal_prio)) {
-- 
2.43.0



