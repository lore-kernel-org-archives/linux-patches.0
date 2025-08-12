Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D6720409A;
	Tue, 12 Aug 2025 18:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024346; cv=none; b=aqjIcPDiH2cfJt1FDVZ0A/XTGS1xHfeKoov8mzmIqefndZtm4IOic0+iika9frSSF9TzYG9O0uTAYjpE+9T55+bqT2GUx7don1MxpsFUYsKldZ/WxHRmiUSOeyvBU0cS50ZZa8Kt7pU6GhV+KOhtcEBogPp0qQx8c4odIrxpf7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024346; c=relaxed/simple;
	bh=DC+Jt11nbF2Vt3eFQd2I9BaMN1r741Ge/SFctaTbqyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xjn0IsIFHnc5b/e3YeT+cGt5A3MXO5jSaUcUscf4icDGWPABbESkfRCesx/cNUI0hkAMpTe/gcKIleN2GawOA2/RfLisf5V3f+6QZJmqwNz7UEVwvRH8jFPNH7OrVUmKUhmV10bF6Em6d1DBaOuFcAKkdvyRx2R8dIoPhDd8JZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QCX+LS0k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QCX+LS0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478DFC4CEF0;
	Tue, 12 Aug 2025 18:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024345;
	bh=DC+Jt11nbF2Vt3eFQd2I9BaMN1r741Ge/SFctaTbqyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCX+LS0kZ/Ka/azULDqGesAtiGt6fqEnERK0iGCjQ0pHDvda6qGe8qSxc9S1xnn1z
	 GDZYRBO4Z2Rk95jsI0bwyBlz7Q7Er2bzJ7vfA4vRfRnlCCGaNr8uIY+62V1aYDEZtg
	 4Bli0HaH+JxYYR4FUMeDz5mVzlp79EbuVH1Hhvo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 313/627] media: imx-jpeg: Account for data_offset when getting image address
Date: Tue, 12 Aug 2025 19:30:08 +0200
Message-ID: <20250812173431.212036311@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ming Qian <ming.qian@oss.nxp.com>

[ Upstream commit 51ad3b570ea7b1916ff4db993f1aa22bb48fdac6 ]

Applications may set data_offset when it refers to an output queue. So
driver need to account for it when getting the start address of input
image in the plane.

Meanwhile the mxc-jpeg codec requires the address (plane address +
data_offset) to be 16-aligned.

Fixes: 2db16c6ed72c ("media: imx-jpeg: Add V4L2 driver for i.MX8 JPEG Encoder/Decoder")
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.c    | 47 ++++++++++++++-----
 .../media/platform/nxp/imx-jpeg/mxc-jpeg.h    |  1 +
 2 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
index 5c17bc58181e..8681dd193033 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -598,6 +598,27 @@ static void _bswap16(u16 *a)
 	*a = ((*a & 0x00FF) << 8) | ((*a & 0xFF00) >> 8);
 }
 
