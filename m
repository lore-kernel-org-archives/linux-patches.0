Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B9864AB3;
	Tue, 23 Jan 2024 01:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975049; cv=none; b=H2P0MXyVzloTTAIOfXr8GVnYO9C6BaW9s7vELQVUWNJeMsnI7O+9GFfGCKTu57CPLfZZ8nMGlYKTHjZjwzLQMqsTj1l46yUKtqRtElrQL6uHpLk8arlpyVFMjODICTdjQC6VLrnQn+b8te7b2DU/s8qmny6yErKXcxTugA30SN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975049; c=relaxed/simple;
	bh=eqpFdUvn4p2IzkXJ8MPBt9ubVMwpAQ3Fsygaugz75jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GczgsTbJ8VDiSJzuHat26onPi0t4QuvLLPqsaw82L25j6T7hmmz3qu4Umr8c7Y90Qaje/yvUO1YI7OkZzQ2Hxs/BNljS93beDbPdxbGRCx/AxHHSI7zD8I7u4K7YCyn2Si8iZjH6iELyEqWR4hdnQ6zYX5npQn2BRZMtrpLTYhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOkbVK28; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOkbVK28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E03FC433C7;
	Tue, 23 Jan 2024 01:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975049;
	bh=eqpFdUvn4p2IzkXJ8MPBt9ubVMwpAQ3Fsygaugz75jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOkbVK28N8Y8JG81y/EqiYPRPanwMF4Z0A4eXOsxySaDDiG6h3UTnWLTzAHZutvza
	 e5nY3/n2BNp97tYrHGSNruXDB6hutNXq3+G1xcIBErVAX4ZlcCVqkwDzOKF1ghq0zM
	 gekv2207jeUzzPvws6NDc3dJtti71rmYv9trRYNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 213/583] sctp: support MSG_ERRQUEUE flag in recvmsg()
Date: Mon, 22 Jan 2024 15:54:24 -0800
Message-ID: <20240122235818.530586721@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4746b36b1abe11ca32987b2d21e1e770deab17cc ]

For some reason sctp_poll() generates EPOLLERR if sk->sk_error_queue
is not empty but recvmsg() can not drain the error queue yet.

This is needed to better support timestamping.

I had to export inet_recv_error(), since sctp
can be compiled as a module.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Willem de Bruijn <willemb@google.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/20231212145550.3872051-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a562c0a2d651 ("sctp: fix busy polling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/af_inet.c | 1 +
 net/sctp/socket.c  | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 2713c9b06c4c..b0a5de1303b5 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1632,6 +1632,7 @@ int inet_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
 #endif
 	return -EINVAL;
 }
+EXPORT_SYMBOL(inet_recv_error);
 
 int inet_gro_complete(struct sk_buff *skb, int nhoff)
 {
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 7f89e43154c0..5fb02bbb4b34 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2099,6 +2099,9 @@ static int sctp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	pr_debug("%s: sk:%p, msghdr:%p, len:%zd, flags:0x%x, addr_len:%p)\n",
 		 __func__, sk, msg, len, flags, addr_len);
 
+	if (unlikely(flags & MSG_ERRQUEUE))
+		return inet_recv_error(sk, msg, len, addr_len);
+
 	lock_sock(sk);
 
 	if (sctp_style(sk, TCP) && !sctp_sstate(sk, ESTABLISHED) &&
-- 
2.43.0



