Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D9C33985;
	Tue, 14 May 2024 11:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687764; cv=none; b=la48/PUJ5mtscFigFvurbf9r3ySTKbPFnC6IdkErBTA7uoN6nDNe5gSC4jZnIJZ1lX5Tb6tG8Q+xZmBPp8ZnJUn92KH5rYoGX/9i7MHZspHM0f0CQap4+H+uxn9qfd/baav9ikChxokDXMJLBfgjabqd05oG5f5QgIUd4eoHoDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687764; c=relaxed/simple;
	bh=3cqzA8a7vGCpm6CU3gLIYLPu/HipNwUhnLBAWVsv9gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjHleKjCbadYhg6xfMQDkU6WQGfwEe7qyIsGMS7F5PpTGGPc5DJDF/2zWPjfnP3EfrBpD3mfaKrB8N/LxAoXbzQOxKbedyddvJy7U6jYZNezJwckJ+Tp6e04Z9npgrxKr6q9QEGl83g0XgeOEvmrRJQuun16MZlSkNXQLNHxKow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KNb4s238; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KNb4s238"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CA57C2BD10;
	Tue, 14 May 2024 11:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687763;
	bh=3cqzA8a7vGCpm6CU3gLIYLPu/HipNwUhnLBAWVsv9gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNb4s238UKBtCKs749ZzDyb+zTbyXH9flLJdmVP+NlZP3qkFXeKrJHYBb2xYD12PG
	 HKQFSmUvYMBSA4FcIpQT1W9w/CPm+Um7uEU5MfXMTn+8EB5RQvsQcLliIpWcfh0XHj
	 0Xwov00DIsIia54E6B2qT3uUOv5lwp2zxWIt1jrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	William Findlay <will@isovalent.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/168] bpf, sockmap: Handle fin correctly
Date: Tue, 14 May 2024 12:19:54 +0200
Message-ID: <20240514101010.313780745@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 901546fd8f9ca4b5c481ce00928ab425ce9aacc0 ]

The sockmap code is returning EAGAIN after a FIN packet is received and no
more data is on the receive queue. Correct behavior is to return 0 to the
user and the user can then close the socket. The EAGAIN causes many apps
to retry which masks the problem. Eventually the socket is evicted from
the sockmap because its released from sockmap sock free handling. The
issue creates a delay and can cause some errors on application side.

To fix this check on sk_msg_recvmsg side if length is zero and FIN flag
is set then set return to zero. A selftest will be added to check this
condition.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: William Findlay <will@isovalent.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20230523025618.113937-6-john.fastabend@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 89204004eeb5e..5fdef5ddfbbe6 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -174,6 +174,24 @@ static int tcp_msg_wait_data(struct sock *sk, struct sk_psock *psock,
 	return ret;
 }
 
+static bool is_next_msg_fin(struct sk_psock *psock)
+{
+	struct scatterlist *sge;
+	struct sk_msg *msg_rx;
+	int i;
+
+	msg_rx = sk_psock_peek_msg(psock);
+	i = msg_rx->sg.start;
+	sge = sk_msg_elem(msg_rx, i);
+	if (!sge->length) {
+		struct sk_buff *skb = msg_rx->skb;
+
+		if (skb && TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN)
+			return true;
+	}
+	return false;
+}
+
 static int tcp_bpf_recvmsg_parser(struct sock *sk,
 				  struct msghdr *msg,
 				  size_t len,
@@ -217,6 +235,19 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 
 msg_bytes_ready:
 	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
+	/* The typical case for EFAULT is the socket was gracefully
+	 * shutdown with a FIN pkt. So check here the other case is
+	 * some error on copy_page_to_iter which would be unexpected.
+	 * On fin return correct return code to zero.
+	 */
+	if (copied == -EFAULT) {
+		bool is_fin = is_next_msg_fin(psock);
+
+		if (is_fin) {
+			copied = 0;
+			goto out;
+		}
+	}
 	if (!copied) {
 		long timeo;
 		int data;
-- 
2.43.0



