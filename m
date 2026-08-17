Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606F943CE7B;
	Mon, 17 Aug 2026 13:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974133; cv=none; b=aGAgThFC+C19XNRCt5FDmjq9KtGaZGDuV1Q2j3f+CnjnRulaDh/EamyOim19glnNC6Al2T1/w0PVUTbtOLbMsWo7/zo3tn/03MFlx/POgLVipsJywVhxG3JJExfEewTLbC8DEpcs8iJqgHLZmltrYz3TVFwE4x/GJpu/Dhog5Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974133; c=relaxed/simple;
	bh=hIDadNf0/EXIVCAV3Qd4f6bWCX0GqD2aXYsBiXJD4do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1+Ug6lk2r42gaufSK9TnQkQp89biLA8una62SFl2iNV/MvPAnIjVqEYkeEOtdpXgnzVJkgx4tdXa7eXxUtkQk4Zk4dIaIiT/NQ3DFKvZOg9jcOgRRQCjZdA6pCcETnd5jLtjKW6kvLcNE5SD4K6YVDDVX9PG+Jd1EZfHjU5FQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeYxLM0C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeYxLM0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781931F000E9;
	Mon, 17 Aug 2026 13:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974132;
	bh=OwY4B/ILbxSkTao79YNdvnulMUj3GIQLQ8bW/7q3q9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GeYxLM0CD2ErITCHDTnKXPbeDW6QLT0w2vHdia0Sa/UW3ExkHPUixZC/tEj4aQ0Nd
	 NHNdmNBz2eEtOGtlO6TPGdqSX9TA+USvsI0I9IzVglvgQMl27Z+j08SoEqroMVH+ul
	 NUkicwS66Vk9B8FoHxD9mAuw1m+Wq6QWmaDxOkw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 100/271] tcp: fix TFO max_qlen accounting across reuseport migration
Date: Mon, 17 Aug 2026 15:30:25 +0200
Message-ID: <20260817132540.921913328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 690f7fb3f029e..935b46db61541 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -946,11 +946,23 @@ static struct request_sock *inet_reqsk_clone(struct request_sock *req,
 
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



