Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7401D4154;
	Tue, 15 Oct 2024 11:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993401; cv=none; b=f5R6unQcaJoqgk1P0MsGn7XQMGIWnh0uoiq/uNJuH2w9c9PbWHhvRU7yC4PJSzp3Yh957cUmuXm8zpExR0JjxIXu8QDcodCNKud7GExRdEA+rQoolKydKxiIEyB9XHLbxTjw3l9S9h+zLqlOMipCxP389hBq22dsnEcwwSCXqr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993401; c=relaxed/simple;
	bh=U6CvHeLEyZjxVMzPMfXlSVSQpkmFrPb0bHHALdo76Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8I08GfxjufoftwObN2cpXo+9iSOVpqF9n06L1K77tVB9jAcNEXf7heOI3GkgQycBss43XoJCN8p9SVughJxSTke8hu9euBUCEgHwvBBbl6lvu5QKhzLgaKy4oEa6/voY0BQD2YuzljXcWT1QT8iu3EdHI2gEOdSCtwwTj6MvlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tda6u/HX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tda6u/HX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C1AC4CECF;
	Tue, 15 Oct 2024 11:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993401;
	bh=U6CvHeLEyZjxVMzPMfXlSVSQpkmFrPb0bHHALdo76Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tda6u/HXgzxJfaByq76SWwyY7iZT9ldtFSWhUFKN+8L/SZCmY4A0uiR+qisViaOVy
	 SeB1sjhQRFERtHn7YUTI6B1C/KNfjwyuhqMffx1fo+H29V6WlICmVLs9d6kKgz8Zor
	 Bh6LfUKXdLt/ooEg2+tfwIz75tyFhnYadIo+7cAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 400/691] media: usbtv: Remove useless locks in usbtv_video_free()
Date: Tue, 15 Oct 2024 13:25:48 +0200
Message-ID: <20241015112456.215217240@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

[ Upstream commit 65e6a2773d655172143cc0b927cdc89549842895 ]

Remove locks calls in usbtv_video_free() because
are useless and may led to a deadlock as reported here:
https://syzkaller.appspot.com/x/bisect.txt?x=166dc872180000
Also remove usbtv_stop() call since it will be called when
unregistering the device.

Before 'c838530d230b' this issue would only be noticed if you
disconnect while streaming and now it is noticeable even when
disconnecting while not streaming.

Fixes: c838530d230b ("media: media videobuf2: Be more flexible on the number of queue stored buffers")
Fixes: f3d27f34fdd7 ("[media] usbtv: Add driver for Fushicai USBTV007 video frame grabber")

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Tested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
[hverkuil: fix minor spelling mistake in log message]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/usbtv/usbtv-video.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index a714ad77ca8e2..e5fcf53229812 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -959,15 +959,8 @@ int usbtv_video_init(struct usbtv *usbtv)
 
 void usbtv_video_free(struct usbtv *usbtv)
 {
-	mutex_lock(&usbtv->vb2q_lock);
-	mutex_lock(&usbtv->v4l2_lock);
-
-	usbtv_stop(usbtv);
 	vb2_video_unregister_device(&usbtv->vdev);
 	v4l2_device_disconnect(&usbtv->v4l2_dev);
 
-	mutex_unlock(&usbtv->v4l2_lock);
-	mutex_unlock(&usbtv->vb2q_lock);
-
 	v4l2_device_put(&usbtv->v4l2_dev);
 }
-- 
2.43.0



