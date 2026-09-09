Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA72569F3C;
	Wed,  9 Sep 2026 14:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962742; cv=none; b=i8otplii8tP6iEisE6ARkZITBmZ2HzLmw+wXfUzmPYBxUvEhOTJOeBYh2d2DuJPaSggrx2FcCLiDBAWu3w/lKjZJ9CvsbXVgqq35rApmQRbqeLIe2u9RGEF/AEM8SX9wBdDgFz4PjOK80ICaDsZpWlqabaNdxQlfT72PCTDjTt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962742; c=relaxed/simple;
	bh=nK9MY9KXQ9Ft2lPUa3PcLBFreOrCn9v4uJn0Q3rrw4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxkCoavii/29nyeuEGK8I4sHlBoJGInDuH8f+AbGq07BDDjdzHli5rKcpXo0/qh6amEZ0zBOF+fM9/WtY53EsdU33KJRlhUEnBFP5rk9V5Sh4i8ENH6b92FqEYaxuM0wO6xJ8olKH/WWQHvTl2VQVcxOsR49N77rdvdZMVOCUYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=St/J0g7k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="St/J0g7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A591F00A3A;
	Wed,  9 Sep 2026 14:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962740;
	bh=0vJu8v/WCH2+pdGSaxvKrnEXAVNYmkJnDYS8KsGtDjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=St/J0g7kaLS+OItAY2fXhv0vjiTsKWBCl7OmNJ11VZSybiqA/ojf6KD0uCJ4XhnTK
	 YGtrridQ3MK9y4raBxk1Zh9d6Wnvr+Ia+cqT/usPMkxIqtcSkMYkWCjVBmPZ1fyaqJ
	 nSMsKvajiZMRoFZBYrYAV3ZGTtnOtCw5Eib2F0Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 396/556] media: ti: vpe: quiesce overflow recovery before freeing streams
Date: Wed,  9 Sep 2026 15:41:16 +0200
Message-ID: <20260909134244.581720150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit aeaacc3001449d44b4ab7da56331121d1f3b137b upstream.

The VIP overflow recovery worker is armed from the hardirq handler when a
FIFO overflow is detected, and the list-complete path looks the stream up
through the VPDMA list private pointer. Both keep touching stream, port
and device state; the recovery worker also resets the parser and VPDMA,
repopulates the descriptor list, and re-enables the per-list IRQs.

vip_stop_streaming() masks and clears the per-list IRQs, but it neither
synchronizes the hardirq handler nor disables recovery_work. An overflow
IRQ that has already queued recovery_work, or a list-complete IRQ in
flight when the stream is torn down, can therefore still dereference the
stream after its resources are released: the descriptor list is freed by
vip_release_stream() on file release, and the stream itself by
free_stream() on unbind/remove.

Drain the recovery worker and the IRQ handler at both teardown points
through a shared vip_quiesce_stream() helper, before any stream-owned
resource is released. disable_work_sync() cancels pending recovery_work,
drains a running instance, and raises its disable depth, so a subsequent
schedule_work() issued by a racing IRQ handler is rejected at the
workqueue scheduler: recovery_work cannot be requeued after
disable_work_sync() takes effect. The worker may still re-enable the
per-list IRQs before disable_work_sync() returns; disable_irqs() then
masks those sources and synchronize_irq() waits for any in-flight handler
that still dereferences stream state. In vip_stop_streaming() the helper
runs before the parser is stopped, since a worker drained by
disable_work_sync() may re-enable the parser before exiting and would
otherwise undo the stop. recovery_work is created disabled and enabled in
vip_start_streaming() before IRQs, pairing the enable with the teardown
disable across the streaming lifecycle.

This issue was found by an in-house static analysis tool and confirmed
by manual code review.

Fixes: fc2873aa4a21 ("media: ti: vpe: Add the VIP driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Tested-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/vpe/vip.c |   37 ++++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

--- a/drivers/media/platform/ti/vpe/vip.c
+++ b/drivers/media/platform/ti/vpe/vip.c
@@ -815,6 +815,22 @@ static void clear_irqs(struct vip_dev *d
 	vpdma_clear_list_stat(dev->shared->vpdma, irq_num, dev->slice_id);
 }
 
+/*
+ * Quiesce recovery work and per-list IRQs before releasing stream resources.
+ * disable_work_sync() prevents the overflow handler from requeueing recovery
+ * work. Mask and synchronize IRQs afterwards because a running worker may
+ * have re-enabled them before exiting.
+ */
+static void vip_quiesce_stream(struct vip_stream *stream)
+{
+	struct vip_dev *dev = stream->port->dev;
+
+	disable_work_sync(&stream->recovery_work);
+	disable_irqs(dev, dev->slice_id, stream->list_num);
+	clear_irqs(dev, dev->slice_id, stream->list_num);
+	synchronize_irq(dev->irq);
+}
+
 static void populate_desc_list(struct vip_stream *stream)
 {
 	struct vip_port *port = stream->port;
@@ -2429,6 +2445,7 @@ static int vip_start_streaming(struct vb
 		goto err;
 
 	stream->num_recovery = 0;
+	enable_work(&stream->recovery_work);
 
 	clear_irqs(dev, dev->slice_id, stream->list_num);
 	enable_irqs(dev, dev->slice_id, stream->list_num);
@@ -2453,13 +2470,17 @@ static void vip_stop_streaming(struct vb
 	struct vip_dev *dev = port->dev;
 	int ret;
 
+	/*
+	 * A running recovery worker may re-enable the parser, so quiesce it
+	 * and its IRQ handler before stopping the parser or releasing the
+	 * descriptor list.
+	 */
+	vip_quiesce_stream(stream);
+
 	vip_parser_stop_imm(port, true);
 	vip_enable_parser(port, false);
 	unset_fmt_params(stream);
 
-	disable_irqs(dev, dev->slice_id, stream->list_num);
-	clear_irqs(dev, dev->slice_id, stream->list_num);
-
 	if (port->subdev) {
 		ret = v4l2_subdev_call(port->subdev, video, s_stream, 0);
 		if (ret)
@@ -3075,6 +3096,8 @@ static int alloc_stream(struct vip_port
 		goto do_free_hwlist;
 
 	INIT_WORK(&stream->recovery_work, vip_overflow_recovery_work);
+	/* Start disabled; vip_start_streaming() enables it before IRQs. */
+	disable_work(&stream->recovery_work);
 
 	INIT_LIST_HEAD(&stream->vidq);
 
@@ -3140,6 +3163,13 @@ static void free_stream(struct vip_strea
 		return;
 
 	dev = stream->port->dev;
+	/*
+	 * Quiesce the IRQ handler and recovery worker, then drop the stream
+	 * from cap_streams[], before releasing stream-owned resources.
+	 */
+	vip_quiesce_stream(stream);
+	stream->port->cap_streams[stream->stream_id] = NULL;
+
 	/* Free up the Drop queue */
 	list_for_each_safe(pos, q, &stream->dropq) {
 		buf = list_entry(pos,
@@ -3151,7 +3181,6 @@ static void free_stream(struct vip_strea
 
 	video_unregister_device(stream->vfd);
 	vpdma_hwlist_release(dev->shared->vpdma, stream->list_num);
-	stream->port->cap_streams[stream->stream_id] = NULL;
 	kfree(stream);
 }
 


