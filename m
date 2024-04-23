Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326A0147C67;
	Tue, 23 Apr 2024 21:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908601; cv=none; b=ledaJx8Hv3FRc/MHoCJznuaR8LoTEOMv4B/kCADYoZWkazG3cXqkFlDAm/NJOqnAVfOtCXIUH7jTVxcDanCfAFE8fIyRTMWFE2fxz2qbYxozjOjelXAvKbBPPuLFvQyD4BgW8OK/JGb5EyVZG65Wr4+XG200YxTERI27m8Pvg4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908601; c=relaxed/simple;
	bh=y//j4ij5Iq4m10W32Y+fYyhTp1NhhA3pRUmvQrQ2/jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N+2FOrTpiztNiviGkgu7fzm8/JGcavxz8UuwIWNixri/zer8s+y0OqdWNe3uqoao5ea1cH05yohNWqmCF6faRil9OlalC0HQFO/4fn+zREMyMjR/SHWgaKRrXX9fFWdZCdwEG3bB0KyjEsqTEx0oJw7roNVpH0WyjUvZa5BnTbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAjs9Iae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAjs9Iae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08090C3277B;
	Tue, 23 Apr 2024 21:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908601;
	bh=y//j4ij5Iq4m10W32Y+fYyhTp1NhhA3pRUmvQrQ2/jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAjs9IaeSprqLfPTXpH35iNik7fhrOIoiZ1CqimAqLdIeGVR26Ukq/D0gT/v0aYKJ
	 CvmsqEE2yLcJBDy19h2AtnwOFTNrgqYDdzJqCk7JWqFHzUvXyVAzCEu9+e8t/1p3cg
	 VqKN3l4dk2PpH9s4EugwmGRct7bxZeCBPtsrT5XU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/158] s390/cio: fix race condition during online processing
Date: Tue, 23 Apr 2024 14:38:22 -0700
Message-ID: <20240423213857.879666471@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Peter Oberparleiter <oberpar@linux.ibm.com>

[ Upstream commit 2d8527f2f911fab84aec04df4788c0c23af3df48 ]

A race condition exists in ccw_device_set_online() that can cause the
online process to fail, leaving the affected device in an inconsistent
state. As a result, subsequent attempts to set that device online fail
with return code ENODEV.

The problem occurs when a path verification request arrives after
a wait for final device state completed, but before the result state
is evaluated.

Fix this by ensuring that the CCW-device lock is held between
determining final state and checking result state.

Note that since:

commit 2297791c92d0 ("s390/cio: dont unregister subchannel from child-drivers")

path verification requests are much more likely to occur during boot,
resulting in an increased chance of this race condition occurring.

Fixes: 2297791c92d0 ("s390/cio: dont unregister subchannel from child-drivers")
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/device.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 4ca5adce91079..57e0050dbaa53 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -363,10 +363,8 @@ int ccw_device_set_online(struct ccw_device *cdev)
 
 	spin_lock_irq(cdev->ccwlock);
 	ret = ccw_device_online(cdev);
-	spin_unlock_irq(cdev->ccwlock);
-	if (ret == 0)
-		wait_event(cdev->private->wait_q, dev_fsm_final_state(cdev));
-	else {
+	if (ret) {
+		spin_unlock_irq(cdev->ccwlock);
 		CIO_MSG_EVENT(0, "ccw_device_online returned %d, "
 			      "device 0.%x.%04x\n",
 			      ret, cdev->private->dev_id.ssid,
@@ -375,7 +373,12 @@ int ccw_device_set_online(struct ccw_device *cdev)
 		put_device(&cdev->dev);
 		return ret;
 	}
-	spin_lock_irq(cdev->ccwlock);
+	/* Wait until a final state is reached */
+	while (!dev_fsm_final_state(cdev)) {
+		spin_unlock_irq(cdev->ccwlock);
+		wait_event(cdev->private->wait_q, dev_fsm_final_state(cdev));
+		spin_lock_irq(cdev->ccwlock);
+	}
 	/* Check if online processing was successful */
 	if ((cdev->private->state != DEV_STATE_ONLINE) &&
 	    (cdev->private->state != DEV_STATE_W4SENSE)) {
-- 
2.43.0



