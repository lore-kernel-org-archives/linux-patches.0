Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028336;
	b=jkjo2DCt0XCXGuLIbOV5DeweoEe3dBhPgLZGkOfxFDJ/0AEcD+DeJhlIgF1J7nwkz+i1
	 6XLxL5N322WrYdlIGwnecZLE3o2CqYYvM3B3l/iWq8pLW0iXBsHSXNKa/HgKpL40V7YdP
	 QGmQ6OuIPVmtRNkWNFhsF/XI8Uqfl9O212mAg10xq3p2t9ooa2BH6wgYPsdJJqg8foHrw
	 CoA+Z/IyuoQjH2AGXRokqzAYOnDkx5BmYdJ8hlb41bOsjwh4iJt+MzcuDcb8ZrQBQnxLD
	 p4vVCxSg+49ET2p1H+tUnQSJgeKQIbCiLi2zpA1F1yCHFgHB1PH/fqEZyHfkUBg936A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vIZJ4k4wDfjQiSYQP0DcF2cQLMJNZ9VtCQ8TLf0jXIw=;
	b=xH0Ga0FW74aUbYP9pRVn4GXHAs1UYnxvEuQMF+WXiL312zu/6ekUlw3Zl1gJ0jCML0ZA
	 r5FN8gNA9ug8LjRGfktJwpdrA4lD4jef8FcA2vAiAMy5y8XWfK1QSE8F6BV2BEY8vg2n2
	 wAd552dpuWYdDsOLr6oum690JtZo5VPMhfy6+rugLVnJKm7OScANES7G8eq4mbPM8OwmG
	 FzILmOVjSdyzM0EliJWYvrK2clrssc+egKSf/LbMCIa1Chq+vObJyvxEGa2Nbd/4iiwun
	 addQFpaHzcn2u/IZuBL9wuNdhapxTiBjew7qnO+zgPV2BGOnASNI+ZYnoZLkIwKnT4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vum7qkLT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3AB606A32C;
	Wed, 18 Nov 2026 18:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vum7qkLT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100771F000C4;
	Wed, 18 Nov 2026 18:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028336;
	bh=vIZJ4k4wDfjQiSYQP0DcF2cQLMJNZ9VtCQ8TLf0jXIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vum7qkLTCCmenD9a1C1aTX7iK4W/Gu9j/a92EeMRVEESO7NuizU6gSFYgja3jQfu6
	 VuZViOcwgLQlbJjBP0bA8bxRMU34xsQkIjk+RZt8JbLdUKPHKhuacNhYyaSN7EVEgJ
	 egt+E5ifRoPDqPUAykuWBUAdsQUMsJkstobDAC0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2109/2151] tcp: avoid double destroy in tcp_abort() of an unaccepted child
Date: Wed, 18 Nov 2026 16:04:04 +0100
Message-ID: <20261118150238.522419236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 11a78d4f9ae00..aa860cbd3a442 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -5066,6 +5066,8 @@ EXPORT_SYMBOL_GPL(tcp_done);
 int tcp_abort(struct sock *sk, int err)
 {
 	int state = inet_sk_state_load(sk);
+	bool listener = false;
+	int ret = 0;
 
 	if (state == TCP_NEW_SYN_RECV) {
 		struct request_sock *req = inet_reqsk(sk);
@@ -5100,21 +5102,31 @@ int tcp_abort(struct sock *sk, int err)
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



