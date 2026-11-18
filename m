Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018070;
	b=AK+Az4rmtc2Of5h4zCTlTiLU+Zw7irtdjNHXPfnx+WChKIfjRXFrkqage1zAw5n5SiSk
	 lNSTPn4k7bSywSsEElGTO6zy55MfQ6S6E2eyF0Xu6s1Tw4E8LI4TuODCpuyBLiPXlvS3L
	 +KuAXHq6IFLtw/4lyGMhEWyuFuxlvPlEDdZ+KcQorWiI8WvJbZCvi6rn/Cg85KH2v1cwA
	 1LpJyoavVjc3eceN5QK5CKPOva+m/LkG1M8COWc2ZyZCejxcZpsgEgQUcbxf+1rulNb7B
	 AQO/Q99HXZ9tooE/M0dTSG8S2JJCPAKWJH8SwdrhCwiD6qqg4sEg/Y2X9dWOnVQ+mSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bWR8Eu+sIx/qmvUsnDy+a/jpIl2bGnsDk4xLN25gG9Y=;
	b=i7y2Rhd8H8xTS7Q57tu8if+NbV2s9vT9tQBg63+SngSAu3cdzmmM9Xdp3QhSIBpUZZLm
	 0twLQZczQaQv4z1R15+Y13K0u5+0EoXnt+9b32zLyV6iWdAum/2r98B1/bPTt4VsBXQSn
	 9iMb8uhXPTGsGF+76W4kH3DgSd9QI7A2qVAEdWl4BBhV70xw51jo8WM1JYReiGctfUCxI
	 1YitOsBeoRTBImUigU7lt+Z8a47B6XlUQBda4VXpzdSgDL0zhlnsu1nrg5bmsDH6D15JY
	 CVY4nNn2mXquQn37ucQYs3O3dtDPxa4Oe/om1j/aTnm8zUAIk1ay9iHE6LpAeguEFoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kaLHDGH/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248CF60A5BD5;
	Wed, 18 Nov 2026 16:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kaLHDGH/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE481F000C5;
	Wed, 18 Nov 2026 16:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018070;
	bh=bWR8Eu+sIx/qmvUsnDy+a/jpIl2bGnsDk4xLN25gG9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kaLHDGH/DxDgA4XZOttChI5g68QnScIswAPuqPw8blgQzg7K1yg5A4DLAbdTFBeia
	 /ZaCZ4OHIisP9SSYW6gIcENCu/Mpfw8+TJSUYbWs6KX0pQ1uVAAKeAI5ZNgsjvbjHx
	 wT/7O8lVKkrKvu6g96gT3lEsanmhBgi3qT9GVzuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Snowhill <chris@kode54.net>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1109/2651] media: em28xx: hold the vb2 queue lock when releasing the queue on close
Date: Wed, 18 Nov 2026 15:39:09 +0100
Message-ID: <20261118150327.921611696@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Christopher Snowhill <chris@kode54.net>

[ Upstream commit 37f4b2004b9a22e70a289be77451f9f2b278142a ]

Commit de626073dfcb ("media: em28xx: drop 'users' field") replaced the
vb2_fop_release() call in em28xx_v4l2_close() with
_vb2_fop_release(filp, NULL) under dev->lock. vb2_fop_release() took
the vb2 queue lock, but the new call takes no lock at all.

The video and VBI queues have their own locks (vb_queue_lock and
vb_vbi_queue_lock), and v4l2_ioctl_get_lock() serializes the queue
ioctls with those rather than dev->lock. The queue can therefore be
released on close while another file handle is in the middle of
VIDIOC_REQBUFS. __vb2_queue_alloc() adds each buffer to the queue before
allocating its planes, so the release can find an MMAP buffer whose
mem_priv is still NULL and hand it to vb2_vmalloc_put():

  BUG: kernel NULL pointer dereference, address: 0000000000000020
  RIP: 0010:vb2_vmalloc_put+0xe/0x50 [videobuf2_vmalloc]
  Call Trace:
   __vb2_queue_free+0x14e/0x350 [videobuf2_common]
   vb2_core_queue_release+0x3b/0x80 [videobuf2_common]
   _vb2_fop_release+0x44/0x70 [videobuf2_v4l2]
   em28xx_v4l2_close+0x60/0x140 [em28xx_v4l]
   v4l2_release+0x9d/0xf0 [videodev]
   __fput+0xfd/0x280

This was hit with OBS on a MyGica iGrabber (card=105).

Pass the queue lock to _vb2_fop_release(). Taking it while holding
dev->lock matches the existing order in em28xx_v4l2_fini(), where
vb2_video_unregister_device() takes the queue lock under dev->lock.

Fixes: de626073dfcb ("media: em28xx: drop 'users' field")
Assisted-by: LLM
Signed-off-by: Christopher Snowhill <chris@kode54.net>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-video.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index e441f221dbb7a..e708d483137e2 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2474,6 +2474,7 @@ static int em28xx_v4l2_resume(struct em28xx *dev)
  */
 static int em28xx_v4l2_close(struct file *filp)
 {
+	struct video_device   *vdev = video_devdata(filp);
 	struct em28xx         *dev  = video_drvdata(filp);
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 	struct usb_device *udev = interface_to_usbdev(dev->intf);
@@ -2482,7 +2483,7 @@ static int em28xx_v4l2_close(struct file *filp)
 
 	mutex_lock(&dev->lock);
 	last_user = v4l2_fh_is_singular_file(filp);
-	_vb2_fop_release(filp, NULL);
+	_vb2_fop_release(filp, vdev->queue->lock);
 
 	if (last_user) {
 		/* No sense to try to write to the device */
-- 
2.53.0



