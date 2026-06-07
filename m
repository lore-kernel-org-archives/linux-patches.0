Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5E12DFF04;
	Sun,  7 Jun 2026 10:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829571; cv=none; b=A/2I8ml4l/Rca23WqVK9WTtAsxc1ogfc4ymdgjZBcEiSJ7SQxgnb//WfB9YCMSmFp+YO2AtvZXU3AS7v/ZA+uapDVaBoNqOzcKE/JBu/GSFkBbv4a6iLOQ6QysFNyV4NrOckFsSxwit/MvjarJl+WfBKvwiyo1aqOtyctGidWgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829571; c=relaxed/simple;
	bh=3HLLMIBeIhVZBNm9YzW6ItVt3T5IC/83zt5fT0s/6A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pc1CxugWAer5KDPHeFL+QXmn/Y7brzZSlzPEiILhlxA6bEntQoXZg4BuqAkq3yydwNSIqYxwQhSW8YqOEFgJMyURa37RzRV0b9ZXu+A0v5F0GHUUQ4jeM0TE3Tg/8DJpOwrys5w182kiDpfEvDnFV7w6zzeQt6y2M7HXlh+GuYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mb1NhGPM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mb1NhGPM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753FA1F00893;
	Sun,  7 Jun 2026 10:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829570;
	bh=rtykEwabUxoKMaprFQ7eT5j1j9FGu8H1lmdha66ZLew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mb1NhGPM1Fi5b64HWxZvf12FfPxeB0/ux5IC5T/UZOWTFdLsb1N7WTNG7O26xhED1
	 USHFTvRafD7QehBj1jItuBZhUGMXlzQw+TnQtG7BFXp1e4IunC1p0Cc1dxYmwmHhY1
	 G1+qaUY0kJoXDG01ZBXKFkpHsaWGzHCE1LkKDO+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>
Subject: [PATCH 6.12 236/307] usb: gadget: f_fs: serialize DMABUF cancel against request completion
Date: Sun,  7 Jun 2026 12:00:33 +0200
Message-ID: <20260607095736.369323304@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 2796646f6d892c1eb6818c7ca41fdfa12568e8d1 upstream.

ffs_epfile_dmabuf_io_complete() calls usb_ep_free_request() on the
completed request but leaves priv->req, the back-pointer that
ffs_dmabuf_transfer() set on submission, pointing at the freed
memory.  A later FUNCTIONFS_DMABUF_DETACH ioctl or
ffs_epfile_release() on the close path still sees priv->req
non-NULL under ffs->eps_lock:

    if (priv->ep && priv->req)
            usb_ep_dequeue(priv->ep, priv->req);

so usb_ep_dequeue() is called on a freed usb_request.

On dummy_hcd the dequeue path only walks a live queue and
pointer-compares, so the freed pointer reads without faulting and
KASAN requires an explicit check at the FunctionFS call site to
surface the use-after-free.  On SG-capable in-tree UDCs the
dequeue path dereferences the supplied request immediately:

  * chipidea's ep_dequeue() does
    container_of(req, struct ci_hw_req, req) and reads
    hwreq->req.status before acquiring its own lock.
  * cdnsp's cdnsp_gadget_ep_dequeue() reads request->status first.

The narrower option of clearing priv->req via cmpxchg() in the
completion does not close the race: the completion runs without
eps_lock, so a cancel path holding eps_lock can still observe
priv->req non-NULL, race a concurrent completion that clears and
frees, and pass the freed pointer to usb_ep_dequeue().  A slightly
longer fix that moves the free into the cleanup work is needed.

Same class of lifetime race as the recent usbip-vudc timer fix [1].

Take eps_lock in the sole place that mutates priv->req from the
callback direction by moving usb_ep_free_request() out of the
completion into ffs_dmabuf_cleanup(), the existing work handler
scheduled by ffs_dmabuf_signal_done() on
ffs->io_completion_wq.  Clear priv->req there under eps_lock
before freeing, and only clear if priv->req still names our
request (a subsequent ffs_dmabuf_transfer() on the same
attachment may have queued a new one).

This keeps the existing dummy_hcd sync-dequeue invariant: the
completion callback is still invoked by the UDC without
eps_lock held (dummy_hcd drops its own lock before calling the
callback), and the callback now takes no f_fs lock at all.
Serialization against the cancel path happens in cleanup, which
runs from the workqueue with no f_fs lock held on entry.

The priv ref count protects the containing ffs_dmabuf_priv:
ffs_dmabuf_transfer() takes a ref via ffs_dmabuf_get(), cleanup
drops it via ffs_dmabuf_put(), so priv stays live for the
cleanup even after the cancel path's list_del + ffs_dmabuf_put.

