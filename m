Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732B6431488;
	Thu, 30 Jul 2026 14:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422656; cv=none; b=rNJ3pvY51OtbHDYFrhgCOidg/hHLYylKyqLS3s4y1RBW3yKe0OkTcdqXNwV8LqB9X6F9IsTlrsGbhJ+Dzwr5lt1XHrs0NTg23nTNlAO/08rld9JZxhM1yk3OMjjRaG1ESYYhV69PcwnrzfQ0F1dc4v0CAw5rYCWkUbt1bGw14To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422656; c=relaxed/simple;
	bh=iruu7euPmjD8ZzwRcOz4GWHwVPDZr8o8fOwo3BTTyxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BssThx+0C7vRHQ5eH1m1GegsxoS5oxgugQ5TNz7e2EoBOAuPa4prLuTTmcIjfr1ehUdFa/Cb6EKVXLT4bmdcLeA3fD3avMKYATPSekBB7Swmkr3wfcC/mIiIr1nK8ufux1Fm6DYOW50xc1phoJ2BPcDu9mxcjAsZHKD3OdPSggU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZphdheRK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZphdheRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF63F1F00AC4;
	Thu, 30 Jul 2026 14:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422655;
	bh=K02DoIT0iXR8PcVMxaOLDTVpfOhi9etCEWj0MM7j5uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZphdheRKaUcqNsJHLkr1tAB/Lv64hj/mFma5t9oL6UY/z+EQdMoEqqaLigv5czZck
	 HZXvdKroXQAlSc71zjsfpFF8mlw0cmlajkaEOgbo0LQEgGN9OrwvEY8VkyN83RiaBW
	 gV0iz/AkofSTbCA/mU32ShLPDmG5apMid9aLs3jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 514/744] media: rzv2h-ivc: Wait for frame end in stop_streaming
Date: Thu, 30 Jul 2026 16:13:07 +0200
Message-ID: <20260730141455.202869965@linuxfoundation.org>
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

From: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>

commit b4e6ddce16b8ae0ddbec7c96c675779260ad4697 upstream.

The rzv2h-ivc driver fails to handle back-2-back streaming sessions that
do not go through a peripheral reset. As the driver uses an autosuspend
delay of 2 seconds, it is quite possible that two consecutive streaming
sessions won't go through a suspend/resume sequence.

If the peripheral is not reset the second streaming session hangs and no
frames are delivered to the ISP.

This is because the stop_streaming() procedure implemented in the driver
doesn't match what's prescribed by the chip datasheet:

1) The chip manual suggests to poll the RZV2H_IVC_FM_INT_STAT_STPEND bit
   of RZV2H_IVC_REG_FM_INT_STA instead of polling on RZV2H_IVC_REG_FM_STOP
   and prescribes to clear the bit after polling has completed

2) More importantly: the RZV2H_IVC_REG_FM_STOP_FSTOP bit has to be set
   on RZV2H_IVC_REG_FM_STOP -only- if a frame transfer to the ISP is in
   progress. Setting the RZV2H_IVC_REG_FM_STOP_FSTOP bit when no frame is
   being transferred causes the polling routine to timeout and the next
   streaming session fails to start

As a frame transfer of an image in 1920x1080@10bi takes 5 milliseconds
at most, it is quite possible that the frame transfer completion interrupt
races with the stop procedure.

Instead of forcing a frame transfer abort, simply wait for the
in-progress transfer to complete by polling the ivc->vvalid_ifp status
variable in an hand-rolled loop that allows to inspect the variable
while holding the spinlock, to allow the irq handler to complete the
current buffer.

With this change, streaming back-2-back without suspending the
peripheral works successfully.

Cc: stable@vger.kernel.org
Fixes: f0b3984d821b ("media: platform: Add Renesas Input Video Control block driver")
Signed-off-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../renesas/rzv2h-ivc/rzv2h-ivc-video.c       | 31 ++++++++++++++++---
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c b/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c
index b167f1bab7ef..932fed38cf3f 100644
--- a/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c
+++ b/drivers/media/platform/renesas/rzv2h-ivc/rzv2h-ivc-video.c
@@ -297,12 +297,33 @@ static int rzv2h_ivc_start_streaming(struct vb2_queue *q, unsigned int count)
 static void rzv2h_ivc_stop_streaming(struct vb2_queue *q)
 {
 	struct rzv2h_ivc *ivc = vb2_get_drv_priv(q);
-	u32 val = 0;
+	unsigned int loop = 5;
 
-	rzv2h_ivc_write(ivc, RZV2H_IVC_REG_FM_STOP, RZV2H_IVC_REG_FM_STOP_FSTOP);
-	readl_poll_timeout(ivc->base + RZV2H_IVC_REG_FM_STOP,
-			   val, !(val & RZV2H_IVC_REG_FM_STOP_FSTOP),
-			   10 * USEC_PER_MSEC, 250 * USEC_PER_MSEC);
+	/*
+	 * If no frame transfer is in progress, we're done, otherwise, wait for
+	 * the transfer to complete.
+	 *
+	 * Transferring a 1920x1080@10bit frame to the ISP takes less than 5
+	 * msec so sleep for 2.5 msec (+- 25%) and give up after 5 attempts.
+	 */
+	for (; loop > 0; loop--) {
+		unsigned int vvalid_ifp;
+
+		/*
+		 * Inspect the ivc->vvalid_ifp variable holding the spinlock not
+		 * to the race with the rzv2h_ivc_buffer_done() call in the irq
+		 * handler.
+		 */
+		scoped_guard(spinlock_irq, &ivc->spinlock) {
+			vvalid_ifp = ivc->vvalid_ifp;
+		}
+		if (vvalid_ifp < 2)
+			break;
+
+		fsleep(2500);
+	}
+	if (!loop)
+		dev_err(ivc->dev, "Failed to stop streaming\n");
 
 	rzv2h_ivc_return_buffers(ivc, VB2_BUF_STATE_ERROR);
 	video_device_pipeline_stop(&ivc->vdev.dev);
-- 
2.55.0



