Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E982EE97A;
	Thu,  3 Jul 2025 15:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554806; cv=none; b=ZMPUy1pUWl7OtxMXD5h7Qf+mCgW6wdLIzU1wOc58e6Kpl/aHALBJoyV8BWbzlh39m8vycxdjlmGXLeHcW/VmuCCKvj/BKtH2eR9pra8QI8RK9hQtw3oTlbLuf+iiPFvqbhz/0PeadnSQnSiEBNhedDbEfoq4KYwt0Yp1RbkJ6ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554806; c=relaxed/simple;
	bh=vhZc/w+90Dj3AW4lWaPnaOMKWEI1jIU4WjpUyu00iUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebRsdHN6uNQGEZTmI8gI3Q5Lmg+lneyTZjFa7E/UX4nQM3EaXjk0dyNaG+d5PkSOSAejWmNcZV0Zf7ZNs27TWf7uogeh3pHfGhCIT0aIwh+d5zNLv/9ivjy1VhYMi7FQa4TzlTBqFXFq/Ne606v0PQz2nBqwRpjMUGxZJ2BEFP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFA6CYdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFA6CYdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEA7C4CEE3;
	Thu,  3 Jul 2025 15:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554805;
	bh=vhZc/w+90Dj3AW4lWaPnaOMKWEI1jIU4WjpUyu00iUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uFA6CYdjCWPDDyH1rx22Q83iF64FWXSzV9c8Tg6oKKQMFVSlp6xb9MZ5MIz1nuPRP
	 U3/tkUxCOaWfPXvDm2Ubf62NImMyBKuzN+uG+ha2WpwSn31vhOb3ryzlyim9G+PpqE
	 4ph8yqBITEkYt+rRlND36je8y6MF/fCIrWq79SK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 084/263] media: uvcvideo: Keep streaming state in the file handle
Date: Thu,  3 Jul 2025 16:40:04 +0200
Message-ID: <20250703144007.673120248@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 14f6e205e5599c2217b68c05b903ce162e7c1e27 ]

Add a variable in the file handle state to figure out if a camera is in
the streaming state or not. This variable will be used in the future for
power management policies.

Now that we are at it, make use of guards to simplify the code.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Message-ID: <20250327-uvc-granpower-ng-v6-1-35a2357ff348@chromium.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Stable-dep-of: a70705d3c020 ("media: uvcvideo: Rollback non processed entities on error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 18 +++++++++++++-----
 drivers/media/usb/uvc/uvcvideo.h |  1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 39065db44e864..22886b47d81c2 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -841,11 +841,18 @@ static int uvc_ioctl_streamon(struct file *file, void *fh,
 	if (!uvc_has_privileges(handle))
 		return -EBUSY;
 
-	mutex_lock(&stream->mutex);
+	guard(mutex)(&stream->mutex);
+
+	if (handle->is_streaming)
+		return 0;
+
 	ret = uvc_queue_streamon(&stream->queue, type);
-	mutex_unlock(&stream->mutex);
+	if (ret)
+		return ret;
 
-	return ret;
+	handle->is_streaming = true;
+
+	return 0;
 }
 
 static int uvc_ioctl_streamoff(struct file *file, void *fh,
@@ -857,9 +864,10 @@ static int uvc_ioctl_streamoff(struct file *file, void *fh,
 	if (!uvc_has_privileges(handle))
 		return -EBUSY;
 
-	mutex_lock(&stream->mutex);
+	guard(mutex)(&stream->mutex);
+
 	uvc_queue_streamoff(&stream->queue, type);
-	mutex_unlock(&stream->mutex);
+	handle->is_streaming = false;
 
 	return 0;
 }
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index b4ee701835fc0..5ceb01e7831a8 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -630,6 +630,7 @@ struct uvc_fh {
 	struct uvc_streaming *stream;
 	enum uvc_handle_state state;
 	unsigned int pending_async_ctrls;
+	bool is_streaming;
 };
 
 /* ------------------------------------------------------------------------
-- 
2.39.5



