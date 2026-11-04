Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831471;
	b=U5WyOMnjkr8vii92uKw2ONfd/fSvrIekZf9Qhw6pby2a7SPKTQfGOVmo7mCi3C5922iL
	 O5PTkZZX0b4rxcUTMe93fMCsXqXygVjb3QFjlUTi0HWyw1KqX3IiNSjFbJ44WPyiWvkSp
	 2y+vzV2oc2DBvlocM6Px9L49U2d8BJe4m+KQQtKsBW6H12dgWGNgYznmIw7oIIa04+ref
	 TwfZsD6i+fkgXEPfstPexoUgFX/CIXv7SXQv+qRJsg9auTlXOlFQHNm65foqQXihahle3
	 nlJDiYCwXdGVJzjqf4099jjGyma2Itaq6mFwO0F8DuR/1BxGIb3l7g9Nnk7c83bkOwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=suRkRFzS4tVYpyfWvF+bKK3MtoyDT1HNLDJjCh+cpYw=;
	b=4+ALc71wTTaqjZYJlrJ9ysOHQ9T1KVhOEDbbNYbqTJV55XmeEWqZZpJBfSGa/By9bpls
	 xriZ5u+sLSCCFGcsD4zaBdW2+YkKtK0drgu2yZU6UoYwyPJ4XCAjg8ERretBqidB9JVNa
	 ZDYRbFC9ROy0OaJbWfHeLZsEPTPb+GX3DEd+c2HhEOAHmdWxxQxBKTR3ayBmXoEgmklXY
	 PnH6/CcY2NMQgjMts80HgIvSu5JSkLShR0mEUvQXEkXK/4HSgLACp11qQT9uQ7Dv69M+9
	 nveyFUHxDGHeIeU6Sv1VRBdF90nPm/hXNTYBPlF0XxwqLaM+tvcr0Hw5Rz55ZRppEyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=toMAHgo5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DA0606A335;
	Wed,  4 Nov 2026 22:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=toMAHgo5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E013F1F000C1;
	Wed,  4 Nov 2026 22:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831471;
	bh=suRkRFzS4tVYpyfWvF+bKK3MtoyDT1HNLDJjCh+cpYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=toMAHgo5WSwYMAZMnvyX0l/FBDhUPSvc0UaPNsCldMoXiFaNvfe4neusUg+dYLSsL
	 /SBRfhnWhhcjMs1GjGWbd1SYhqDGKFot5oOIpv/BiwzUOkKh13OHxFEq8vc//125UB
	 0Vz8er9lNmWogkKpcBT83uzV6yifoS23vDf4r6/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0724/1005] media: marvell: mcam: stop DMA and cancel s_bh_work before freeing DMA buffers
Date: Wed,  4 Nov 2026 16:07:37 -0500
Message-ID: <20261104211103.787985102@linuxfoundation.org>
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


