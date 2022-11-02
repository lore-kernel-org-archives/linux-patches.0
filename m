Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FE3629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F26C43141;
	Wed,  2 Nov 2022 03:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359854;
	bh=4L5afp2iBOY29Y/hQwLTqhSkVs8Wa9v+bPu0UIttJHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsN47nh0ax8FH01DlUfL2C5xd4j1Stok16pma36igB4tj/Uztno6aqgGtT5jTuZoh
	 ykXMGy3Y5JWTbCRTWGwjZw21SvQKp59u1fTB3CDw8b9BEPAw4X4vLbNkX94Ae/maWl
	 3HWWtdWg1+8gzkcQf2YGg3xuCl171ZsBwunzXNJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 21/78] media: v4l2-mem2mem: Apply DST_QUEUE_OFF_BASE on MMAP buffers across ioctls
Date: Wed,  2 Nov 2022 03:34:06 +0100
Message-Id: <20221102022053.602910713@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen-Yu Tsai <wenst@chromium.org>

commit 8310ca94075e784bbb06593cd6c068ee6b6e4ca6 upstream.

DST_QUEUE_OFF_BASE is applied to offset/mem_offset on MMAP capture buffers
only for the VIDIOC_QUERYBUF ioctl, while the userspace fields (including
offset/mem_offset) are filled in for VIDIOC_{QUERY,PREPARE,Q,DQ}BUF
ioctls. This leads to differences in the values presented to userspace.
If userspace attempts to mmap the capture buffer directly using values
from DQBUF, it will fail.

Move the code that applies the magic offset into a helper, and call
that helper from all four ioctl entry points.

[hverkuil: drop unnecessary '= 0' in v4l2_m2m_querybuf() for ret]

Fixes: 7f98639def42 ("V4L/DVB: add memory-to-memory device helper framework for videobuf")
Fixes: 908a0d7c588e ("[media] v4l: mem2mem: port to videobuf2")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
[OP: adjusted return logic for 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c |   62 +++++++++++++++++++++++----------
 1 file changed, 45 insertions(+), 17 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -445,19 +445,14 @@ int v4l2_m2m_reqbufs(struct file *file,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_reqbufs);
 
-int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
-		      struct v4l2_buffer *buf)
+static void v4l2_m2m_adjust_mem_offset(struct vb2_queue *vq,
+				       struct v4l2_buffer *buf)
 {
-	struct vb2_queue *vq;
-	int ret = 0;
-	unsigned int i;
-
-	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	ret = vb2_querybuf(vq, buf);
-
 	/* Adjust MMAP memory offsets for the CAPTURE queue */
 	if (buf->memory == V4L2_MEMORY_MMAP && !V4L2_TYPE_IS_OUTPUT(vq->type)) {
 		if (V4L2_TYPE_IS_MULTIPLANAR(vq->type)) {
+			unsigned int i;
+
 			for (i = 0; i < buf->length; ++i)
 				buf->m.planes[i].m.mem_offset
 					+= DST_QUEUE_OFF_BASE;
@@ -465,8 +460,23 @@ int v4l2_m2m_querybuf(struct file *file,
 			buf->m.offset += DST_QUEUE_OFF_BASE;
 		}
 	}
+}
+
+int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		      struct v4l2_buffer *buf)
+{
+	struct vb2_queue *vq;
+	int ret;
 
-	return ret;
+	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
+	ret = vb2_querybuf(vq, buf);
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_querybuf);
 
@@ -478,10 +488,15 @@ int v4l2_m2m_qbuf(struct file *file, str
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
 	ret = vb2_qbuf(vq, buf);
-	if (!ret)
-		v4l2_m2m_try_schedule(m2m_ctx);
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	v4l2_m2m_try_schedule(m2m_ctx);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_qbuf);
 
@@ -489,9 +504,17 @@ int v4l2_m2m_dqbuf(struct file *file, st
 		   struct v4l2_buffer *buf)
 {
 	struct vb2_queue *vq;
+	int ret;
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
-	return vb2_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
+	ret = vb2_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
 
@@ -503,10 +526,15 @@ int v4l2_m2m_prepare_buf(struct file *fi
 
 	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
 	ret = vb2_prepare_buf(vq, buf);
-	if (!ret)
-		v4l2_m2m_try_schedule(m2m_ctx);
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	v4l2_m2m_try_schedule(m2m_ctx);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_prepare_buf);
 


