Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB5E2E7379;
	Sat, 30 May 2026 17:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162853; cv=none; b=CxboV9yzkoiEYc8JuHbAl5bvrp3SDmbmkCmT56XRzf9DzOua/qAq4yoLfCStBRvWRrX6RdPoGjvkdjgj9W2TWQDZgpClrEuBnJGFHZSSMxoHUQwlRAXs6hkFk0JSNWEaTzzHg3elKOFjslfK2UPc1u7VJDDGHLukEH/rH6UbQYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162853; c=relaxed/simple;
	bh=GRfz2p4B3PSXmM2PgeuaaFkxn08E+YrNliCSpemBADM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmWrTqKeL8BLxgYj3A3lehgK4W07yh5/ZGJggL4c3uT8+jBbl657KA8P6/2cMUx9KbRpgqwZWgkuQAKjTr1TQP5A1+Z2Z4I0LG+Yg6ycKOdhkNTDDC4K/bXP1fzMMZG5hegeWW5saN4Xk1grRSWT/RYXXothiUKWpp6OrbLNRdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2dA+PpW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2dA+PpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703761F00893;
	Sat, 30 May 2026 17:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162852;
	bh=69OuostZCDnQFyMF1l5oGjRQOWYnJzXx31pHU3rKauY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C2dA+PpWhCWPeoI5pgOVpNS7U5bPRHw9BFfZDcIwbAT8hEhE98GQy4tEsgx6szg8x
	 CZddKNtlsPooK9RIv6O4bqVudzT9FL6IRngVW9koRN9mb5QabtGauYvo160JjkqCCK
	 jKpu6sTxA9bb7RtQULu/wIS1q/CYFTC8+/1hCmT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c025d34b8eaa54c571b8@syzkaller.appspotmail.com,
	Abhishek Kumar <abhishek_sts8@yahoo.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 083/776] media: em28xx: fix use-after-free in em28xx_v4l2_open()
Date: Sat, 30 May 2026 17:56:37 +0200
Message-ID: <20260530160242.479862582@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
@@ -2136,7 +2136,7 @@ static int em28xx_v4l2_open(struct file
 {
 	struct video_device *vdev = video_devdata(filp);
 	struct em28xx *dev = video_drvdata(filp);
-	struct em28xx_v4l2 *v4l2 = dev->v4l2;
+	struct em28xx_v4l2 *v4l2;
 	enum v4l2_buf_type fh_type = 0;
 	int ret;
 
@@ -2153,13 +2153,19 @@ static int em28xx_v4l2_open(struct file
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


