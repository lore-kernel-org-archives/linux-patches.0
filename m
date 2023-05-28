Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6F3611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B0F9C4339B;
	Sun, 28 May 2023 19:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301422;
	bh=+tTyT/Mlo9AAwd5T2SnjJd405rXrrwuP/DzYdXzbAdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOvQ2petuqYhtgswX9JtulY6FWhNd7POHwwzcH0c0IWXkhiu74MNqvJHSTREeuf4F
	 u6DS2aysUuYpG6dmbOiayIHtGgdRrRP+M9EBbbW3ENJSrZN+XGdj2FNnuHfLPkYz/g
	 tAgDIO0KIw0m+VUMu6+hZjw7G8HWxevYpQ+XP9RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 006/132] tcp: factor out __tcp_close() helper
Date: Sun, 28 May 2023 20:09:05 +0100
Message-Id: <20230528190833.760953134@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
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
index 9e37f3912ff19..81300a04b5808 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -389,6 +389,7 @@ void tcp_update_metrics(struct sock *sk);
 void tcp_init_metrics(struct sock *sk);
 void tcp_metrics_init(void);
 bool tcp_peer_is_proven(struct request_sock *req, struct dst_entry *dst);
+void __tcp_close(struct sock *sk, long timeout);
 void tcp_close(struct sock *sk, long timeout);
 void tcp_init_sock(struct sock *sk);
 void tcp_init_transfer(struct sock *sk, int bpf_op);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 2fcf6e5a371dd..9200e7330b7d6 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2338,13 +2338,12 @@ bool tcp_check_oom(struct sock *sk, int shift)
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
@@ -2505,6 +2504,12 @@ void tcp_close(struct sock *sk, long timeout)
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



