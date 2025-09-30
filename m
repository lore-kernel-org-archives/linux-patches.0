Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2596F266B65;
	Tue, 30 Sep 2025 15:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244876; cv=none; b=TSNDetukvtgYCHu/DMzsGy0UfSz50vdiCy/RDxcH+N5QGe1l2v3Z/3UhY01r1BCBxm0TEKXVZTJMq2/NrqhsyDhiMAxq9gxdLmRDEOOUkEm3cz5me+QQlQ8zIzI86ZpiqH8y7KuRZk7YtUOvgY5+4uwsGI7ao9Mdz/jy0rnF2No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244876; c=relaxed/simple;
	bh=8ztnTFc2p9c0gpstLeYkPtnp7EqMdekFCFZ/s0UOzHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gB5vTSPfJiX4XO640dRxa09/K+nnbngWnkKn4Nh0jA6Cw/P6Ln7w/RbI8UDbP4iG+sFvcYMKwjNUt0wf1qR+teyM6VB5BM14dVsCvEKy/e+uZcEt58E1ACwCjQzjEXjSEzOHWCTt62TgXTm9YbTdblqKhpweagW0UPs+MK5lHVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/uhxhzY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/uhxhzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDDCC4CEF0;
	Tue, 30 Sep 2025 15:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244876;
	bh=8ztnTFc2p9c0gpstLeYkPtnp7EqMdekFCFZ/s0UOzHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/uhxhzY1iUe3Hctmvk2fp8GmAAp9gpqPd09H8eW3keGXaCcVWjt1tIw8eXxIgKVy
	 UPC8t1wymRO1xMSwpPrNpEQngTC8WOlgx1NbUw+7AurHITZlsDuD3Y7m0ZEn+lr4aj
	 1Lnj5KTIyzak3DMnkV+7JKHCWCApTWSSYHb4A4fE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Kohler <jon@nutanix.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.16 123/143] Revert "vhost/net: Defer TX queue re-enable until after sendmsg"
Date: Tue, 30 Sep 2025 16:47:27 +0200
Message-ID: <20250930143836.135168563@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

commit 4174152771bf0d014d58f7d7e148bb0c8830fe53 upstream.

This reverts commit 8c2e6b26ffe243be1e78f5a4bfb1a857d6e6f6d6. It tries
to defer the notification enabling by moving the logic out of the loop
after the vhost_tx_batch() when nothing new is spotted. This will
bring side effects as the new logic would be reused for several other
error conditions.

One example is the IOTLB: when there's an IOTLB miss, get_tx_bufs()
might return -EAGAIN and exit the loop and see there's still available
buffers, so it will queue the tx work again until userspace feed the
IOTLB entry correctly. This will slowdown the tx processing and
trigger the TX watchdog in the guest as reported in
https://lkml.org/lkml/2025/9/10/1596.

To fix, revert the change. A follow up patch will bring the performance
back in a safe way.

Reported-by: Jon Kohler <jon@nutanix.com>
Cc: stable@vger.kernel.org
Fixes: 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after sendmsg")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20250917063045.2042-2-jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/net.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -760,10 +760,10 @@ static void handle_tx_copy(struct vhost_
 	int err;
 	int sent_pkts = 0;
 	bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
-	bool busyloop_intr;
 
 	do {
-		busyloop_intr = false;
+		bool busyloop_intr = false;
+
 		if (nvq->done_idx == VHOST_NET_BATCH)
 			vhost_tx_batch(net, nvq, sock, &msg);
 
@@ -774,10 +774,13 @@ static void handle_tx_copy(struct vhost_
 			break;
 		/* Nothing new?  Wait for eventfd to tell us they refilled. */
 		if (head == vq->num) {
-			/* Kicks are disabled at this point, break loop and
-			 * process any remaining batched packets. Queue will
-			 * be re-enabled afterwards.
-			 */
+			if (unlikely(busyloop_intr)) {
+				vhost_poll_queue(&vq->poll);
+			} else if (unlikely(vhost_enable_notify(&net->dev,
+								vq))) {
+				vhost_disable_notify(&net->dev, vq);
+				continue;
+			}
 			break;
 		}
 
@@ -827,22 +830,7 @@ done:
 		++nvq->done_idx;
 	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
 
-	/* Kicks are still disabled, dispatch any remaining batched msgs. */
 	vhost_tx_batch(net, nvq, sock, &msg);
-
-	if (unlikely(busyloop_intr))
-		/* If interrupted while doing busy polling, requeue the
-		 * handler to be fair handle_rx as well as other tasks
-		 * waiting on cpu.
-		 */
-		vhost_poll_queue(&vq->poll);
-	else
-		/* All of our work has been completed; however, before
-		 * leaving the TX handler, do one last check for work,
-		 * and requeue handler if necessary. If there is no work,
-		 * queue will be reenabled.
-		 */
-		vhost_net_busy_poll_try_queue(net, vq);
 }
 
 static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)


