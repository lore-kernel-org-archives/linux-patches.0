Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19B819464
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ljp4qHMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468C5C433CA;
	Mon,  9 Oct 2023 13:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857181;
	bh=HxgvAaS+fW9PyQThPQn1WfUml0VLOWkLZdBtM/4hhLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ljp4qHMcTc/pOpPEvhgEW4DzMlA4GOmoaB7faLKhvE8bLqrxdl/lEbBG6WwHdXu/5
	 GE27zgVmcY9OUfdlOJ1AjFwFazbOZd0S+LTdmsju3Dy/w5W6X1xwd+cm69ZBa078BF
	 t0tZRIEcMEN2kfjUQvhH5jY34KaGw0cW7BBK1p7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 098/163] bpf, sockmap: Do not inc copied_seq when PEEK flag set
Date: Mon,  9 Oct 2023 15:01:02 +0200
Message-ID: <20231009130126.737001410@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit da9e915eaf5dadb1963b7738cdfa42ed55212445 ]

When data is peek'd off the receive queue we shouldn't considered it
copied from tcp_sock side. When we increment copied_seq this will confuse
tcp_data_ready() because copied_seq can be arbitrarily increased. From
application side it results in poll() operations not waking up when
expected.

Notice tcp stack without BPF recvmsg programs also does not increment
copied_seq.

We broke this when we moved copied_seq into recvmsg to only update when
actual copy was happening. But, it wasn't working correctly either before
because the tcp_data_ready() tried to use the copied_seq value to see
if data was read by user yet. See fixes tags.

Fixes: e5c6de5fa0258 ("bpf, sockmap: Incorrectly handling copied_seq")
Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20230926035300.135096-3-john.fastabend@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 81f0dff69e0b6..3272682030015 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -222,6 +222,7 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 				  int *addr_len)
 {
 	struct tcp_sock *tcp = tcp_sk(sk);
+	int peek = flags & MSG_PEEK;
 	u32 seq = tcp->copied_seq;
 	struct sk_psock *psock;
 	int copied = 0;
@@ -311,7 +312,8 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 		copied = -EAGAIN;
 	}
 out:
-	WRITE_ONCE(tcp->copied_seq, seq);
+	if (!peek)
+		WRITE_ONCE(tcp->copied_seq, seq);
 	tcp_rcv_space_adjust(sk);
 	if (copied > 0)
 		__tcp_cleanup_rbuf(sk, copied);
-- 
2.40.1



