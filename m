Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705332;
	b=xWEOI742DOZtP7m4t/Mv/9j7IIJwQL0gpt+MeTwpbg8MEJzevTz+p2IJSksF4a6oqOT/
	 EFC8PBgjvO8cCHOj/1usB0yCVIjBog7vhL2kpsyWbVVgMbf4nZRqxo1O6Q+yzavKe8aP5
	 eda703RdHbwtDiFYEgnmmIfUHipdO7G255UgJ/UQ38z41lJ+RiyZO7lLlZJ1rJQu5kSv5
	 wQ6v8Zqte2E47KxqAMp4ytaV8vgOfdalm0og0CJmdNI/lgUimsbEeb9DDbjiyau3c1PGE
	 cM0s3wt49GwV35v/Dlin91JRo68XbD5JTvPECxWeMmQqyRZakMXTgFTXvja1ttsqGmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4lZaRZerT0TO0HdGRLVO052WB+WoqBpeN8seFB5I+3s=;
	b=IDvrFafciwWOFziH1QQPKyHTC2OjyaE4Oe9bwjEHKpQvQnWK13JUIe0K2Gue6zA/BYLO
	 Xsbc3R5Y0fnJBTR0ZReqEJiWlKhgnRjHmjCNsSZciJsh0QyAx5mR/nKTggKY0HL/+qPwc
	 nnZeo9COPPY6kJQ6KntkWsyCHy5NfVcq32asBXTqXyj/7esmKAtzaI5LEQVqU7enAvuE1
	 jttmX9f7itOa6LrAeIu/hvG2hZ4w1cb3O5zQBM1fcdWenhmarvxsDda5HpU0bP474xTHv
	 lbEQ1S0KmcUxa02rNLZvDrJ3xc/EmX/Vx9gyQXVH6yhCJYDY8ecwNNIwdzmhiNInIMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EuMl532Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E883F606A32C;
	Thu, 26 Nov 2026 15:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EuMl532Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1381F000E0;
	Thu, 26 Nov 2026 15:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705331;
	bh=4lZaRZerT0TO0HdGRLVO052WB+WoqBpeN8seFB5I+3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EuMl532Ynquj4x5HYQZfyyVMkZ1EAKqo18ngq0YXTx4ZbY3WGcjoUl8YdzWdiAi+e
	 FnpGtAXF6sFSdrmeNLDH5w6SA6byFHSVzLSFx51Th572kYVydCf3tbwnlnzdzZjtaN
	 XZTpkvI3GCamwKQaNlIVxkAsIdKrcfhDAzgRZr8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/319] tcp: Pass req->rsk_listener to inet_csk_reqsk_queue_drop() in tcp_check_req().
Date: Thu, 26 Nov 2026 15:38:49 +0100
Message-ID: <20261126144010.380159364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index be4fb0ce2574c..1abe28b8bfc5e 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -810,7 +810,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		tcp_reset(sk, skb);
 	}
 	if (!fastopen) {
-		bool unlinked = inet_csk_reqsk_queue_drop(sk, req);
+		bool unlinked = inet_csk_reqsk_queue_drop(req->rsk_listener, req);
 
 		if (unlinked)
 			__NET_INC_STATS(sock_net(sk), LINUX_MIB_EMBRYONICRSTS);
-- 
2.53.0



