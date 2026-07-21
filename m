Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A8846EC9A;
	Tue, 21 Jul 2026 18:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659099; cv=none; b=tYqWMq5Dc9Fd6/gOMTofpFtcetNgn39RHcv+WaKZCJD7nEs1brFeh75TddaQPC4DpPZFgdpZuwbfGWViWqqIqBwGyPFiJSKBgg/B0j9TlwIUauM3tFFpKjX/s7YDgM3PcOP1+umwC1JL8Q/N4bT55TG+eSaFo7QEPS/oJAYWmD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659099; c=relaxed/simple;
	bh=FPYPffXghRZwEv3ThLiIkehs1wmzwZMQwIIYCHVeFEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a87STqPw8U4c5QA4C6ZGQv+aygcjD88l6d42AyBTjf7ENYb15rX4SiFQKaIxFgzdnPz1t/qmSd3GzxIqkobnaqOYEWUocVsVhcFr42ekF7uv42QHoTvucDOITRzzOr//q+2mEKFxooh9U829++ZWMOiMjwFIQqxkbK4cd82c+1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCkpzRXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCkpzRXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AD81F00A3A;
	Tue, 21 Jul 2026 18:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659091;
	bh=KJa6ILkH8aEZXpCgnaDp26cT5D6HB5nFBIZM8tAG6fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCkpzRXJungOBFW+epRh1cqTeCeb9HeIChD0Hy9XETl7LgYJ7OUWc/D7yjuYuQdzi
	 iaaBTXd4PI6cidOt3VKBcvIg3GfMLFFPyKulW5k75QHDwYZy5oc8SGf2rcM1ZP82fz
	 Rvy5iDVthEaCiof5jQpSCJneB35PUWOq9V3dScqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+000c800a02097aaa10ed@syzkaller.appspotmail.com,
	Thomas Gleixner <tglx@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 6.18 1388/1611] locking/rt: Fix the incorrect RCU protection in rt_spin_unlock()
Date: Tue, 21 Jul 2026 17:25:04 +0200
Message-ID: <20260721152546.662843414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@kernel.org>

commit 89038cc87d80c77e7aa6f42a64b2573b74af339f upstream.

rt_spin_unlock() releases the RCU protection before unlocking the
lock. That opens the door for the following UAF scenario:

 T1					T2
 spin_lock(&p->lock);		rcu_read_lock();
 invalidate(p);			p = rcu_dereference(ptr);
 rcu_assign_pointer(ptr, NULL);	if (!p) return;
 spin_unlock(&p->lock);		spin_lock(&p->lock)
 				   lock(&lock->lock);
				   rcu_read_lock();
 kfree_rcu(p);			rcu_read_unlock();
				....
				spin_unlock(&p->lock)
				  rcu_read_unlock(); // Ends grace period
 rcu_do_batch()
   kfree(p);
			    UAF ->	  rt_mutex_cmpxchg_release(&lock->lock...)

Regular spinlocks keep preemption disabled accross the unlock operation,
which provides full RCU protection, but the RT substitution fails to
resemble that. Same applies for the rwlock substitution.

Move the rcu_read_unlock() invocation past the unlock operations to match
the non-RT semantics. This makes it asymmetric vs. rt_xxx_lock(), but
that's harmless as the caller needs to hold RCU read lock across the lock
operation. The migrate_enable() call stays before the unlock operation
because there is no per CPU operation in the unlock path which would
require migration to be kept disabled.

Fixes: 0f383b6dc96e ("locking/spinlock: Provide RT variant")
Reported-by: syzbot+000c800a02097aaa10ed@syzkaller.appspotmail.com
Decoded-by: Jann Horn <jannh@google.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/87jyrud75z.ffs@fw13
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/spinlock_rt.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

--- a/kernel/locking/spinlock_rt.c
+++ b/kernel/locking/spinlock_rt.c
@@ -79,10 +79,27 @@ void __sched rt_spin_unlock(spinlock_t *
 {
 	spin_release(&lock->dep_map, _RET_IP_);
 	migrate_enable();
-	rcu_read_unlock();
 
 	if (unlikely(!rt_mutex_cmpxchg_release(&lock->lock, current, NULL)))
 		rt_mutex_slowunlock(&lock->lock);
+
+	/*
+	 * This must be last to prevent the following UAF:
+	 *
+	 * T1					T2
+	 * spin_lock(&p->lock);			rcu_read_lock();
+	 * invalidate(p);			p = rcu_dereference(ptr);
+	 * rcu_assign_pointer(ptr, NULL);	if (!p) return;
+	 * spin_unlock(&p->lock);		spin_lock(&p->lock);
+	 * kfree_rcu(p);			rcu_read_unlock();
+	 *					....
+	 *					spin_unlock(&p->lock)
+	 *					  rcu_read_unlock(); // Ends grace period
+	 * rcu_do_batch()
+	 *   kfree(p);
+	 *			    UAF ->	  rt_mutex_cmpxchg_release(&p->lock.lock...)
+	 */
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(rt_spin_unlock);
 
@@ -262,17 +279,21 @@ void __sched rt_read_unlock(rwlock_t *rw
 {
 	rwlock_release(&rwlock->dep_map, _RET_IP_);
 	migrate_enable();
-	rcu_read_unlock();
 	rwbase_read_unlock(&rwlock->rwbase, TASK_RTLOCK_WAIT);
+
+	/* This must be last. See comment in rt_spin_unlock() */
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(rt_read_unlock);
 
 void __sched rt_write_unlock(rwlock_t *rwlock) __releases(RCU)
 {
 	rwlock_release(&rwlock->dep_map, _RET_IP_);
-	rcu_read_unlock();
 	migrate_enable();
 	rwbase_write_unlock(&rwlock->rwbase);
+
+	/* This must be last. See comment in rt_spin_unlock() */
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(rt_write_unlock);
 


