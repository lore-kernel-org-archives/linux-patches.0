Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059894;
	b=nsI2IwYAWQfRgVZVuk853JPt7z2vO6WGuY1vNK8NVpLM2f+F1lHCNtPGppkW8Csyw1NS
	 eNJv/U9oFMRXGbQKnxSJ9BfNY3N4vh7PGE9jV0YjTnXi1A8lQmzKp3NR9lqhc7U0XQ6Np
	 EZYpcSOylXMs0QEjBi+wfqxAAz03EEWwC6U3LeZd1ki+G8OQ7bnP1qKK7pF98L7M/Ln7E
	 XNJuSjavHwKX19akiT0rOyK4zzKG2TaYrK3syIg6SGTot6cpi3wb8gl75lnTgl3flDnIg
	 LMld/UamrsuAmBLycEerbtjBTl3xwlMfFyzWRuPdBsyk9BiYU8xZM2H20ALWOrDy3Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ya8IIo/McyHuzCrYvmt1c+Fr2/v8JWNzZ9sseH2HIFs=;
	b=l5mZn5FcvMwk3oBtB7sEs1c1xctC6t14xNj6UcTw8AOi1TZqFrXj5NkQonG5fFJjuqGB
	 BnzDk66I6yi2rRtpmgj62zpeFLc25wFEMsbqX5FpaMK90C3+h7m3eXRqrCc/T9viLNobH
	 ye+MRKe4Rnc4SjNhhn6DfXf/2AptSx4qzadIF+CY/ZvmVF9t97nykhVO4wewIeiL2T2BH
	 6SlvRWDhAwuUvGvhRo6fI6AjYXvV5Qro5MfJqiYmth3sqd2hD4o+Bef4HCGDK6Jv/LOOW
	 djfDOWSNoGCt7R9lI+/qqOZKeTaBb950b7nkgKtETcWA3hg3HoFjbqJ0yG8WfEp2jIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yk0JdTt5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136B6606A320;
	Thu, 19 Nov 2026 03:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yk0JdTt5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0F51F000C4;
	Thu, 19 Nov 2026 03:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059893;
	bh=ya8IIo/McyHuzCrYvmt1c+Fr2/v8JWNzZ9sseH2HIFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yk0JdTt57bL9aXV9w/sygRCHksl5DDYLo/V2ov5WLbLZcS+gY1YT82F0v57HVcbf1
	 ETLB7PrUZ+srwT5vACWHWhNdKFMr348z8t6N6G++/uB3uzc9cEjmw6t3yDa2oM6c12
	 /R3VxeW/MB9bOx6MkUE+pECKeO6Dm/JsWHM3QZ+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Teigland <teigland@redhat.com>,
	Alexander Aring <aahringo@redhat.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1003/1848] dlm: fix send buffer backpressure handling
Date: Wed, 18 Nov 2026 15:50:41 +0100
Message-ID: <20261118145958.784530054@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit e234d7625598b2eaded84fa99f53c8062650828f ]

lowcomms.c tests and clears SOCKWQ_ASYNC_NOSPACE in con->sock->flags,
but this bit has not been stored there for ten years.

Commit 9cd3e072b0be ("net: rename SOCK_ASYNC_NOSPACE and
SOCK_ASYNC_WAITDATA") mechanically renamed the two dlm users, then
commit ceb5d58b2170 ("net: fix sock_wake_async() rcu protection") moved
the bit from socket->flags to the RCU protected socket_wq->flags, where
it is reachable only through sk_set_bit() and sk_clear_bit(), and is
only maintained for sockets having SOCK_FASYNC set.  dlm uses kernel
sockets, which never have SOCK_FASYNC set, and never sets the bit
itself, so the test in send_to_sock() has been false ever since.

The consequence is that when sock_sendmsg() returns -EAGAIN because the
socket send buffer is full, dlm no longer sets CF_APP_LIMITED, does not
increment sk_write_pending, and does not return DLM_IO_END to wait for
lowcomms_write_space().  It returns DLM_IO_RESCHED instead, and
process_send_sockets() immediately requeues the send work.  A connection
to a peer that is slow to drain thus keeps cycling through
sock_sendmsg() and -EAGAIN, burning CPU, instead of sleeping until TCP
reports that space is available again.

Test SOCK_NOSPACE instead.  This is the bit that lives in socket->flags,
that TCP sets whenever sendmsg() returns -EAGAIN for lack of send buffer
space (tcp_sendmsg_locked() and sk_stream_wait_memory()), and that
lowcomms_write_space() already clears.  This restores the semantics dlm
had before the bit moved.

Also remove the clear_bit() of SOCKWQ_ASYNC_NOSPACE from
lowcomms_write_space(), for the same reason.

SCTP connections are deliberately left as they are.  SCTP does not set
SOCK_NOSPACE, and it never calls sk->sk_write_space(): sctp_wfree() ends
up in sctp_wake_up_waiters(), which calls sctp_write_space() directly.
lowcomms_write_space() is thus never invoked for an SCTP connection, and
the test added here stays false, so send_to_sock() keeps returning
DLM_IO_RESCHED as it does today.  This is the only safe behavior, as
returning DLM_IO_END would wait for a callback that never comes.

Fixes: ceb5d58b2170 ("net: fix sock_wake_async() rcu protection")
Cc: stable@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20260929071743.23624-2-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: adapted the flag check to the existing kernel_sendpage() loop while retaining its -EAGAIN guard ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 68b765369c928..f3311621b67f7 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -421,10 +421,8 @@ static void lowcomms_write_space(struct sock *sk)
 
 	clear_bit(SOCK_NOSPACE, &con->sock->flags);
 
-	if (test_and_clear_bit(CF_APP_LIMITED, &con->flags)) {
+	if (test_and_clear_bit(CF_APP_LIMITED, &con->flags))
 		con->sock->sk->sk_write_pending--;
-		clear_bit(SOCKWQ_ASYNC_NOSPACE, &con->sock->flags);
-	}
 
 	queue_work(send_workqueue, &con->swork);
 out:
@@ -1435,7 +1433,7 @@ static void send_to_sock(struct connection *con)
 					      msg_flags);
 			if (ret == -EAGAIN || ret == 0) {
 				if (ret == -EAGAIN &&
-				    test_bit(SOCKWQ_ASYNC_NOSPACE, &con->sock->flags) &&
+				    test_bit(SOCK_NOSPACE, &con->sock->flags) &&
 				    !test_and_set_bit(CF_APP_LIMITED, &con->flags)) {
 					/* Notify TCP that we're limited by the
 					 * application window size.
-- 
2.53.0



