Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7598713B2B4;
	Tue, 27 Feb 2024 14:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043785; cv=none; b=hDgdIa+F9ZPF3/J4otzz1UHDaDGpIgW+TKVCsCi7JWG19AQ/ADT2qwiZG8ZVtlnEad8z/twdQI7/69IrDXjGKFzE3PPI2CWaU0yTEXOJNEXW+JwhyKgIjkUUIVYQgnvpQXbkWEoBI3cUQTygF99feI1zpVTt0VrmvNKMDlbpTiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043785; c=relaxed/simple;
	bh=5tQWivTUYJLJ7WLigxHq3MuF0VJ4HNwsZYouSyqxQKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpDMgFQMOWS1auHn3fsTsaw75MU310Cokzl1JevYjotwLMvsdnHyUPjCh5WpMW5JRC/Yzayj7oLYYVCRVWyxb/JRGC/s7YdWi7+mqfSlN+wLPXlMLEitcNdEwuGDi1XZr9E3zDzqWTNBZKbIqMtwi6sS6qOEwLDghj2NhYlBFd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIuN0uNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIuN0uNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01597C433F1;
	Tue, 27 Feb 2024 14:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043785;
	bh=5tQWivTUYJLJ7WLigxHq3MuF0VJ4HNwsZYouSyqxQKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIuN0uNoUzVRR10UcbmLqb8jHOFYeMDnL3MpAIRYB+R5X4m/CAyENUTQW++x4to7o
	 xzbODmNu7jVcirpniJ6v+QgI8n6WGftW1nbP+PLEFKnaQ9Ju4gks0iUIZ68MzhmcP9
	 mZhc0naj7X5H2EsHGYZCdA72Fp/GbqKAAuVvGVCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Soheil Hassas Yeganeh <soheil@google.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/84] tcp: return EPOLLOUT from tcp_poll only when notsent_bytes is half the limit
Date: Tue, 27 Feb 2024 14:27:02 +0100
Message-ID: <20240227131554.012093065@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6a52fdcf9e4ef..e45c09977c600 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -566,7 +566,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 			mask |= EPOLLIN | EPOLLRDNORM;
 
 		if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
-			if (sk_stream_is_writeable(sk)) {
+			if (__sk_stream_is_writeable(sk, 1)) {
 				mask |= EPOLLOUT | EPOLLWRNORM;
 			} else {  /* send SIGIO later */
 				sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
@@ -578,7 +578,7 @@ __poll_t tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 				 * pairs with the input side.
 				 */
 				smp_mb__after_atomic();
-				if (sk_stream_is_writeable(sk))
+				if (__sk_stream_is_writeable(sk, 1))
 					mask |= EPOLLOUT | EPOLLWRNORM;
 			}
 		} else
-- 
2.43.0



