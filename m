Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43F61E87B;
	Sun,  1 Sep 2024 16:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208526; cv=none; b=eNKK+Ym+g0LSwVgUbgczOjJ7PC51JSqew3NYNfGC424tXzYY+2kpz65cBbWPic9XXCk+7ei2uniN8GHpLkcj67RfzZrpDN4UkAVcoVZG1xqQokHSZ46f7ssKwfOkn0AGofRzVxOajvgUwOWYA8OY8HaE6EhDCdhfEi+vZhnVBX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208526; c=relaxed/simple;
	bh=H2LLt5cJeU7C9kKilCaBx+Vr9KorCpQRTqKP1wt05vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIfd8f7G+TEKuJDGTj/g2LKl7Uet3zZpSFSf3U4kFswyu6ACcDFnl/I4xL38V1OB0a9fUPaKdaJSi7rRjCFJBeI/lApEubXz9tq2ZM52IaCts88aIZJkIK8IxkJmLXCec5GvuB/TmY7rjMuFenGOp5TvHxKr2MYem5nSiCGzYu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIa+hEa5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIa+hEa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FC7C4CEC3;
	Sun,  1 Sep 2024 16:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208525;
	bh=H2LLt5cJeU7C9kKilCaBx+Vr9KorCpQRTqKP1wt05vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIa+hEa5xkxrpZrZ3hDL2TdqfnQfncvnt5HMJ36HDKpLIYYxRqDKTj8dPA+OaWN3K
	 UbRLUNc8/DjhKrrOsZVqpAzo4dAQFOdZ8j6bdkI7w4jPDSKa5mvUzKMT5JjUtxqvG2
	 S8OpPbNaVQg5reSxyzb8FJreshh8vApSjJpf86UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueming Feng <kuro@kuroa.me>,
	Lorenzo Colitti <lorenzo@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 108/149] tcp: fix forever orphan socket caused by tcp_abort
Date: Sun,  1 Sep 2024 18:16:59 +0200
Message-ID: <20240901160821.516860198@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xueming Feng <kuro@kuroa.me>

[ Upstream commit bac76cf89816bff06c4ec2f3df97dc34e150a1c4 ]

We have some problem closing zero-window fin-wait-1 tcp sockets in our
environment. This patch come from the investigation.

Previously tcp_abort only sends out reset and calls tcp_done when the
socket is not SOCK_DEAD, aka orphan. For orphan socket, it will only
purging the write queue, but not close the socket and left it to the
timer.

While purging the write queue, tp->packets_out and sk->sk_write_queue
is cleared along the way. However tcp_retransmit_timer have early
return based on !tp->packets_out and tcp_probe_timer have early
return based on !sk->sk_write_queue.

This caused ICSK_TIME_RETRANS and ICSK_TIME_PROBE0 not being resched
and socket not being killed by the timers, converting a zero-windowed
orphan into a forever orphan.

This patch removes the SOCK_DEAD check in tcp_abort, making it send
reset to peer and close the socket accordingly. Preventing the
timer-less orphan from happening.

According to Lorenzo's email in the v1 thread, the check was there to
prevent force-closing the same socket twice. That situation is handled
by testing for TCP_CLOSE inside lock, and returning -ENOENT if it is
already closed.

The -ENOENT code comes from the associate patch Lorenzo made for
iproute2-ss; link attached below, which also conform to RFC 9293.

At the end of the patch, tcp_write_queue_purge(sk) is removed because it
was already called in tcp_done_with_error().

p.s. This is the same patch with v2. Resent due to mis-labeled "changes
requested" on patchwork.kernel.org.

Link: https://patchwork.ozlabs.org/project/netdev/patch/1450773094-7978-3-git-send-email-lorenzo@google.com/
Fixes: c1e64e298b8c ("net: diag: Support destroying TCP sockets.")
Signed-off-by: Xueming Feng <kuro@kuroa.me>
Tested-by: Lorenzo Colitti <lorenzo@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240826102327.1461482-1-kuro@kuroa.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ec6911034138f..2edbd5b181e29 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4573,6 +4573,13 @@ int tcp_abort(struct sock *sk, int err)
 		/* Don't race with userspace socket closes such as tcp_close. */
 		lock_sock(sk);
 
+	/* Avoid closing the same socket twice. */
+	if (sk->sk_state == TCP_CLOSE) {
+		if (!has_current_bpf_ctx())
+			release_sock(sk);
+		return -ENOENT;
+	}
+
 	if (sk->sk_state == TCP_LISTEN) {
 		tcp_set_state(sk, TCP_CLOSE);
 		inet_csk_listen_stop(sk);
@@ -4582,16 +4589,13 @@ int tcp_abort(struct sock *sk, int err)
 	local_bh_disable();
 	bh_lock_sock(sk);
 
-	if (!sock_flag(sk, SOCK_DEAD)) {
-		if (tcp_need_reset(sk->sk_state))
-			tcp_send_active_reset(sk, GFP_ATOMIC,
-					      SK_RST_REASON_NOT_SPECIFIED);
-		tcp_done_with_error(sk, err);
-	}
+	if (tcp_need_reset(sk->sk_state))
+		tcp_send_active_reset(sk, GFP_ATOMIC,
+				      SK_RST_REASON_NOT_SPECIFIED);
+	tcp_done_with_error(sk, err);
 
 	bh_unlock_sock(sk);
 	local_bh_enable();
-	tcp_write_queue_purge(sk);
 	if (!has_current_bpf_ctx())
 		release_sock(sk);
 	return 0;
-- 
2.43.0



