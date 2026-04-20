Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BF3332919;
	Mon, 20 Apr 2026 15:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699985; cv=none; b=AgYnPtW7Yh4HNu4jUohi4p97NNaeuc5QyYkxRNMdc8R0S9fFHh389X2sGhMQSi5WgAMVvjeUUjavGjgaL3vp2UaF85OnZQmSTRrzexMRFpkgQhkskEoIhV8C6lZMsDBs9Q+n2PAnaObwZUgUG80mvZ0M4EPKSjttQRYs9A6tkOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699985; c=relaxed/simple;
	bh=nLG1bLXf3wikWEHvXVfMR1Q0qOxkaWNid22tPRHm0is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9j9lNFi8Q7srAA1h7/PSO62i2k0WCtR7AaQtWlM6ulH0Pvru8CxdB5qid5TUxkJcwq/LhPW3w5q9+QHG7kS8A4lW9NV/1+0zsTAUFfqFMQ/nBiW/AGx/hOT0PeY3MCs0Vtyt2OU/HFnBFxmNlFMQAKoMSsBBTGbYBRaQhNFSnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NmYyYwwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NmYyYwwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0C4C19425;
	Mon, 20 Apr 2026 15:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699985;
	bh=nLG1bLXf3wikWEHvXVfMR1Q0qOxkaWNid22tPRHm0is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmYyYwwvqhS23pM2Ulwr+63bZQ2w4cvegT74qFmx09d3asuhd5xvWKeSbJkyKHIiI
	 XZXwGTUoryK5Mu1cqC3Ya19zOnU9tBVTsRlPFlcvMsJlkWMslMNo5rLRcqyfEfOvW5
	 L9AV1Sklfrb5AYV57hqcGvuQM6fvV4ORBcDRx+QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c025d34b8eaa54c571b8@syzkaller.appspotmail.com,
	Abhishek Kumar <abhishek_sts8@yahoo.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 67/76] media: em28xx: fix use-after-free in em28xx_v4l2_open()
Date: Mon, 20 Apr 2026 17:42:18 +0200
Message-ID: <20260420153913.259008008@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhishek Kumar <abhishek_sts8@yahoo.com>

commit a66485a934c7187ae8e36517d40615fa2e961cff upstream.

em28xx_v4l2_open() reads dev->v4l2 without holding dev->lock,
creating a race with em28xx_v4l2_init()'s error path and
em28xx_v4l2_fini(), both of which free the em28xx_v4l2 struct
and set dev->v4l2 to NULL under dev->lock.

This race leads to two issues:
 - use-after-free in v4l2_fh_init() when accessing vdev->ctrl_handler,
   since the video_device is embedded in the freed em28xx_v4l2 struct.
 - NULL pointer dereference in em28xx_resolution_set() when accessing
   v4l2->norm, since dev->v4l2 has been set to NULL.

Fix this by moving the mutex_lock() before the dev->v4l2 read and
adding a NULL check for dev->v4l2 under the lock.

Reported-by: syzbot+c025d34b8eaa54c571b8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c025d34b8eaa54c571b8
Fixes: 8139a4d583ab ("[media] em28xx: move v4l2 user counting fields from struct em28xx to struct v4l2")
Cc: stable@vger.kernel.org
Signed-off-by: Abhishek Kumar <abhishek_sts8@yahoo.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/em28xx/em28xx-video.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2126,7 +2126,7 @@ static int em28xx_v4l2_open(struct file
 {
 	struct video_device *vdev = video_devdata(filp);
 	struct em28xx *dev = video_drvdata(filp);
-	struct em28xx_v4l2 *v4l2 = dev->v4l2;
+	struct em28xx_v4l2 *v4l2;
 	enum v4l2_buf_type fh_type = 0;
 	int ret;
 
@@ -2143,13 +2143,19 @@ static int em28xx_v4l2_open(struct file
 		return -EINVAL;
 	}
 
+	if (mutex_lock_interruptible(&dev->lock))
+		return -ERESTARTSYS;
+
+	v4l2 = dev->v4l2;
+	if (!v4l2) {
+		mutex_unlock(&dev->lock);
+		return -ENODEV;
+	}
+
 	em28xx_videodbg("open dev=%s type=%s users=%d\n",
 			video_device_node_name(vdev), v4l2_type_names[fh_type],
 			v4l2->users);
 
-	if (mutex_lock_interruptible(&dev->lock))
-		return -ERESTARTSYS;
-
 	ret = v4l2_fh_open(filp);
 	if (ret) {
 		dev_err(&dev->intf->dev,


