Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827221;
	b=JnJlHCEz6E6TlDeWuzZ95+B/tJbaX3bLdrcdcub3I8tUqpV8+xlzQ5IqyEevPQa9EbzK
	 8SNTvXRQc9jp8pFskFm5qFdRfsfN0+i2CDIt1JCDwnwW7YhmWXGw58rFQtfQzlELXKZwY
	 thXUalKXgmiTB9kXHrYrNpQDYgp8Yc3HlVS0xJq0ovs2IxgDirpwX5i67vpU/TeaD/RYy
	 zUH8q2F9q0XoQSAvVI5zvYwdOF88t039O3t9ITPMtxVHaHEoByW0vj88pqCCnM2zNjizT
	 zvdH71BCYvOrUqMG+FlorinSI/o89I+91MgRMMgANRokI2+eRrf4qDHIMsKF/UDJ4Ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fOBngUzjIuefeyMVqZi0gsxED2LLyqcJVE0avmZAKMw=;
	b=2D72Olsp33mTLv6N9X6iah2Q7IW5aJu/R1mHMyAptRgXsgPm/9aKgj1QA3bb2viq4EOJ
	 JRg9844FgzXhwv+hVqRVrjxXBb7uFSv7gPKphYngOlfZJR6Sgn9cVCjkNw2wfjghMhy5q
	 dj7AykgnLdGt1Ufz83NMg1jrsR5AnQY4IzlaRttD9Q2iZRxmoYgCzVZ3yANC9oz49aZH4
	 f3+TsgrzlHHKebqH9DYXfQQVYSNl934NN4Su1E65eKgNj169kFzGEmtxiyNWyy2vOY0KD
	 oC96K2o6j7aRnT+0RA+nYHaNVMA0VJKWN9L9qRA4r+8i28efrLBFfRSaqHsMnCFPR8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qi5KyPqR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE39C606B3AF;
	Wed,  4 Nov 2026 21:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qi5KyPqR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADF91F00A17;
	Wed,  4 Nov 2026 21:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827220;
	bh=fOBngUzjIuefeyMVqZi0gsxED2LLyqcJVE0avmZAKMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qi5KyPqREpw29hQk8R89sJ4uXZOb2LryikHsDFME+ZgxkcArlvGTUW4n+wVdd6l2I
	 UsRYGNBsmtvfhrzNi0tA3ahCIjILMRSr6nSm1CqPWvsYlPDDJExDy4H0ei6YcsRCrW
	 yPyTXiMxrhTjrEmuizurSBnvH+GBmHVtdLYgQ2K0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 228/547] media: marvell: mcam: stop DMA and cancel s_bh_work before freeing DMA buffers
Date: Wed,  4 Nov 2026 16:06:52 -0500
Message-ID: <20261104211044.633874626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 0f29f84317c1e35f6a9265277be33e60d3fc8c1c upstream.

In vmalloc mode the frame-completion IRQ queues mcam_frame_work() on
cam->s_bh_work, which memcpy()s from the dma_bufs[] that
mcam_free_dma_bufs() frees with dma_free_coherent().  mccic_shutdown()
frees those buffers without stopping the controller, so while streaming
a late frame IRQ can re-arm the work after the buffers are gone, causing a
use-after-free.

Stop the controller in mccic_shutdown() when streaming is still active
(gated on an open fd, which holds a runtime-PM reference, so the device
is powered), cancel s_bh_work in mcam_free_dma_bufs(), and move
INIT_WORK() into mccic_register() before the device can be published.

Fixes: 67a8dbbc4e04 ("[media] marvell-cam: Basic working MMP camera driver")
Cc: stable@vger.kernel.org
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/marvell/mcam-core.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/marvell/mcam-core.c
+++ b/drivers/media/platform/marvell/mcam-core.c
@@ -406,6 +406,8 @@ static void mcam_free_dma_bufs(struct mc
 {
 	int i;
 
+	cancel_work_sync(&cam->s_bh_work);
+
 	for (i = 0; i < cam->nbufs; i++) {
 		dma_free_coherent(cam->dev, cam->dma_buf_size,
 				cam->dma_bufs[i], cam->dma_handles[i]);
@@ -1306,7 +1308,6 @@ static int mcam_setup_vb2(struct mcam_ca
 		break;
 	case B_vmalloc:
 #ifdef MCAM_MODE_VMALLOC
-		INIT_WORK(&cam->s_bh_work, mcam_frame_work);
 		vq->ops = &mcam_vb2_ops;
 		vq->mem_ops = &vb2_vmalloc_memops;
 		cam->dma_setup = mcam_ctlr_dma_vmalloc;
@@ -1864,6 +1865,12 @@ int mccic_register(struct mcam_camera *c
 		goto out;
 	}
 
+#ifdef MCAM_MODE_VMALLOC
+	/* Init before sensor bind: armed by IRQ, cancelled on probe-error paths. */
+	if (cam->buffer_mode == B_vmalloc)
+		INIT_WORK(&cam->s_bh_work, mcam_frame_work);
+#endif
+
 	mutex_init(&cam->s_mutex);
 	cam->state = S_NOTREADY;
 	mcam_set_config_needed(cam, 1);
@@ -1922,10 +1929,15 @@ void mccic_shutdown(struct mcam_camera *
 	 * take it down again will wedge the machine, which is frowned
 	 * upon.
 	 */
+	mutex_lock(&cam->s_mutex);
 	if (!list_empty(&cam->vdev.fh_list)) {
 		cam_warn(cam, "Removing a device with users!\n");
+		/* Stop so the IRQ can't re-arm s_bh_work after the buffers are freed. */
+		if (cam->state == S_STREAMING)
+			mcam_ctlr_stop_dma(cam);
 		sensor_call(cam, core, s_power, 0);
 	}
+	mutex_unlock(&cam->s_mutex);
 	if (cam->buffer_mode == B_vmalloc)
 		mcam_free_dma_bufs(cam);
 	v4l2_ctrl_handler_free(&cam->ctrl_handler);


