Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C171A76A2;
	Tue, 30 Jul 2024 17:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359749; cv=none; b=BhU/LBMGXvhsAK0YT0Uz89NEHZowzz62FssjiJKyTsjAXUQzXmNPDR8CJaS71q8PIYr1BNtpD/d1T94QscggQLtdfGi99LrxxIavnS5x8E6uYijLeueuCu08pVpgl2sn+yuBq+h2abxRoJku40jPnG1NaLNGzo4pd/VRWr9hfbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359749; c=relaxed/simple;
	bh=ubgpjZGd6IqG6YR2ZMqDe1y3pyPFDQIyt7qCwJglV8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJLoShBVtTJxxw0rzQ5SaokTmD0dtCWuBPyu2Pmg0KfKBpV0R2BZM+aDgHAyAytE1iKAYCeKxQMv4qX2ReCjxYr81hRf/OSlAwU+CeLzRSk5kH4gjLBE7R4UGwjjfhjCCt3+lM5MgtXq61klCJNiU3gXScEAQTg+fYawbre6Xm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N38a3GL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N38a3GL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2072CC32782;
	Tue, 30 Jul 2024 17:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359749;
	bh=ubgpjZGd6IqG6YR2ZMqDe1y3pyPFDQIyt7qCwJglV8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N38a3GL1TFiXsFnTnq2K6IDeWHGvzqrk9MgbjCoKA/7YDCZT7gzymYkQ4vfpWfoyx
	 WprTbtxyexfCn71ywj8Er5HuaZF+dIqJgBWWX0tUaI2CJVssFK9eSbhmWfEHqjkuZm
	 fisNaC93mYQeDUtIVbYVy3C6uAJMYShhF+rf32YU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Michal Luczaj <mhal@rbox.co>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 531/568] af_unix: Disable MSG_OOB handling for sockets in sockmap/sockhash
Date: Tue, 30 Jul 2024 17:50:38 +0200
Message-ID: <20240730151700.910318052@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 638f32604385fd23059985da8de918e9c18f0b98 ]

AF_UNIX socket tracks the most recent OOB packet (in its receive queue)
with an `oob_skb` pointer. BPF redirecting does not account for that: when
an OOB packet is moved between sockets, `oob_skb` is left outdated. This
results in a single skb that may be accessed from two different sockets.

Take the easy way out: silently drop MSG_OOB data targeting any socket that
is in a sockmap or a sockhash. Note that such silent drop is akin to the
fate of redirected skb's scm_fp_list (SCM_RIGHTS, SCM_CREDENTIALS).

For symmetry, forbid MSG_OOB in unix_bpf_recvmsg().

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Suggested-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20240713200218.2140950-2-mhal@rbox.co
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c  | 41 ++++++++++++++++++++++++++++++++++++++++-
 net/unix/unix_bpf.c |  3 +++
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 5a26e785ce70d..a551be47cb6c6 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2624,10 +2624,49 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 
 static int unix_stream_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
+	struct unix_sock *u = unix_sk(sk);
+	struct sk_buff *skb;
+	int err;
+
 	if (unlikely(READ_ONCE(sk->sk_state) != TCP_ESTABLISHED))
 		return -ENOTCONN;
 
-	return unix_read_skb(sk, recv_actor);
+	mutex_lock(&u->iolock);
+	skb = skb_recv_datagram(sk, MSG_DONTWAIT, &err);
+	mutex_unlock(&u->iolock);
+	if (!skb)
+		return err;
+
+#if IS_ENABLED(CONFIG_AF_UNIX_OOB)
+	if (unlikely(skb == READ_ONCE(u->oob_skb))) {
+		bool drop = false;
+
+		unix_state_lock(sk);
+
+		if (sock_flag(sk, SOCK_DEAD)) {
+			unix_state_unlock(sk);
+			kfree_skb(skb);
+			return -ECONNRESET;
+		}
+
+		spin_lock(&sk->sk_receive_queue.lock);
+		if (likely(skb == u->oob_skb)) {
+			WRITE_ONCE(u->oob_skb, NULL);
+			drop = true;
+		}
+		spin_unlock(&sk->sk_receive_queue.lock);
+
+		unix_state_unlock(sk);
+
+		if (drop) {
+			WARN_ON_ONCE(skb_unref(skb));
+			kfree_skb(skb);
+			return -EAGAIN;
+		}
+	}
+#endif
+
+	return recv_actor(sk, skb);
 }
 
 static int unix_stream_read_generic(struct unix_stream_read_state *state,
diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
index bd84785bf8d6c..bca2d86ba97d8 100644
--- a/net/unix/unix_bpf.c
+++ b/net/unix/unix_bpf.c
@@ -54,6 +54,9 @@ static int unix_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
 	struct sk_psock *psock;
 	int copied;
 
+	if (flags & MSG_OOB)
+		return -EOPNOTSUPP;
+
 	if (!len)
 		return 0;
 
-- 
2.43.0



