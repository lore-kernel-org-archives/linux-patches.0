Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622222;
	b=gAHtgMzN8wfib7+tXI4mIni2ZHYFq8naeV49GJ8CQbqf2NCYqNNpcvpMIfvPU1ZlzjEM
	 KDdwZI2PdSNcspcmaGummRy897fiPRCsGCI5cR5jV1GNI18nrsVu9XBcvDKodJflO6G0K
	 CpNLr8xuGG/Z4zaNEGfzOiZYlXTYOH4wnGbK0eiNUPtk1RZuHr3ODf81Fa8UY3gAQjWGX
	 Nw/vtmVa1b1bI1oFZ8IFmFpfyYwua3jGsvFN6Wi0BnXaUGQxYWMEKB/1kVz6+hTaUugaM
	 BCMXAk3xuFTrroiLF5p5RCjHxg7V7qYWg/zibZLrx4yt06akFsSQITWjXfRe28QIplg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ongkyQIyf7PDt9hqKmp7L7v7gdk/J4oHQKakjyYWrus=;
	b=EMVZxn6FgagmdoS/QEkCtgBTztHz8J/fFLOd4Df6nBjBhxiGG4WxxXDYruOVXr1RemY0
	 W+hsn2BZK40/lkcP00jQ0DVvVTxl3HyS5yycVBMgMoKK1ggcFK/ZCvY32PD5nY0vQcXJH
	 Fz71syFI6Usox77ndI0twpUUEqcLN/g59mK90pW8NQL3SWXuXOrtk44CUXdoH9cJHHgmr
	 3ByDQJ/d+ThvU8u58dBYUS/8XQBxsPjEQbJ6sEqn9M2c+3zaXgm2ecZjIPdVcTQV8Bdqe
	 mhCsRKbmekwmPDQLxlOspq4owClczBSR54u5R4PeISg4bF4TXY2vI8TKZGLctPsYgzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GS8Pa54b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178FE606A31E;
	Wed, 25 Nov 2026 15:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GS8Pa54b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582861F000CA;
	Wed, 25 Nov 2026 15:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622221;
	bh=ongkyQIyf7PDt9hqKmp7L7v7gdk/J4oHQKakjyYWrus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GS8Pa54bgyICkauDvgwNYYTK8x2xbJBfZkgWrFmF1tyRzpJqm3gH6iwKAhD5k2uru
	 J2v0xcQDO5k5G8TUzE1uL2ZGsQ/UyXgUdZPDEQdcLyeMzzzhsbe8gTwGz7Elpan2F2
	 2hraOIm44riYHx9uYA6otShV2uKxXhJR3+PioHOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 468/990] tcp: Pass req->rsk_listener to inet_csk_reqsk_queue_drop() in tcp_check_req().
Date: Wed, 25 Nov 2026 15:30:35 +0100
Message-ID: <20261125143833.059321280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ebcd78ad13efa..accd276830e2e 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -980,7 +980,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		tcp_reset(sk, skb);
 	}
 	if (!fastopen) {
-		bool unlinked = inet_csk_reqsk_queue_drop(sk, req);
+		bool unlinked = inet_csk_reqsk_queue_drop(req->rsk_listener, req);
 
 		if (unlinked)
 			__NET_INC_STATS(sock_net(sk), LINUX_MIB_EMBRYONICRSTS);
-- 
2.53.0



