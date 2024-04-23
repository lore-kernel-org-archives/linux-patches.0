Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2342A14388D;
	Tue, 23 Apr 2024 21:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908507; cv=none; b=PuSic12XvkFn8Iy8GcEkhxbNIGmksKNizOAVaHfxAuzB31HPyaOO5Og2S0sqVQIhHs7pv4+nYxoeoUggUrVAci884dKwlJyThS4VMbciJbOVHPUOKaV4MgRgMZVhRqC1PzQqUr8enxbVnoYaBAqo8qvCNdpZcOqcojBrGlxgPlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908507; c=relaxed/simple;
	bh=b2cCcWMIVXxsIev2qylYjowVRScIDiv/6mgsw9i6HtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=te9z13bmQzjAXOOX6H+dbLDinhA59DP41A2iHiHzfyo9NHuCbkGiSmQaAf5SyN9V+ez1M4NYMpFY//UH+X6gylxtuju4xYxjz+xxgY0vfWPtrdZw8RT3ZYC0wN/Go7ZgXCABuKhdOz6c5YkhNGrij2eNF0KVFnVa4XD8CLFlKns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DzfKxBX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DzfKxBX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD5CC32781;
	Tue, 23 Apr 2024 21:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908506;
	bh=b2cCcWMIVXxsIev2qylYjowVRScIDiv/6mgsw9i6HtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2DzfKxBXFH6T2OWCjFZR3uFLCYThJAwhAQoKuTuc0ZdwSI2fr69G67idd6Qk5F02a
	 qjzgPkhBCohEJFLOgzRjVbKwuDkptZb8I/oTVhOpIa8E1eNC2UYo3TrsaZWDVuH9fz
	 Yw2O0kDo1h5kXPssG/+5FiSSfM3SqbuKQVzz06Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 061/158] s390/cio: fix race condition during online processing
Date: Tue, 23 Apr 2024 14:38:03 -0700
Message-ID: <20240423213857.945308670@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 0cfb179e1bcb6..34b2567b8df49 100644
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



