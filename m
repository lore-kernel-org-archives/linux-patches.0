Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784E2313E26;
	Wed,  3 Dec 2025 15:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776761; cv=none; b=ielv1LDY0zqkX1dIncjeNgd1eZeOGGmNjsCGwgnZwqmgWbhK8nMEfVFcvpbi8PjmFTRsFuPUrB/mktBee2yHAj+8zVp+7DnkErzbITpOIwbN++qANh/AuXPqfI8XSPYl8z1IoAQNTVC6D7RkfN67hvYjoXsUa+uDwx2//6J94Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776761; c=relaxed/simple;
	bh=D1j7SA6YOrDSl2Nx+1B7pMsCGOvEYZmQrG/RR/NoOvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rox9uKoZzVkUcYPF63S69lEo0/kxAR3KsdiSiOEK9N/L+xqxi1zNg8d6RTh4x4/K9j2wxSVruXeAO7ZWgydA7qe5bE1Krs8bDm+2gqYowoExXG/Ud75iHkSrydkDcesdzUyRFQ9i+xb6Pn/j/kBhLpRXFpWw9/Nq8P+hdXdtZUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q3Ny28vQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q3Ny28vQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2A5C4CEF5;
	Wed,  3 Dec 2025 15:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776761;
	bh=D1j7SA6YOrDSl2Nx+1B7pMsCGOvEYZmQrG/RR/NoOvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q3Ny28vQe9U1NPBXkjauNRFpl/GJ7gVQmjMXddBpm7d5+WHUQs3YeW5bXeAKeNXYF
	 7vdbYsXcibUBn+o6oQDgugesFM4qTUJsRi44KVbmHIZ5Ei4AF1R68XARfbDpu9Jk+D
	 4cQacjLV1NMBxc3S1IKLwU6NgNyG9cz2wr/upb+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+355158e7e301548a1424@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 247/300] mptcp: fix race condition in mptcp_schedule_work()
Date: Wed,  3 Dec 2025 16:27:31 +0100
Message-ID: <20251203152409.782877883@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 035bca3f017ee9dea3a5a756e77a6f7138cc6eea ]

syzbot reported use-after-free in mptcp_schedule_work() [1]

Issue here is that mptcp_schedule_work() schedules a work,
then gets a refcount on sk->sk_refcnt if the work was scheduled.
This refcount will be released by mptcp_worker().

[A] if (schedule_work(...)) {
[B]     sock_hold(sk);
        return true;
    }

Problem is that mptcp_worker() can run immediately and complete before [B]

We need instead :

    sock_hold(sk);
    if (schedule_work(...))
        return true;
    sock_put(sk);

[1]
refcount_t: addition on 0; use-after-free.
 WARNING: CPU: 1 PID: 29 at lib/refcount.c:25 refcount_warn_saturate+0xfa/0x1d0 lib/refcount.c:25
Call Trace:
 <TASK>
 __refcount_add include/linux/refcount.h:-1 [inline]
  __refcount_inc include/linux/refcount.h:366 [inline]
  refcount_inc include/linux/refcount.h:383 [inline]
  sock_hold include/net/sock.h:816 [inline]
  mptcp_schedule_work+0x164/0x1a0 net/mptcp/protocol.c:943
  mptcp_tout_timer+0x21/0xa0 net/mptcp/protocol.c:2316
  call_timer_fn+0x17e/0x5f0 kernel/time/timer.c:1747
  expire_timers kernel/time/timer.c:1798 [inline]
  __run_timers kernel/time/timer.c:2372 [inline]
  __run_timer_base+0x648/0x970 kernel/time/timer.c:2384
  run_timer_base kernel/time/timer.c:2393 [inline]
  run_timer_softirq+0xb7/0x180 kernel/time/timer.c:2403
  handle_softirqs+0x22f/0x710 kernel/softirq.c:622
  __do_softirq kernel/softirq.c:656 [inline]
  run_ktimerd+0xcf/0x190 kernel/softirq.c:1138
  smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
  kthread+0x711/0x8a0 kernel/kthread.c:463
  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Cc: stable@vger.kernel.org
Fixes: 3b1d6210a957 ("mptcp: implement and use MPTCP-level retransmission")
Reported-by: syzbot+355158e7e301548a1424@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6915b46f.050a0220.3565dc.0028.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20251113103924.3737425-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -716,14 +716,19 @@ static void mptcp_reset_timer(struct soc
 
 bool mptcp_schedule_work(struct sock *sk)
 {
-	if (inet_sk_state_load(sk) != TCP_CLOSE &&
-	    schedule_work(&mptcp_sk(sk)->work)) {
-		/* each subflow already holds a reference to the sk, and the
-		 * workqueue is invoked by a subflow, so sk can't go away here.
-		 */
-		sock_hold(sk);
+	if (inet_sk_state_load(sk) == TCP_CLOSE)
+		return false;
+
+	/* Get a reference on this socket, mptcp_worker() will release it.
+	 * As mptcp_worker() might complete before us, we can not avoid
+	 * a sock_hold()/sock_put() if schedule_work() returns false.
+	 */
+	sock_hold(sk);
+
+	if (schedule_work(&mptcp_sk(sk)->work))
 		return true;
-	}
+
+	sock_put(sk);
 	return false;
 }
 


