Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621725;
	b=S8fCi9WfXubndYeED/uNeFxwIEki310TIRCLteEXdyW+dmqI6LvhLjHF9hHCLctK0KGr
	 u+XWbG7VSDt8roru5/C3Gd8bjZqWITGp1q8IWEBWRmy0JdFzeQjgcGxxHJ8UQIvpWBM2p
	 M5NmqcAJg+dq/h4NQQLjJ078I5nF34ALXaDwfWrVKgkaV9VkwcmpMu0gkZ87I3vX7ZjnT
	 BqaWNVYDBgYGddT5frPi25s4PHvekDsTbm6sfQNo8yVOwzWCv5XNCP/jnznAlHpZTQKPK
	 XalkH/Dc8QeXJ2FH0nNnGupffuUhNxTfulYVXfySBQFsmABKdS+PGQR1DNDYbBbq7sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=asB6+/BOR9J4UTAO5QBId8i/rZI+LX63V0dq16on/b4=;
	b=0P+UQIJYzJLWzSwNs5HcfoCl2qEVz6QN/n5TYENbuTlxkCJqdOz/ZgVCWegBLCycu2Rh
	 FaNbi5N+DhCoQL1EAN5M/JSH+VICyYd+9GSwe70DcnFPlmGJ5DRk9saVsMjywWxdQjJdY
	 295U+B+JiDP3aVxAocrXiKVw6RmoOEJCkn49c2q6Zn0fzYt1wWA9VBNSqqHsnMnH2wCsG
	 gOlFqWodgOtirk+Qa7OI5lPsuJKpyX7n3UaRj0V/swShwn9G674iLzQ595Dm0syC5s5bu
	 lSKJyfLceUC8Fi2/dTVn58EeUsDQIzMKvp2FqmjGwLRNFgeSPuoM1igQPDjBfg6zeQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qlQGDLcd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8C7606A33F;
	Wed, 25 Nov 2026 15:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qlQGDLcd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6E91F0089F;
	Wed, 25 Nov 2026 15:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621725;
	bh=asB6+/BOR9J4UTAO5QBId8i/rZI+LX63V0dq16on/b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlQGDLcd/VBfwoVZCyAbQ1DARC6SuZ9pE1W1zcxXwFgXmf81lMoCpsDXLA7SxjNU6
	 6D9a5LHuWdQmYYkHHstdX+I2O6VA1L86XmpPtuMSWC36z0oX401oMtG4l+PlZS9O8n
	 l4ZZ0KHnt9z83SNJPdS5n1HuRL8biA4dVy8h5hK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Laight <david.laight.linux@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Waiman Long <longman@redhat.com>,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 318/990] locking/osq: Switch osq_wait_next()/atomic_cmpxchg() ordering
Date: Wed, 25 Nov 2026 15:28:05 +0100
Message-ID: <20261125143829.539500218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 1b9e01fcc47aff00d2fd64693c5dcd620eff5865 ]

The atomic_cmpxchg() in osq_wait_next() removes the current CPU's node
from the tail of the queue and puts @old_cpu back.

This is very much like an 'unlock', which is RELEASE, rather than
ACQUIRE.

Additionally, on success (the only case where the ordering is
effective), this returns NULL which means both callsites will do nothing
more, there are no subsequent operations to order against.

Furthermore, the osq_lock() caller will then return false, indicating
failure to acquire -- the mutex must go block. Again, not making a case
for ACQUIRE.  Neither atomics nor locks provide ordering on failure.

Since ACQUIRE makes no sense, while RELEASE makes it more symmetric with
osq_unlock(), switch the ordering. This then makes osq_unlock()
consistently RELEASE.

Fixes: c55a6ffa6285 ("locking/osq: Relax atomic semantics")
Suggested-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <longman@redhat.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/osq_lock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/osq_lock.c b/kernel/locking/osq_lock.c
index b4233dc2c2b04..98b12d7b79964 100644
--- a/kernel/locking/osq_lock.c
+++ b/kernel/locking/osq_lock.c
@@ -59,7 +59,7 @@ osq_wait_next(struct optimistic_spin_queue *lock,
 
 	for (;;) {
 		if (atomic_read(&lock->tail) == curr &&
-		    atomic_cmpxchg_acquire(&lock->tail, curr, old_cpu) == curr) {
+		    atomic_cmpxchg_release(&lock->tail, curr, old_cpu) == curr) {
 			/*
 			 * We were the last queued, we moved @lock back. @prev
 			 * will now observe @lock and will complete its
-- 
2.53.0



