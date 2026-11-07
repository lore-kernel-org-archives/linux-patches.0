Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062209;
	b=MF65jnWW4RTeduLeh/IUv6gq0PSuCfHG3mmfGbObXGZU96I01JvObuXQDVuyeAG7rSGa
	 pY7g6KyWPQ60o/6woWGu1krmBSVjbnuezN/jtMZ5oCeZDkoHpDfE5c8IoPSURX1wQPYO+
	 cUHozX71Hm/Z9rDG9IfAGEw/b8ENGkDXzaM+yF1zSxkZSEr0oWfVO286Aa7e8/JfZjwOm
	 iRgrMLjW15FQRf2afjlpLxmjoX0wvgIyl8wolrZhzdFmPrGCN3Vh5/GfH+mrfpst5ke1D
	 hSW74a3YKinPUD6yAIbt63FG9zsRhOVf0AncJIsPjL2mxzYmAyuQMBR36+JjKW8l2HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VMFpjmSZIkbpcAnLZhEl6sZCCSokejwJShSacVbhIeg=;
	b=2FACLcabSf0bK35v2f+VM119IlbYnFxUwp5bNhQHdEqUJJOltAY4wX+e+8fwj9C0ecfn
	 P5DQUHdN62/V8D3YMpM+4SUR8WtwB47g943jJn0UEwHxSUzU+JalczMQ3ubo5r/moregX
	 KRugMopI1Ppkr6zpYUf3R9rkKr/izeR4hle9qAryocljeVGZxNZEHT0ajQmGXfXiR+W9d
	 Uoy91hyJqG2Rhss/PNpCqNzBz2v0Bh2PA/Hlvy/zPtGf2obWWxOsAcfTDvm9UFVNKnSxS
	 c1vHeQLntfWtNxmFxoX5Fs7NwB3GtIQdcSqaAu6rKP7WULJJutycSfATJgR/m+wK/hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mrLtKZta;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD434606A326;
	Sat,  7 Nov 2026 14:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mrLtKZta
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C771F0089F;
	Sat,  7 Nov 2026 14:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062208;
	bh=VMFpjmSZIkbpcAnLZhEl6sZCCSokejwJShSacVbhIeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mrLtKZtaVr8QNaS9tNp9V4VY0sNuZbPE+uJlIaP37207AC7zvkHV1jbrywAVSr8xQ
	 oIcWEiE2f2S4QPedSrxEwmzGTZ1T0Omt9HeTY9L2TFstsI0f+snDepacEv6UQbWORN
	 RQU2brOquWUUXS+gBMEs2K/H7tFOgZ1dPtPsgJUY=
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
Subject: [PATCH 6.12 1164/1536] dlm: fix send buffer backpressure handling
Date: Sat,  7 Nov 2026 08:53:00 -0500
Message-ID: <20261107135030.423975859@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 10461451185e8..7e2783dc5b34b 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -519,10 +519,8 @@ static void lowcomms_write_space(struct sock *sk)
 	clear_bit(SOCK_NOSPACE, &con->sock->flags);
 
 	spin_lock_bh(&con->writequeue_lock);
-	if (test_and_clear_bit(CF_APP_LIMITED, &con->flags)) {
+	if (test_and_clear_bit(CF_APP_LIMITED, &con->flags))
 		con->sock->sk->sk_write_pending--;
-		clear_bit(SOCKWQ_ASYNC_NOSPACE, &con->sock->flags);
-	}
 
 	lowcomms_queue_swork(con);
 	spin_unlock_bh(&con->writequeue_lock);
@@ -1388,7 +1386,7 @@ static int send_to_sock(struct connection *con)
 	if (ret == -EAGAIN || ret == 0) {
 		lock_sock(con->sock->sk);
 		spin_lock_bh(&con->writequeue_lock);
-		if (test_bit(SOCKWQ_ASYNC_NOSPACE, &con->sock->flags) &&
+		if (test_bit(SOCK_NOSPACE, &con->sock->flags) &&
 		    !test_and_set_bit(CF_APP_LIMITED, &con->flags)) {
 			/* Notify TCP that we're limited by the
 			 * application window size.
-- 
2.53.0



