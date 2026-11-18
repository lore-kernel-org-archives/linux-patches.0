Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054225;
	b=KsMaHB0QLxeF9kKbnsSZJdVLUXJ77n8tlZ7uajt+XZ9wNnKTaplOFRe02OxR3wehk/tc
	 bBKxGkF6XsL31kTNf2XkjtSXCfQE6uCmBn43WdosGFe4FsiZ0n9WwFhXQbcxuQkGu9R2e
	 viZ7nBZLwXayaYNyjOMOAocDWfyR9DkcTj9B1N6nKUVvXRq8zKlKOJeNEcdiG5mnlIAdu
	 DTivE3XGVBCJH7DAgxMzKJ+nxe9rcEXRgkiu0g2BQEUbCa2zo69VHDfKl8G9pIkKSTnEW
	 ERgPlMTAtqclbum9eW+6oBuvnxfm23V1qkniNEnY2iqiS1aiqDDsbT4+zxO8AlBfbkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eUjLIYrnn57u28W2LHjczAF9CssgKJMI8NtqTe5yu3w=;
	b=KgrUhkdFtNXg13OIsKJGauIV/R5iY0Ia+rs8TE95o7fal/TenxXROkycUoA2AnCuz308
	 TT33LokZJ+KDLavWtoIEp0PehAW+Ip3cRhDCvo5HGNUWCIIZ0fjJRn08aiaLBfNLNeR2u
	 s9YMn394AMvHBQkG4yktiheL408Kuhq1sdn9QrfyAJKiCuz4a5PX/gRDypjp/3eefLWVh
	 U4ij75Gn5FpJRSrhMcfcP9/abBzt6L+EO56Ry5A2xLwp3IelhoQqAQFmxzwhnsBI5UnhB
	 oHZnFWqtG7o/NHz9nF9mboq2Mi+QxsnlPiG/bk+dknrJeJeiWR99/Era5jWbYZD5Nrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2GiSJQh1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B39606A325;
	Thu, 19 Nov 2026 02:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2GiSJQh1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461881F000C4;
	Thu, 19 Nov 2026 02:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054224;
	bh=eUjLIYrnn57u28W2LHjczAF9CssgKJMI8NtqTe5yu3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2GiSJQh1fjiZ7SQfm79O2tuGjVDCF3AwHQw7dAc1a2U6b7Qrekfap3OdOyIi9A/Qc
	 YMTPAS/bH8Dma1LzYs6Cv6TZ0jfnMzkBIrQe3xWCWZqemwsMYXm62cYoDmlPkn0IeC
	 i+IDul0Q/BFiPQwPCBoUFUEvDnx2TSi+AzdMcHco=
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
Subject: [PATCH 5.15 1197/2214] dlm: fix send buffer backpressure handling
Date: Wed, 18 Nov 2026 15:47:53 +0100
Message-ID: <20261118150059.767425964@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
[ sashal: adjusted context around the existing ret == -EAGAIN guard in send_to_sock() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 5b53425554077..80aae70431fea 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -518,10 +518,8 @@ static void lowcomms_write_space(struct sock *sk)
 
 	clear_bit(SOCK_NOSPACE, &con->sock->flags);
 
-	if (test_and_clear_bit(CF_APP_LIMITED, &con->flags)) {
+	if (test_and_clear_bit(CF_APP_LIMITED, &con->flags))
 		con->sock->sk->sk_write_pending--;
-		clear_bit(SOCKWQ_ASYNC_NOSPACE, &con->sock->flags);
-	}
 
 	queue_work(send_workqueue, &con->swork);
 out:
@@ -1417,7 +1415,7 @@ static void send_to_sock(struct connection *con)
 				      msg_flags);
 		if (ret == -EAGAIN || ret == 0) {
 			if (ret == -EAGAIN &&
-			    test_bit(SOCKWQ_ASYNC_NOSPACE, &con->sock->flags) &&
+			    test_bit(SOCK_NOSPACE, &con->sock->flags) &&
 			    !test_and_set_bit(CF_APP_LIMITED, &con->flags)) {
 				/* Notify TCP that we're limited by the
 				 * application window size.
-- 
2.53.0



