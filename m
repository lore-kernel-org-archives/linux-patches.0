Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EB53ACA60;
	Thu,  2 Jul 2026 16:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010686; cv=none; b=XjzqrRzfXjTuYNc+/pOdHAhVJB9mEsVsp/VevIIBHCCKNehGpoaHBKHY6X9Qes0BFVUEKyOkmUdDdvp6WXWXh/+G7Kc7qb5zW4YjgeYQ9tJYEzR7Drw6jDh+vzjh6LD1QUnBpQyPiBveipO8UNtCJXYH5U0oFCghdVCqyjvjQGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010686; c=relaxed/simple;
	bh=B0+S2CU+oUWXQgOqDjUc52zgQLb1fUZikhmW87TOZNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sbQRUaRxDtHdeEZnpZ6zFv2s66jTUU0x9/UQf0DdQbMchVacBMww1aXQzi8yRJXlAY8CzFHLugfLWj25dVj64XVhsdHAQAGJGpE/HkxqAyRnyJ+thrpyKIjgVuet9x1ij89i/PuTsZp53t0wgHfqZIN1AJ2R7bCdAkzF5lF9VIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQp+cSYd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQp+cSYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1931F000E9;
	Thu,  2 Jul 2026 16:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010684;
	bh=QrcvU8FBE/O8qUq2kWs38EA3sNyccXC5mCfYZXB9IdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QQp+cSYdmgnnN93MLzdyRS2bxT7wVDx5g5B1jNmC3hv5PAKmhcDoQnb3YRF13Pncz
	 VeuyCkm/Ncxz3wMvg11zQIJMrwOqAGOBDEjp2GpkpKw2owRDmkDpp/tKbsak3BWAGA
	 4ex8XBaJgOXNC3lIcR+pFuLmt5Q/dmzzO2qbqa/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	John Stultz <jstultz@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>
Subject: [PATCH 6.12 201/204] locking: rtmutex: Fix wake_q logic in task_blocks_on_rt_mutex
Date: Thu,  2 Jul 2026 18:20:58 +0200
Message-ID: <20260702155122.875497137@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <jstultz@google.com>

commit 82f9cc094975240885c93effbca7f4603f5de1bf upstream.

Anders had bisected a crash using PREEMPT_RT with linux-next and
isolated it down to commit 894d1b3db41c ("locking/mutex: Remove
wakeups from under mutex::wait_lock"), where it seemed the
wake_q structure was somehow getting corrupted causing a null
pointer traversal.

I was able to easily repoduce this with PREEMPT_RT and managed
to isolate down that through various call stacks we were
actually calling wake_up_q() twice on the same wake_q.

I found that in the problematic commit, I had added the
wake_up_q() call in task_blocks_on_rt_mutex() around
__ww_mutex_add_waiter(), following a similar pattern in
__mutex_lock_common().

However, its just wrong. We haven't dropped the lock->wait_lock,
so its contrary to the point of the original patch. And it
didn't match the __mutex_lock_common() logic of re-initializing
the wake_q after calling it midway in the stack.

Looking at it now, the wake_up_q() call is incorrect and should
just be removed. So drop the erronious logic I had added.

Fixes: 894d1b3db41c ("locking/mutex: Remove wakeups from under mutex::wait_lock")
Closes: https://lore.kernel.org/lkml/6afb936f-17c7-43fa-90e0-b9e780866097@app.fastmail.com/
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: John Stultz <jstultz@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lore.kernel.org/r/20241114190051.552665-1-jstultz@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/rtmutex.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1248,10 +1248,7 @@ static int __sched task_blocks_on_rt_mut
 
 		/* Check whether the waiter should back out immediately */
 		rtm = container_of(lock, struct rt_mutex, rtmutex);
-		preempt_disable();
 		res = __ww_mutex_add_waiter(waiter, rtm, ww_ctx, wake_q);
-		wake_up_q(wake_q);
-		preempt_enable();
 		if (res) {
 			raw_spin_lock(&task->pi_lock);
 			rt_mutex_dequeue(lock, waiter);


