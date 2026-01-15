Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17D22D7DED;
	Thu, 15 Jan 2026 17:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498853; cv=none; b=uC6RaR1UUzY5TE6o0UyP58SXpbiLVWVtntkhdpT7iDhstA3bFW2aPii4yBfJy4wC57FKnNd1TRFmjYKHx4cbLSaAkoi6hJtr02itlroxOZZGkInnbQGcQjZ2nq6rHMtKZd3aYzE+jLlVuBlhAhcxQWAwjKU2f2lyAZ9Jx6NIDyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498853; c=relaxed/simple;
	bh=AOiXkTBI2VCzDJ99Ll8r2U8R00Cyd/fSxXztiH1ACQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrRQf6kjVJgqlGvVQdD/e7iI/FJSu4QOnf/P2iyVwHZsq1pWtLs8skUE9M/NSQ9YO1gfqu28gUQOhNVXwAFuUASzSjlNVngOeCum+n2oRDeYWwCGejjuh5eaesz6lqjJ8uqu4MZ0bQ3tthrqlIZAGAL0tpeBIW/Bgww8iStw29E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sPw+UW1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sPw+UW1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDABC19422;
	Thu, 15 Jan 2026 17:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498852;
	bh=AOiXkTBI2VCzDJ99Ll8r2U8R00Cyd/fSxXztiH1ACQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sPw+UW1B0Eeb1eZxaHeDnuxxxasO4EkgCFoZZBLIjTNkxw7XzKPABtBLR7VcV0PsS
	 IutV8U+/4GBwBDMdv/sChI6ebuveAy+Fpa95XEz3nkpVOW3DT+zmYEp8A2lnLtwI3s
	 kvv6Z8K6V486MIRYi493yw9tg/7YooG4jTxOg3dc=
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
Subject: [PATCH 5.10 008/451] locking/spinlock/debug: Fix data-race in do_raw_write_lock
Date: Thu, 15 Jan 2026 17:43:29 +0100
Message-ID: <20260115164231.182980057@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -180,8 +180,8 @@ void do_raw_read_unlock(rwlock_t *lock)
 static inline void debug_write_lock_before(rwlock_t *lock)
 {
 	RWLOCK_BUG_ON(lock->magic != RWLOCK_MAGIC, lock, "bad magic");
-	RWLOCK_BUG_ON(lock->owner == current, lock, "recursion");
-	RWLOCK_BUG_ON(lock->owner_cpu == raw_smp_processor_id(),
+	RWLOCK_BUG_ON(READ_ONCE(lock->owner) == current, lock, "recursion");
+	RWLOCK_BUG_ON(READ_ONCE(lock->owner_cpu) == raw_smp_processor_id(),
 							lock, "cpu recursion");
 }
 


