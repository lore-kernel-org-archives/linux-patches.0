Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77ED841F5EA;
	Mon, 17 Aug 2026 14:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977612; cv=none; b=BRQyQf2wA0FXaW1OAwoQSJlJ+Hiq/51Rn2XUSEEVxVzzgCMrTYguFqOK3/cYYkHtNjxe/egHO/ZMzFrgf0K4H9qrJE+bhXyTDwIX5iSAvTRhjIAHpmzc0K+KN0mMifED1kU0wnfaDfJNz7Qx9YLd/PUbP3MuApTmKJeadHvKTug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977612; c=relaxed/simple;
	bh=CQCpdcjDNmEtDsbI6mQQKL55KhrUQU9eOYLj3xpZinI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gczsxpjfdJqXVUekFF1D/5CVDGHoeINPhit/vsxwY6426ICEOGKzHOEmUGrpvIC/cvDuhOwEMB9QB2LS0Tqkjdi7B8wKS8P0XqRbFpsjVQzggcG5/Xi5TyY4rN5Bl6STalgFHvgyQthIWRE3/s/zq43n0Ds2WPKI39K37qhXZ4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpTSiCAQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpTSiCAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37BD1F000E9;
	Mon, 17 Aug 2026 14:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977611;
	bh=yfdErj62B6gnwX8p0EMZ6307HPJjg8yygKmCNez1zcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpTSiCAQZUoEwMxRREuXZumfouiCRA5h6OwTuv89lvDbOfv88rnAvYVjxG/1t14sk
	 7MWwI4XCJxzfaADw1oqvbK1HAcTUuMIdao6T5MOa/Klb4mwKKUOAilnIaJPazNQRva
	 34q4aWjDTDuOV2AcK2KuJJTmSMLb40CF20ePJmwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 388/456] tcp: fix TFO max_qlen accounting across reuseport migration
Date: Mon, 17 Aug 2026 15:32:58 +0200
Message-ID: <20260817132554.611018036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d99fed07b024f..042982aaf9704 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -750,11 +750,23 @@ static struct request_sock *inet_reqsk_clone(struct request_sock *req,
 
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