The ffs_dmabuf_transfer() error path no longer frees usb_req
inline: fence->req and fence->ep are set before usb_ep_queue(),
so ffs_dmabuf_cleanup() (scheduled by the error-path
ffs_dmabuf_signal_done()) owns the free regardless of whether
the queue succeeded.

Reproduced under KASAN on both detach and close paths against
dummy_hcd with an observability hook
(kasan_check_byte(priv->req) immediately before usb_ep_dequeue)
at the two FunctionFS cancel sites to surface the stale-pointer
access; the hook is not part of this patch.  The KASAN
allocator / free stacks in the captured splats identify the
same request: alloc in dummy_alloc_request, free in
dummy_timer, fault reached from ffs_epfile_release (close) and
from the FUNCTIONFS_DMABUF_DETACH ioctl (detach).  With the
patch applied, both paths are silent under the same hook.

The bug is reached from the FunctionFS device node, which in
real deployments is owned by the privileged gadget daemon
(adbd, UMS, composite gadget services, etc.); it is not
reachable from unprivileged userspace or from a USB host on the
cable.  FunctionFS mounts default to GLOBAL_ROOT_UID, but the
filesystem supports uid=, gid=, and fmode= delegation to a
non-root gadget daemon, so on real deployments the attacker may
be a less-privileged service rather than root.

Fixes: 7b07a2a7ca02 ("usb: gadget: functionfs: Add DMABUF import interface")
Link: https://lore.kernel.org/all/20260417163552.807548-1-michael.bommarito@gmail.com/ [1]
Cc: stable <stable@kernel.org>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260419161227.1587668-1-michael.bommarito@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -151,6 +151,8 @@ struct ffs_dma_fence {
 	struct dma_fence base;
 	struct ffs_dmabuf_priv *priv;
 	struct work_struct work;
+	struct usb_ep *ep;
+	struct usb_request *req;
 };
 
 struct ffs_epfile {
@@ -1375,6 +1377,21 @@ static void ffs_dmabuf_cleanup(struct wo
 	struct ffs_dmabuf_priv *priv = dma_fence->priv;
 	struct dma_buf_attachment *attach = priv->attach;
 	struct dma_fence *fence = &dma_fence->base;
+	struct usb_request *req = dma_fence->req;
+	struct usb_ep *ep = dma_fence->ep;
+
+	/*
+	 * eps_lock pairs with the cancel paths so they cannot pass a freed
+	 * req to usb_ep_dequeue().  Only clear if priv->req still names ours;
+	 * a re-queue on the same attachment may have taken that slot.
+	 */
+	spin_lock_irq(&priv->ffs->eps_lock);
+	if (priv->req == req)
+		priv->req = NULL;
+	spin_unlock_irq(&priv->ffs->eps_lock);
+
+	if (ep && req)
+		usb_ep_free_request(ep, req);
 
 	ffs_dmabuf_put(attach);
 	dma_fence_put(fence);
@@ -1404,8 +1421,8 @@ static void ffs_epfile_dmabuf_io_complet
 					  struct usb_request *req)
 {
 	pr_vdebug("FFS: DMABUF transfer complete, status=%d\n", req->status);
+	/* req is freed by ffs_dmabuf_cleanup() under eps_lock. */
 	ffs_dmabuf_signal_done(req->context, req->status);
-	usb_ep_free_request(ep, req);
 }
 
 static const char *ffs_dmabuf_get_driver_name(struct dma_fence *fence)
@@ -1689,6 +1706,10 @@ static int ffs_dmabuf_transfer(struct fi
 	usb_req->context  = fence;
 	usb_req->complete = ffs_epfile_dmabuf_io_complete;
 
+	/* ffs_dmabuf_cleanup() frees usb_req via these two fields. */
+	fence->req = usb_req;
+	fence->ep = ep->ep;
+
 	cookie = dma_fence_begin_signalling();
 	ret = usb_ep_queue(ep->ep, usb_req, GFP_ATOMIC);
 	dma_fence_end_signalling(cookie);
@@ -1698,7 +1719,6 @@ static int ffs_dmabuf_transfer(struct fi
 	} else {
 		pr_warn("FFS: Failed to queue DMABUF: %d\n", ret);
 		ffs_dmabuf_signal_done(fence, ret);
-		usb_ep_free_request(ep->ep, usb_req);
 	}
 
 	spin_unlock_irq(&epfile->ffs->eps_lock);


