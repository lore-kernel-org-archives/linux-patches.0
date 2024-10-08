Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA32D1DE8B1;
	Tue,  8 Oct 2024 13:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393070; cv=none; b=ru4KoyT7o6MsfbydBVdtVaETXGLYrfy0nT6Oez/84B09UhLTy6URuMXrQYyvH0opxJwkvvMy6Fhk81QhNPfaKsajRP+Ag4z9hII+0/vHTYHivbKygKdrmD4daoVyvXUDcZMZ0Ns4PfBA18GZ+FD+FwIqDr7+sKLd7G+k3rRihKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393070; c=relaxed/simple;
	bh=0BZVx05jntKB86PsGGPwUuNaMMsSfOyw+82d+hh81Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StsYfh2XvHXto8Wd6lg3xE3YY9+kISS7F19FEFBF1YuxuIPBRls4U52dH50SdLMKbuPswQA4wuSWFx6ozQY0FSvUPz+CGS5Ofh5c1aKDksm2ovz0LjFlhVYKGbgoVTpIJ6/kCxDkASmb476Zt8KbrjfRGPIRUhVuEaaqEgnVw3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXoKBH6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXoKBH6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4991DC4CEC7;
	Tue,  8 Oct 2024 13:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393070;
	bh=0BZVx05jntKB86PsGGPwUuNaMMsSfOyw+82d+hh81Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXoKBH6d2RmF8U+66Ms5FED8mvcMmyoXPjFlmOQ64OYa/KIlTBWaPhhwPoRMoeGpo
	 yQo/h85lyVHC7zGqr78Sqn+s/588tK2C84b4bj6L95+H29ZKp9DbYSL95RnvLnrlWI
	 7sM+8TILcsk4MxKxAmf6tANjwond0R7eMQNAIVIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/386] media: usbtv: Remove useless locks in usbtv_video_free()
Date: Tue,  8 Oct 2024 14:04:48 +0200
Message-ID: <20241008115631.168037172@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1e30e05953dc6..7495df6b51912 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -962,15 +962,8 @@ int usbtv_video_init(struct usbtv *usbtv)
 
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



