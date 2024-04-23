Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C75D143C49;
	Tue, 23 Apr 2024 21:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908719; cv=none; b=ofYCIeYegIx6QM/46KX5GNVeDJpbtl6U+mRNesHVuD4HKhZZVLUeCkh8PiswIyezEiDegCZvjjHIx+O+q+7fCN5fyt4U8kz0PTC8BVJKMjRAS/PSYhAcc39EVcUxeA8Uq4Hei+ikelsMXgBuvU1CpnNaZrTBJxe4BybAbvCSz2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908719; c=relaxed/simple;
	bh=Q8uPlxIGsifBbUL2rwlllQ+0tIy4vdJn2WkL3CBE72s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIbC2rh8Ng7/ldO8Y1RnVeyJAAgrpU+oflTs95RsSJmvRPqA/XDLXTKOvd3FyJMBxtjsBCMw1SsmrqEQoV3TpCGmCAlY+olZqiJYthM6i8lX+UBORCXf1xpGw95JLjazOhwXWNFBmbdG+VkxESj7fZLRTiwbz9KexPL5V+iztCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Nk3FU30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Nk3FU30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBE7C32782;
	Tue, 23 Apr 2024 21:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908719;
	bh=Q8uPlxIGsifBbUL2rwlllQ+0tIy4vdJn2WkL3CBE72s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Nk3FU30QR4tSDIx74YoOIW0LhBLFBkmYenXK7D0BwPQeOpZX3BUw0j8WpVtGOFru
	 UAqL5+idxyDRketRsgJEFZZLtJ6hIISm/MWBOgmQWS11mppIJHBmWW1WpVy3cEkPaK
	 1LX34pCCRLs3AuY9yv6MXoqN7J4jECFDat59VgXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/141] s390/cio: fix race condition during online processing
Date: Tue, 23 Apr 2024 14:38:40 -0700
Message-ID: <20240423213854.949523699@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 02813b63f90fd..5666b9cc5d296 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -360,10 +360,8 @@ int ccw_device_set_online(struct ccw_device *cdev)
 
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
@@ -372,7 +370,12 @@ int ccw_device_set_online(struct ccw_device *cdev)
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



