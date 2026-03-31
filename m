Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AA03F8E04;
	Tue, 31 Mar 2026 16:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976102; cv=none; b=IvF5dOeQTwV87ksZ4y3MbdxVOzwwR1Ree8nC+YA2lusqDrr+Tjl4ALVCt3sQXP2xi9dDLBtSYSs0oFpNwHIMmsodfqXLp5H9fvZXEti0wShZkUzmmKPe+MpD283ZygEF7kGGCWlbvOoVfiYukSdMQm5Jcd4NqYK58CaV/dsPGNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976102; c=relaxed/simple;
	bh=YpBwcZ4qaX1N93PxUb7csOdo3dZle2A41i4q0YQjLJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nVoLghdogzeiP1LDUkk+2pB/e9TnIIEh6P7UgoE8897Iv+qYHc8HWnkxGLoZNlT31THLDN4bRSeXXBe9VH7wY1XdxFt1WCqdBh1SyOtt8hJXu+z34COJv9caea45agW/GvGdZ2etO2X7sNQGYOC1pEwcCmYpJJA8IZbU3IEeWv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOsmUfIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOsmUfIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C63AC19423;
	Tue, 31 Mar 2026 16:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976101;
	bh=YpBwcZ4qaX1N93PxUb7csOdo3dZle2A41i4q0YQjLJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOsmUfISZ0HkwXxOIuTmMGtUJSLJO36w6bNB0I3IcpmkflRB1vJvnDnOLk+n5irUq
	 8bXXpsnIx/RamkoziqYazeK5ThdArwQFKq1blHUkuh5MdT1Xswq95/GY3FUHBWegCl
	 1p44ckpogGEIiyOw6cslrQ0nbqJfUWaHS2PMTLKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Richard Leitner" <richard.leitner@linux.dev>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 6.12 206/244] media: nxp: imx8-isi: Fix streaming cleanup on release
Date: Tue, 31 Mar 2026 18:22:36 +0200
Message-ID: <20260331161749.362127531@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Leitner <richard.leitner@linux.dev>

[ Upstream commit 47773031a148ad7973b809cc7723cba77eda2b42 ]

The current implementation unconditionally calls
mxc_isi_video_cleanup_streaming() in mxc_isi_video_release(). This can
lead to situations where any release call (like from a simple
"v4l2-ctl -l") may release a currently streaming queue when called on
such a device.

This is reproducible on an i.MX8MP board by streaming from an ISI
capture device using gstreamer:

	gst-launch-1.0 -v v4l2src device=/dev/videoX ! \
	    video/x-raw,format=GRAY8,width=1280,height=800,framerate=1/120 ! \
	    fakesink

While this stream is running, querying the caps of the same device
provokes the error state:

	v4l2-ctl -l -d /dev/videoX

This results in the following trace:

[  155.452152] ------------[ cut here ]------------
[  155.452163] WARNING: CPU: 0 PID: 1708 at drivers/media/platform/nxp/imx8-isi/imx8-isi-pipe.c:713 mxc_isi_pipe_irq_handler+0x19c/0x1b0 [imx8_isi]
[  157.004248] Modules linked in: cfg80211 rpmsg_ctrl rpmsg_char rpmsg_tty virtio_rpmsg_bus rpmsg_ns rpmsg_core rfkill nft_ct nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables mcp251x6
[  157.053499] CPU: 0 UID: 0 PID: 1708 Comm: python3 Not tainted 6.15.4-00114-g1f61ca5cad76 #1 PREEMPT
[  157.064369] Hardware name: imx8mp_board_01 (DT)
[  157.068205] pstate: 400000c5 (nZcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  157.075169] pc : mxc_isi_pipe_irq_handler+0x19c/0x1b0 [imx8_isi]
[  157.081195] lr : mxc_isi_pipe_irq_handler+0x38/0x1b0 [imx8_isi]
[  157.087126] sp : ffff800080003ee0
[  157.090438] x29: ffff800080003ee0 x28: ffff0000c3688000 x27: 0000000000000000
[  157.097580] x26: 0000000000000000 x25: ffff0000c1e7ac00 x24: ffff800081b5ad50
[  157.104723] x23: 00000000000000d1 x22: 0000000000000000 x21: ffff0000c25e4000
[  157.111866] x20: 0000000060000200 x19: ffff80007a0608d0 x18: 0000000000000000
[  157.119008] x17: ffff80006a4e3000 x16: ffff800080000000 x15: 0000000000000000
[  157.126146] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
[  157.133287] x11: 0000000000000040 x10: ffff0000c01445f0 x9 : ffff80007a053a38
[  157.140425] x8 : ffff0000c04004b8 x7 : 0000000000000000 x6 : 0000000000000000
[  157.147567] x5 : ffff0000c0400490 x4 : ffff80006a4e3000 x3 : ffff0000c25e4000
[  157.154706] x2 : 0000000000000000 x1 : ffff8000825c0014 x0 : 0000000060000200
[  157.161850] Call trace:
[  157.164296]  mxc_isi_pipe_irq_handler+0x19c/0x1b0 [imx8_isi] (P)
[  157.170319]  __handle_irq_event_percpu+0x58/0x218
[  157.175029]  handle_irq_event+0x54/0xb8
[  157.178867]  handle_fasteoi_irq+0xac/0x248
[  157.182968]  handle_irq_desc+0x48/0x68
[  157.186723]  generic_handle_domain_irq+0x24/0x38
[  157.191346]  gic_handle_irq+0x54/0x120
[  157.195098]  call_on_irq_stack+0x24/0x30
[  157.199027]  do_interrupt_handler+0x88/0x98
[  157.203212]  el0_interrupt+0x44/0xc0
[  157.206792]  __el0_irq_handler_common+0x18/0x28
[  157.211328]  el0t_64_irq_handler+0x10/0x20
[  157.215429]  el0t_64_irq+0x198/0x1a0
[  157.219009] ---[ end trace 0000000000000000 ]---

