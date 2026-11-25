Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621623;
	b=jUDEvgjkuCd228BZ35231GT5LbyyTWAgEZYmOi5ICVTHZax52oMn+pVhTjmXncJ82sP+
	 QFwun7hJ8NfggYHSq67QZUEfVPRxm5j9qMJYwOkgUo52IkBjlaT64pu2k9iwd4dxWRl/6
	 g8KrSKnUAdyA4G3Jo41Oqdo1G+wH93QnTjH3Lku24F6q6TZl7Hl1f0+LRaaOUa7XMDgjd
	 elkr45KcdW0qoMHlLWKXIgwjmVVbBV/du80MFeMNJqS/DKkPJFfYQjdyO1Iz7QxRqkML2
	 M3kjJ4DrYxhucqN3/ZZKGsndnPOQVFKEoCSw4Xye//r0Cm8uN0QWKTXmE6xmxXYt01g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sw3ds8eSx1WL6l+xkvO1HNPA6vFHBby+pLDkzkfYS14=;
	b=S3j+hAFF3kokMH3j7x8Btqg/gHppQpeSrgR8M6AFXzODIydY4OPcmq8kzMkOQNgNIJfu
	 XrX2rEoZjAo/guXzqZDnxkNW+Qw9LEwLMW1A8QSJHm8P3atjviUC2yNm9CJTGUNy/5MVk
	 lCWfT0rtwd1grkJ5UTofIdc0Zxj0Ek17TxmrX8g3NEXFd1Vs1dtR0/frD8rYF7fjHZhUJ
	 BKV/EoCBmTpzrsKcB1T5akKh9plUtzZJW0l2ZFYlCltCJrhLwwhl6vdgOjuvDUDA27ZEl
	 1O1G1x1L/fkkTL1VqLPgfl6XU/P/XktI3OhP1ARH1ykqSoCX14mKWDENFG3WdG8HoEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="sIA9+m/C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF773606A32D;
	Wed, 25 Nov 2026 15:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIA9+m/C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D63D1F000C4;
	Wed, 25 Nov 2026 15:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621622;
	bh=Sw3ds8eSx1WL6l+xkvO1HNPA6vFHBby+pLDkzkfYS14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sIA9+m/CHP1QlT4va12ZmVaZd+ESc4qUS58RU2vG6MMkanGc3TqpPekjJ0TcpNkgi
	 SaFXXkX/HqeIcaf0bN9FIKSeidMX4M+TjDaYoIY6bAcqHthBykupjM1pKafU5AyBgs
	 cyU7pTSci94g6D3eDQPYN11/6mAeB071Bu7AxmBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 284/990] tcp: initialize send sequence numbers before deferring TFO
Date: Wed, 25 Nov 2026 15:27:31 +0100
Message-ID: <20261125143828.739602272@linuxfoundation.org>
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

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit 57889a8f6d49fc153aa0017d13086ab736567f8a ]

TCP_FASTOPEN_CONNECT can return from connect() before tcp_connect_init()
when a cached cookie or cookieless Fast Open allows deferring the SYN.
At this point write_seq contains the initial sequence number, while
snd_una and snd_nxt have not been initialized to that sequence number.

Consequently, inet_diag and /proc/net/tcp{,6} report the initial
sequence number as the send queue length despite no SYN or payload being
queued.

Initialize snd_una and snd_nxt to write_seq before marking the
connection as deferred. Both sequence-based queue lengths then remain
zero until the first write starts the connection and runs
tcp_connect_init().

Fixes: 19f6d3f3c842 ("net/tcp-fastopen: Add new API support")
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Link: https://patch.msgid.link/20261102035943.9700-1-qingfang.deng@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_fastopen.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index dbd97df1b442f..1b0f367f9dfc8 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -456,6 +456,8 @@ bool tcp_fastopen_defer_connect(struct sock *sk, int *err)
 
 	if (tp->fastopen_connect && !tp->fastopen_req) {
 		if (tcp_fastopen_cookie_check(sk, &mss, &cookie)) {
+			WRITE_ONCE(tp->snd_una, tp->write_seq);
+			WRITE_ONCE(tp->snd_nxt, tp->write_seq);
 			inet_set_bit(DEFER_CONNECT, sk);
 			return true;
 		}
-- 
2.53.0



