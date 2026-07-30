Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594BC431488;
	Thu, 30 Jul 2026 14:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422562; cv=none; b=fVH+/QqPWAJMyDCb7/E3oj9s05Uu6j1WbLN8jRvj3PdId+z5Er+cIeJAZMQqyf9gyDj3zv6jCy4QHNWS/+GuePI/rHHQrAV+LmmHzr+uxPId5WxKfmp56oRNN0ALGc85uu5H3ICN1HSdpRWLooqEII//ka1HY5Ay+y/8Ysics58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422562; c=relaxed/simple;
	bh=8Hhj+zpjbqK41Djw1E6BgDqHaruYLfbbIM73M+te6S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtclWGMsag77tYY5jl24myId5NEC0FPLrEEHcU0N9PGb/rYL/VK/NZG1VQTJeT8k6x3KOcFQ8IlD4Exiyz5t74JU4smWv+Wb0cLHMTELEWzfHA9zZGCasSiFCaA/+o1P44xKyt9erw6BnAHH4RKZMXbQswDeKbHG6J/fW04q4FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLJfUCZf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLJfUCZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDDD1F000E9;
	Thu, 30 Jul 2026 14:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422561;
	bh=HgJXpkYLLoyl0GagfiU7qnQlDsKKfDBU8KVcEwQsENI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLJfUCZfHpQq5P/7oWSEHKo8mCkVCIIKM1sjH1lCQ/lb3eRvsPEp1mzX2RLrhcaTV
	 9ORHIX0JdYR4Gf3xFtvwhoExoUNY9qk+Xc1hOIUswQzuR7YAgweARClOcLgTyi57KZ
	 X9R27Md5zpKO/IOj7kvJ14cSeMyNyJNAzlXPidGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brandon Brnich <b-brnich@ti.com>,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 481/744] media: chips-media: wave5: Move src_buf Removal to finish_encode
Date: Thu, 30 Jul 2026 16:12:34 +0200
Message-ID: <20260730141454.519234689@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brandon Brnich <b-brnich@ti.com>

commit b20157147089a9c16a38c7810e2fe6f2df8e3277 upstream.

During encoder processing, there is a case where the IRQ response could
return the buffer back to userspace via v4l2_m2m_buf_done call. In this
time, userspace could queue up this same buffer before start_encode removes
the index from the ready queue. This would then lead to a case where the
buffer in the ready queue could be a self loop due to the
WRITE_ONCE(prev->next, new) call in __list_add.

When __list_del is finally called, the loop is already made so nothing
points back to ready queue list head and pointers are poisoned.

A buffer should not be marked as DONE before the buffer is removed from
m2m ready queue. Move removal entirely to finish_encode.

Fixes: 9707a6254a8a6 ("media: chips-media: wave5: Add the v4l2 layer")
Cc: stable@vger.kernel.org
Signed-off-by: Brandon Brnich <b-brnich@ti.com>
Tested-by: Jackson Lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c |   29 ++-------------
 1 file changed, 4 insertions(+), 25 deletions(-)

--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
@@ -226,13 +226,6 @@ static int start_encode(struct vpu_insta
 	} else {
 		dev_dbg(inst->dev->dev, "%s: wave5_vpu_enc_start_one_frame success\n",
 			__func__);
-		/*
-		 * Remove the source buffer from the ready-queue now and finish
-		 * it in the videobuf2 framework once the index is returned by the
-		 * firmware in finish_encode
-		 */
-		if (src_buf)
-			v4l2_m2m_src_buf_remove_by_idx(m2m_ctx, src_buf->vb2_buf.index);
 	}
 
 	return 0;
@@ -259,27 +252,13 @@ static void wave5_vpu_enc_finish_encode(
 		__func__,  enc_output_info.pic_type, enc_output_info.recon_frame_index,
 		enc_output_info.enc_src_idx, enc_output_info.enc_pic_byte, enc_output_info.pts);
 
-	/*
-	 * The source buffer will not be found in the ready-queue as it has been
-	 * dropped after sending of the encode firmware command, locate it in
-	 * the videobuf2 queue directly
-	 */
 	if (enc_output_info.enc_src_idx >= 0) {
-		struct vb2_buffer *vb = vb2_get_buffer(v4l2_m2m_get_src_vq(m2m_ctx),
-						       enc_output_info.enc_src_idx);
-		if (vb->state != VB2_BUF_STATE_ACTIVE)
-			dev_warn(inst->dev->dev,
-				 "%s: encoded buffer (%d) was not in ready queue %i.",
-				 __func__, enc_output_info.enc_src_idx, vb->state);
-		else
-			src_buf = to_vb2_v4l2_buffer(vb);
-
-		if (src_buf) {
+		src_buf = v4l2_m2m_src_buf_remove_by_idx(m2m_ctx, enc_output_info.enc_src_idx);
+		if (!src_buf) {
+			dev_warn(inst->dev->dev, "%s: no source buffer found\n", __func__);
+		} else {
 			inst->timestamp = src_buf->vb2_buf.timestamp;
 			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
-		} else {
-			dev_warn(inst->dev->dev, "%s: no source buffer with index: %d found\n",
-				 __func__, enc_output_info.enc_src_idx);
 		}
 	}
 


