Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCC62D8364;
	Mon, 13 Apr 2026 16:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098128; cv=none; b=pc9mPDakzLbhVaOcMsnMBV4tVzYGTtx0nPV2boqV/V1TVdE5zwO6QzpfxktZBAdD9JZOGBRJd64XSs6dOLLcTpfuu6qBvb2zI3jbhNuiv8GWKtK8Palx73KXa+b2w4OYb8gVldr1Xc0Z7E891eJqq3sPPUM0zalS+JIAGExbnbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098128; c=relaxed/simple;
	bh=TXUYGRa/BqeoT/WTk3WP7O650KK3i+zfMeolzucIQKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SghQjZa2woqTdKKSzWXbHqTU6XwoeMgHi76a1rQ4gOLFOlc7/wT3xaEws6mwOyYsJZ95xF5CY3wa4WI7bAoIey6025IAG3pDSIe47mq3a+xlt7wOdKcAptd+DrvJ+EzdE26PraC6LSsjQXrgwsiAoQe2siDdXU/h2hj1gJ6luJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xLlYS7Gz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xLlYS7Gz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B0BC2BCAF;
	Mon, 13 Apr 2026 16:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098127;
	bh=TXUYGRa/BqeoT/WTk3WP7O650KK3i+zfMeolzucIQKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xLlYS7GzhZ6T0zStlbfomEPns/IbJowOVYF9JrVuBVtX8EKl+Bh/ERvP1PvJx8WJO
	 yX6ttSQNBNQkRrd1eTTJgybZaJziWeydYwMuvuCodYJ7jVGVWRvcYyZ3aHSzx9Om5r
	 ncKeHLCGRNtIdQpTxyJU0+75q+Xi0GB0MBi8xUbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuchan Nam <entropy1110@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 372/570] media: mc, v4l2: serialize REINIT and REQBUFS with req_queue_mutex
Date: Mon, 13 Apr 2026 17:58:23 +0200
Message-ID: <20260413155844.415236228@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchan Nam <entropy1110@gmail.com>

commit bef4f4a88b73e4cc550d25f665b8a9952af22773 upstream.

MEDIA_REQUEST_IOC_REINIT can run concurrently with VIDIOC_REQBUFS(0)
queue teardown paths. This can race request object cleanup against vb2
queue cancellation and lead to use-after-free reports.

We already serialize request queueing against STREAMON/OFF with
req_queue_mutex. Extend that serialization to REQBUFS, and also take
the same mutex in media_request_ioctl_reinit() so REINIT is in the
same exclusion domain.

This keeps request cleanup and queue cancellation from running in
parallel for request-capable devices.

Fixes: 6093d3002eab ("media: vb2: keep a reference to the request until dqbuf")
Cc: stable@vger.kernel.org
Signed-off-by: Yuchan Nam <entropy1110@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/mc/mc-request.c        |    5 +++++
 drivers/media/v4l2-core/v4l2-ioctl.c |    5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/media/mc/mc-request.c
+++ b/drivers/media/mc/mc-request.c
@@ -190,6 +190,8 @@ static long media_request_ioctl_reinit(s
 	struct media_device *mdev = req->mdev;
 	unsigned long flags;
 
+	mutex_lock(&mdev->req_queue_mutex);
+
 	spin_lock_irqsave(&req->lock, flags);
 	if (req->state != MEDIA_REQUEST_STATE_IDLE &&
 	    req->state != MEDIA_REQUEST_STATE_COMPLETE) {
@@ -197,6 +199,7 @@ static long media_request_ioctl_reinit(s
 			"request: %s not in idle or complete state, cannot reinit\n",
 			req->debug_str);
 		spin_unlock_irqrestore(&req->lock, flags);
+		mutex_unlock(&mdev->req_queue_mutex);
 		return -EBUSY;
 	}
 	if (req->access_count) {
@@ -204,6 +207,7 @@ static long media_request_ioctl_reinit(s
 			"request: %s is being accessed, cannot reinit\n",
 			req->debug_str);
 		spin_unlock_irqrestore(&req->lock, flags);
+		mutex_unlock(&mdev->req_queue_mutex);
 		return -EBUSY;
 	}
 	req->state = MEDIA_REQUEST_STATE_CLEANING;
@@ -214,6 +218,7 @@ static long media_request_ioctl_reinit(s
 	spin_lock_irqsave(&req->lock, flags);
 	req->state = MEDIA_REQUEST_STATE_IDLE;
 	spin_unlock_irqrestore(&req->lock, flags);
+	mutex_unlock(&mdev->req_queue_mutex);
 
 	return 0;
 }
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -2926,13 +2926,14 @@ static long __video_do_ioctl(struct file
 		vfh = file->private_data;
 
 	/*
-	 * We need to serialize streamon/off with queueing new requests.
+	 * We need to serialize streamon/off/reqbufs with queueing new requests.
 	 * These ioctls may trigger the cancellation of a streaming
 	 * operation, and that should not be mixed with queueing a new
 	 * request at the same time.
 	 */
 	if (v4l2_device_supports_requests(vfd->v4l2_dev) &&
-	    (cmd == VIDIOC_STREAMON || cmd == VIDIOC_STREAMOFF)) {
+	    (cmd == VIDIOC_STREAMON || cmd == VIDIOC_STREAMOFF ||
+	     cmd == VIDIOC_REQBUFS)) {
 		req_queue_lock = &vfd->v4l2_dev->mdev->req_queue_mutex;
 
 		if (mutex_lock_interruptible(req_queue_lock))


