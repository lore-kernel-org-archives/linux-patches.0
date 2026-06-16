Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1924143CEC7;
	Tue, 16 Jun 2026 15:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622854; cv=none; b=rzSLmgx7XyjCefFzfnQmu/uVXrxlMUxVoHpkyEh9COMyHs9I3v589VCQzIdfYMO1y2PlvmGZR5KNDrlDpucsiycFwMQAkFDgW4XwbqmKIcQwtgMSfBQtfq1rlCGkjbkF3k/1hfqNcw57u1ZXr1Dm8ysJQWCnnbsp3Smgd6v89HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622854; c=relaxed/simple;
	bh=bmx7j2VRIRlJA9z/gqLToNR67cZPcDHlSTBRy74B41w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHgmfUeyNyfSL8ZVo9k+30Jyn/FIPJ+PRZ3dJScUlLzkuvcunMyHseZiZe4HPD3oarFmKRS/ogT8i1W2WoaWgY2DzZUk3E9MvXzNYqPzxCnlVMyVymhUbXCozSC6amtkul2c2yUN5t22Fbrx/41O+eFU6HQ3t4wfU50fsdhgsI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeZUL3AR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeZUL3AR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020981F000E9;
	Tue, 16 Jun 2026 15:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622853;
	bh=KMQFpKPXbTFXVQQkK5PoH4CKRYAwHdpG+lqFJ8cLBDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QeZUL3ARqvHJyApfHM0i7VKgMUVE/KT+MrRC064vQ/umSLqHC10E4FlrN1mUkckm8
	 YTLAz9fHx0hLlQ3kn54vZKdIyaLMlEivkz32zNcTUSdHvli4ZeyICmdZrqw0nyb+HH
	 JUQ6FMlS71dX4wotdezRl1vuB85nES0V6ChS3VAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e809069bc15f26300526@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 034/378] tcp: Add preempt_{disable,enable}_nested() in reqsk_queue_hash_req().
Date: Tue, 16 Jun 2026 20:24:25 +0530
Message-ID: <20260616145111.664111905@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit e10902df24488ca722303133acfc82490f7d59ad ]

syzbot reported a weird reqsk->rsk_refcnt underflow in
__inet_csk_reqsk_queue_drop().

The captured reqsk_put() in __inet_csk_reqsk_queue_drop()
is called only when it successfully removes reqsk from ehash.

Moreover, reqsk_timer_handler() calls another reqsk_put()
after that.

This indicates that the reqsk was missing both refcnts for
ehash and the timer itself.

Since all the syzbot reports had PREEMPT_RT enabled, the only
possible scenario is that reqsk_queue_hash_req() is preempted
after mod_timer() and before refcount_set(), and then the timer
triggered after 1s aborts the reqsk due to its listener's close().

Let's wrap mod_timer() and refcount_set() with
preempt_disable_nested() and preempt_enable_nested().

Note that inet_ehash_insert() holds the normal spin_lock()
(mutex in PREEMPT_RT), so it must be called outside of
preempt_disable_nested(), but this is fine.

The lookup path just ignores 0 sk_refcnt entries in ehash
and tries to create another reqsk, but this will fail at
inet_ehash_insert().

[0]:
refcount_t: underflow; use-after-free.
WARNING: lib/refcount.c:28 at refcount_warn_saturate+0xb2/0x110 lib/refcount.c:28, CPU#0: ktimers/0/16
Modules linked in:
CPU: 0 UID: 0 PID: 16 Comm: ktimers/0 Tainted: G             L      syzkaller #0 PREEMPT_{RT,(full)}
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
RIP: 0010:refcount_warn_saturate+0xb2/0x110 lib/refcount.c:28
Code: e4 7d d1 0a 67 48 0f b9 3a eb 4a e8 38 3d 23 fd 48 8d 3d e1 7d d1 0a 67 48 0f b9 3a eb 37 e8 25 3d 23 fd 48 8d 3d de 7d d1 0a <67> 48 0f b9 3a eb 24 e8 12 3d 23 fd 48 8d 3d db 7d d1 0a 67 48 0f
RSP: 0000:ffffc90000157948 EFLAGS: 00010246
RAX: ffffffff84a1301b RBX: 0000000000000003 RCX: ffff88801ca98000
RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffffffff8f72ae00
RBP: ffffffff99ae3b01 R08: ffff88801ca98000 R09: 0000000000000005
R10: 0000000000000100 R11: 0000000000000004 R12: ffff8880425ef568
R13: ffff8880425ef4f8 R14: ffff8880425ef578 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff888126386000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7b46710e9c CR3: 000000000dbb6000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __refcount_sub_and_test include/linux/refcount.h:400 [inline]
 __refcount_dec_and_test include/linux/refcount.h:432 [inline]
 refcount_dec_and_test include/linux/refcount.h:450 [inline]
 reqsk_put include/net/request_sock.h:136 [inline]
 __inet_csk_reqsk_queue_drop+0x3ce/0x440 net/ipv4/inet_connection_sock.c:1007
 reqsk_timer_handler+0x651/0xdf0 net/ipv4/inet_connection_sock.c:1137
 call_timer_fn+0x192/0x5e0 kernel/time/timer.c:1748
 expire_timers kernel/time/timer.c:1799 [inline]
 __run_timers kernel/time/timer.c:2374 [inline]
 __run_timer_base+0x6a3/0x9f0 kernel/time/timer.c:2386
 run_timer_base kernel/time/timer.c:2395 [inline]
 run_timer_softirq+0x67/0x170 kernel/time/timer.c:2403
 handle_softirqs+0x1de/0x6d0 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 run_ktimerd+0x69/0x100 kernel/softirq.c:1151
 smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Fixes: d2d6422f8bd1 ("x86: Allow to enable PREEMPT_RT.")
Reported-by: syzbot+e809069bc15f26300526@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a1a7bcf.0a9e871e.332604.000b.GAE@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://patch.msgid.link/20260601182101.3183993-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index f1988fd503540d..d9f6c8d4d7e63a 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1151,6 +1151,9 @@ static bool reqsk_queue_hash_req(struct request_sock *req)
 	/* The timer needs to be setup after a successful insertion. */
 	req->timeout = tcp_timeout_init((struct sock *)req);
 	timer_setup(&req->rsk_timer, reqsk_timer_handler, TIMER_PINNED);
+
+	preempt_disable_nested();
+
 	mod_timer(&req->rsk_timer, jiffies + req->timeout);
 
 	/* before letting lookups find us, make sure all req fields
@@ -1158,6 +1161,9 @@ static bool reqsk_queue_hash_req(struct request_sock *req)
 	 */
 	smp_wmb();
 	refcount_set(&req->rsk_refcnt, 2 + 1);
+
+	preempt_enable_nested();
+
 	return true;
 }
 
-- 
2.53.0



