Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B197405A;
	Mon,  6 Jan 2025 15:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177827; cv=none; b=Itm8arHcLDSqwOp+wkrdxUj/j6upjoi5xg6Tn+Oba9+LPqqYL4fpFJ/SsPpTha8RmI1mwXvawrAg34zVeQ+d2MJ+As0xcrMojH8KmIUpMXoNBczS8UZJvOp+e48vrlUrDx+2dq9UKfqS9XLSsshEdUIdncW4AFpRNudqUbaLQQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177827; c=relaxed/simple;
	bh=NyaKsKL72jYS9xOZysTCJ83nGK45MrREUHdZXWaO8vY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YEqrJhQIgfw6iiReexnmMhINrOB07MCDrVvpbxoQu7lK1fkcCMTy0+q+qZ4kJSNTs9KYKESFX1vC32gvR2Yur/N0Spwt9HqRKokE9qscaQaPY1lffQXBOpWS8xDkm8w8PASI+2T1ZgNwT21ApnaKIyJC4o8mW+ZPvXc3Ti1g0tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7VnKRPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7VnKRPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F41AC4CED2;
	Mon,  6 Jan 2025 15:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177825;
	bh=NyaKsKL72jYS9xOZysTCJ83nGK45MrREUHdZXWaO8vY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7VnKRPcs7F8NjCMo3eKU0GLmaNlJsOWh3qpTeaLAbc1O7A+L1gM4MiXT+lmlR2fW
	 8PKgtDrzC0WUcSOdsHz7hNVtH82wd3/smnTzr/In/6LtndZxiJIVw61BxTgj7ghcGp
	 T7Fo0WqKoyRtgGrely8sLmhucRd7CsrGsAPG4JpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b3e02953598f447d4d2a@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Martin KaFai Lau <kafai@fb.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/156] net: restrict SO_REUSEPORT to inet sockets
Date: Mon,  6 Jan 2025 16:15:55 +0100
Message-ID: <20250106151144.332951589@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 5b0af621c3f6ef9261cf6067812f2fd9943acb4b ]

After blamed commit, crypto sockets could accidentally be destroyed
from RCU call back, as spotted by zyzbot [1].

Trying to acquire a mutex in RCU callback is not allowed.

Restrict SO_REUSEPORT socket option to inet sockets.

v1 of this patch supported TCP, UDP and SCTP sockets,
but fcnal-test.sh test needed RAW and ICMP support.

[1]
BUG: sleeping function called from invalid context at kernel/locking/mutex.c:562
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 24, name: ksoftirqd/1
preempt_count: 100, expected: 0
RCU nest depth: 0, expected: 0
1 lock held by ksoftirqd/1/24:
  #0: ffffffff8e937ba0 (rcu_callback){....}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
  #0: ffffffff8e937ba0 (rcu_callback){....}-{0:0}, at: rcu_do_batch kernel/rcu/tree.c:2561 [inline]
  #0: ffffffff8e937ba0 (rcu_callback){....}-{0:0}, at: rcu_core+0xa37/0x17a0 kernel/rcu/tree.c:2823
Preemption disabled at:
 [<ffffffff8161c8c8>] softirq_handle_begin kernel/softirq.c:402 [inline]
 [<ffffffff8161c8c8>] handle_softirqs+0x128/0x9b0 kernel/softirq.c:537
CPU: 1 UID: 0 PID: 24 Comm: ksoftirqd/1 Not tainted 6.13.0-rc3-syzkaller-00174-ga024e377efed #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
  __dump_stack lib/dump_stack.c:94 [inline]
  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
  __might_resched+0x5d4/0x780 kernel/sched/core.c:8758
  __mutex_lock_common kernel/locking/mutex.c:562 [inline]
  __mutex_lock+0x131/0xee0 kernel/locking/mutex.c:735
  crypto_put_default_null_skcipher+0x18/0x70 crypto/crypto_null.c:179
  aead_release+0x3d/0x50 crypto/algif_aead.c:489
  alg_do_release crypto/af_alg.c:118 [inline]
  alg_sock_destruct+0x86/0xc0 crypto/af_alg.c:502
  __sk_destruct+0x58/0x5f0 net/core/sock.c:2260
  rcu_do_batch kernel/rcu/tree.c:2567 [inline]
  rcu_core+0xaaa/0x17a0 kernel/rcu/tree.c:2823
  handle_softirqs+0x2d4/0x9b0 kernel/softirq.c:561
  run_ksoftirqd+0xca/0x130 kernel/softirq.c:950
  smpboot_thread_fn+0x544/0xa30 kernel/smpboot.c:164
  kthread+0x2f0/0x390 kernel/kthread.c:389
  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Fixes: 8c7138b33e5c ("net: Unpublish sk from sk_reuseport_cb before call_rcu")
Reported-by: syzbot+b3e02953598f447d4d2a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6772f2f4.050a0220.2f3838.04cb.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20241231160527.3994168-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index da50df485090..a83f64a1d96a 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1300,7 +1300,10 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 		sk->sk_reuse = (valbool ? SK_CAN_REUSE : SK_NO_REUSE);
 		break;
 	case SO_REUSEPORT:
-		sk->sk_reuseport = valbool;
+		if (valbool && !sk_is_inet(sk))
+			ret = -EOPNOTSUPP;
+		else
+			sk->sk_reuseport = valbool;
 		break;
 	case SO_DONTROUTE:
 		sock_valbool_flag(sk, SOCK_LOCALROUTE, valbool);
-- 
2.39.5



