Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624935;
	b=dey/248nXehRDBberGj+v0bA0wyBgvgaNDehbR167OQTx1X7/7OORvmC/481VasuwH6u
	 Hnn4x+DyIQ+k26jcziB+9LwRtKQ0kgVvOkoPVC7tBzckYzQvDbSw7T1n4Bl5bVxTK8I0N
	 N6TBlHsf3qSRa8sBPzmK8/0974qIknOXoPf+H+AFecYzuUQ4s4kVZmAJQNbXXcdQ2EIzZ
	 TX3NIncnQav1uK13R2koucHN4rIfT/oTd3bFUgBSqpSr04ABTYHVzl6JaoJJD9V4helKi
	 WzlL7wfXcJ7vcaHI8D7o4QZSemYfjUGFaE/bhDj7vrngVEoEYHGITOXEIO78gla0lQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FOPXVvF3Mg0kf0rqjI6dJ3u0NUgj0jhRW9HItk1AHus=;
	b=bSWTY+URl6FAim6g8IxfGCbIqepdvX8rjmkPjwNCBx/cJZLIdAfFRihD62oLzE6mEqrg
	 qopz8CfE2nV5l7ejkzKQh98B7JT03RAX5My0W+kXiFDMQyaWuUdPXKTVaGm+EAKfSdg+h
	 pafnPq6FTxrCxmpFWf+1SYd6YSWTDeAyOwCqBM7D9AfzwpqLx8WYO5b+DCBA3D7r037tC
	 ULOYHleqyZX4UWM8FJ670N/8SviKo0JGTLFchxFSvMZKDe285KTLStaUbP/hB/UCj8QZD
	 qX0mDbivX0ooa14Mif+AAN/B/5sqKTJ35Sdm6Hs6/BP8NBCxiAQ16FFI0FT3LjJtl3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tUIvg9eU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8A8606A31E;
	Wed, 25 Nov 2026 16:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tUIvg9eU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179B41F000C6;
	Wed, 25 Nov 2026 16:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624935;
	bh=FOPXVvF3Mg0kf0rqjI6dJ3u0NUgj0jhRW9HItk1AHus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tUIvg9eUfOZPeKMD2g3jRqkKu+FjpfG/616NoHJ3FFknaocYecRrNQ6GyzZnW+/DR
	 LOOg6muW3uPLnwHtXUXjgJz+x07LBkLU3BzfKqh9E+g5+6d8qx6A+h6+iVnNf9+rg6
	 KtqUDd6EyaCeRkUvc6aHQ8fjn6vpFlyRTlfcgCsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 352/816] tcp: Pass req->rsk_listener to inet_csk_reqsk_queue_drop() in tcp_check_req().
Date: Wed, 25 Nov 2026 15:31:40 +0100
Message-ID: <20261125143857.345896303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit a9782a6f2bbd0c444689725a710d8b21eab61bc5 ]

When connection migration happens in tcp_v[46]_rcv(), a new
listener is passed to tcp_check_req().

When either of the following is true,

  * the new listener queue is full and
    net.ipv4.tcp_abort_on_overflow is set

  * the packet has RST or (not stripped) SYN

tcp_check_req() sends RST and calls inet_csk_reqsk_queue_drop().

Here, the new listener is passed, and its qlen is decremented
wrongly while reqsk is tied to the old listener.

Once qlen underflows, inet_csk_reqsk_queue_is_full() always
return true, and the new listener stops serving.

Without the patch, this script times out while waiting for SYN+ACK
since the new listener drops SYN, but with the patch, 3WHS completes.

    0 `sysctl -q net.ipv4.tcp_migrate_req=1`
   +0 `sysctl -q net.ipv4.tcp_syncookies=0`
   +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEPORT, [1], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 4
   +0 setsockopt(4, SOL_SOCKET, SO_REUSEPORT, [1], 4) = 0
   +0 bind(4, ..., ...) = 0
   +0 listen(4, 128) = 0
   +0 < S 0:0(0) win 32792 <mss 1000>
   +0 > S. 0:0(0) ack 1 <...>
   +0 listen(3, 128) = 0
   +0 close(4) = 0
 +.01 < R 1:1(0) win 0
   +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 5
   +0 listen(5, 1) = 0
 +.01 < S 0:0(0) win 32792 <mss 1000>
   +0 > S. 0:0(0) ack 1 <...>
   +0 < . 1:1(0) ack 1 win 32792
   +0 fcntl(3, F_SETFL, O_RDWR|O_NONBLOCK) = 0
   +0 accept(3, ..., ...) = 6

Let's pass req->rsk_listener instead.

Fixes: d4f2c86b2b7e ("tcp: Migrate TCP_NEW_SYN_RECV requests at receiving the final ACK.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261111020304.1532064-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_minisocks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index a43f082b871ed..567710d43c13f 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -900,7 +900,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		tcp_reset(sk, skb);
 	}
 	if (!fastopen) {
-		bool unlinked = inet_csk_reqsk_queue_drop(sk, req);
+		bool unlinked = inet_csk_reqsk_queue_drop(req->rsk_listener, req);
 
 		if (unlinked)
 			__NET_INC_STATS(sock_net(sk), LINUX_MIB_EMBRYONICRSTS);
-- 
2.53.0



