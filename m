Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACE8611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45302C433EF;
	Sun, 28 May 2023 19:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302755;
	bh=2jHSGTNis6eoirjI6LmQoch4FleTBskUs1PCt+f+Wcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h93x2mSgYxJn2oMDMVOaE5R5zACe1POeLLb9pOSz71ST6T2quQPTvS013a3V93quR
	 t5j6gembsaMC9TwJ4RWI6puekbewnGo8Qjo6HXrXtKmlcer/OyA3UZFhqoagACqdaL
	 7S1fnYwDMUDHDizRs0alCo6tmv33A9KBEA1lwjGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/211] tcp: factor out __tcp_close() helper
Date: Sun, 28 May 2023 20:08:54 +0100
Message-Id: <20230528190843.853097084@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 77c3c95637526f1e4330cc9a4b2065f668c2c4fe ]

unlocked version of protocol level close, will be used by
MPTCP to allow decouple orphaning and subflow level close.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e14cadfd80d7 ("tcp: add annotations around sk->sk_shutdown accesses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h | 1 +
 net/ipv4/tcp.c    | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9a8d98639b20f..d213b86a48227 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -381,6 +381,7 @@ void tcp_update_metrics(struct sock *sk);
 void tcp_init_metrics(struct sock *sk);
 void tcp_metrics_init(void);
 bool tcp_peer_is_proven(struct request_sock *req, struct dst_entry *dst);
+void __tcp_close(struct sock *sk, long timeout);
 void tcp_close(struct sock *sk, long timeout);
 void tcp_init_sock(struct sock *sk);
 void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6a0560a735ce4..3666fa307d0f0 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2510,13 +2510,12 @@ bool tcp_check_oom(struct sock *sk, int shift)
 	return too_many_orphans || out_of_socket_memory;
 }
 
-void tcp_close(struct sock *sk, long timeout)
+void __tcp_close(struct sock *sk, long timeout)
 {
 	struct sk_buff *skb;
 	int data_was_unread = 0;
 	int state;
 
-	lock_sock(sk);
 	sk->sk_shutdown = SHUTDOWN_MASK;
 
 	if (sk->sk_state == TCP_LISTEN) {
@@ -2680,6 +2679,12 @@ void tcp_close(struct sock *sk, long timeout)
 out:
 	bh_unlock_sock(sk);
 	local_bh_enable();
+}
+
+void tcp_close(struct sock *sk, long timeout)
+{
+	lock_sock(sk);
+	__tcp_close(sk, timeout);
 	release_sock(sk);
 	sock_put(sk);
 }
-- 
2.39.2



