Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB40303C87;
	Fri,  9 Jan 2026 12:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961426; cv=none; b=YQz7QCSAS/2IkzoyNgARd0NzVDxxtbYN3uQABcMQM62+DmkCLA2dm+9IRH160Qx1DpDvwC2dq9mfVcSxBySt7cSyTpEAx48v59G7YdSmMRU7SVhWiF+qkRXl/VV8UPxF3pSG5umTURTor1oN7VhVXY1YJDzcGi/Lfi0kDPiZ8FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961426; c=relaxed/simple;
	bh=JLrr+f6EbzqsjGHrD7jMnAIQ+8J05MrCI/7rbDBorR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PdI4cGP6qlw8vLxhH2CHNnZKfAruGTQMGG1F59yFxzKj3EaVgcKV+lUeI2a6F0ULnxvAfXkkiFTct4sMQUMjFI7Ja1i+9NuhVsQNaZLvvTVYfB8xycjdg0FQVBrUvgqT4Xr3DBsv39XtH/O7XEECDpqy7/OqCrNYsi5HnddM4K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GtWjt6zK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GtWjt6zK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD96DC4CEF1;
	Fri,  9 Jan 2026 12:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961426;
	bh=JLrr+f6EbzqsjGHrD7jMnAIQ+8J05MrCI/7rbDBorR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GtWjt6zKjLxlYFmZIsbkdKtiMhg8yNSeA7fLnnmrsTLWlANt0UXPWWhaEktlpyE2W
	 rcFOPxmIZ8gp7iYM2zduLG7fKzt2RobK/lZWhyF7CK5BSFeXaJzTPhaxUixZIVI0kx
	 PcrRHp/FF8gA1X8BSTRgBhBZSV3OyTQdgI5zvcsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Freihofer <adrian.freihofer@siemens.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 6.1 011/634] locking/spinlock/debug: Fix data-race in do_raw_write_lock
Date: Fri,  9 Jan 2026 12:34:49 +0100
Message-ID: <20260109112117.855601149@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

commit c14ecb555c3ee80eeb030a4e46d00e679537f03a upstream.

KCSAN reports:

BUG: KCSAN: data-race in do_raw_write_lock / do_raw_write_lock

write (marked) to 0xffff800009cf504c of 4 bytes by task 1102 on cpu 1:
 do_raw_write_lock+0x120/0x204
 _raw_write_lock_irq
 do_exit
 call_usermodehelper_exec_async
 ret_from_fork

read to 0xffff800009cf504c of 4 bytes by task 1103 on cpu 0:
 do_raw_write_lock+0x88/0x204
 _raw_write_lock_irq
 do_exit
 call_usermodehelper_exec_async
 ret_from_fork

value changed: 0xffffffff -> 0x00000001

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 1103 Comm: kworker/u4:1 6.1.111

Commit 1a365e822372 ("locking/spinlock/debug: Fix various data races") has
adressed most of these races, but seems to be not consistent/not complete.

>From do_raw_write_lock() only debug_write_lock_after() part has been
converted to WRITE_ONCE(), but not debug_write_lock_before() part.
Do it now.

Fixes: 1a365e822372 ("locking/spinlock/debug: Fix various data races")
Reported-by: Adrian Freihofer <adrian.freihofer@siemens.com>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Acked-by: Waiman Long <longman@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/spinlock_debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/locking/spinlock_debug.c
+++ b/kernel/locking/spinlock_debug.c
@@ -183,8 +183,8 @@ void do_raw_read_unlock(rwlock_t *lock)
 static inline void debug_write_lock_before(rwlock_t *lock)
 {
 	RWLOCK_BUG_ON(lock->magic != RWLOCK_MAGIC, lock, "bad magic");
-	RWLOCK_BUG_ON(lock->owner == current, lock, "recursion");
-	RWLOCK_BUG_ON(lock->owner_cpu == raw_smp_processor_id(),
+	RWLOCK_BUG_ON(READ_ONCE(lock->owner) == current, lock, "recursion");
+	RWLOCK_BUG_ON(READ_ONCE(lock->owner_cpu) == raw_smp_processor_id(),
 							lock, "cpu recursion");
 }
 


