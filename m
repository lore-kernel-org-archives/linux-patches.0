Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BB12288CB;
	Tue,  8 Apr 2025 11:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111975; cv=none; b=IQgBSOs9m9ufB4uZzixT0U/h+TO5qVkBkuCCuRMcUQFScwQbJZiHcIV0rMD1+co5253rzH57aEcZ7Z5xjgCGpsQOtMejCwkBa5SbNeSobszRsKhZgCeYrPc66K2imC7m3mdo5I2wKUp8xO8buoyJjmphxNdtEDzDdlt38a8muUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111975; c=relaxed/simple;
	bh=K7qKA0rwhSFmG85An63Ol1CYUnNTCR5CBBpxSf0hSIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3UWir0JkfgzRqI1B16JkaMAgMCYE+bc8JJstl67frHqMwKwkbpIzR3lMWiprmORemXUoB2A71uf6a0p1iBcNDgDbobJqzDkbDncmSwuqHYA6klxkKWBeYWz8Ixmb7KtcunPa+6m+UGNDRS1M+dPm5/smPlIH9J2UIjS697fSkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJjZIqq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJjZIqq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20D5C4CEE5;
	Tue,  8 Apr 2025 11:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111975;
	bh=K7qKA0rwhSFmG85An63Ol1CYUnNTCR5CBBpxSf0hSIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJjZIqq4bU7R1rcN6tu1xjEr8cdkJwECB4wiNqt+g6gm6VMJU/qDstI2//AHVSuWD
	 AinG8QZXMVXIW+cZG76ZjFuEwj0f7kq6+wzm650gLIvLA2UvQxXII8X2XTNUAferuo
	 /saffXCTBkeBxsB08J4ynsUGnYD/GqBXvRHGgZK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Dowling <madowlin@amazon.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 628/731] udp: Fix memory accounting leak.
Date: Tue,  8 Apr 2025 12:48:45 +0200
Message-ID: <20250408104928.880233589@linuxfoundation.org>
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

[ Upstream commit df207de9d9e7a4d92f8567e2c539d9c8c12fd99d ]

Matt Dowling reported a weird UDP memory usage issue.

Under normal operation, the UDP memory usage reported in /proc/net/sockstat
remains close to zero.  However, it occasionally spiked to 524,288 pages
and never dropped.  Moreover, the value doubled when the application was
terminated.  Finally, it caused intermittent packet drops.

We can reproduce the issue with the script below [0]:

  1. /proc/net/sockstat reports 0 pages

    # cat /proc/net/sockstat | grep UDP:
    UDP: inuse 1 mem 0

  2. Run the script till the report reaches 524,288

    # python3 test.py & sleep 5
    # cat /proc/net/sockstat | grep UDP:
    UDP: inuse 3 mem 524288  <-- (INT_MAX + 1) >> PAGE_SHIFT

  3. Kill the socket and confirm the number never drops

    # pkill python3 && sleep 5
    # cat /proc/net/sockstat | grep UDP:
    UDP: inuse 1 mem 524288

  4. (necessary since v6.0) Trigger proto_memory_pcpu_drain()

    # python3 test.py & sleep 1 && pkill python3

  5. The number doubles

    # cat /proc/net/sockstat | grep UDP:
    UDP: inuse 1 mem 1048577

The application set INT_MAX to SO_RCVBUF, which triggered an integer
overflow in udp_rmem_release().

When a socket is close()d, udp_destruct_common() purges its receive
queue and sums up skb->truesize in the queue.  This total is calculated
and stored in a local unsigned integer variable.

The total size is then passed to udp_rmem_release() to adjust memory
accounting.  However, because the function takes a signed integer
argument, the total size can wrap around, causing an overflow.

Then, the released amount is calculated as follows:

  1) Add size to sk->sk_forward_alloc.
  2) Round down sk->sk_forward_alloc to the nearest lower multiple of
      PAGE_SIZE and assign it to amount.
  3) Subtract amount from sk->sk_forward_alloc.
  4) Pass amount >> PAGE_SHIFT to __sk_mem_reduce_allocated().

