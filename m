Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113C945C0B;
	Fri, 17 Oct 2025 15:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713557; cv=none; b=d2KythsE33jMx+dE0k6UfAl8RIpMfS/GGI5FWz6VRaseVmhBeGZnSvKvW0LpyH0mbOm2bnljXwJTs6leKkr+27L1oN+soxmx7cKRbX1nkvxZWbqZ9fTI69y/7GEjqZaFy+ympUD6aIakZqjgtHTRBuvJ1QOLuADbzQlQxv1KFDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713557; c=relaxed/simple;
	bh=AvbkBZsF/Cv/G38P0XGmkH6kbJyrFcyVj4e8ZLbcbTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0hsLX27rZvAtdShKu9vRK8EU2vZt7aftDGxnjfzwYaWIr3OUzrMju8MFulKPElkcXgPWziEUzi4BD4oqQ6DopsfaDIePS/PhFXyqjEhzbU1twXe3fYGD+J0OnEWKq6jkkTaeuf/J54y3hYvWfEnOltQORiu3U5zPyr9AE5UCe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6zMRfjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6zMRfjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F9BC4CEE7;
	Fri, 17 Oct 2025 15:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713556;
	bh=AvbkBZsF/Cv/G38P0XGmkH6kbJyrFcyVj4e8ZLbcbTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6zMRfjKy9PjeSB0yF+i+9YzGsa6Hzw93xo9L136iYezYcRV1r1NwFJylz+zLsNLQ
	 f9a8gIhOF3/VxZeywvg8Z3bAHx1LMTyqgtRR10W1mq9ECgD1RKWVaz8P7ixFNHeE2Y
	 DZ5JgW/vsWlZbnROyMJvOaiMnMkOxSFKS8Y8rpCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzkaller <syzkaller@googlegroups.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/201] tcp: Dont call reqsk_fastopen_remove() in tcp_conn_request().
Date: Fri, 17 Oct 2025 16:51:38 +0200
Message-ID: <20251017145136.106261588@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 2e7cbbbe3d61c63606994b7ff73c72537afe2e1c ]

syzbot reported the splat below in tcp_conn_request(). [0]

If a listener is close()d while a TFO socket is being processed in
tcp_conn_request(), inet_csk_reqsk_queue_add() does not set reqsk->sk
and calls inet_child_forget(), which calls tcp_disconnect() for the
TFO socket.

After the cited commit, tcp_disconnect() calls reqsk_fastopen_remove(),
where reqsk_put() is called due to !reqsk->sk.

Then, reqsk_fastopen_remove() in tcp_conn_request() decrements the
last req->rsk_refcnt and frees reqsk, and __reqsk_free() at the
drop_and_free label causes the refcount underflow for the listener
and double-free of the reqsk.

Let's remove reqsk_fastopen_remove() in tcp_conn_request().

Note that other callers make sure tp->fastopen_rsk is not NULL.

[0]:
refcount_t: underflow; use-after-free.
WARNING: CPU: 12 PID: 5563 at lib/refcount.c:28 refcount_warn_saturate (lib/refcount.c:28)
Modules linked in:
CPU: 12 UID: 0 PID: 5563 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:refcount_warn_saturate (lib/refcount.c:28)
Code: ab e8 8e b4 98 ff 0f 0b c3 cc cc cc cc cc 80 3d a4 e4 d6 01 00 75 9c c6 05 9b e4 d6 01 01 48 c7 c7 e8 df fb ab e8 6a b4 98 ff <0f> 0b e9 03 5b 76 00 cc 80 3d 7d e4 d6 01 00 0f 85 74 ff ff ff c6
RSP: 0018:ffffa79fc0304a98 EFLAGS: 00010246
RAX: d83af4db1c6b3900 RBX: ffff9f65c7a69020 RCX: d83af4db1c6b3900
RDX: 0000000000000000 RSI: 00000000ffff7fff RDI: ffffffffac78a280
RBP: 000000009d781b60 R08: 0000000000007fff R09: ffffffffac6ca280
R10: 0000000000017ffd R11: 0000000000000004 R12: ffff9f65c7b4f100
R13: ffff9f65c7d23c00 R14: ffff9f65c7d26000 R15: ffff9f65c7a64ef8
FS:  00007f9f962176c0(0000) GS:ffff9f65fcf00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000180 CR3: 000000000dbbe006 CR4: 0000000000372ef0
Call Trace:
 <IRQ>
 tcp_conn_request (./include/linux/refcount.h:400 ./include/linux/refcount.h:432 ./include/linux/refcount.h:450 ./include/net/sock.h:1965 ./include/net/request_sock.h:131 net/ipv4/tcp_input.c:7301)
 tcp_rcv_state_process (net/ipv4/tcp_input.c:6708)
 tcp_v6_do_rcv (net/ipv6/tcp_ipv6.c:1670)
 tcp_v6_rcv (net/ipv6/tcp_ipv6.c:1906)
 ip6_protocol_deliver_rcu (net/ipv6/ip6_input.c:438)
 ip6_input (net/ipv6/ip6_input.c:500)
 ipv6_rcv (net/ipv6/ip6_input.c:311)
 __netif_receive_skb (net/core/dev.c:6104)
 process_backlog (net/core/dev.c:6456)
 __napi_poll (net/core/dev.c:7506)
 net_rx_action (net/core/dev.c:7569 net/core/dev.c:7696)
 handle_softirqs (kernel/softirq.c:579)
 do_softirq (kernel/softirq.c:480)
 </IRQ>

Fixes: 45c8a6cc2bcd ("tcp: Clear tcp_sk(sk)->fastopen_rsk in tcp_disconnect().")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20251001233755.1340927-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c6d00817ad3fd..8834cd41b3840 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -7200,7 +7200,6 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 				    &foc, TCP_SYNACK_FASTOPEN, skb);
 		/* Add the child socket directly into the accept queue */
 		if (!inet_csk_reqsk_queue_add(sk, req, fastopen_sk)) {
-			reqsk_fastopen_remove(fastopen_sk, req, false);
 			bh_unlock_sock(fastopen_sk);
 			sock_put(fastopen_sk);
 			goto drop_and_free;
-- 
2.51.0



