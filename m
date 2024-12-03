Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E5D1F6698;
	Tue,  3 Dec 2024 14:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237613; cv=none; b=VkJXlL4RDZIQxQSy7gWG2FKjTMuLHaiOo2jC4FREthSPJM2mE2TPD68LPujjSae4p4Q0GX4JPXZt8RWnH/CtU5vWgO0HONE0nl5Uu/iwmAe7ZsJzqDETBG7m2U+yhP2rb1oY3cnq0qoSzg6Cjqduum63GBGK3qs5gaVDDWoxZ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237613; c=relaxed/simple;
	bh=xSQbIVznNyfftIoXyPaSstSoXA65Jpmag9cUe/0S2ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVJFJbbT2Z1JOrDu7W2dDvMU6PGfRBlJ3CxVNCC/bFbNx1V4WHxvHwrg6MYlxTjmSHpxqZ7MmRDkstPScPif0wPqtVNm/hrtPqDD9jOWIsVPF0W/WTss+ef6/XR87jkuC1cKnI/4sFkkHYO9eGX55BBO4fZh+JtmK/FEa7tcv+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ljtkzczu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ljtkzczu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE2BC4CECF;
	Tue,  3 Dec 2024 14:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237613;
	bh=xSQbIVznNyfftIoXyPaSstSoXA65Jpmag9cUe/0S2ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjtkzczuwV5b+tAkDj5oRshe4S+X6KY3t2hz5j9f+uCofXRa9JGO4W53IUlWTsKZ7
	 hDjJhW/pyKwtT/QnCZGZF/wRv5LC4fsmBzIQRZ6mKDC8xGqxgn35nKH9LsgTkmMgS0
	 0kDzknMN4IXieAi9+uvLKtMJtTCdXLajwW2x0+Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <mrpre@163.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 020/817] bpf: fix filed access without lock
Date: Tue,  3 Dec 2024 15:33:12 +0100
Message-ID: <20241203143956.430935977@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index fe6178715ba05..915286c3615a2 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -221,11 +221,11 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
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
@@ -238,7 +238,8 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
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



