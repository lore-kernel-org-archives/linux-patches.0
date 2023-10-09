Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD9A250E0
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPBctwj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE40CC433C9;
	Mon,  9 Oct 2023 13:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857652;
	bh=/zK+SQdR5zdvYmEF7Xdund+WAR4qfNIgaGW+WVKkqRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPBctwj3IGx+mWJaifZzsl0QvgDf1ucEDolKgUU9j2b0cI0vw/4H351QYdXsiUb3V
	 P+7WV+1H+Ia+pPnu7icoTpJBYOmsrYjvlU1+bdEV8JQ4JmvJtPPPfAyArHFOQ702FY
	 zmA6d3Mqb185edeF/1BPner/NoZccb9/lnKMrTrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Florian Westphal <fw@strlen.de>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/162] ipv6: tcp: add a missing nf_reset_ct() in 3WHS handling
Date: Mon,  9 Oct 2023 15:01:35 +0200
Message-ID: <20231009130126.075982964@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit 9593c7cb6cf670ef724d17f7f9affd7a8d2ad0c5 ]

Commit b0e214d21203 ("netfilter: keep conntrack reference until
IPsecv6 policy checks are done") is a direct copy of the old
commit b59c270104f0 ("[NETFILTER]: Keep conntrack reference until
IPsec policy checks are done") but for IPv6.  However, it also
copies a bug that this old commit had.  That is: when the third
packet of 3WHS connection establishment contains payload, it is
added into socket receive queue without the XFRM check and the
drop of connection tracking context.

That leads to nf_conntrack module being impossible to unload as
it waits for all the conntrack references to be dropped while
the packet release is deferred in per-cpu cache indefinitely, if
not consumed by the application.

The issue for IPv4 was fixed in commit 6f0012e35160 ("tcp: add a
missing nf_reset_ct() in 3WHS handling") by adding a missing XFRM
check and correctly dropping the conntrack context.  However, the
issue was introduced to IPv6 code afterwards.  Fixing it the
same way for IPv6 now.

Fixes: b0e214d21203 ("netfilter: keep conntrack reference until IPsecv6 policy checks are done")
Link: https://lore.kernel.org/netdev/d589a999-d4dd-2768-b2d5-89dec64a4a42@ovn.org/
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Acked-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230922210530.2045146-1-i.maximets@ovn.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/tcp_ipv6.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 4bdd356bb5c46..7be89dcfd5fc5 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1644,9 +1644,12 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		drop_reason = tcp_inbound_md5_hash(sk, skb,
-						   &hdr->saddr, &hdr->daddr,
-						   AF_INET6, dif, sdif);
+		if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
+			drop_reason = SKB_DROP_REASON_XFRM_POLICY;
+		else
+			drop_reason = tcp_inbound_md5_hash(sk, skb,
+							   &hdr->saddr, &hdr->daddr,
+							   AF_INET6, dif, sdif);
 		if (drop_reason) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
@@ -1693,6 +1696,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 			}
 			goto discard_and_relse;
 		}
+		nf_reset_ct(skb);
 		if (nsk == sk) {
 			reqsk_put(req);
 			tcp_v6_restore_cb(skb);
-- 
2.40.1



