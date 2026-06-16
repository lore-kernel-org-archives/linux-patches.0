Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB45466B57;
	Tue, 16 Jun 2026 16:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626913; cv=none; b=JxduLzpGv9GjhTKsYCP2J5qSI7VeiY3PQcsxlm2n1B/KKQ7c+k5UMo9kngMfaUrNt42udOJahkjlomyjbi+hnsg9n/RJ3r8eKWmoKFSz8c4rYSQFiop+zixMsCf87bT9FEHjLibiSxNBVPUtQ+Sz0Qg49PKj4thNQZ67gieiY88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626913; c=relaxed/simple;
	bh=fRy6W76PVzXgun6kM0zo1exHoOwh5c6+0UbarEsS/qM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0gNiI0S3kTQxHvQ3nezMH+x2v97tvnVp+GKi0iaOjBN1OWbqlTqTBHzsYpr7Ud4GGTeGQ/39BVfR38Jz402ip22WZYMO440UyBa3ob9RJY+3bd0v8rtnC22BnXqHqQLXwPdnlcS8fTiGqf1olrYfWLCDNiOzXU41YlV0v3f61g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGeofeXk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGeofeXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB511F000E9;
	Tue, 16 Jun 2026 16:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626912;
	bh=PS7yZFMyuuGtvUIFBkAIJimILtKb8Z/ZnkTvqClsSsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGeofeXk7PEFKDDZvqG5itZWRYebwvNMbwkrwTCD3+e+L4qTDeB4DvETwf05k/JSK
	 flbuDjCoQX/rPrK6UQkpZZyllKLTPeVh0coEPrEYVdBfSsCG8KN6wyxTyHIBbE4pkj
	 +zBpMmyDSQVqrxFxsgazyhKr5xjMusS9w7L/bTEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/261] net: guard timestamp cmsgs to real error queue skbs
Date: Tue, 16 Jun 2026 20:28:51 +0530
Message-ID: <20260616145049.346268159@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 1ee90b77b727df903033db873c75caac5c27ec98 ]

skb_is_err_queue() treats PACKET_OUTGOING as the sole marker for an skb
from sk_error_queue. That assumption is not true for AF_PACKET sockets:
outgoing packet taps are also delivered to packet sockets with
skb->pkt_type == PACKET_OUTGOING, but their skb->cb is owned by AF_PACKET
instead of struct sock_exterr_skb.

If such an skb is received with timestamping enabled, the generic
timestamp cmsg path can read AF_PACKET control-buffer state as
sock_exterr_skb::opt_stats. With SO_RXQ_OVFL enabled, the packet drop
counter overlaps opt_stats. An odd drop count makes the path emit
SCM_TIMESTAMPING_OPT_STATS with skb->len and skb->data. For non-linear
skbs this copies past the linear head and can trigger hardened usercopy or
disclose adjacent heap contents.

Keep skb_is_err_queue() local to net/socket.c, but make it verify that
the PACKET_OUTGOING marker is paired with the sock_rmem_free destructor
installed by sock_queue_err_skb(). AF_PACKET receive skbs use normal
receive ownership and no longer pass as error-queue skbs, while legitimate
sk_error_queue entries keep the PACKET_OUTGOING marker and sock_rmem_free
ownership.

Fixes: 8605330aac5a ("tcp: fix SCM_TIMESTAMPING_OPT_STATS for normal skbs")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260607021819.49698-1-kylebot@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h |  1 +
 net/core/skbuff.c  |  6 +++---
 net/socket.c       | 11 ++++++-----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 6edd9cac500675..0d77a87929f938 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1806,6 +1806,7 @@ struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
 			     gfp_t priority);
 void skb_orphan_partial(struct sk_buff *skb);
 void sock_rfree(struct sk_buff *skb);
+void sock_rmem_free(struct sk_buff *skb);
 void sock_efree(struct sk_buff *skb);
 #ifdef CONFIG_INET
 void sock_edemux(struct sk_buff *skb);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index fba5f06b94d9d6..4be699bd3a17f7 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5384,7 +5384,7 @@ int skb_cow_data(struct sk_buff *skb, int tailbits, struct sk_buff **trailer)
 }
 EXPORT_SYMBOL_GPL(skb_cow_data);
 
-static void sock_rmem_free(struct sk_buff *skb)
+void sock_rmem_free(struct sk_buff *skb)
 {
 	struct sock *sk = skb->sk;
 
@@ -5393,8 +5393,8 @@ static void sock_rmem_free(struct sk_buff *skb)
 
 static void skb_set_err_queue(struct sk_buff *skb)
 {
-	/* pkt_type of skbs received on local sockets is never PACKET_OUTGOING.
-	 * So, it is safe to (mis)use it to mark skbs on the error queue.
+	/* The error-queue test in skb_is_err_queue() matches this marker
+	 * with the sock_rmem_free destructor installed by sock_queue_err_skb().
 	 */
 	skb->pkt_type = PACKET_OUTGOING;
 	BUILD_BUG_ON(PACKET_OUTGOING == 0);
diff --git a/net/socket.c b/net/socket.c
index 878155076bc0f8..5c5dd9f6605a94 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -804,12 +804,13 @@ EXPORT_SYMBOL(kernel_sendmsg_locked);
 
 static bool skb_is_err_queue(const struct sk_buff *skb)
 {
-	/* pkt_type of skbs enqueued on the error queue are set to
-	 * PACKET_OUTGOING in skb_set_err_queue(). This is only safe to do
-	 * in recvmsg, since skbs received on a local socket will never
-	 * have a pkt_type of PACKET_OUTGOING.
+	/* Error-queue skbs are marked as PACKET_OUTGOING in
+	 * skb_set_err_queue() and use the destructor installed by
+	 * sock_queue_err_skb(). PACKET_OUTGOING alone is not unique:
+	 * AF_PACKET outgoing taps use the same pkt_type.
 	 */
-	return skb->pkt_type == PACKET_OUTGOING;
+	return skb->pkt_type == PACKET_OUTGOING &&
+	       skb->destructor == sock_rmem_free;
 }
 
 /* On transmit, software and hardware timestamps are returned independently.
-- 
2.53.0



