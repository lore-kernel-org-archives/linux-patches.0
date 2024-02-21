Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B817A708;
	Wed, 21 Feb 2024 14:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525689; cv=none; b=pH5OQjQGNtPQx15YaiEIfjacMvZ6pXkNvgh0e+euKpfQCJ/pKhN54pdXTStz2BDb0GkEMiKR6zSrkl+oD8b8LsK0T/opB2wJHU8rUnUu20+lZczkgmSLbii0h3s4g4lIdnVeFYGClKL7xSp4fKcI5bG2DYOPn6cMXz8KP8TuODs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525689; c=relaxed/simple;
	bh=cm/JicI/plLNj9o6jw3x3TgmwLJ4YT0i3tj3TOsWXbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlfCA0WvqcE5OmlpCwPQRsjBhFiUmP5Z4uJkHnk/WIIh4C6LXe5/fbsNEl+eMaCuCYl0l7aJDCKDa93iECJDPUPEzWzzAgRnt3gC+InC22Iys+PZE5wVzurk29Bhm9T0tPxhhMuPajh080Z6oyCJHY9nvdFsRPBQWLue0RhQxMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPzQTfqF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPzQTfqF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC12C433C7;
	Wed, 21 Feb 2024 14:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525688;
	bh=cm/JicI/plLNj9o6jw3x3TgmwLJ4YT0i3tj3TOsWXbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPzQTfqFihxKOtJTIl12h4aoaP8cIHodUpA4RntCAntPQxrRR//hQNFFcXChyihJD
	 prxm/25xZora4QitqRus6LA3j8V207/5znTamx36nMJnf40frdAoCltWHFoj+fwL8s
	 YFYNDMPlLrCKboQ8v2LMc/o2ioLC2j7fHhyKYIXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Paul Durrant <paul@xen.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 225/267] xen-netback: properly sync TX responses
Date: Wed, 21 Feb 2024 14:09:26 +0100
Message-ID: <20240221125947.309004113@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <jbeulich@suse.com>

commit 7b55984c96ffe9e236eb9c82a2196e0b1f84990d upstream.

Invoking the make_tx_response() / push_tx_responses() pair with no lock
held would be acceptable only if all such invocations happened from the
same context (NAPI instance or dealloc thread). Since this isn't the
case, and since the interface "spec" also doesn't demand that multicast
operations may only be performed with no in-flight transmits,
MCAST_{ADD,DEL} processing also needs to acquire the response lock
around the invocations.

To prevent similar mistakes going forward, "downgrade" the present
functions to private helpers of just the two remaining ones using them
directly, with no forward declarations anymore. This involves renaming
what so far was make_tx_response(), for the new function of that name
to serve the new (wrapper) purpose.

While there,
- constify the txp parameters,
- correct xenvif_idx_release()'s status parameter's type,
- rename {,_}make_tx_response()'s status parameters for consistency with
  xenvif_idx_release()'s.

Fixes: 210c34dcd8d9 ("xen-netback: add support for multicast control")
Cc: stable@vger.kernel.org
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Link: https://lore.kernel.org/r/980c6c3d-e10e-4459-8565-e8fbde122f00@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c |   84 ++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 44 deletions(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -97,13 +97,12 @@ module_param_named(hash_cache_size, xenv
 MODULE_PARM_DESC(hash_cache_size, "Number of flows in the hash cache");
 
 static void xenvif_idx_release(struct xenvif_queue *queue, u16 pending_idx,
-			       u8 status);
+			       s8 status);
 
 static void make_tx_response(struct xenvif_queue *queue,
-			     struct xen_netif_tx_request *txp,
+			     const struct xen_netif_tx_request *txp,
 			     unsigned int extra_count,
-			     s8       st);
-static void push_tx_responses(struct xenvif_queue *queue);
+			     s8 status);
 
 static void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx);
 
