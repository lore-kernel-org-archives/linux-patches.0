Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F75611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9292C433EF;
	Sun, 28 May 2023 19:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301420;
	bh=AZhhvawArSKkcTAmiz04exIWyoy05W02J3W/bj0B9gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jq+P6fHhAbUBDqstfKFYan/SmSwobr0OiTBa5S9d+Im2VqfdOz1UBpNRVt4M7hF4N
	 Z/3uLuJ6Ofnbk7Q5ETaj7w/rrZvGG5TZS90ULMQOxcTcTglRIFGEx1gyIwZjrK2s7A
	 3JZxYyteZM8CQki5Irt3HbPAIv+mz+bOohA6mhBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soheil Hassas Yeganeh <soheil@google.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 005/132] tcp: return EPOLLOUT from tcp_poll only when notsent_bytes is half the limit
Date: Sun, 28 May 2023 20:09:04 +0100
Message-Id: <20230528190833.728570413@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Soheil Hassas Yeganeh <soheil@google.com>

[ Upstream commit 8ba3c9d1c6d75d1e6af2087278b30e17f68e1fff ]

If there was any event available on the TCP socket, tcp_poll()
will be called to retrieve all the events.  In tcp_poll(), we call
sk_stream_is_writeable() which returns true as long as we are at least
one byte below notsent_lowat.  This will result in quite a few
spurious EPLLOUT and frequent tiny sendmsg() calls as a result.

Similar to sk_stream_write_space(), use __sk_stream_is_writeable
with a wake value of 1, so that we set EPOLLOUT only if half the
space is available for write.

Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e14cadfd80d7 ("tcp: add annotations around sk->sk_shutdown accesses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 68f89fe7f9233..2fcf6e5a371dd 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -576,7 +576,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 			mask |= EPOLLIN | EPOLLRDNORM;
 
 		if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
-			if (sk_stream_is_writeable(sk)) {
+			if (__sk_stream_is_writeable(sk, 1)) {
 				mask |= EPOLLOUT | EPOLLWRNORM;
 			} else {  /* send SIGIO later */
 				sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
@@ -588,7 +588,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 				 * pairs with the input side.
 				 */
 				smp_mb__after_atomic();
-				if (sk_stream_is_writeable(sk))
+				if (__sk_stream_is_writeable(sk, 1))
 					mask |= EPOLLOUT | EPOLLWRNORM;
 			}
 		} else
-- 
2.39.2



