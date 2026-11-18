Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033244;
	b=ingo/KRshvKwHdEMIRewBqJSs16bbrV+BuSgpgqnV6UDlFfSPIDdqdXwoN6o56inTH5h
	 pQBWzjkuMIsq1kcQX5jsd3UXfLRQkiv1I/jVkJZOKfvRzMq9/iEZzhVR5CV7G8Kgw0YCN
	 saQfAWaWxAO5xqcDrpqSO6dhuRb97+bPefJS4vB42BMgaBNRQ9x715ZN837vkM0JWmKd1
	 VYOvmBEn1Pt5i1BHwbUy/1EF8SQhF30vV7wTcjxSUEc/K77zesMxBtAUw3nRcK3Qbx1KT
	 k93POTURwJ5T7RDqtEOq8GPuNKoRY8e6ZbgHkGOgtwWoyqCt6RBHkIqedVbkTkat9xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tB5ToaioYSiE6c8QkzasaIS42bgNeAdv7FZ4VeTLwL0=;
	b=KNU7xtSFf1Iau/fplUtOG4pEyRGg8dfYHHlIHPYq3PSz5ljZYunKyOdOlm9UpyXnnxas
	 RHI5Ve+sr1qUX4jK6tPN5uYEvQMaUN27IF0NrylguxPwAIypLO5qvx3v7lV0TgUn9kKQm
	 rVydAFOaRYNfxI/FnRBvXC3Wauk3tI5wMJ/KgPkRbWbp1pqhsNkCrtUXn6D+BlylxzoW8
	 FRvaEhmtU35VIypkAxXIom3tNZCrpJxWeuP48VvMoJhLiIyRUq6petn2eJFLPlXZRVpen
	 s4+7sRPPxSpSWcJwVwKjzVEt0Hkr4diQElNjT1xpAIatc+h9ndexVSa7JmaliNSug7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wApLevQx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A23606A32A;
	Wed, 18 Nov 2026 20:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wApLevQx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315571F000C7;
	Wed, 18 Nov 2026 20:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033243;
	bh=tB5ToaioYSiE6c8QkzasaIS42bgNeAdv7FZ4VeTLwL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wApLevQxzaJnA5R2hRk5fasB1GXWLqhyGWCvDkRpKWSUaBVro9c+Fe4DHlqUmLP2F
	 YLlQiB3Xt2vqhjcfYwZiYmKYiILR3EHziaLNZj/FbvgMUsqvijkOfegSvsJaCNLmzp
	 uWXD6F0CaOoxXxfxR3ScCkB6bK95rMS+Kb9q6/Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1700/1756] tcp: avoid double destroy in tcp_abort() of an unaccepted child
Date: Wed, 18 Nov 2026 16:03:47 +0100
Message-ID: <20261118150117.328960087@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit dbd62ad55a4c898f5a4c9edb20c0c062afb799df ]

tcp_abort() checks for TCP_CLOSE while only owning the socket lock,
then grabs the BH lock before calling tcp_done_with_error().

For a child still sitting in a listener accept queue (which can be
reached via SOCK_DESTROY or bpf_sock_destroy()), inet_csk_listen_stop()
can run in this window: it only holds the child BH lock, and calls
inet_child_forget(), which disconnects, orphans and destroys the child.

tcp_abort() then calls tcp_done_with_error() -> tcp_done(), which sees
SOCK_DEAD and calls inet_csk_destroy_sock() a second time, leading to
a double sock_put() and a use-after-free.

Recheck TCP_CLOSE after acquiring the BH lock, unless we just closed
a listener ourselves, in which case tcp_done_with_error() must still
run to report the error.

Note that the WARN_ON(sock_owned_by_user(child)) in
inet_csk_listen_stop() can still trigger in this window.

Fixes: bac76cf89816 ("tcp: fix forever orphan socket caused by tcp_abort")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
[edumazet: recheck TCP_CLOSE under the BH lock instead of moving the test, smaller diff]
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261028160847.2170959-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5c2314e600ab0..ba4e7ffa18761 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4912,6 +4912,8 @@ EXPORT_SYMBOL_GPL(tcp_done);
 int tcp_abort(struct sock *sk, int err)
 {
 	int state = inet_sk_state_load(sk);
+	bool listener = false;
+	int ret = 0;
 
 	if (state == TCP_NEW_SYN_RECV) {
 		struct request_sock *req = inet_reqsk(sk);
@@ -4946,21 +4948,31 @@ int tcp_abort(struct sock *sk, int err)
 	if (sk->sk_state == TCP_LISTEN) {
 		tcp_set_state(sk, TCP_CLOSE);
 		inet_csk_listen_stop(sk);
+		listener = true;
 	}
 
 	/* Don't race with BH socket closes such as inet_csk_listen_stop. */
 	local_bh_disable();
 	bh_lock_sock(sk);
 
+	/* An unaccepted child might have been closed by
+	 * inet_csk_listen_stop() while we were not holding its BH lock.
+	 */
+	if (!listener && sk->sk_state == TCP_CLOSE) {
+		ret = -ENOENT;
+		goto out;
+	}
+
 	if (tcp_need_reset(sk->sk_state))
 		tcp_send_active_reset(sk, SK_RST_REASON_TCP_STATE);
 	tcp_done_with_error(sk, err);
 
+out:
 	bh_unlock_sock(sk);
 	local_bh_enable();
 	if (!has_current_bpf_ctx())
 		release_sock(sk);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(tcp_abort);
 
-- 
2.53.0



