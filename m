Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829522;
	b=S+6uRLC22UBGvw+p3KLyrBi6lpnMK3WAY/3sn7yFNJGO0lU92ulj8vNuJRJIouhJEoOc
	 qCtrL+L3pXGu+lLqPWe8JfU27WSZB7JdkA6SSam3moiz+TjBDolxixKfC+1lEAuExLPeT
	 8UdtACvLB/RhvKAa/D7VqAMaXwWUAXlP5iKRf/LP0LytwILlkiFKbfaG9pFbNbwCioTVM
	 X1D4hzEDU8FhhyA/KggwZo7juDMge9PMWnu91ImY0vT4Biy9vUXgcWKUDBpM7Z35BgzVW
	 WWKYmaYuwTtPV4zlbop6SUyWBS0FHt9bXvfDCbiGqgrQQ29/4Fi0oyjhF7CgsAhvVTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W/yUML+r9527t1toIQZ2uGLPoibeI2EXbZKUJbI2jhM=;
	b=V0eci6eR4GFXKoVoSv5QOWa60n7wvaMegnmNDKS5saxfGHqrLMoGPVosVkomexp6bNac
	 cLPQ9u8yhuzfNglZfnZ3/3YHP7sPMWbWn5DAqAw8jlEHPDbKOkVG+OJ7Ls5Z1g969pU08
	 kyE139a3BX3cJ37rGYSaZCTdRkKtUAqzWagz84KNbCZKGIkDKT0bW/CyNDgcnpT94Be7Y
	 NpAm+gbjjfMGNK5FcahWR0s8cH/dOAjPp+V+KS/6I720Po2+ISP7pURC42cYog/DMRHAH
	 VPjd41Q3YS52Kp6L2gl8DE0t1hKyJf9fyWG2xpSXMrIPc6Ja9odOYCxyV/MBgChqtqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0P5jDxi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE8F606AB38;
	Wed,  4 Nov 2026 21:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0P5jDxi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488851F0093A;
	Wed,  4 Nov 2026 21:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829521;
	bh=W/yUML+r9527t1toIQZ2uGLPoibeI2EXbZKUJbI2jhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D0P5jDxiBbAHwujQ/+/7bhShP5sfUYLDrWPGNvgB0ubLxhtPitrV0Bw1OwpokzwOQ
	 YFdMBb3bD8uWdm121S4B14yTGw90hy12ClAfue9vSUdGRq8l3mbvRwi9q7l8c/DwYb
	 bNcq+HUjoUeERekNINSYpM33HzJCkKRquoVjiRyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0139/1005] media: em28xx: requeue buffers if start_streaming fails
Date: Wed,  4 Nov 2026 15:57:52 -0500
Message-ID: <20261104211047.593030183@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit 67f87b104f4ef3108607ac9d8fa2075b13ed314d ]

If start_streaming fails, then all queued buffers must be
returned to vb2 in state QUEUED.

Otherwise it will trigger a WARN_ON.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Tested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-video.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index c8514682bccda..e0a69309687b0 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1070,6 +1070,9 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct em28xx *dev = vb2_get_drv_priv(vq);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
+	struct em28xx_dmaqueue *dmaq = vq->type == V4L2_BUF_TYPE_VBI_CAPTURE ?
+		&dev->vbiq : &dev->vidq;
+	unsigned long flags = 0;
 	struct v4l2_frequency f;
 	struct v4l2_fh *owner;
 	int rc = 0;
@@ -1084,7 +1087,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 	 */
 	rc = res_get(dev, vq->type);
 	if (rc)
-		return rc;
+		goto exit;
 
 	if (v4l2->streaming_users == 0) {
 		/* First active streaming user, so allocate all the URBs */
@@ -1107,7 +1110,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 					  em28xx_urb_data_copy);
 		if (rc < 0) {
 			res_free(dev, vq->type);
-			return rc;
+			goto exit;
 		}
 
 		/*
@@ -1132,7 +1135,18 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 	}
 
 	v4l2->streaming_users++;
+	return 0;
 
+exit:
+	spin_lock_irqsave(&dev->slock, flags);
+	while (!list_empty(&dmaq->active)) {
+		struct em28xx_buffer *buf;
+
+		buf = list_entry(dmaq->active.next, struct em28xx_buffer, list);
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
+	}
+	spin_unlock_irqrestore(&dev->slock, flags);
 	return rc;
 }
 
-- 
2.53.0



