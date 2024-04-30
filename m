Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07EF17592;
	Tue, 30 Apr 2024 11:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476301; cv=none; b=MKrgsLvPgNXsOL/4yzGCkBf+Qcb4dpbQnmvJaZ3TjXb5ST0pkxBa15/4567dEV/8xT8wyas79FVM42IfFCsW1/C8SWt4HkXmQu0X5Wgja5ydLIqpe2Rpzds8++lm20FWDPR285Cy9osSQ+NInFH6k6tEG/SatE8gcABfn36zETo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476301; c=relaxed/simple;
	bh=aWi3YtVWgMb2H7YGd7WGRinB2Y2r09BwuQKEerkB4y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r17KnJSnczwKaBccehY3Mav4+1hnNYvK/nqEOZnhbnS3MNrE4IUxOs/gmtXKIFGgnBMTyLb0tuPxX5ex9CgdNhBPKXsEFWKYsxnmVkM9emytT8YsIcMXUVeVbh/VKb1yOogt+7iYI28YGrvEkg+y1/B1pxL1kP8jFJgGZin6LUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQddrriT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQddrriT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0EBC2BBFC;
	Tue, 30 Apr 2024 11:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476301;
	bh=aWi3YtVWgMb2H7YGd7WGRinB2Y2r09BwuQKEerkB4y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQddrriTN+Ne3xpu9WTLl6fkaB+5gQBAhq7CEW93Ww14O6bg2LK++Kz/icsqrtbZC
	 7DGzDuxeib1cQljwUA6B7E3Lxr94o8RJ3yLAkTu8oc6V6Eeht0LSkD9SKwlfdTg6+s
	 K0Jl2/V9H+EOlgSU2CMLBEnzLlaz+UHWdy64zqZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Zhengchao Shao <shaozhengchao@huawei.com>
Subject: [PATCH 5.4 098/107] tcp: Clean up kernel listeners reqsk in inet_twsk_purge()
Date: Tue, 30 Apr 2024 12:40:58 +0200
Message-ID: <20240430103047.550538724@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 740ea3c4a0b2e326b23d7cdf05472a0e92aa39bc upstream.

Eric Dumazet reported a use-after-free related to the per-netns ehash
series. [0]

When we create a TCP socket from userspace, the socket always holds a
refcnt of the netns.  This guarantees that a reqsk timer is always fired
before netns dismantle.  Each reqsk has a refcnt of its listener, so the
listener is not freed before the reqsk, and the net is not freed before
the listener as well.

OTOH, when in-kernel users create a TCP socket, it might not hold a refcnt
of its netns.  Thus, a reqsk timer can be fired after the netns dismantle
and access freed per-netns ehash.

To avoid the use-after-free, we need to clean up TCP_NEW_SYN_RECV sockets
in inet_twsk_purge() if the netns uses a per-netns ehash.

[0]: https://lore.kernel.org/netdev/CANn89iLXMup0dRD_Ov79Xt8N9FM0XdhCHEN05sf3eLwxKweM6w@mail.gmail.com/

BUG: KASAN: use-after-free in tcp_or_dccp_get_hashinfo
include/net/inet_hashtables.h:181 [inline]
BUG: KASAN: use-after-free in reqsk_queue_unlink+0x320/0x350
net/ipv4/inet_connection_sock.c:913
Read of size 8 at addr ffff88807545bd80 by task syz-executor.2/8301

CPU: 1 PID: 8301 Comm: syz-executor.2 Not tainted
6.0.0-syzkaller-02757-gaf7d23f9d96a #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 09/22/2022
Call Trace:
<IRQ>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
print_address_description mm/kasan/report.c:317 [inline]
print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
tcp_or_dccp_get_hashinfo include/net/inet_hashtables.h:181 [inline]
reqsk_queue_unlink+0x320/0x350 net/ipv4/inet_connection_sock.c:913
inet_csk_reqsk_queue_drop net/ipv4/inet_connection_sock.c:927 [inline]
inet_csk_reqsk_queue_drop_and_put net/ipv4/inet_connection_sock.c:939 [inline]
reqsk_timer_handler+0x724/0x1160 net/ipv4/inet_connection_sock.c:1053
call_timer_fn+0x1a0/0x6b0 kernel/time/timer.c:1474
expire_timers kernel/time/timer.c:1519 [inline]
__run_timers.part.0+0x674/0xa80 kernel/time/timer.c:1790
__run_timers kernel/time/timer.c:1768 [inline]
run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
__do_softirq+0x1d0/0x9c8 kernel/softirq.c:571
invoke_softirq kernel/softirq.c:445 [inline]
__irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
sysvec_apic_timer_interrupt+0x93/0xc0 arch/x86/kernel/apic/apic.c:1107
</IRQ>

Fixes: d1e5e6408b30 ("tcp: Introduce optional per-netns ehash.")
Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: Eric Dumazet <edumazet@google.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20221012145036.74960-1-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[shaozhengchao: resolved conflicts in 5.10]
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_timewait_sock.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -268,8 +268,21 @@ restart_rcu:
 		rcu_read_lock();
 restart:
 		sk_nulls_for_each_rcu(sk, node, &head->chain) {
-			if (sk->sk_state != TCP_TIME_WAIT)
+			if (sk->sk_state != TCP_TIME_WAIT) {
+				/* A kernel listener socket might not hold refcnt for net,
+				 * so reqsk_timer_handler() could be fired after net is
+				 * freed.  Userspace listener and reqsk never exist here.
+				 */
+				if (unlikely(sk->sk_state == TCP_NEW_SYN_RECV &&
+					     hashinfo->pernet)) {
+					struct request_sock *req = inet_reqsk(sk);
+
+					inet_csk_reqsk_queue_drop_and_put(req->rsk_listener, req);
+				}
+
 				continue;
+			}
+
 			tw = inet_twsk(sk);
 			if ((tw->tw_family != family) ||
 				refcount_read(&twsk_net(tw)->count))


