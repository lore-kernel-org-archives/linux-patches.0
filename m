Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042748;
	b=STDMcA7/Rg/8PD66qkpG1m4AcaiyNnp3qTCxeHy6Dx/wFH5IsqTOvgeBNkMNnC8OElit
	 qqdPWTqx2QxU4jVq91G5Ym+3En3hCxxzRNALXr4kOeDcSBWQLp0bB/jBanCO1djZBFaGx
	 XRp/J4mSB6sw78R3LLy84t24pB6j0SUpNEiQGwVh+TRSxkaXyxLDw4iGMKnrt6EbIvhi+
	 2yBDP1hdw+QW2Raaa7XbhxhqiCT6ofou+7HSwbM9DMekhHavSJ6keaf4EU6lXadF0FAg4
	 EL9ad9f13RJ8gMILPNNCM4dDP+AlAC9R8JQSS9mM036AbeBBq1dxAB5B7ew+0MIB60w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n16tlRV9i3kcR95h/3Vvl3LfOYRQZeK47dCeqfcSyls=;
	b=tk+uu+AZ0Kqb/gqirbLC3HCvsgVglXFtSQye91OtKlVtlgUSbiJhYH1HaFPUpAHoAsRy
	 L4Ti3dLeoasChQ0QaEKANhwt/HZld1VA6lc2wh/moh6EkFNZ+lOsUTqZ/GoNY81iggLWp
	 iTMTFmXKBXEX0cPNHhxR7ZM7wiixfc+wO/zoVh2zjJ9h+Lr9afWpcu+UDO2NI6Ipcvqpu
	 TDTe+CCk5osDNvXk/GIt0hLzMg2JTCtnqflZLInALS/m63NCHizw7+20BugeOPQqAgjGn
	 Pq5M4FNJa7xLqe9TXSeT2aWk7+isZKb/Fp/rJT8s1jJpT8k1guv+LOLLl4lKAhPHZvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1u2aWKGx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD342606A320;
	Wed, 18 Nov 2026 22:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1u2aWKGx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD371F000C4;
	Wed, 18 Nov 2026 22:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042748;
	bh=n16tlRV9i3kcR95h/3Vvl3LfOYRQZeK47dCeqfcSyls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1u2aWKGx1j4ydbn07MnHgHeFpvhQmLVl2tylEA+wM8nWPQeH6oif9QWUi4MleBeH6
	 qcegqa3mG3NYDWd2APUowIm1k4MlfeoSX4RNkTPi00kKjAr0dJuSVGb51zOPT4Uoni
	 axoU2TEEEMqNs3eLyMwd8qiqKOLEWJ1T35VaSimM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3280/3318] tcp: avoid double destroy in tcp_abort() of an unaccepted child
Date: Wed, 18 Nov 2026 16:05:02 +0100
Message-ID: <20261118150458.012674779@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a5dbbc65a61ca..a427a6ceec136 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4532,6 +4532,8 @@ EXPORT_SYMBOL_GPL(tcp_done);
 int tcp_abort(struct sock *sk, int err)
 {
 	int state = inet_sk_state_load(sk);
+	bool listener = false;
+	int ret = 0;
 
 	if (state == TCP_NEW_SYN_RECV) {
 		struct request_sock *req = inet_reqsk(sk);
@@ -4566,21 +4568,31 @@ int tcp_abort(struct sock *sk, int err)
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
 		tcp_send_active_reset(sk, GFP_ATOMIC);
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