When the issue occurred, the total in udp_destruct_common() was 2147484480
(INT_MAX + 833), which was cast to -2147482816 in udp_rmem_release().

At 1) sk->sk_forward_alloc is changed from 3264 to -2147479552, and
2) sets -2147479552 to amount.  3) reverts the wraparound, so we don't
see a warning in inet_sock_destruct().  However, udp_memory_allocated
ends up doubling at 4).

Since commit 3cd3399dd7a8 ("net: implement per-cpu reserves for
memory_allocated"), memory usage no longer doubles immediately after
a socket is close()d because __sk_mem_reduce_allocated() caches the
amount in udp_memory_per_cpu_fw_alloc.  However, the next time a UDP
socket receives a packet, the subtraction takes effect, causing UDP
memory usage to double.

This issue makes further memory allocation fail once the socket's
sk->sk_rmem_alloc exceeds net.ipv4.udp_rmem_min, resulting in packet
drops.

To prevent this issue, let's use unsigned int for the calculation and
call sk_forward_alloc_add() only once for the small delta.

Note that first_packet_length() also potentially has the same problem.

[0]:
from socket import *

SO_RCVBUFFORCE = 33
INT_MAX = (2 ** 31) - 1

s = socket(AF_INET, SOCK_DGRAM)
s.bind(('', 0))
s.setsockopt(SOL_SOCKET, SO_RCVBUFFORCE, INT_MAX)

c = socket(AF_INET, SOCK_DGRAM)
c.connect(s.getsockname())

data = b'a' * 100

while True:
    c.send(data)

Fixes: f970bd9e3a06 ("udp: implement memory accounting helpers")
Reported-by: Matt Dowling <madowlin@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20250401184501.67377-3-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 31f7bfec23590..3fe85ecec2361 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1626,12 +1626,12 @@ static bool udp_skb_has_head_state(struct sk_buff *skb)
 }
 
 /* fully reclaim rmem/fwd memory allocated for skb */
-static void udp_rmem_release(struct sock *sk, int size, int partial,
-			     bool rx_queue_lock_held)
+static void udp_rmem_release(struct sock *sk, unsigned int size,
+			     int partial, bool rx_queue_lock_held)
 {
 	struct udp_sock *up = udp_sk(sk);
 	struct sk_buff_head *sk_queue;
-	int amt;
+	unsigned int amt;
 
 	if (likely(partial)) {
 		up->forward_deficit += size;
@@ -1651,10 +1651,8 @@ static void udp_rmem_release(struct sock *sk, int size, int partial,
 	if (!rx_queue_lock_held)
 		spin_lock(&sk_queue->lock);
 
-
-	sk_forward_alloc_add(sk, size);
-	amt = (sk->sk_forward_alloc - partial) & ~(PAGE_SIZE - 1);
-	sk_forward_alloc_add(sk, -amt);
+	amt = (size + sk->sk_forward_alloc - partial) & ~(PAGE_SIZE - 1);
+	sk_forward_alloc_add(sk, size - amt);
 
 	if (amt)
 		__sk_mem_reduce_allocated(sk, amt >> PAGE_SHIFT);
@@ -1844,7 +1842,7 @@ EXPORT_SYMBOL_GPL(skb_consume_udp);
 
 static struct sk_buff *__first_packet_length(struct sock *sk,
 					     struct sk_buff_head *rcvq,
-					     int *total)
+					     unsigned int *total)
 {
 	struct sk_buff *skb;
 
@@ -1877,8 +1875,8 @@ static int first_packet_length(struct sock *sk)
 {
 	struct sk_buff_head *rcvq = &udp_sk(sk)->reader_queue;
 	struct sk_buff_head *sk_queue = &sk->sk_receive_queue;
+	unsigned int total = 0;
 	struct sk_buff *skb;
-	int total = 0;
 	int res;
 
 	spin_lock_bh(&rcvq->lock);
-- 
2.39.5



