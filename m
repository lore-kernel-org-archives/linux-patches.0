Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF99737C925;
	Thu, 20 Aug 2026 15:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238845; cv=none; b=JWy8GG9eebjGbrgGaGql2J/ZR8zctMK9leO6a6v0PZPtfN2VIRyAsR+J/jU++nYKm/EeTtnQyoSlhuTrjWGrgHhrOb3tKL5ivECXXTcrO94VOd3Tmf978flP8HEsgjY0yWdRNl0RyRYlUBC53WnD5PQVFl45uVFuCwB11albHEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238845; c=relaxed/simple;
	bh=3XzDIKkyyiVhNhQMT9zFMNnFisJYrMkBXUik6167zPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lk8MJVeKzBfVYjssJ6ZdJBLNqjhI/0Nh9IM8ddisVwskbj40jvqbKW6PujbJHw1vtNSGnmMEeByIXqg4osFQgZUyXv2mcIfBE5jQBiJbI3lnFLG48WGUkNoPy45DqWgMPQ6PIfBxPj5jET5RV73nwiFNPhHaTVVB4/ysPX4ae5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YB/Shd19; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YB/Shd19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B291F000E9;
	Thu, 20 Aug 2026 15:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238844;
	bh=mz2m6XelwkvyWASk0quTVdO299Mgof0P1WYsPhSV3eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YB/Shd191ZkAZfHKDXbcBX3cvC9OVmmTUKluHA+DQtGEROPRTywgj24S4SVgyki9f
	 JhZWxyJJFJvTfQ6mvBLf84P1FUxCSOSGc5DstA65x1G+WYGkzQkUYSPJxKrxFn0xBF
	 awdv55/tboi3f8kWUdfwjGNzcEX6GKzVj5xvOwU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 061/217] Input: sur40 - fix V4L error path cleanup
Date: Thu, 20 Aug 2026 16:53:49 +0200
Message-ID: <20260820145239.457315933@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 062dc4693e2c10d77de06f61e6f3faf37c0a8383 upstream.

In sur40_probe(), if video_register_device() fails, the error path jumps to
err_unreg_video. This incorrectly attempts to unregister a video device
that was never successfully registered, and fails to free the V4L2 control
handler (v4l2_ctrl_handler_free) that was initialized immediately prior.

Fix this by introducing an err_free_ctrl label to properly free the V4L2
control handler and bypass video_unregister_device() when video device
registration fails.

Reported-by: sashiko-bot@kernel.org
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Link: https://patch.msgid.link/20260616051235.1549517-2-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/sur40.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -787,7 +787,7 @@ static int sur40_probe(struct usb_interf
 	if (error) {
 		dev_err(&interface->dev,
 			"Unable to register video subdevice.");
-		goto err_unreg_video;
+		goto err_free_ctrl;
 	}
 
 	/* register the polled input device */
@@ -806,6 +806,8 @@ static int sur40_probe(struct usb_interf
 
 err_unreg_video:
 	video_unregister_device(&sur40->vdev);
+err_free_ctrl:
+	v4l2_ctrl_handler_free(&sur40->hdl);
 err_unreg_v4l2:
 	v4l2_device_unregister(&sur40->v4l2);
 err_free_buffer:


