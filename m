Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B04154C18;
	Tue, 30 Jul 2024 17:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360628; cv=none; b=hkep7jbc/6AehaSdldkwNXig/myHAMqwG3HtvOjajuSl23qPY8pOeLWl4/9tj50KDr6PlFRInL16KVJRBYvsbve/Lq22Sy0neMcuITHsGOwobpS26vNB9SkJ5Ve/qWO4a5BTEhZ3pC7hdIg8yKyKe8XSqa5aqTZvHDzYQP2u5UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360628; c=relaxed/simple;
	bh=lb1DY+WBj3mUdpgNgMFp32wUwKvQs7awsSDwd6FS8XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EwfBL6TfgZnLkuoKgSG8mx9LewtVJB8MsLo748W6F3xZfYsAPw1eS/37kAI8Tr7Bihn9NxuT2kGd5hEiEqXqJMXXl7ua9j3fdUbwaXizzlBKN/PjX8jPTd0Cc1e/zGvUFnMuMdvtECYY+gZMYuG5eZ9f0G9/jaB/WNFWDouciDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9FnwtLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9FnwtLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD35BC32782;
	Tue, 30 Jul 2024 17:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360628;
	bh=lb1DY+WBj3mUdpgNgMFp32wUwKvQs7awsSDwd6FS8XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9FnwtLnKf2c0Iy3dV0ulD0aTJObgvtDVimlYMLVwdUg68j1CrRItnJyu7BTMlTIO
	 F1Z5tvHEXzJHMZe5tfqN2q14cd53BeXIbBlfNnnY/1+ZxIzVgl6KM3X8h6TNbK5ZnE
	 z15LeR7wkwaOKKXzQiTxxeuykF8k3XPYZCDvLv68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Michal Luczaj <mhal@rbox.co>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 756/809] af_unix: Disable MSG_OOB handling for sockets in sockmap/sockhash
Date: Tue, 30 Jul 2024 17:50:32 +0200
Message-ID: <20240730151754.819929938@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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
index 142f56770b77f..11cb5badafb6d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2667,10 +2667,49 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 
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



