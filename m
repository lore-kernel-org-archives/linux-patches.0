Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE85331A46;
	Wed,  3 Dec 2025 16:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778259; cv=none; b=pvv6eMpFpkpSxLlKRfK0+HbgmxmNNLxQ1VFhqrOnluoldd7XHZP0drwFErUhwsNUV8oAhnE/S9ZgMDgsM52VeFP+Uqa3+pgL72z/oHkQjbbQFddRhjeoRilfBDyVkbKFI/igz3M5JEigJQv6tXb9c85fFUxRPhizjGXRGjvij+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778259; c=relaxed/simple;
	bh=bvTzGH4AI6l0dqh8v9bV5XO4MiO2ieE56mEssa621bA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fC4+jTJWDfeGyQw0WEykesuY0dLmiiUuYi/SPk9cNBblTWuc7+RZlsmwhdvospKMV2VNR60uYIoUNFpCz9+Ng3JNOcBegHl58cpFpGSDrcni8iTyMGi8HyWAHDqUcwhwF/rfxmE5ZuyCsCRrQEuJzdhkmHEONvJvwsMH7N2tCNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXzHr0o5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXzHr0o5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD67C4CEF5;
	Wed,  3 Dec 2025 16:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778259;
	bh=bvTzGH4AI6l0dqh8v9bV5XO4MiO2ieE56mEssa621bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXzHr0o5VFsEQ34BxKWZxOtbhrrj2LQfv0n//NhA3fR3HixkqiKsA8fiTxdoa5sa3
	 fGPLtgYWsVBafuUPl+mMnXclJphvNs91shcd9ySwst2mHsmV/vJIqWwQSNL7du+tG+
	 Fftc9izNN4rBFoW8zchf6jGsIWa1E8cjNqg6J4xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+355158e7e301548a1424@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 292/392] mptcp: fix race condition in mptcp_schedule_work()
Date: Wed,  3 Dec 2025 16:27:22 +0100
Message-ID: <20251203152424.902339429@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 035bca3f017ee9dea3a5a756e77a6f7138cc6eea upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -880,14 +880,19 @@ static void mptcp_reset_rtx_timer(struct
 
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
 


