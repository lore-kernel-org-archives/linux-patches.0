Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B561D2571DC;
	Tue, 25 Mar 2025 12:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905715; cv=none; b=NWp4/lszVNi3txUXL8J1uCWhJzZkO+lb34KqWu7WkrrNdOp+NdwyCGVUbez1YxhvN7xnYcXsJekHQpnv+9NmQrV4OPGdz9ZfWdbMxPhWyQ7t5nRPqUvmbBOXDjORUMycH8U10WurriqpW7+a235GIYcqgY14lXN/73Iwwh/qKrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905715; c=relaxed/simple;
	bh=r56EAzT3WJWBMCYXk5TdWKo8n9GXAW/C21WLrIuZJvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUvMfxjfaaqXAr4wnTztIhCi6YC1abahiPt0Ld39PilyX41IPM4Hx7/KU+6nfx9E4aE6S8K1BbOkeVRNJ4BVOyv0lmujLauRtjC6fX5VhM5ikS52gBRg6ZvLwMU4hbwDRo/JCK7SpYloq5fWzzGLAWhZm1UW4g4/t0nAC5ZkCao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HeMD6NKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HeMD6NKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63065C4CEE4;
	Tue, 25 Mar 2025 12:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905715;
	bh=r56EAzT3WJWBMCYXk5TdWKo8n9GXAW/C21WLrIuZJvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HeMD6NKRPBXzj/VVmcxqHVKB40qPFJsiutc+ENjf+W37BikVOjOWOCW8BjHrZFE/b
	 hKvyYAIKa+aJ8p2uACr2MBpLvrd8BiD71jP3Kz+bN53gq3V39FKnAYYJRYpSp8+QZq
	 i2jRd1FA+48i9nQu4yybABiCie7cIE/lA9SA4OuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueming Feng <kuro@kuroa.me>,
	Lorenzo Colitti <lorenzo@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Youngmin Nam <youngmin.nam@samsung.com>
Subject: [PATCH 6.1 124/198] tcp: fix forever orphan socket caused by tcp_abort
Date: Tue, 25 Mar 2025 08:21:26 -0400
Message-ID: <20250325122159.905577125@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xueming Feng <kuro@kuroa.me>

commit bac76cf89816bff06c4ec2f3df97dc34e150a1c4 upstream.

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
[youngmin: Resolved minor conflict in net/ipv4/tcp.c]
Signed-off-by: Youngmin Nam <youngmin.nam@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4745,6 +4745,12 @@ int tcp_abort(struct sock *sk, int err)
 	/* Don't race with userspace socket closes such as tcp_close. */
 	lock_sock(sk);
 
+	/* Avoid closing the same socket twice. */
+	if (sk->sk_state == TCP_CLOSE) {
+		release_sock(sk);
+		return -ENOENT;
+	}
+
 	if (sk->sk_state == TCP_LISTEN) {
 		tcp_set_state(sk, TCP_CLOSE);
 		inet_csk_listen_stop(sk);
@@ -4754,15 +4760,12 @@ int tcp_abort(struct sock *sk, int err)
 	local_bh_disable();
 	bh_lock_sock(sk);
 
-	if (!sock_flag(sk, SOCK_DEAD)) {
-		if (tcp_need_reset(sk->sk_state))
-			tcp_send_active_reset(sk, GFP_ATOMIC);
-		tcp_done_with_error(sk, err);
-	}
+	if (tcp_need_reset(sk->sk_state))
+		tcp_send_active_reset(sk, GFP_ATOMIC);
+	tcp_done_with_error(sk, err);
 
 	bh_unlock_sock(sk);
 	local_bh_enable();
-	tcp_write_queue_purge(sk);
 	release_sock(sk);
 	return 0;
 }


