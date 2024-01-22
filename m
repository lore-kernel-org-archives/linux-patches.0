Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8254A154C05;
	Tue, 23 Jan 2024 00:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969417; cv=none; b=FE/M2A5ubCEKHSEms1GZCllaesooTsehgEC0gOtYE3HYwiU9naiTQu5vHr5kggLirlF8/20aSd/HMlloHyZSRqc7olGZYzVwPAWX1a56L2JELc+7f+gre7f1lqUcroKPiimUHUevIly0Ng2nPzAlMJYEPd8ZmzBp4LYvzEi0zb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969417; c=relaxed/simple;
	bh=arTaVRh2akEOSWSETPoL9U/cBtNAIznxrR6kZG06wYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfOGS5YQgAwrpNBopi5PqLtjbVD6NirB7h9A3sRgFdcjPL8pCwTe0dBivhKy1Tx+EhtX97H93hp8qM/qaBK/8P8vXDcoIxbsL41grP+jMtk2cRFkIf+Ya4Kzm0KrCB1rGJ6OtJFEhWq4F9jkmNMVnSGi7q1Ymn6iLB4KZc6OKTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VEUaNvl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VEUaNvl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE0CC433A6;
	Tue, 23 Jan 2024 00:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969417;
	bh=arTaVRh2akEOSWSETPoL9U/cBtNAIznxrR6kZG06wYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2VEUaNvlxRugj50DxB+09nQeOd0TE3oiYjTRjPvIAke6ZpYvD9cJxFD+LXsK6vQT7
	 GN74qaz633bNRyfbbYsLMjddDWQdGpV91YaHRhz9As8pPEreZJtbYH/N8d2VlGY5Cz
	 yJ5hW4U/+9yslpmSiCcE3XuyBuTXr9Z2f7cnf+iM=
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
Subject: [PATCH 6.7 232/641] sctp: support MSG_ERRQUEUE flag in recvmsg()
Date: Mon, 22 Jan 2024 15:52:16 -0800
Message-ID: <20240122235825.189582653@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index fb81de10d332..ea0b0334a0fb 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1633,6 +1633,7 @@ int inet_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
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



