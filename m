Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDCC1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C82EC433C8;
	Mon, 11 Sep 2023 13:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440514;
	bh=baVFV0YLAY2SuUWtBeEz3GbofGXSI0JIFk5/7BmQwmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4PyevRU47ca/PLdAa4xWmXT6iPrd3ZHXzI8rUzwLr/RzSRYsHvHD409U/2CsM0Pq
	 1iLgpH4Q+hyyZ6dUzyGH8jCcGTTcQt2PjklUJvIk3H0nREpKl7Qk+kjLTNu3H2tetx
	 JADl6x0BXa7UK5VNI9EDfS/P3b0wlj9z5sU907tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Stringer <joe@cilium.io>,
	Lorenz Bauer <lmb@isovalent.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 089/739] bpf: reject unhashed sockets in bpf_sk_assign
Date: Mon, 11 Sep 2023 15:38:08 +0200
Message-ID: <20230911134653.590876879@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

From: Lorenz Bauer <lmb@isovalent.com>

[ Upstream commit 67312adc96b5a585970d03b62412847afe2c6b01 ]

The semantics for bpf_sk_assign are as follows:

    sk = some_lookup_func()
    bpf_sk_assign(skb, sk)
    bpf_sk_release(sk)

That is, the sk is not consumed by bpf_sk_assign. The function
therefore needs to make sure that sk lives long enough to be
consumed from __inet_lookup_skb. The path through the stack for a
TCPv4 packet is roughly:

  netif_receive_skb_core: takes RCU read lock
    __netif_receive_skb_core:
      sch_handle_ingress:
        tcf_classify:
          bpf_sk_assign()
      deliver_ptype_list_skb:
        deliver_skb:
          ip_packet_type->func == ip_rcv:
            ip_rcv_core:
            ip_rcv_finish_core:
              dst_input:
                ip_local_deliver:
                  ip_local_deliver_finish:
                    ip_protocol_deliver_rcu:
                      tcp_v4_rcv:
                        __inet_lookup_skb:
                          skb_steal_sock

The existing helper takes advantage of the fact that everything
happens in the same RCU critical section: for sockets with
SOCK_RCU_FREE set bpf_sk_assign never takes a reference.
skb_steal_sock then checks SOCK_RCU_FREE again and does sock_put
if necessary.

This approach assumes that SOCK_RCU_FREE is never set on a sk
between bpf_sk_assign and skb_steal_sock, but this invariant is
violated by unhashed UDP sockets. A new UDP socket is created
in TCP_CLOSE state but without SOCK_RCU_FREE set. That flag is only
added in udp_lib_get_port() which happens when a socket is bound.

When bpf_sk_assign was added it wasn't possible to access unhashed
UDP sockets from BPF, so this wasn't a problem. This changed
in commit 0c48eefae712 ("sock_map: Lift socket state restriction
for datagram sockets"), but the helper wasn't adjusted accordingly.
The following sequence of events will therefore lead to a refcount
leak:

1. Add socket(AF_INET, SOCK_DGRAM) to a sockmap.
2. Pull socket out of sockmap and bpf_sk_assign it. Since
   SOCK_RCU_FREE is not set we increment the refcount.
3. bind() or connect() the socket, setting SOCK_RCU_FREE.
4. skb_steal_sock will now set refcounted = false due to
   SOCK_RCU_FREE.
5. tcp_v4_rcv() skips sock_put().

Fix the problem by rejecting unhashed sockets in bpf_sk_assign().
This matches the behaviour of __inet_lookup_skb which is ultimately
the goal of bpf_sk_assign().

Fixes: cf7fbe660f2d ("bpf: Add socket assign support")
Cc: Joe Stringer <joe@cilium.io>
Signed-off-by: Lorenz Bauer <lmb@isovalent.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20230720-so-reuseport-v6-2-7021b683cdae@isovalent.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 28a59596987a9..f1a5775400658 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7352,6 +7352,8 @@ BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
 		return -ENETUNREACH;
 	if (unlikely(sk_fullsock(sk) && sk->sk_reuseport))
 		return -ESOCKTNOSUPPORT;
+	if (sk_unhashed(sk))
+		return -EOPNOTSUPP;
 	if (sk_is_refcounted(sk) &&
 	    unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
 		return -ENOENT;
-- 
2.40.1



