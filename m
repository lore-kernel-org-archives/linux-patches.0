Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9633D6479;
	Mon, 17 Aug 2026 13:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974896; cv=none; b=fAb2NPuyy9jjAXr93QDpfVl0BElDHrX+nDRAi7fr+XA4R4Cfqt+kUL4OH4pAAp2jTgCh/nBGipr/KUj5ugyLHKUuK8BWMNutXtv0MNVu1lGtArSUa0/vI6IRmYY4QqSsQjWqOV2fzEUYtWMskwUD7+qXAu9ttbf1ARy7iXV78n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974896; c=relaxed/simple;
	bh=j8/9VWZmbf+U1lC9GsaBMiU+ikTPL5PoMx8qPbDFZoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hxu7XNOuoauz3xhZbT7an4m9jMMpWcwaoWeJUpLcIzK/8H+YXBaON3wAaeT4HPi8elsqhy1VjYs6Q6Z9y3oaVgmEc7Okl9BPA9TDWzknB8Pyn+IW0wKyMn0V7bIGcCNU8aDxeK1R1H1czvMYvViZvcxBwzjjFJWfQ6mai0CFkvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6la+Vkp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6la+Vkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AF91F00A3A;
	Mon, 17 Aug 2026 13:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974892;
	bh=Ff6sjCKnvwwPZBM7ppvoVt9ny1DoQ0uvQT55xNlkHiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k6la+VkpJeIGP4r8ZiPZM1hyFWz1Yd2uNZ84JsYupgN9eO0rtE81D8/mJxnArOV6G
	 /YLg0r9oIIuZKx9fj/kZHGFzhSMTzqI95hjxts7fRBQD9SsRcFy2Ya09slyAB3buUF
	 s7r31HmVY5zAYe4wP3KwiOqXwXd9t8m8/oNlrU5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 090/250] tcp: fix TFO max_qlen accounting across reuseport migration
Date: Mon, 17 Aug 2026 15:30:51 +0200
Message-ID: <20260817132540.162912460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit a0ab2ba83e35159d81cec830a92e885ecf8139be ]

A listener's TCP_FASTOPEN max_qlen stops being accurate and lets through
far more pending Fast Open requests than it was configured for.

This only shows up with SO_REUSEPORT listener migration, where closing a
listener hands its still-pending TFO children over to a surviving one.

fastopenq.qlen is charged in tcp_fastopen_create_child() when the child
is created and uncharged in reqsk_fastopen_remove() when the handshake
completes.  The uncharge follows rsk_listener of the request the child
points at, and inet_reqsk_clone() has repointed the child at a new
request owned by the new listener, so the ++ and the -- land on two
different sockets.  The new listener's qlen drifts negative and its
limit no longer binds.

Charge the new listener during migration, like reqsk_queue_migrated()
already does for queue->young and queue->qlen.

Fixes: 54b92e841937 ("tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260803061739.134737-1-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 1679bfefa560d..5db36e323e683 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -964,11 +964,23 @@ static struct request_sock *inet_reqsk_clone(struct request_sock *req,
 
 	nreq->rsk_listener = sk;
 
-	/* We need not acquire fastopenq->lock
-	 * because the child socket is locked in inet_csk_listen_stop().
-	 */
-	if (sk->sk_protocol == IPPROTO_TCP && tcp_rsk(nreq)->tfo_listener)
+	if (sk->sk_protocol == IPPROTO_TCP && tcp_rsk(nreq)->tfo_listener) {
+		struct fastopen_queue *fastopenq;
+
+		/* reqsk_fastopen_remove() will uncharge nreq->rsk_listener,
+		 * that is @sk, so charge it here.  Unlike the listener
+		 * being closed, @sk is live and needs its lock.
+		 */
+		fastopenq = &inet_csk(sk)->icsk_accept_queue.fastopenq;
+		spin_lock_bh(&fastopenq->lock);
+		fastopenq->qlen++;
+		spin_unlock_bh(&fastopenq->lock);
+
+		/* We need not acquire fastopenq->lock
+		 * because the child socket is locked in inet_csk_listen_stop().
+		 */
 		rcu_assign_pointer(tcp_sk(nreq->sk)->fastopen_rsk, nreq);
+	}
 
 	return nreq;
 }
-- 
2.53.0