Address this issue by moving the streaming preparation and cleanup to
the vb2 .prepare_streaming() and .unprepare_streaming() operations. This
also simplifies the driver by allowing direct usage of the
vb2_ioctl_streamon() and vb2_ioctl_streamoff() helpers, and removal of
the manual cleanup from mxc_isi_video_release().

Link: https://lore.kernel.org/r/20250813212451.22140-2-laurent.pinchart@ideasonboard.com
Signed-off-by: Richard Leitner <richard.leitner@linux.dev>
Co-developed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Richard Leitner <richard.leitner@linux.dev> # i.MX8MP
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ Minor context change fixed. ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c |  156 +++++++------------
 1 file changed, 58 insertions(+), 98 deletions(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
@@ -937,6 +937,49 @@ static void mxc_isi_video_init_channel(s
 	mxc_isi_channel_set_output_format(pipe, video->fmtinfo, &video->pix);
 }
 
+static int mxc_isi_vb2_prepare_streaming(struct vb2_queue *q)
+{
+	struct mxc_isi_video *video = vb2_get_drv_priv(q);
+	struct media_device *mdev = &video->pipe->isi->media_dev;
+	struct media_pipeline *pipe;
+	int ret;
+
+	/* Get a pipeline for the video node and start it. */
+	scoped_guard(mutex, &mdev->graph_mutex) {
+		ret = mxc_isi_pipe_acquire(video->pipe,
+					   &mxc_isi_video_frame_write_done);
+		if (ret)
+			return ret;
+
+		pipe = media_entity_pipeline(&video->vdev.entity)
+		     ? : &video->pipe->pipe;
+
+		ret = __video_device_pipeline_start(&video->vdev, pipe);
+		if (ret)
+			goto err_release;
+	}
+
+	/* Verify that the video format matches the output of the subdev. */
+	ret = mxc_isi_video_validate_format(video);
+	if (ret)
+		goto err_stop;
+
+	/* Allocate buffers for discard operation. */
+	ret = mxc_isi_video_alloc_discard_buffers(video);
+	if (ret)
+		goto err_stop;
+
+	video->is_streaming = true;
+
+	return 0;
+
+err_stop:
+	video_device_pipeline_stop(&video->vdev);
+err_release:
+	mxc_isi_pipe_release(video->pipe);
+	return ret;
+}
+
 static int mxc_isi_vb2_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct mxc_isi_video *video = vb2_get_drv_priv(q);
@@ -985,6 +1028,17 @@ static void mxc_isi_vb2_stop_streaming(s
 	mxc_isi_video_return_buffers(video, VB2_BUF_STATE_ERROR);
 }
 
+static void mxc_isi_vb2_unprepare_streaming(struct vb2_queue *q)
+{
+	struct mxc_isi_video *video = vb2_get_drv_priv(q);
+
+	mxc_isi_video_free_discard_buffers(video);
+	video_device_pipeline_stop(&video->vdev);
+	mxc_isi_pipe_release(video->pipe);
+
+	video->is_streaming = false;
+}
+
 static const struct vb2_ops mxc_isi_vb2_qops = {
 	.queue_setup		= mxc_isi_vb2_queue_setup,
 	.buf_init		= mxc_isi_vb2_buffer_init,
@@ -992,8 +1046,10 @@ static const struct vb2_ops mxc_isi_vb2_
 	.buf_queue		= mxc_isi_vb2_buffer_queue,
 	.wait_prepare		= vb2_ops_wait_prepare,
 	.wait_finish		= vb2_ops_wait_finish,
+	.prepare_streaming	= mxc_isi_vb2_prepare_streaming,
 	.start_streaming	= mxc_isi_vb2_start_streaming,
 	.stop_streaming		= mxc_isi_vb2_stop_streaming,
+	.unprepare_streaming	= mxc_isi_vb2_unprepare_streaming,
 };
 
 /* -----------------------------------------------------------------------------
@@ -1147,97 +1203,6 @@ static int mxc_isi_video_s_fmt(struct fi
 	return 0;
 }
 
-static int mxc_isi_video_streamon(struct file *file, void *priv,
-				  enum v4l2_buf_type type)
-{
-	struct mxc_isi_video *video = video_drvdata(file);
-	struct media_device *mdev = &video->pipe->isi->media_dev;
-	struct media_pipeline *pipe;
-	int ret;
-
-	if (vb2_queue_is_busy(&video->vb2_q, file))
-		return -EBUSY;
-
-	/*
-	 * Get a pipeline for the video node and start it. This must be done
-	 * here and not in the queue .start_streaming() handler, so that
-	 * pipeline start errors can be reported from VIDIOC_STREAMON and not
-	 * delayed until subsequent VIDIOC_QBUF calls.
-	 */
-	mutex_lock(&mdev->graph_mutex);
-
-	ret = mxc_isi_pipe_acquire(video->pipe, &mxc_isi_video_frame_write_done);
-	if (ret) {
-		mutex_unlock(&mdev->graph_mutex);
-		return ret;
-	}
-
-	pipe = media_entity_pipeline(&video->vdev.entity) ? : &video->pipe->pipe;
-
-	ret = __video_device_pipeline_start(&video->vdev, pipe);
-	if (ret) {
-		mutex_unlock(&mdev->graph_mutex);
-		goto err_release;
-	}
-
-	mutex_unlock(&mdev->graph_mutex);
-
-	/* Verify that the video format matches the output of the subdev. */
-	ret = mxc_isi_video_validate_format(video);
-	if (ret)
-		goto err_stop;
-
-	/* Allocate buffers for discard operation. */
-	ret = mxc_isi_video_alloc_discard_buffers(video);
-	if (ret)
-		goto err_stop;
-
-	ret = vb2_streamon(&video->vb2_q, type);
-	if (ret)
-		goto err_free;
-
-	video->is_streaming = true;
-
-	return 0;
-
-err_free:
-	mxc_isi_video_free_discard_buffers(video);
-err_stop:
-	video_device_pipeline_stop(&video->vdev);
-err_release:
-	mxc_isi_pipe_release(video->pipe);
-	return ret;
-}
-
-static void mxc_isi_video_cleanup_streaming(struct mxc_isi_video *video)
-{
-	lockdep_assert_held(&video->lock);
-
-	if (!video->is_streaming)
-		return;
-
-	mxc_isi_video_free_discard_buffers(video);
-	video_device_pipeline_stop(&video->vdev);
-	mxc_isi_pipe_release(video->pipe);
-
-	video->is_streaming = false;
-}
-
-static int mxc_isi_video_streamoff(struct file *file, void *priv,
-				   enum v4l2_buf_type type)
-{
-	struct mxc_isi_video *video = video_drvdata(file);
-	int ret;
-
-	ret = vb2_ioctl_streamoff(file, priv, type);
-	if (ret)
-		return ret;
-
-	mxc_isi_video_cleanup_streaming(video);
-
-	return 0;
-}
-
 static int mxc_isi_video_enum_framesizes(struct file *file, void *priv,
 					 struct v4l2_frmsizeenum *fsize)
 {
@@ -1293,9 +1258,8 @@ static const struct v4l2_ioctl_ops mxc_i
 	.vidioc_expbuf			= vb2_ioctl_expbuf,
 	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
 	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
-
-	.vidioc_streamon		= mxc_isi_video_streamon,
-	.vidioc_streamoff		= mxc_isi_video_streamoff,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
 
 	.vidioc_enum_framesizes		= mxc_isi_video_enum_framesizes,
 
@@ -1334,10 +1298,6 @@ static int mxc_isi_video_release(struct
 	if (ret)
 		dev_err(video->pipe->isi->dev, "%s fail\n", __func__);
 
-	mutex_lock(&video->lock);
-	mxc_isi_video_cleanup_streaming(video);
-	mutex_unlock(&video->lock);
-
 	pm_runtime_put(video->pipe->isi->dev);
 	return ret;
 }


