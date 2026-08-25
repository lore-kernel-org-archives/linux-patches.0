Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDD6481254;
	Tue, 25 Aug 2026 13:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665392; cv=none; b=d7jfieI9rYa7VSezyOp8H84NVUv6WP4dENCwQR2VqNVAPXOcF3JNNxQJmuUng7pgbWSjZtl7VCRyoDCjp0SJsb6Z8vtdiBPQQFbLHv8SCKVPpgSEe+lfd9UOu8F9Q5Dio6mfDRx2yCdhxnXQQZ7Gaf0QodLrlGOBfD+iZ5n3f6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665392; c=relaxed/simple;
	bh=bFuvUvwdpeOrRaFSS4xeuCQteaEFQfj6ib+j/ASLSTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbedCSOlxT3XNWYURptc+WICmeH39cQ70pGUV4E/e1ZIBOBu2v3zBU5BR0ZCl9/yGkM/FbIikXQahqI+zrwmXRwKO231dDjDd/kdiDRfZTbz/L6mxC++SOrsBeySYgv5GDvqN6GUzCi3+jx2Gl8pz6GcLf2M8xybcf22gW5Bzz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQl5rDXD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQl5rDXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5FE1F000E9;
	Tue, 25 Aug 2026 13:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665390;
	bh=SwQGSmZ+iVQzHGSKfJ4rnmwA+0NGBQLzKWKvGVvwO2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQl5rDXDgCB62CnJ4jEXz4M4Xr2yn5VWm+9w0E2AoeTifUwrI6E5NPn9A63l0g+0F
	 OMrMRjaxTudZQWOwq4TtIlF2a46at0CdRu4B8mMEqJq1lJCxnObSuvdvKwsjhxSPs2
	 1M5TxGcfb6DzKWJlFSUcZjre6JdSBZvIfVs/4UGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 10/77] ipv4: frags: remove ipq_put()
Date: Tue, 25 Aug 2026 15:25:32 +0200
Message-ID: <20260825132541.957921304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


