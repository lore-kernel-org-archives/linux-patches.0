Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4783F927A;
	Fri, 15 May 2026 16:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862430; cv=none; b=C/jGIuvH4Nlx6ZvS7lZUXdMXvAAd6NPgpIibK6kqef+Lb/UIbwDNvHrZIdGCeNFC4KEg5PpDna4ke0pezCUKz7r1vyIHfW8dNyNQMb9i3eO83XdrhKZoX5LZbWckFaoO7lWpm1Vox/F5YI8FXUKSkSyeeA612QiqMrLUDRlyOFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862430; c=relaxed/simple;
	bh=Vh0ogmnOzRiOXJDmfsf26WgCOGeOcqHP0ga2pGuNt2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiPywHpVwn6tr95ekdlWaQA3Mrr9TwhWwEFK87eGOgaTY0YawuAjBdAvS69kdAB6U3xsTZ95PxMYU4om206qtvEltTrUVp10jWAgmohHLO6un52Y1u4fnNv18IGH+qiT9rLGHxaxPxf1Jyr2io6gvv3Kehsz3YY6bE8Sda2O7eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=we5nlg9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="we5nlg9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FD0C2BCB0;
	Fri, 15 May 2026 16:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862430;
	bh=Vh0ogmnOzRiOXJDmfsf26WgCOGeOcqHP0ga2pGuNt2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=we5nlg9U7+UfnkOMFh4jI7AK5oxC2kqhMf5Fdz9kLizX4K3PXdo1VZAA81qszxrn/
	 yim+zlwAEbdvqPD45CV0ef3/HmTEqiN524VeXKpeYp/gn0M1kIHmCVDW7YCow+TpeG
	 yDBbZ3ITpX9F/RwfUgLGq9uvrUJ75d7EozvEQD4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 009/201] media: rzv2h-ivc: Avoid double job scheduling
Date: Fri, 15 May 2026 17:47:07 +0200
Message-ID: <20260515154658.739059883@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>

commit b1de0940a19c1b0001425f8069d6a82369986af7 upstream.

The scheduling of a new buffer transfer in the IVC driver is triggered
by two occurrences of the "frame completed" interrupt.

The first interrupt occurrence identifies when all image data have been
transferred to the ISP, the second occurrence identifies when the
post-transfer VBLANK has completed and a new buffer can be transferred.

Under heavy system load conditions the actual execution of the workqueue
item might be delayed and two items might happen to run concurrently,
leading to a new frame transfer being triggered while the previous one
has not yet finished.

This error condition is only visible because the driver maintains a
status variable that counts the number of interrupts since the last
transfer, and warns in case an IRQ happens before the counter has been
reset.

To ensure sequential execution of the worqueue items and avoid a double
buffer transfer to run concurrently, protect the whole function body
with the spinlock that so far was solely used to reset the counter and
inspect the interrupt counter variable at the beginning of the buffer
transfer function.

As soon as the ongoing transfer completes, the workqueue item will be
re-scheduled and will consume the pending buffer.

Cc: stable@vger.kernel.org
Fixes: f0b3984d821b ("media: platform: Add Renesas Input Video Control block driver")
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c
+++ b/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c
@@ -149,6 +149,11 @@ static void rzv2h_ivc_transfer_buffer(st
 					     buffers.work);
 	struct rzv2h_ivc_buf *buf;
 
+	guard(spinlock_irqsave)(&ivc->spinlock);
+
+	if (ivc->vvalid_ifp)
+		return;
+
 	/* Setup buffers */
 	scoped_guard(spinlock_irqsave, &ivc->buffers.lock) {
 		buf = list_first_entry_or_null(&ivc->buffers.queue,
@@ -164,9 +169,7 @@ static void rzv2h_ivc_transfer_buffer(st
 	buf->addr = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
 	rzv2h_ivc_write(ivc, RZV2H_IVC_REG_AXIRX_SADDL_P0, buf->addr);
 
-	scoped_guard(spinlock_irqsave, &ivc->spinlock) {
-		ivc->vvalid_ifp = 2;
-	}
+	ivc->vvalid_ifp = 2;
 	rzv2h_ivc_write(ivc, RZV2H_IVC_REG_FM_FRCON, 0x1);
 }
 
@@ -201,7 +204,7 @@ static void rzv2h_ivc_buf_queue(struct v
 	}
 
 	scoped_guard(spinlock_irq, &ivc->spinlock) {
-		if (vb2_is_streaming(vb->vb2_queue) && !ivc->vvalid_ifp)
+		if (vb2_is_streaming(vb->vb2_queue))
 			queue_work(ivc->buffers.async_wq, &ivc->buffers.work);
 	}
 }


