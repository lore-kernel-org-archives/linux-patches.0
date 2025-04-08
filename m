Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11078269AF4;
	Tue,  8 Apr 2025 11:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111973; cv=none; b=PCSSXql+/V1Th1HhzEEQkxt06et1kcfih66bgCsj1Merz5rlEJ0vtuEQFJljh7X36hlChTaPiy3oeVnJN+6FPPUzHK4HrUyegDxwCoTIZjHqmwkiKfAeBdUkX7qsEs7Jay+1PfOarSknTI6YtMxjGQdKtW5dUGxnmua4p1irfZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111973; c=relaxed/simple;
	bh=QCEhF7gYV/DdAZW8HsSrUrG4KPQ/9WmOjGmW/CkZ07Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evG4ymxA8sJmvQWLOGhRxmc1dFNMA5X9c+EdK+KBQJxrCmVe9/9CygDhe+oVLSmHcd47hFqkCAclzBOX8Lv0HkuoQACERH8Xmf8WDUYK8gMxt7PaaTqPVLQtTqqj9JSMriOrS8M1CHtVfgUpoZRzK0Nx57Zz7oGXuYfPq6KdEeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSQKWLXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSQKWLXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B68C4CEE5;
	Tue,  8 Apr 2025 11:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111972;
	bh=QCEhF7gYV/DdAZW8HsSrUrG4KPQ/9WmOjGmW/CkZ07Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSQKWLXd4gbRT3BmFry8DBhk8MSrGOuxo5804oaj12vmhJtDPfcNvm6RsiYm3t6oe
	 JLG5ts5ylmB/D81z+iLmr7qlhNICfkdAe3j5W9q3RgyO94qArKJjqmQEiIKt+4OCV6
	 wBtuNnRR71CE9QKii/5WekyASxYEBb7u7IBWPeJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 627/731] udp: Fix multiple wraparounds of sk->sk_rmem_alloc.
Date: Tue,  8 Apr 2025 12:48:44 +0200
Message-ID: <20250408104928.857526755@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 5a465a0da13ee9fbd7d3cd0b2893309b0fe4b7e3 ]

__udp_enqueue_schedule_skb() has the following condition:

  if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
          goto drop;

sk->sk_rcvbuf is initialised by net.core.rmem_default and later can
be configured by SO_RCVBUF, which is limited by net.core.rmem_max,
or SO_RCVBUFFORCE.

If we set INT_MAX to sk->sk_rcvbuf, the condition is always false
as sk->sk_rmem_alloc is also signed int.

Then, the size of the incoming skb is added to sk->sk_rmem_alloc
unconditionally.

This results in integer overflow (possibly multiple times) on
sk->sk_rmem_alloc and allows a single socket to have skb up to
net.core.udp_mem[1].

For example, if we set a large value to udp_mem[1] and INT_MAX to
sk->sk_rcvbuf and flood packets to the socket, we can see multiple
overflows:

  # cat /proc/net/sockstat | grep UDP:
  UDP: inuse 3 mem 7956736  <-- (7956736 << 12) bytes > INT_MAX * 15
                                             ^- PAGE_SHIFT
  # ss -uam
  State  Recv-Q      ...
  UNCONN -1757018048 ...    <-- flipping the sign repeatedly
         skmem:(r2537949248,rb2147483646,t0,tb212992,f1984,w0,o0,bl0,d0)

Previously, we had a boundary check for INT_MAX, which was removed by
commit 6a1f12dd85a8 ("udp: relax atomic operation on sk->sk_rmem_alloc").

A complete fix would be to revert it and cap the right operand by
INT_MAX:

  rmem = atomic_add_return(size, &sk->sk_rmem_alloc);
  if (rmem > min(size + (unsigned int)sk->sk_rcvbuf, INT_MAX))
          goto uncharge_drop;

but we do not want to add the expensive atomic_add_return() back just
for the corner case.

Casting rmem to unsigned int prevents multiple wraparounds, but we still
allow a single wraparound.

  # cat /proc/net/sockstat | grep UDP:
  UDP: inuse 3 mem 524288  <-- (INT_MAX + 1) >> 12

  # ss -uam
  State  Recv-Q      ...
  UNCONN -2147482816 ...   <-- INT_MAX + 831 bytes
         skmem:(r2147484480,rb2147483646,t0,tb212992,f3264,w0,o0,bl0,d14468947)

So, let's define rmem and rcvbuf as unsigned int and check skb->truesize
only when rcvbuf is large enough to lower the overflow possibility.

Note that we still have a small chance to see overflow if multiple skbs
to the same socket are processed on different core at the same time and
each size does not exceed the limit but the total size does.

Note also that we must ignore skb->truesize for a small buffer as
explained in commit 363dc73acacb ("udp: be less conservative with
sock rmem accounting").

Fixes: 6a1f12dd85a8 ("udp: relax atomic operation on sk->sk_rmem_alloc")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250401184501.67377-2-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index a9bb9ce5438ea..31f7bfec23590 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1726,17 +1726,25 @@ static int udp_rmem_schedule(struct sock *sk, int size)
 int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 {
 	struct sk_buff_head *list = &sk->sk_receive_queue;
-	int rmem, err = -ENOMEM;
+	unsigned int rmem, rcvbuf;
 	spinlock_t *busy = NULL;
-	int size, rcvbuf;
+	int size, err = -ENOMEM;
 
-	/* Immediately drop when the receive queue is full.
-	 * Always allow at least one packet.
-	 */
 	rmem = atomic_read(&sk->sk_rmem_alloc);
 	rcvbuf = READ_ONCE(sk->sk_rcvbuf);
-	if (rmem > rcvbuf)
-		goto drop;
+	size = skb->truesize;
+
+	/* Immediately drop when the receive queue is full.
+	 * Cast to unsigned int performs the boundary check for INT_MAX.
+	 */
+	if (rmem + size > rcvbuf) {
+		if (rcvbuf > INT_MAX >> 1)
+			goto drop;
+
+		/* Always allow at least one packet for small buffer. */
+		if (rmem > rcvbuf)
+			goto drop;
+	}
 
 	/* Under mem pressure, it might be helpful to help udp_recvmsg()
 	 * having linear skbs :
@@ -1746,10 +1754,10 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
 	 */
 	if (rmem > (rcvbuf >> 1)) {
 		skb_condense(skb);
-
+		size = skb->truesize;
 		busy = busylock_acquire(sk);
 	}
-	size = skb->truesize;
+
 	udp_set_dev_scratch(skb);
 
 	atomic_add(size, &sk->sk_rmem_alloc);
-- 
2.39.5



