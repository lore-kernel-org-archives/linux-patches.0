Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149913B9930;
	Tue, 21 Jul 2026 21:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670904; cv=none; b=UwMCbL/W2J8sxLChggO+lvDvgczr3ozoSYml+HjDslKIck084mJea6z5mP+mzZfQYIpl+6xfiwEYUWFPQY6qDJISKFxpvopY3EUT+Ckxk7CNkYFDVHQXEXYkE1RqEaBgmC1N+VBl+pp8gBGPG5sidPsKow2Nu534a/dycYg+z60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670904; c=relaxed/simple;
	bh=57XWhT1TtH6T0slNQbS6riCW2TUgoBo/0Ay1jp952Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4EneysOiU6wwZmsfdpv1wGF+4XjQsR8fjI1gztTKXSZD++JAoiy4TL7yF7ZYap7I22ci2M03FFx0Ykcs1uFlM44S7gi2N7ir2oOFBxzxOtkN+GhigZlGM6PE1Xh5ykRb4Mq0LfmFujsUUjO7upJD3EhWY7c6bOOvjFQ5nRQhrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AfqIaahk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AfqIaahk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A05B1F000E9;
	Tue, 21 Jul 2026 21:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670903;
	bh=zZoQnkT3coWygGD0KG7j4vuQ20RofLG8ly/cyituF08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AfqIaahkRvvN4qV37G/KdGvGUqepAEZLSB7Qa8uDcsdLZ7BIOcdEBoi5eSLV2QM1l
	 U1CPx1strmXy0UsG8vhnXdWVKKlEcxbrWIvk/EPIt+09NaNjp+wC3ZqIVcBiZQ5U3N
	 yZRWYqpHqMcOzIrqOGiKBdK2ePS7VDuojKojwMgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+78147abe6c524f183ee9@syzkaller.appspotmail.com,
	Davidlohr Bueso <dave@stgolabs.net>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/843] locking/rtmutex: Skip remove_waiter() when waiter is not enqueued
Date: Tue, 21 Jul 2026 17:14:40 +0200
Message-ID: <20260721152406.993733332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 kernel/locking/rtmutex.c     | 3 +++
 kernel/locking/rtmutex_api.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/locking/rtmutex.c b/kernel/locking/rtmutex.c
index f79c9286c7c0c1..2118f8928eb7cb 100644
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -1513,6 +1513,9 @@ static void __sched remove_waiter(struct rt_mutex_base *lock,
 
 	lockdep_assert_held(&lock->wait_lock);
 
+	if (!waiter_task) /* never enqueued */
+		return;
+
 	raw_spin_lock(&waiter_task->pi_lock);
 	rt_mutex_dequeue(lock, waiter);
 	waiter_task->pi_blocked_on = NULL;
diff --git a/kernel/locking/rtmutex_api.c b/kernel/locking/rtmutex_api.c
index 56d1938cb52a1f..c4e191340c59b3 100644
--- a/kernel/locking/rtmutex_api.c
+++ b/kernel/locking/rtmutex_api.c
@@ -322,7 +322,7 @@ int __sched rt_mutex_start_proxy_lock(struct rt_mutex_base *lock,
 
 	raw_spin_lock_irq(&lock->wait_lock);
 	ret = __rt_mutex_start_proxy_lock(lock, waiter, task);
-	if (unlikely(ret))
+	if (unlikely(ret < 0))
 		remove_waiter(lock, waiter);
 	raw_spin_unlock_irq(&lock->wait_lock);
 
-- 
2.53.0



