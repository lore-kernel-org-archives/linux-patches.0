Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F4315575F;
	Fri,  6 Dec 2024 14:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496574; cv=none; b=DoyNMaGulcchFEZ5X2qSEG7wfGTNSZC5IiPBY4f8FWOai3SYsjv1oK2y3HUjuow7C9sWnTis6uLnXACIWfYhll8vzWV1FvVaFkHhJ0r5nIHHKeyVO674vk5zax1BatYfKxaO7eQaWYn3agU+/ubciKTWIopbdu0TDjEi6M22BLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496574; c=relaxed/simple;
	bh=XEXw/KEtHuMxz9HhaLK9DDb+s2M11npcvYEqB8X8Y8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYrx2nl7EU2NmU2luyl+ddsEFbOXVdJmPYj+CpQKO99HJ1t65NEAsfxrlrLFNzLrpZZAsBdMIPbnaIBxvUmEk0034i6t8dPb2n4rTXzaajPgp2Nwi18i2dJEq/82j1tQXoV0c3hojWBTB9TNgiPWQYLKfSh/o9NMsa0L9lO5Nrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPTFZGa8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPTFZGa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB03C4CED1;
	Fri,  6 Dec 2024 14:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496574;
	bh=XEXw/KEtHuMxz9HhaLK9DDb+s2M11npcvYEqB8X8Y8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPTFZGa8eNWMASel8fvydqqEJPU9HryY7k5iExEMTRwECa4rnyvDrgjzUva8nhzN/
	 ljG7hRfb5tlEN+S3LcyD5pCYKOJdtaX24RmS6Yq6NPRfzMNlZWScgCNxAqa7P85w2V
	 1IWGTnLvJ4blD+dyLBYOKDzcQoO8IRI+eHPXTpKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <mrpre@163.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 013/676] bpf: fix filed access without lock
Date: Fri,  6 Dec 2024 15:27:12 +0100
Message-ID: <20241206143653.876525531@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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



