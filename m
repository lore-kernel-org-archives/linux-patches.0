Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F69646EF87;
	Tue, 25 Aug 2026 13:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665635; cv=none; b=JIZGPnnYwsD1qnv+GVnEaL+8vNaA8AbyKfiI2LsB49FV7hxJg5M2fODOtE8BOZRi3pKxr4J/iBHa7pQHro6ns+rWMBDsSkACieZpd7PIp3YG/8S21AkE6Y1jMhEpFU7lbX2TDc/rJ2vKEYB/VrmuFDAR+RJ0vheci0Zb1GwojmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665635; c=relaxed/simple;
	bh=AG/rdkIKyrh1vNDK+Ak3H5yltV4qRWbEZ7bbuk6wg/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ij+7QCgxgVYqyZzBkGF/l5N6QLch0WNoby4Y8IevyV9juznVDErQ1hEJYIq6qxHduCIxfEeNelE7lZu3nHOAKUFMgSL/WqC78hMGQnUNQVtNjfnI1KhF0UaGy/cqNOh6CEljs/sxNzk+nP9cBxabEO5U0LIblNg9UTSL8yst8Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdDMsW2x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdDMsW2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732071F000E9;
	Tue, 25 Aug 2026 13:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665634;
	bh=EtulP0h7mZWx5Y4Q7BFvDZ/A5PvSw4ZMOw/lFm63IHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EdDMsW2x3ZwDAsoJIAMOPzhP0v4mZZgGgOueR95o3EQ7OAXSQDLfBJkRyWJzhurH8
	 M1klz8dk0xBYsIOd1/JDPnBAi9q3QLNI2OOUpRVUWY8eH6JXgPTFIdt4Ir4xxngbhn
	 cpN9d3mxalPZ/b6ZhjYhONJDo8c2v1EExUB9aT18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 15/87] ipv4: frags: remove ipq_put()
Date: Tue, 25 Aug 2026 15:25:38 +0200
Message-ID: <20260825132542.429605494@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a2fb987c0ecf0498cc17056339cb11d128c46ab7 ]

Replace ipq_put() with inet_frag_putn()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250312082250.1803501-3-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 653d7ddf6cba ("inet: frags: publish queues before arming timer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_fragment.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -107,14 +107,6 @@ static void ip4_frag_free(struct inet_fr
 		inet_putpeer(qp->peer);
 }
 
-
-/* Destruction primitives. */
-
-static void ipq_put(struct ipq *ipq)
-{
-	inet_frag_putn(&ipq->q, 1);
-}
-
 /* Kill ipq entry. It is not destroyed immediately,
  * because caller (and someone more) holds reference count.
  */
@@ -142,6 +134,7 @@ static void ip_expire(struct timer_list
 	struct sk_buff *head = NULL;
 	struct net *net;
 	struct ipq *qp;
+	int refs = 1;
 	int err;
 
 	qp = container_of(frag, struct ipq, q);
@@ -203,7 +196,7 @@ out:
 out_rcu_unlock:
 	rcu_read_unlock();
 	kfree_skb_reason(head, SKB_DROP_REASON_FRAG_REASM_TIMEOUT);
-	ipq_put(qp);
+	inet_frag_putn(&qp->q, refs);
 }
 
 /* Find the correct entry in the "incomplete datagrams" queue for
@@ -492,14 +485,14 @@ int ip_defrag(struct net *net, struct sk
 	/* Lookup (or create) queue header */
 	qp = ip_find(net, ip_hdr(skb), user, vif);
 	if (qp) {
-		int ret;
+		int ret, refs = 1;
 
 		spin_lock(&qp->q.lock);
 
 		ret = ip_frag_queue(qp, skb);
 
 		spin_unlock(&qp->q.lock);
-		ipq_put(qp);
+		inet_frag_putn(&qp->q, refs);
 		return ret;
 	}
 


