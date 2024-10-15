Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC941AF0B0;
	Tue, 15 Oct 2024 13:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997790; cv=none; b=bD5gGao+ellsHpKHEAV0SEx7GvAe/2S65Rb78KwnVan4Ihlm/+H6lS4bJ1PBCLRoKhisFewvr20BoRPjt2reEa+SfoV/3UhJO45TN2d9f0LKctePbl4h5S8NJQ95shDOUWHV4f/1td1b8PJ2Y3x6X5FcZJyc+qLM/bprZLoXlr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997790; c=relaxed/simple;
	bh=rcagSSZrBBTGdb+LiJexW9KbzwVsG3CZM3fFp084w/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MRwR61NiC84dWcXcdhbKD/NpYp5Ran4eSxbZl3bZVgwXvjBXu0EYNLHIEUoffTGT44ObWNYJsEaTPCQAoou4wTjTdBFkOj7FERXGkaXbRMeE1JE7ik5MZrGz5vaVrb2J5/SfXFO5vJmfRdqsJbNFFoDKwCTsbFplXxxKmn1+4v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLDblAXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLDblAXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16647C4CECF;
	Tue, 15 Oct 2024 13:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997790;
	bh=rcagSSZrBBTGdb+LiJexW9KbzwVsG3CZM3fFp084w/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLDblAXcvYsJtP3nHDFnNnCItvc/b8TsKMqk89Sk2RUKwNZrlGGUL2Mv3PL1zS2GC
	 leiT5ookEFy42aV7VUZ5WXLsGft+gV8n6Y9McRVGg2GJyf/wAub6LWZpbHkJobNTNB
	 R0Q9SFxPzEEkVU04tV2s4k9LZh2S12uvJYHKX8Ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 287/518] media: usbtv: Remove useless locks in usbtv_video_free()
Date: Tue, 15 Oct 2024 14:43:11 +0200
Message-ID: <20241015123928.066485746@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3b4a2e7692309..f2aaec0f77c8d 100644
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



