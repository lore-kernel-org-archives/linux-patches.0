Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A23348465;
	Thu,  2 Jul 2026 16:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010788; cv=none; b=bjRfGkFWsNLW09C6bGwrKPz54bFNARZl5bRlwzlEZH6GENY20YBk9zIoHHdBbDwOMZCi49+ye3f9NagGs/0hgW10Shth6ND3saL3QPLCGBMrMlIrVfDw2lwoN8WtRtABGDZw/oDvudaO+e0MqgUTJNlMdw3kWEoQcrnH6lcle2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010788; c=relaxed/simple;
	bh=sz4r7Q4w1NEKFz3NzyqBr+BW7ePCwVgVKjNCO+EPeic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmAoK1sEwLjR7mrdzrzJs7ajKYqKZNKVUF1DunL8mIFRn9UIvwZDUH08ZtNuN7wRBY90RtocEqNij7Loyp8jXuZQrVSmAxA90EoBjllYfGLs6c6861ljj8FyTr8zFWwUKJjqN+hzQkbaJ0tkZV26sifqMBZYoe7VyEzZgNzBMzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4fHo0QE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4fHo0QE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57331F00A3A;
	Thu,  2 Jul 2026 16:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010787;
	bh=o6glv/I+jpLI1B3aWe4yuNuksIBqa1pj7f45G5DMw00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4fHo0QERGqIG6HJ2YPBKwJX1TiDWbSTZRL5QbKhwPaK0L/AZmf5UiHej7N5lnGVU
	 h41Xd1ve45xfZSE4iYFjpVIYc0cqCQz0ET1XuZO5PcCzen5i94USIEUYqRz7KVc7fb
	 8rrci6wQcgIH/AlUll23s0KoD0XUti1QuWAd3BpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+78147abe6c524f183ee9@syzkaller.appspotmail.com,
	Davidlohr Bueso <dave@stgolabs.net>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/175] locking/rtmutex: Skip remove_waiter() when waiter is not enqueued
Date: Thu,  2 Jul 2026 18:18:57 +0200
Message-ID: <20260702155116.559022693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <dave@stgolabs.net>

[ Upstream commit 40a25d59e85b3c8709ac2424d44f65610467871e ]

syzbot triggered the following splat in remove_waiter() via
FUTEX_CMP_REQUEUE_PI:

  KASAN: null-ptr-deref in range [0x0000000000000a88-0x0000000000000a8f]
   class_raw_spinlock_constructor
   remove_waiter+0x159/0x1200 kernel/locking/rtmutex.c:1561
   rt_mutex_start_proxy_lock+0x103/0x120
   futex_requeue+0x10e4/0x20d0
   __x64_sys_futex+0x34f/0x4d0

task_blocks_on_rt_mutex() does not arm the waiter upon deadlock detection,
leaving waiter->task nil, where 3bfdc63936dd ("rtmutex: Use waiter::task instead
of current in remove_waiter()") made this fatal.

Furthermore, rt_mutex_start_proxy_lock() should not be calling into remove_waiter()
upon a successfully grabbing the rtmutex. 1a1fb985f2e2 ("futex: Handle early deadlock
return correctly"), moved the remove_waiter() out of __rt_mutex_start_proxy_lock()
(where 'ret' was only ever 0 or < 0) into the wrapper. Tighten this check to
account for try_to_take_rt_mutex().

Fixes: 3bfdc63936dd ("rtmutex: Use waiter::task instead of current in remove_waiter()")
Reported-by: syzbot+78147abe6c524f183ee9@syzkaller.appspotmail.com
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/all/69f114ac.050a0220.ac8b.0003.GAE@google.com/
Link: https://patch.msgid.link/20260507112913.1019537-1-dave@stgolabs.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/rtmutex.c     |    3 +++
 kernel/locking/rtmutex_api.c |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1524,6 +1524,9 @@ static void __sched remove_waiter(struct
 
 	lockdep_assert_held(&lock->wait_lock);
 
+	if (!waiter_task) /* never enqueued */
+		return;
+
 	scoped_guard(raw_spinlock, &waiter_task->pi_lock) {
 		rt_mutex_dequeue(lock, waiter);
 		waiter_task->pi_blocked_on = NULL;
--- a/kernel/locking/rtmutex_api.c
+++ b/kernel/locking/rtmutex_api.c
@@ -344,7 +344,7 @@ int __sched rt_mutex_start_proxy_lock(st
 
 	raw_spin_lock_irq(&lock->wait_lock);
 	ret = __rt_mutex_start_proxy_lock(lock, waiter, task);
-	if (unlikely(ret))
+	if (unlikely(ret < 0))
 		remove_waiter(lock, waiter);
 	raw_spin_unlock_irq(&lock->wait_lock);
 


