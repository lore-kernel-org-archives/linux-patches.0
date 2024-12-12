Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A5C2210C2;
	Thu, 12 Dec 2024 15:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018707; cv=none; b=ICIsnHLwXO5q88E+DDgGt4ppQnYaHpDmI/eq+Vbst6z1mZO3qnLlvGbWmWU4cl2+gyBNZ3bEsEbPqb2gI7gu9rmLg5oB6S+/qrR2+fDIcDfeOYYgm5xdC5TEAdJBsqFAHudgvW8rwROCUmjhOykpkrlIQ+QLm25mOHkNwLTch+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018707; c=relaxed/simple;
	bh=OeQInyXXhRzDUPQOlDUg/lpyFcQ8eHyo1BHuVZJkBU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wf85hzEmCtT97Ryk2RWUPw5DFMFF1AKONXTwOqfSQU2LpnYV17zq26F9QiGTyeo3HeQf707dk+YK+0g4jWAXnISupd4gyz3DLunLKnZ0rPwnQiPME2HV6YEOF5Qlolw0SZ/wt5Dmwdp3c6W2QJPB/n0NIwL1aTSIUBgCFqnH4II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGWcItv7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGWcItv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25890C4CECE;
	Thu, 12 Dec 2024 15:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018707;
	bh=OeQInyXXhRzDUPQOlDUg/lpyFcQ8eHyo1BHuVZJkBU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGWcItv7SWgk19UfC06N3pzQI1LeVhpekN6hEvBlOE/XulrA7TKOy2LXMpXEQDecN
	 0TlSk+lNJiG28GxBVFFaFi/falFR3ZDzodrzsExFBR+4G/kBM0X9mL1RL448NdVqh3
	 //R0X8ZkO8zuBVScgHnk+LOQJ8a2AAW+K3w7fD+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <mrpre@163.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 010/772] bpf: fix filed access without lock
Date: Thu, 12 Dec 2024 15:49:15 +0100
Message-ID: <20241212144350.375931609@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <mrpre@163.com>

[ Upstream commit a32aee8f0d987a7cba7fcc28002553361a392048 ]

The tcp_bpf_recvmsg_parser() function, running in user context,
retrieves seq_copied from tcp_sk without holding the socket lock, and
stores it in a local variable seq. However, the softirq context can
modify tcp_sk->seq_copied concurrently, for example, n tcp_read_sock().

As a result, the seq value is stale when it is assigned back to
tcp_sk->copied_seq at the end of tcp_bpf_recvmsg_parser(), leading to
incorrect behavior.

Due to concurrency, the copied_seq field in tcp_bpf_recvmsg_parser()
might be set to an incorrect value (less than the actual copied_seq) at
the end of function: 'WRITE_ONCE(tcp->copied_seq, seq)'. This causes the
'offset' to be negative in tcp_read_sock()->tcp_recv_skb() when
processing new incoming packets (sk->copied_seq - skb->seq becomes less
than 0), and all subsequent packets will be dropped.

Signed-off-by: Jiayuan Chen <mrpre@163.com>
Link: https://lore.kernel.org/r/20241028065226.35568-1-mrpre@163.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 07a896685d0d3..f67e4c9f8d40e 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -216,11 +216,11 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 				  int flags,
 				  int *addr_len)
 {
-	struct tcp_sock *tcp = tcp_sk(sk);
 	int peek = flags & MSG_PEEK;
-	u32 seq = tcp->copied_seq;
 	struct sk_psock *psock;
+	struct tcp_sock *tcp;
 	int copied = 0;
+	u32 seq;
 
 	if (unlikely(flags & MSG_ERRQUEUE))
 		return inet_recv_error(sk, msg, len, addr_len);
@@ -233,7 +233,8 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 		return tcp_recvmsg(sk, msg, len, flags, addr_len);
 
 	lock_sock(sk);
-
+	tcp = tcp_sk(sk);
+	seq = tcp->copied_seq;
 	/* We may have received data on the sk_receive_queue pre-accept and
 	 * then we can not use read_skb in this context because we haven't
 	 * assigned a sk_socket yet so have no link to the ops. The work-around
-- 
2.43.0