@@ -201,13 +200,9 @@ static void xenvif_tx_err(struct xenvif_
 			  unsigned int extra_count, RING_IDX end)
 {
 	RING_IDX cons = queue->tx.req_cons;
-	unsigned long flags;
 
 	do {
-		spin_lock_irqsave(&queue->response_lock, flags);
 		make_tx_response(queue, txp, extra_count, XEN_NETIF_RSP_ERROR);
-		push_tx_responses(queue);
-		spin_unlock_irqrestore(&queue->response_lock, flags);
 		if (cons == end)
 			break;
 		RING_COPY_REQUEST(&queue->tx, cons++, txp);
@@ -458,12 +453,7 @@ static void xenvif_get_requests(struct x
 	for (shinfo->nr_frags = 0; nr_slots > 0 && shinfo->nr_frags < MAX_SKB_FRAGS;
 	     nr_slots--) {
 		if (unlikely(!txp->size)) {
-			unsigned long flags;
-
-			spin_lock_irqsave(&queue->response_lock, flags);
 			make_tx_response(queue, txp, 0, XEN_NETIF_RSP_OKAY);
-			push_tx_responses(queue);
-			spin_unlock_irqrestore(&queue->response_lock, flags);
 			++txp;
 			continue;
 		}
@@ -489,14 +479,8 @@ static void xenvif_get_requests(struct x
 
 		for (shinfo->nr_frags = 0; shinfo->nr_frags < nr_slots; ++txp) {
 			if (unlikely(!txp->size)) {
-				unsigned long flags;
-
-				spin_lock_irqsave(&queue->response_lock, flags);
 				make_tx_response(queue, txp, 0,
 						 XEN_NETIF_RSP_OKAY);
-				push_tx_responses(queue);
-				spin_unlock_irqrestore(&queue->response_lock,
-						       flags);
 				continue;
 			}
 
@@ -990,7 +974,6 @@ static void xenvif_tx_build_gops(struct
 					 (ret == 0) ?
 					 XEN_NETIF_RSP_OKAY :
 					 XEN_NETIF_RSP_ERROR);
-			push_tx_responses(queue);
 			continue;
 		}
 
@@ -1002,7 +985,6 @@ static void xenvif_tx_build_gops(struct
 
 			make_tx_response(queue, &txreq, extra_count,
 					 XEN_NETIF_RSP_OKAY);
-			push_tx_responses(queue);
 			continue;
 		}
 
@@ -1437,8 +1419,35 @@ int xenvif_tx_action(struct xenvif_queue
 	return work_done;
 }
 
+static void _make_tx_response(struct xenvif_queue *queue,
+			     const struct xen_netif_tx_request *txp,
+			     unsigned int extra_count,
+			     s8 status)
+{
+	RING_IDX i = queue->tx.rsp_prod_pvt;
+	struct xen_netif_tx_response *resp;
+
+	resp = RING_GET_RESPONSE(&queue->tx, i);
+	resp->id     = txp->id;
+	resp->status = status;
+
+	while (extra_count-- != 0)
+		RING_GET_RESPONSE(&queue->tx, ++i)->status = XEN_NETIF_RSP_NULL;
+
+	queue->tx.rsp_prod_pvt = ++i;
+}
+
+static void push_tx_responses(struct xenvif_queue *queue)
+{
+	int notify;
+
+	RING_PUSH_RESPONSES_AND_CHECK_NOTIFY(&queue->tx, notify);
+	if (notify)
+		notify_remote_via_irq(queue->tx_irq);
+}
+
 static void xenvif_idx_release(struct xenvif_queue *queue, u16 pending_idx,
-			       u8 status)
+			       s8 status)
 {
 	struct pending_tx_info *pending_tx_info;
 	pending_ring_idx_t index;
@@ -1448,8 +1457,8 @@ static void xenvif_idx_release(struct xe
 
 	spin_lock_irqsave(&queue->response_lock, flags);
 
-	make_tx_response(queue, &pending_tx_info->req,
-			 pending_tx_info->extra_count, status);
+	_make_tx_response(queue, &pending_tx_info->req,
+			  pending_tx_info->extra_count, status);
 
 	/* Release the pending index before pusing the Tx response so
 	 * its available before a new Tx request is pushed by the
@@ -1463,32 +1472,19 @@ static void xenvif_idx_release(struct xe
 	spin_unlock_irqrestore(&queue->response_lock, flags);
 }
 
-
 static void make_tx_response(struct xenvif_queue *queue,
-			     struct xen_netif_tx_request *txp,
+			     const struct xen_netif_tx_request *txp,
 			     unsigned int extra_count,
-			     s8       st)
+			     s8 status)
 {
-	RING_IDX i = queue->tx.rsp_prod_pvt;
-	struct xen_netif_tx_response *resp;
-
-	resp = RING_GET_RESPONSE(&queue->tx, i);
-	resp->id     = txp->id;
-	resp->status = st;
-
-	while (extra_count-- != 0)
-		RING_GET_RESPONSE(&queue->tx, ++i)->status = XEN_NETIF_RSP_NULL;
+	unsigned long flags;
 
-	queue->tx.rsp_prod_pvt = ++i;
-}
+	spin_lock_irqsave(&queue->response_lock, flags);
 
-static void push_tx_responses(struct xenvif_queue *queue)
-{
-	int notify;
+	_make_tx_response(queue, txp, extra_count, status);
+	push_tx_responses(queue);
 
-	RING_PUSH_RESPONSES_AND_CHECK_NOTIFY(&queue->tx, notify);
-	if (notify)
-		notify_remote_via_irq(queue->tx_irq);
+	spin_unlock_irqrestore(&queue->response_lock, flags);
 }
 
 static void xenvif_idx_unmap(struct xenvif_queue *queue, u16 pending_idx)


