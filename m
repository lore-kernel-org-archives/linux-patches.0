Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047439;
	b=e2Z45DDmvqs11aY6/60sJVcD/PhSiOnPdL2Z/X3UdrHUF9BkCBycI4yiBuMePHqJiNkD
	 RO96fWiJocPDcrUU+/EgPHc+YLZlqQAcT7yVfLps3OOumnNoIpQVdkDkUpCrtauCrmGWO
	 WCDogK6eHTc+uIyQEMNB9n4Dol6oZeJyE2m2Bk09Ckg2brRsrwbJEcxOafCAV6UvaLUp8
	 9PmCF07jKub+7QhLDvI/9ZJIVWIyylJs1/iuayw8Fo+tj6iyOKjX7edwkgGjpPPE6KK3U
	 Z73ACA16c7gkJHTdTWFQK9DJwqgrJtbStrktIywK3OVdOKZah2r+Gc4OYehnYKrs6YA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9mKd6Y7yppHZvBUcvTepQjUf6lZAez4cZdfjxejjJHA=;
	b=UA7qvxsZCJ4cCpKliqRN4w5ACRenuk7dOHhqnuTgDNDakX6GHlqJyf+/9qkehoNXgjVJ
	 DwvtuuhqZ+q4QRjUglDK1g/qSAk5kiYb+YXgK1SRANnd/QbA7N5AXqrl7LdsJ3rZX5h8i
	 q/Jj7o+MK0j727lQvs1DMgjPnuWUEdQJVKGEHMNbokJrHRZnLramCf4iUiBbTkPvJGtaf
	 QFyt2vKBtvUgSgt8qu2akA0jypQ2nLH/LQBzXWaZQozkkWDvPnsmlzqjzlcJBOd4Q0Diu
	 O0OTvOcSH/ZfB9b6yIAocF+x9M4h2x6sC1wy0Bm2vrhgTGIDYaFlZpAaIBN+3JVvW9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ho+8BngR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CCC606A332;
	Thu, 19 Nov 2026 00:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ho+8BngR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B421F000C7;
	Thu, 19 Nov 2026 00:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047439;
	bh=9mKd6Y7yppHZvBUcvTepQjUf6lZAez4cZdfjxejjJHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ho+8BngRxmUaKb2sNUUQzGqe0YkNMm2kdhr5irMbcQTBN/nSL4V8JFA9srqWHigob
	 NtNESOafMeU+Pf2O2rSvY9DAhqp8oRRqlPAbhUY7p2v9LOIf9qb+/snH3NlpCT+1ZF
	 lrFuI1KuBqzCQ1DSToiu1HlOYCZxsaU9oGuF8iws=
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
Subject: [PATCH 6.1 1598/2857] dlm: fix send buffer backpressure handling
Date: Wed, 18 Nov 2026 15:43:52 +0100
Message-ID: <20261118150258.912680932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted context to the older kernel_sendpage() loop with its existing ret == -EAGAIN guard ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 4ad492d035dd1..6260c8ed179fd 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -521,10 +521,8 @@ static void lowcomms_write_space(struct sock *sk)
 
 	clear_bit(SOCK_NOSPACE, &con->sock->flags);
 
-	if (test_and_clear_bit(CF_APP_LIMITED, &con->flags)) {
+	if (test_and_clear_bit(CF_APP_LIMITED, &con->flags))
 		con->sock->sk->sk_write_pending--;
-		clear_bit(SOCKWQ_ASYNC_NOSPACE, &con->sock->flags);
-	}
 
 	queue_work(send_workqueue, &con->swork);
 }
@@ -1330,7 +1328,7 @@ static void send_to_sock(struct connection *con)
 		trace_dlm_send(con->nodeid, ret);
 		if (ret == -EAGAIN || ret == 0) {
 			if (ret == -EAGAIN &&
-			    test_bit(SOCKWQ_ASYNC_NOSPACE, &con->sock->flags) &&
+			    test_bit(SOCK_NOSPACE, &con->sock->flags) &&
 			    !test_and_set_bit(CF_APP_LIMITED, &con->flags)) {
 				/* Notify TCP that we're limited by the
 				 * application window size.
-- 
2.53.0



