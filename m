Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD6314AA9
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fwPphra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB719C433C7;
	Mon, 23 Oct 2023 11:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059393;
	bh=tI5ORdKRgra8O1Sc2KkiNTFb8Gr6E/zyr5BiGhgiRYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2fwPphra2jEvzX9QL+fOscxIths/uHg5WIlkhqwFQJIyqT1hefVRHhK1pAYZfbAqD
	 45MdZRzUAHRdbLWx/rKpABpNso2xq81u3azELxhH8rCrXedJkbeVUGbo9hksUtbX/n
	 HtlS8vFXxIekv7qpD0PX/wUPOZ5Xpphh8Lpi9/eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Eric Dumazet <edumazet@google.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 163/241] tcp_bpf: properly release resources on error paths
Date: Mon, 23 Oct 2023 12:55:49 +0200
Message-ID: <20231023104837.849296216@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 68b54aeff804acceb02f228ea2e28419272c1fb9 ]

In the blamed commit below, I completely forgot to release the acquired
resources before erroring out in the TCP BPF code, as reported by Dan.

Address the issues by replacing the bogus return with a jump to the
relevant cleanup code.

Fixes: 419ce133ab92 ("tcp: allow again tcp_disconnect() when threads are waiting")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/8f99194c698bcef12666f0a9a999c58f8b1cb52c.1697557782.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index ba2e921881248..53b0d62fd2c2d 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -307,8 +307,10 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 		}
 
 		data = tcp_msg_wait_data(sk, psock, timeo);
-		if (data < 0)
-			return data;
+		if (data < 0) {
+			copied = data;
+			goto unlock;
+		}
 		if (data && !sk_psock_queue_empty(psock))
 			goto msg_bytes_ready;
 		copied = -EAGAIN;
@@ -319,6 +321,8 @@ static int tcp_bpf_recvmsg_parser(struct sock *sk,
 	tcp_rcv_space_adjust(sk);
 	if (copied > 0)
 		__tcp_cleanup_rbuf(sk, copied);
+
+unlock:
 	release_sock(sk);
 	sk_psock_put(sk, psock);
 	return copied;
@@ -353,8 +357,10 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 		timeo = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
 		data = tcp_msg_wait_data(sk, psock, timeo);
-		if (data < 0)
-			return data;
+		if (data < 0) {
+			ret = data;
+			goto unlock;
+		}
 		if (data) {
 			if (!sk_psock_queue_empty(psock))
 				goto msg_bytes_ready;
@@ -365,6 +371,8 @@ static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		copied = -EAGAIN;
 	}
 	ret = copied;
+
+unlock:
 	release_sock(sk);
 	sk_psock_put(sk, psock);
 	return ret;
-- 
2.40.1



