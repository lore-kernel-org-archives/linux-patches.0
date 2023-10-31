Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B154C208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QmlMlwZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA0FC433C9;
	Tue, 31 Oct 2023 17:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774471;
	bh=c4cUGdYCDqW3utYO/pZ4pKouJPUnuWbN5DTbdUVtmwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmlMlwZRq04l8nBArmc5De1tbS8BL8g3J//sAaQE6RCeIXjVeXsuXiJjizCo4/HTA
	 x72yP0Gdcrd1PY94nhUS/HuQ9zZyTdKWvPWY+xMGEy/GASqusGtIq3gZnQIt49hKvN
	 SpA/TNoSZNHBzuIw6RybDyaslJNrgTfdo3K2eCpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Shakeel Butt <shakeelb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 056/112] net: do not leave an empty skb in write queue
Date: Tue, 31 Oct 2023 18:00:57 +0100
Message-ID: <20231031165903.082981401@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 72bf4f1767f0386970dc04726dc5bc2e3991dc19 ]

Under memory stress conditions, tcp_sendmsg_locked()
might call sk_stream_wait_memory(), thus releasing the socket lock.

If a fresh skb has been allocated prior to this,
we should not leave it in the write queue otherwise
tcp_write_xmit() could panic.

This apparently does not happen often, but a future change
in __sk_mem_raise_allocated() that Shakeel and others are
considering would increase chances of being hurt.

Under discussion is to remove this controversial part:

    /* Fail only if socket is _under_ its sndbuf.
     * In this case we cannot block, so that we have to fail.
     */
    if (sk->sk_wmem_queued + size >= sk->sk_sndbuf) {
        /* Force charge with __GFP_NOFAIL */
        if (memcg_charge && !charged) {
            mem_cgroup_charge_skmem(sk->sk_memcg, amt,
                gfp_memcg_charge() | __GFP_NOFAIL);
        }
        return 1;
    }

Fixes: fdfc5c8594c2 ("tcp: remove empty skb from write queue in error cases")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Link: https://lore.kernel.org/r/20231019112457.1190114-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9bdc1b2eaf734..a0a87446f827c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -925,10 +925,11 @@ int tcp_send_mss(struct sock *sk, int *size_goal, int flags)
 	return mss_now;
 }
 
-/* In some cases, both sendmsg() could have added an skb to the write queue,
- * but failed adding payload on it.  We need to remove it to consume less
+/* In some cases, sendmsg() could have added an skb to the write queue,
+ * but failed adding payload on it. We need to remove it to consume less
  * memory, but more importantly be able to generate EPOLLOUT for Edge Trigger
- * epoll() users.
+ * epoll() users. Another reason is that tcp_write_xmit() does not like
+ * finding an empty skb in the write queue.
  */
 void tcp_remove_empty_skb(struct sock *sk)
 {
@@ -1286,6 +1287,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 
 wait_for_space:
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
+		tcp_remove_empty_skb(sk);
 		if (copied)
 			tcp_push(sk, flags & ~MSG_MORE, mss_now,
 				 TCP_NAGLE_PUSH, size_goal);
-- 
2.42.0



