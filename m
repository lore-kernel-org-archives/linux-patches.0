Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0207913B2B8;
	Tue, 27 Feb 2024 14:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043783; cv=none; b=siqFIHmzeAjpC6l7LS5tm4BcTLW49qW6yNjxnZ3Sy56lKEU4PmZgGLCh+9FgwSzuwFUeOu7ukbDRj+fM7WZRqSadm82oSUDh5zTRhTYjFB1kh1ID7yUrtu+yt3OhWUbGKsbhkHLBgM18rR5xFG2NXBZOpCHsENh2cX59A7f98uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043783; c=relaxed/simple;
	bh=5YHpTaYCL6TVN92Rwu+FFIdPPDzrVMXKBZtIWACKoYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjMycZ5suvC8a4v6Hd2x3kmMTFyrjJJz/fHsKzD6dT+W5xJyu4bqi7wXjcZljGwokUVnUyu5ultk5A0Kxv7tZSzvDkIIF7Hf+gWdHZIL18mIjxPNvwje34uKA4zjBq+0j0dcfgFwuf/+iSixJ99AnROswftYf1wscx5Qb4RE/OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kn0XcPzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kn0XcPzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285F8C433C7;
	Tue, 27 Feb 2024 14:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043782;
	bh=5YHpTaYCL6TVN92Rwu+FFIdPPDzrVMXKBZtIWACKoYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kn0XcPzJ8T+sEo/bYGLoV0+UVQ6nH+uAz6l9B4yCuqPU1q6fdkkQDejlFDmwylTD9
	 ULgRBHSgCte6J72asMSPo1K2RxzjByohgxw9MBtQXTed7P8jZlnR8sxXf1ud3FAgZ3
	 YYSwC5e8wMchRUtSr9eq0obLWdXbZ+3LdcrGhijQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/84] tcp: factor out __tcp_close() helper
Date: Tue, 27 Feb 2024 14:27:01 +0100
Message-ID: <20240227131553.979688065@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 77c3c95637526f1e4330cc9a4b2065f668c2c4fe ]

unlocked version of protocol level close, will be used by
MPTCP to allow decouple orphaning and subflow level close.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h | 1 +
 net/ipv4/tcp.c    | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index af67e19eba392..164ba7b77bd9f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -391,6 +391,7 @@ void tcp_update_metrics(struct sock *sk);
 void tcp_init_metrics(struct sock *sk);
 void tcp_metrics_init(void);
 bool tcp_peer_is_proven(struct request_sock *req, struct dst_entry *dst);
+void __tcp_close(struct sock *sk, long timeout);
 void tcp_close(struct sock *sk, long timeout);
 void tcp_init_sock(struct sock *sk);
 void tcp_init_transfer(struct sock *sk, int bpf_op);
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 53a8522adf681..6a52fdcf9e4ef 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2351,13 +2351,12 @@ bool tcp_check_oom(struct sock *sk, int shift)
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
@@ -2521,6 +2520,12 @@ void tcp_close(struct sock *sk, long timeout)
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
2.43.0



