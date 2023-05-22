Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FAA2171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B36C4339B;
	Mon, 22 May 2023 19:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783465;
	bh=sOFCupPmco37yPY4TQcRSbwtpvyDHpYMv3Rmg9UkMo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1gjst4cJFFYmPgn/dW8JvgckCz+ZefChb9AEDcRQStohIhEenxUtaQfRbJEOq9Q8
	 mrVZnNMa4am/VBah4ImF53yTk/WOf8gLF4DNmpwsH/aA16Af0JBIEY0HcPkmwpKcts
	 byxT8m/cXQsXIod+uu64KGV0kc/sewD9GgwUQhFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	harperchen <harperchen1110@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 051/292] media: pci: tw68: Fix null-ptr-deref bug in buf prepare and finish
Date: Mon, 22 May 2023 20:06:48 +0100
Message-Id: <20230522190407.210880601@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: harperchen <harperchen1110@gmail.com>

[ Upstream commit 1634b7adcc5bef645b3666fdd564e5952a9e24e0 ]

When the driver calls tw68_risc_buffer() to prepare the buffer, the
function call dma_alloc_coherent may fail, resulting in a empty buffer
buf->cpu. Later when we free the buffer or access the buffer, null ptr
deref is triggered.

This bug is similar to the following one:
https://git.linuxtv.org/media_stage.git/commit/?id=2b064d91440b33fba5b452f2d1b31f13ae911d71.

We believe the bug can be also dynamically triggered from user side.
Similarly, we fix this by checking the return value of tw68_risc_buffer()
and the value of buf->cpu before buffer free.

Signed-off-by: harperchen <harperchen1110@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/tw68/tw68-video.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 0cbc5b038073b..773a18702d369 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -437,6 +437,7 @@ static void tw68_buf_queue(struct vb2_buffer *vb)
  */
 static int tw68_buf_prepare(struct vb2_buffer *vb)
 {
+	int ret;
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct tw68_dev *dev = vb2_get_drv_priv(vq);
@@ -452,30 +453,30 @@ static int tw68_buf_prepare(struct vb2_buffer *vb)
 	bpl = (dev->width * dev->fmt->depth) >> 3;
 	switch (dev->field) {
 	case V4L2_FIELD_TOP:
-		tw68_risc_buffer(dev->pci, buf, dma->sgl,
+		ret = tw68_risc_buffer(dev->pci, buf, dma->sgl,
 				 0, UNSET, bpl, 0, dev->height);
 		break;
 	case V4L2_FIELD_BOTTOM:
-		tw68_risc_buffer(dev->pci, buf, dma->sgl,
+		ret = tw68_risc_buffer(dev->pci, buf, dma->sgl,
 				 UNSET, 0, bpl, 0, dev->height);
 		break;
 	case V4L2_FIELD_SEQ_TB:
-		tw68_risc_buffer(dev->pci, buf, dma->sgl,
+		ret = tw68_risc_buffer(dev->pci, buf, dma->sgl,
 				 0, bpl * (dev->height >> 1),
 				 bpl, 0, dev->height >> 1);
 		break;
 	case V4L2_FIELD_SEQ_BT:
-		tw68_risc_buffer(dev->pci, buf, dma->sgl,
+		ret = tw68_risc_buffer(dev->pci, buf, dma->sgl,
 				 bpl * (dev->height >> 1), 0,
 				 bpl, 0, dev->height >> 1);
 		break;
 	case V4L2_FIELD_INTERLACED:
 	default:
-		tw68_risc_buffer(dev->pci, buf, dma->sgl,
+		ret = tw68_risc_buffer(dev->pci, buf, dma->sgl,
 				 0, bpl, bpl, bpl, dev->height >> 1);
 		break;
 	}
-	return 0;
+	return ret;
 }
 
 static void tw68_buf_finish(struct vb2_buffer *vb)
@@ -485,7 +486,8 @@ static void tw68_buf_finish(struct vb2_buffer *vb)
 	struct tw68_dev *dev = vb2_get_drv_priv(vq);
 	struct tw68_buf *buf = container_of(vbuf, struct tw68_buf, vb);
 
-	dma_free_coherent(&dev->pci->dev, buf->size, buf->cpu, buf->dma);
+	if (buf->cpu)
+		dma_free_coherent(&dev->pci->dev, buf->size, buf->cpu, buf->dma);
 }
 
 static int tw68_start_streaming(struct vb2_queue *q, unsigned int count)
-- 
2.39.2



