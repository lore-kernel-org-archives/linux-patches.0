Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC0D151988;
	Wed,  5 Feb 2025 14:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766093; cv=none; b=Z0zOw7Rr0sSDGGegV7rWqM7193fCEj8BxTwpiwnp+46GsQ+VCV+tHnrmqAuQoUsfoaJ/fFmQywktS+s/mq6SH+dUTdIXv3TYWp6Yp2i6UJfZ6GJZhqqv5RXBORannaawZ8tzHZIhvj5h+xE7pvgHhtKBCYD/SsF0DQ827SN/vKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766093; c=relaxed/simple;
	bh=tDafhmk5fBULWZvkzGauo9iRk+SFr24JNlhzs2jef4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0eN0e9PS/Jpgr6c0cBIZA0ycPa9HYBmeII+5sVF8mCKsTSWZMLkXsd273DeBEF6nWCvp6LHPrp5A9WyTbdv+WXrRakGcaJZzUP89N4yrFVvjW/p+8EduMljstwvvexEEMQ1tO8yY2ZP88HhOKs7FwbqaBpwigtMg2beQ95GwJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWlK22hB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWlK22hB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BC8C4CED1;
	Wed,  5 Feb 2025 14:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766093;
	bh=tDafhmk5fBULWZvkzGauo9iRk+SFr24JNlhzs2jef4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWlK22hBt1irotcmgZGE7Z7GH7PU+CVZdymjmTNIHQs5gQzMQMkniCi1RlciTHvEh
	 yHx09mUeohrGEMbxYCV6zQvrbeLQXXz8Fu9hOuTEYcbYDGV+yhSYWHZLcpme90WTgl
	 T4aBSJNZCxU0Iu2hQR882gpo2x+egmo/GncJ7rC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 329/393] net: rose: fix timer races against user threads
Date: Wed,  5 Feb 2025 14:44:08 +0100
Message-ID: <20250205134432.903239571@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5de7665e0a0746b5ad7943554b34db8f8614a196 ]

Rose timers only acquire the socket spinlock, without
checking if the socket is owned by one user thread.

Add a check and rearm the timers if needed.

BUG: KASAN: slab-use-after-free in rose_timer_expiry+0x31d/0x360 net/rose/rose_timer.c:174
Read of size 2 at addr ffff88802f09b82a by task swapper/0/0

CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.13.0-rc5-syzkaller-00172-gd1bf27c4e176 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <IRQ>
  __dump_stack lib/dump_stack.c:94 [inline]
  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
  print_address_description mm/kasan/report.c:378 [inline]
  print_report+0x169/0x550 mm/kasan/report.c:489
  kasan_report+0x143/0x180 mm/kasan/report.c:602
  rose_timer_expiry+0x31d/0x360 net/rose/rose_timer.c:174
  call_timer_fn+0x187/0x650 kernel/time/timer.c:1793
  expire_timers kernel/time/timer.c:1844 [inline]
  __run_timers kernel/time/timer.c:2418 [inline]
  __run_timer_base+0x66a/0x8e0 kernel/time/timer.c:2430
  run_timer_base kernel/time/timer.c:2439 [inline]
  run_timer_softirq+0xb7/0x170 kernel/time/timer.c:2449
  handle_softirqs+0x2d4/0x9b0 kernel/softirq.c:561
  __do_softirq kernel/softirq.c:595 [inline]
  invoke_softirq kernel/softirq.c:435 [inline]
  __irq_exit_rcu+0xf7/0x220 kernel/softirq.c:662
  irq_exit_rcu+0x9/0x30 kernel/softirq.c:678
  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1049 [inline]
  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1049
 </IRQ>

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250122180244.1861468-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_timer.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/rose/rose_timer.c b/net/rose/rose_timer.c
index f06ddbed3fed6..1525773e94aa1 100644
--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -122,6 +122,10 @@ static void rose_heartbeat_expiry(struct timer_list *t)
 	struct rose_sock *rose = rose_sk(sk);
 
 	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		sk_reset_timer(sk, &sk->sk_timer, jiffies + HZ/20);
+		goto out;
+	}
 	switch (rose->state) {
 	case ROSE_STATE_0:
 		/* Magic here: If we listen() and a new link dies before it
@@ -152,6 +156,7 @@ static void rose_heartbeat_expiry(struct timer_list *t)
 	}
 
 	rose_start_heartbeat(sk);
+out:
 	bh_unlock_sock(sk);
 	sock_put(sk);
 }
@@ -162,6 +167,10 @@ static void rose_timer_expiry(struct timer_list *t)
 	struct sock *sk = &rose->sock;
 
 	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		sk_reset_timer(sk, &rose->timer, jiffies + HZ/20);
+		goto out;
+	}
 	switch (rose->state) {
 	case ROSE_STATE_1:	/* T1 */
 	case ROSE_STATE_4:	/* T2 */
@@ -182,6 +191,7 @@ static void rose_timer_expiry(struct timer_list *t)
 		}
 		break;
 	}
+out:
 	bh_unlock_sock(sk);
 	sock_put(sk);
 }
@@ -192,6 +202,10 @@ static void rose_idletimer_expiry(struct timer_list *t)
 	struct sock *sk = &rose->sock;
 
 	bh_lock_sock(sk);
+	if (sock_owned_by_user(sk)) {
+		sk_reset_timer(sk, &rose->idletimer, jiffies + HZ/20);
+		goto out;
+	}
 	rose_clear_queues(sk);
 
 	rose_write_internal(sk, ROSE_CLEAR_REQUEST);
@@ -207,6 +221,7 @@ static void rose_idletimer_expiry(struct timer_list *t)
 		sk->sk_state_change(sk);
 		sock_set_flag(sk, SOCK_DEAD);
 	}
+out:
 	bh_unlock_sock(sk);
 	sock_put(sk);
 }
-- 
2.39.5