+static dma_addr_t mxc_jpeg_get_plane_dma_addr(struct vb2_buffer *buf, unsigned int plane_no)
+{
+	if (plane_no >= buf->num_planes)
+		return 0;
+	return vb2_dma_contig_plane_dma_addr(buf, plane_no) + buf->planes[plane_no].data_offset;
+}
+
+static void *mxc_jpeg_get_plane_vaddr(struct vb2_buffer *buf, unsigned int plane_no)
+{
+	if (plane_no >= buf->num_planes)
+		return NULL;
+	return vb2_plane_vaddr(buf, plane_no) + buf->planes[plane_no].data_offset;
+}
+
+static unsigned long mxc_jpeg_get_plane_payload(struct vb2_buffer *buf, unsigned int plane_no)
+{
+	if (plane_no >= buf->num_planes)
+		return 0;
+	return vb2_get_plane_payload(buf, plane_no) - buf->planes[plane_no].data_offset;
+}
+
 static void print_mxc_buf(struct mxc_jpeg_dev *jpeg, struct vb2_buffer *buf,
 			  unsigned long len)
 {
@@ -610,11 +631,11 @@ static void print_mxc_buf(struct mxc_jpeg_dev *jpeg, struct vb2_buffer *buf,
 		return;
 
 	for (plane_no = 0; plane_no < buf->num_planes; plane_no++) {
-		payload = vb2_get_plane_payload(buf, plane_no);
+		payload = mxc_jpeg_get_plane_payload(buf, plane_no);
 		if (len == 0)
 			len = payload;
-		dma_addr = vb2_dma_contig_plane_dma_addr(buf, plane_no);
-		vaddr = vb2_plane_vaddr(buf, plane_no);
+		dma_addr = mxc_jpeg_get_plane_dma_addr(buf, plane_no);
+		vaddr = mxc_jpeg_get_plane_vaddr(buf, plane_no);
 		v4l2_dbg(3, debug, &jpeg->v4l2_dev,
 			 "plane %d (vaddr=%p dma_addr=%x payload=%ld):",
 			  plane_no, vaddr, dma_addr, payload);
@@ -712,16 +733,15 @@ static void mxc_jpeg_addrs(struct mxc_jpeg_desc *desc,
 	struct mxc_jpeg_q_data *q_data;
 
 	q_data = mxc_jpeg_get_q_data(ctx, raw_buf->type);
-	desc->buf_base0 = vb2_dma_contig_plane_dma_addr(raw_buf, 0);
+	desc->buf_base0 = mxc_jpeg_get_plane_dma_addr(raw_buf, 0);
 	desc->buf_base1 = 0;
 	if (img_fmt == STM_CTRL_IMAGE_FORMAT(MXC_JPEG_YUV420)) {
 		if (raw_buf->num_planes == 2)
-			desc->buf_base1 = vb2_dma_contig_plane_dma_addr(raw_buf, 1);
+			desc->buf_base1 = mxc_jpeg_get_plane_dma_addr(raw_buf, 1);
 		else
 			desc->buf_base1 = desc->buf_base0 + q_data->sizeimage[0];
 	}
-	desc->stm_bufbase = vb2_dma_contig_plane_dma_addr(jpeg_buf, 0) +
-		offset;
+	desc->stm_bufbase = mxc_jpeg_get_plane_dma_addr(jpeg_buf, 0) + offset;
 }
 
 static bool mxc_jpeg_is_extended_sequential(const struct mxc_jpeg_fmt *fmt)
@@ -1029,8 +1049,8 @@ static irqreturn_t mxc_jpeg_dec_irq(int irq, void *priv)
 			vb2_set_plane_payload(&dst_buf->vb2_buf, 1, payload);
 		}
 		dev_dbg(dev, "Decoding finished, payload size: %ld + %ld\n",
-			vb2_get_plane_payload(&dst_buf->vb2_buf, 0),
-			vb2_get_plane_payload(&dst_buf->vb2_buf, 1));
+			mxc_jpeg_get_plane_payload(&dst_buf->vb2_buf, 0),
+			mxc_jpeg_get_plane_payload(&dst_buf->vb2_buf, 1));
 	}
 
 	/* short preview of the results */
@@ -1889,8 +1909,8 @@ static int mxc_jpeg_parse(struct mxc_jpeg_ctx *ctx, struct vb2_buffer *vb)
 	struct mxc_jpeg_sof *psof = NULL;
 	struct mxc_jpeg_sos *psos = NULL;
 	struct mxc_jpeg_src_buf *jpeg_src_buf = vb2_to_mxc_buf(vb);
-	u8 *src_addr = (u8 *)vb2_plane_vaddr(vb, 0);
-	u32 size = vb2_get_plane_payload(vb, 0);
+	u8 *src_addr = (u8 *)mxc_jpeg_get_plane_vaddr(vb, 0);
+	u32 size = mxc_jpeg_get_plane_payload(vb, 0);
 	int ret;
 
 	memset(&header, 0, sizeof(header));
@@ -2027,6 +2047,11 @@ static int mxc_jpeg_buf_prepare(struct vb2_buffer *vb)
 				i, vb2_plane_size(vb, i), sizeimage);
 			return -EINVAL;
 		}
+		if (!IS_ALIGNED(mxc_jpeg_get_plane_dma_addr(vb, i), MXC_JPEG_ADDR_ALIGNMENT)) {
+			dev_err(dev, "planes[%d] address is not %d aligned\n",
+				i, MXC_JPEG_ADDR_ALIGNMENT);
+			return -EINVAL;
+		}
 	}
 	if (V4L2_TYPE_IS_CAPTURE(vb->vb2_queue->type)) {
 		vb2_set_plane_payload(vb, 0, 0);
diff --git a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
index fdde45f7e163..44e46face6d1 100644
--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.h
@@ -30,6 +30,7 @@
 #define MXC_JPEG_MAX_PLANES		2
 #define MXC_JPEG_PATTERN_WIDTH		128
 #define MXC_JPEG_PATTERN_HEIGHT		64
+#define MXC_JPEG_ADDR_ALIGNMENT		16
 
 enum mxc_jpeg_enc_state {
 	MXC_JPEG_ENCODING	= 0, /* jpeg encode phase */
-- 
2.39.5



