Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2DF6D1DA;
	Tue, 23 Jan 2024 02:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975391; cv=none; b=X5XgkiNOj0IjGfWnPTXaImOQP2QEx2dMfNMQIcd9WrDwJ9mYbpL4Cu0SfYsXs+71qkDCmIi3ZcmrHO4NrbVPlHpSL+T565xTaEpSH0+mJeVJrQl4ICtVXPw9VjZ219qJltmjPt2CZIjZuQMAUqKR1xrVdd7Eby7rOffWYxCBdz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975391; c=relaxed/simple;
	bh=VdQvV3YNp4bVMQdmBbZvS7RmHS17oLc/nqLCreLOguE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPRdV7BlYuU62fzlSQ3+Cqtdtdp80D7a6NBSWZw7N2TSJi/8+gSs9D1oCD3pyMqYiUzwh/BwUGO7rsV5D6GyZVd4PggoQJ8SCl/gXAyPuSv0fen7uWAMaoUEXzM5ljnvRG6jsxochzvwBnUshkFfCc2syM03q7uasjW4Xt3uLDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uub+v7Bg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uub+v7Bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F0BC43390;
	Tue, 23 Jan 2024 02:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975391;
	bh=VdQvV3YNp4bVMQdmBbZvS7RmHS17oLc/nqLCreLOguE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uub+v7BggA/saF1fHqMbz4W2S3QEo9HRumz4Jk+Wg9tERbsU1SL7YJ531UC7i2AVu
	 epVRBTlb6evDw0eJYNkbqwcMDIIHF1rOXZOVfdehtoi85ygudX4dZhnG/D9kiX4VDp
	 MCKjFpMgXiJd0EZFZNoDJkrIHUV+LreN842eWnKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Juergen Gross <jgross@suse.com>,
	Paul Durrant <paul@xen.org>
Subject: [PATCH 6.6 352/583] xen-netback: dont produce zero-size SKB frags
Date: Mon, 22 Jan 2024 15:56:43 -0800
Message-ID: <20240122235822.793870174@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <jbeulich@suse.com>

commit c7ec4f2d684e17d69bbdd7c4324db0ef5daac26a upstream.

While frontends may submit zero-size requests (wasting a precious slot),
core networking code as of at least 3ece782693c4b ("sock: skb_copy_ubufs
support for compound pages") can't deal with SKBs when they have all
zero-size fragments. Respond to empty requests right when populating
fragments; all further processing is fragment based and hence won't
encounter these empty requests anymore.

In a way this should have been that way from the beginning: When no data
is to be transferred for a particular request, there's not even a point
in validating the respective grant ref. That's no different from e.g.
passing NULL into memcpy() when at the same time the size is 0.

This is XSA-448 / CVE-2023-46838.

Cc: stable@vger.kernel.org
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c |   44 ++++++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 6 deletions(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -463,12 +463,25 @@ static void xenvif_get_requests(struct x
 	}
 
 	for (shinfo->nr_frags = 0; nr_slots > 0 && shinfo->nr_frags < MAX_SKB_FRAGS;
-	     shinfo->nr_frags++, gop++, nr_slots--) {
+	     nr_slots--) {
+		if (unlikely(!txp->size)) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&queue->response_lock, flags);
+			make_tx_response(queue, txp, 0, XEN_NETIF_RSP_OKAY);
+			push_tx_responses(queue);
+			spin_unlock_irqrestore(&queue->response_lock, flags);
+			++txp;
+			continue;
+		}
+
 		index = pending_index(queue->pending_cons++);
 		pending_idx = queue->pending_ring[index];
 		xenvif_tx_create_map_op(queue, pending_idx, txp,
 				        txp == first ? extra_count : 0, gop);
 		frag_set_pending_idx(&frags[shinfo->nr_frags], pending_idx);
+		++shinfo->nr_frags;
+		++gop;
 
 		if (txp == first)
 			txp = txfrags;
@@ -481,20 +494,39 @@ static void xenvif_get_requests(struct x
 		shinfo = skb_shinfo(nskb);
 		frags = shinfo->frags;
 
-		for (shinfo->nr_frags = 0; shinfo->nr_frags < nr_slots;
-		     shinfo->nr_frags++, txp++, gop++) {
+		for (shinfo->nr_frags = 0; shinfo->nr_frags < nr_slots; ++txp) {
+			if (unlikely(!txp->size)) {
+				unsigned long flags;
+
+				spin_lock_irqsave(&queue->response_lock, flags);
+				make_tx_response(queue, txp, 0,
+						 XEN_NETIF_RSP_OKAY);
+				push_tx_responses(queue);
+				spin_unlock_irqrestore(&queue->response_lock,
+						       flags);
+				continue;
+			}
+
 			index = pending_index(queue->pending_cons++);
 			pending_idx = queue->pending_ring[index];
 			xenvif_tx_create_map_op(queue, pending_idx, txp, 0,
 						gop);
 			frag_set_pending_idx(&frags[shinfo->nr_frags],
 					     pending_idx);
+			++shinfo->nr_frags;
+			++gop;
 		}
 
-		skb_shinfo(skb)->frag_list = nskb;
-	} else if (nskb) {
+		if (shinfo->nr_frags) {
+			skb_shinfo(skb)->frag_list = nskb;
+			nskb = NULL;
+		}
+	}
+
+	if (nskb) {
 		/* A frag_list skb was allocated but it is no longer needed
-		 * because enough slots were converted to copy ops above.
+		 * because enough slots were converted to copy ops above or some
+		 * were empty.
 		 */
 		kfree_skb(nskb);
 	}


