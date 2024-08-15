Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EE31DDF5;
	Thu, 15 Aug 2024 13:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728548; cv=none; b=lMLHFSlQ6nqhtzBfAdtBjO0TwcWZbYflrj9JXnCeyQRbDq+vPRStke3g6b7DDApgU9MOfi0Wc8kLMKC0VEvcFMMOCJbCFbuhEfTU5wqL5O2wGy9K4W5M5VoUD5ENkzda2pTt5FPMAODHUcYsAI096dtOWizUkKmhZdf0lV+y6ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728548; c=relaxed/simple;
	bh=GKthvC6bh5LShMOM61iJ5mxl06EZ3YsxODG/K3zBCnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTo/6/kf0nkcjclQvYO1g/NHpDrtnImBh+lhOeRNfRK6Yl2Ynaw3Jy6EDTwQ0nGKnA7ipAqTFlhlnV9QIE7upcErk53C3vR+WvkSreCTB3p7fAio48JaWONvcLne8TSXEnJy1pSDCQi9URUjhkHs0Emqc3tXLxQnQHwOzDPDErQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2s7n/q96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2s7n/q96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9028BC32786;
	Thu, 15 Aug 2024 13:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728548;
	bh=GKthvC6bh5LShMOM61iJ5mxl06EZ3YsxODG/K3zBCnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2s7n/q96zRAKnV4LbY4Sgs9pEwJqovmGOxA6Us2HymFXodFakQqcUClJmpZHvkav5
	 ITGCz/SEwoJdMkFZsBswsbbxqOiZri3HkpXfi9OF+qewcGrBqkHMXO7/ns9Axaq7Mj
	 vT+Brh3aT5wUbN5JyUtM4m8/lhroZ8BrUj0ZFy7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 034/196] media: renesas: vsp1: Fix _irqsave and _irq mix
Date: Thu, 15 Aug 2024 15:22:31 +0200
Message-ID: <20240815131853.394061622@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit 57edbbcf5258c378a9b9d0c80d33b03a010b22c8 ]

The histogram support mixes _irqsave and _irq, causing the following
smatch warning:

     drivers/media/platform/renesas/vsp1/vsp1_histo.c:153 histo_stop_streaming()
     warn: mixing irqsave and irq

The histo_stop_streaming() calls spin_lock_irqsave() followed by
wait_event_lock_irq(). The former hints that interrupts may be disabled
by the caller, while the latter reenables interrupts unconditionally.
This doesn't cause any real bug, as the function is always called with
interrupts enabled, but the pattern is still incorrect.

Fix the problem by using spin_lock_irq() instead of spin_lock_irqsave()
in histo_stop_streaming(). While at it, switch to spin_lock_irq() and
spin_lock() as appropriate elsewhere.

Fixes: 99362e32332b ("[media] v4l: vsp1: Add histogram support")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-renesas-soc/164d74ff-312c-468f-be64-afa7182cd2f4@moroto.mountain/
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vsp1/vsp1_histo.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_histo.c b/drivers/media/platform/vsp1/vsp1_histo.c
index 5e15c8ff88d99..d1942163e650d 100644
--- a/drivers/media/platform/vsp1/vsp1_histo.c
+++ b/drivers/media/platform/vsp1/vsp1_histo.c
@@ -36,9 +36,8 @@ struct vsp1_histogram_buffer *
 vsp1_histogram_buffer_get(struct vsp1_histogram *histo)
 {
 	struct vsp1_histogram_buffer *buf = NULL;
-	unsigned long flags;
 
-	spin_lock_irqsave(&histo->irqlock, flags);
+	spin_lock(&histo->irqlock);
 
 	if (list_empty(&histo->irqqueue))
 		goto done;
@@ -49,7 +48,7 @@ vsp1_histogram_buffer_get(struct vsp1_histogram *histo)
 	histo->readout = true;
 
 done:
-	spin_unlock_irqrestore(&histo->irqlock, flags);
+	spin_unlock(&histo->irqlock);
 	return buf;
 }
 
@@ -58,7 +57,6 @@ void vsp1_histogram_buffer_complete(struct vsp1_histogram *histo,
 				    size_t size)
 {
 	struct vsp1_pipeline *pipe = histo->entity.pipe;
-	unsigned long flags;
 
 	/*
 	 * The pipeline pointer is guaranteed to be valid as this function is
@@ -70,10 +68,10 @@ void vsp1_histogram_buffer_complete(struct vsp1_histogram *histo,
 	vb2_set_plane_payload(&buf->buf.vb2_buf, 0, size);
 	vb2_buffer_done(&buf->buf.vb2_buf, VB2_BUF_STATE_DONE);
 
-	spin_lock_irqsave(&histo->irqlock, flags);
+	spin_lock(&histo->irqlock);
 	histo->readout = false;
 	wake_up(&histo->wait_queue);
-	spin_unlock_irqrestore(&histo->irqlock, flags);
+	spin_unlock(&histo->irqlock);
 }
 
 /* -----------------------------------------------------------------------------
@@ -124,11 +122,10 @@ static void histo_buffer_queue(struct vb2_buffer *vb)
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vsp1_histogram *histo = vb2_get_drv_priv(vb->vb2_queue);
 	struct vsp1_histogram_buffer *buf = to_vsp1_histogram_buffer(vbuf);
-	unsigned long flags;
 
-	spin_lock_irqsave(&histo->irqlock, flags);
+	spin_lock_irq(&histo->irqlock);
 	list_add_tail(&buf->queue, &histo->irqqueue);
-	spin_unlock_irqrestore(&histo->irqlock, flags);
+	spin_unlock_irq(&histo->irqlock);
 }
 
 static int histo_start_streaming(struct vb2_queue *vq, unsigned int count)
@@ -140,9 +137,8 @@ static void histo_stop_streaming(struct vb2_queue *vq)
 {
 	struct vsp1_histogram *histo = vb2_get_drv_priv(vq);
 	struct vsp1_histogram_buffer *buffer;
-	unsigned long flags;
 
-	spin_lock_irqsave(&histo->irqlock, flags);
+	spin_lock_irq(&histo->irqlock);
 
 	/* Remove all buffers from the IRQ queue. */
 	list_for_each_entry(buffer, &histo->irqqueue, queue)
@@ -152,7 +148,7 @@ static void histo_stop_streaming(struct vb2_queue *vq)
 	/* Wait for the buffer being read out (if any) to complete. */
 	wait_event_lock_irq(histo->wait_queue, !histo->readout, histo->irqlock);
 
-	spin_unlock_irqrestore(&histo->irqlock, flags);
+	spin_unlock_irq(&histo->irqlock);
 }
 
 static const struct vb2_ops histo_video_queue_qops = {
-- 
2.43.0



