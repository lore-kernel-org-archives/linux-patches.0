Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E34526CE11;
	Fri, 15 May 2026 16:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861858; cv=none; b=Nl2evKthuT7M0lku6TuP+1OMJzCLTYIkJzb/dNqLt05uamX3wqetXNA7vbJY4K82Eshm70xSedwrjzt1Dt2QXPuwM86lH5E9XDeqTwxxFlQstCjP47PphZNJnVApxzMVUwd9ZFkr1TojOdys6mcn9BDID3KEYyI6VfU6ABd8s9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861858; c=relaxed/simple;
	bh=Ouy3gQiDQJsBDF7TR2IDogjnFPIRsrjC1S48zYlGBPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cE1zlVgz9K0OABVzIJoNPco5tP9eeRmuxpVdgH8lbtX+xJ8foURPnAxeOb3Yn0K43AcZSCHpZmOvfVPavw7XZnYUFCZ1RVpG/YC1avKKerw2/u58dD96GNm1DdGKfQFLKlKqhrEd+pZVyreY8xghbcre1mn7+xadddq6i0icuOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdEYkGWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdEYkGWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E621BC2BCB0;
	Fri, 15 May 2026 16:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861858;
	bh=Ouy3gQiDQJsBDF7TR2IDogjnFPIRsrjC1S48zYlGBPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdEYkGWFA+Z3XKPi7l3VYxDp3IQImTvduTslj/RiEkBgaxjEhgLqQo8eLNpPAMd/2
	 4DJFJl3db5BQXFtxVWRGXAuwN5vsvj4xxAKTKD7Cc2gsZr7GJZB4S/HOhGZG0NTIG+
	 rnWv0kuXGpYExocvO3HRG4sAnyXDFSoymaS3jDG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 016/188] media: chips-media: wave5: add missing spinlock protection for send_eos_event()
Date: Fri, 15 May 2026 17:47:13 +0200
Message-ID: <20260515154657.659557242@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

commit f48050436746be75227fbc90066a8658cbe94d17 upstream.

Add spin_lock_irqsave()/spin_unlock_irqrestore() around send_eos_event()
calls in the VB2 buffer queue and streamoff callbacks to fix the missing
lock protection.

wave5_vpu_dec_buf_queue_dst() and streamoff_output() call send_eos_event()
without holding inst->state_spinlock. However, send_eos_event() has
lockdep_assert_held(&inst->state_spinlock) indicating that callers must
hold this lock.

Other callers of send_eos_event() properly acquire the spinlock:
- wave5_vpu_dec_finish_decode() acquires lock at line 431
- wave5_vpu_dec_encoder_cmd() acquires lock at line 821
- wave5_vpu_dec_device_run() acquires lock at line 1592

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Fixes: 9707a6254a8a6b ("media: chips-media: wave5: Add the v4l2 layer")
Cc: stable@vger.kernel.org
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -1265,13 +1265,17 @@ static void wave5_vpu_dec_buf_queue_dst(
 
 	if (vb2_is_streaming(vb->vb2_queue) && v4l2_m2m_dst_buf_is_last(m2m_ctx)) {
 		unsigned int i;
+		unsigned long flags;
 
 		for (i = 0; i < vb->num_planes; i++)
 			vb2_set_plane_payload(vb, i, 0);
 
 		vbuf->field = V4L2_FIELD_NONE;
 
+		spin_lock_irqsave(&inst->state_spinlock, flags);
 		send_eos_event(inst);
+		spin_unlock_irqrestore(&inst->state_spinlock, flags);
+
 		v4l2_m2m_last_buffer_done(m2m_ctx, vbuf);
 	} else {
 		v4l2_m2m_buf_queue(m2m_ctx, vbuf);
@@ -1415,8 +1419,13 @@ static int streamoff_output(struct vb2_q
 	inst->codec_info->dec_info.stream_rd_ptr = new_rd_ptr;
 	inst->codec_info->dec_info.stream_wr_ptr = new_rd_ptr;
 
-	if (v4l2_m2m_has_stopped(m2m_ctx))
+	if (v4l2_m2m_has_stopped(m2m_ctx)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&inst->state_spinlock, flags);
 		send_eos_event(inst);
+		spin_unlock_irqrestore(&inst->state_spinlock, flags);
+	}
 
 	/* streamoff on output cancels any draining operation */
 	inst->eos = false;


