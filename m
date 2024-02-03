Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02E013AC2;
	Sat,  3 Feb 2024 04:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933754; cv=none; b=FIz5atsuq57v1sI3WTLewLJvO6sPpmmGzDcwyM1t91thAgBhF0NT1BIzO8iNMnQwONz2lhkOMGuH7bQYvUCPHuZY2eIP+BlZyJNvZ8DLwE+M2w+l+efexcvfNJ6ZigKynkorbjN94zdywUpdKVVLATlPA1YEKSA3iA/CvcW+WPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933754; c=relaxed/simple;
	bh=3LYQYCAgqblAUXq3htm0Ou7M5d9dsosNUovzXdtuxng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NkbU5gc2yfti+if9uJhfAhPQWEgbrAFviPEYG7i2Nx/Hoki2Jtveai/AVyKwItx+eR5n17QzI7BVFcaGHk7RRtjNYHX1B9ov3/BGWFugiw8jJ8ELhBgsBUYIiv0zMOvd7gUOi61vyhCEf86NFtg1vZPG1m1/ADsKRxQPkkvFbYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTA2oXI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTA2oXI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A847EC433C7;
	Sat,  3 Feb 2024 04:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933753;
	bh=3LYQYCAgqblAUXq3htm0Ou7M5d9dsosNUovzXdtuxng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTA2oXI73YPvLRidh+biHB+0MDZjWTIfB1mYRRgwqm1YNoZFkAjjfOjOzDkM1XeFj
	 +6++TVK2F/6CjDDdUZUutztJ3zYyug1nKNYQULs1fn2qQarRMXB+HFVuRGcdcBGAVx
	 AtHV5cNUWN6OE5uK39RC8fq9VrToWys6w0DDIc+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Krowiak <akrowiak@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 049/353] s390/vfio-ap: fix sysfs status attribute for AP queue devices
Date: Fri,  2 Feb 2024 20:02:47 -0800
Message-ID: <20240203035405.359895830@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Krowiak <akrowiak@linux.ibm.com>

[ Upstream commit a0d8f4eeb7c4ffaee21702bcc91a09b3988c5b7a ]

The 'status' attribute for AP queue devices bound to the vfio_ap device
driver displays incorrect status when the mediated device is attached to a
guest, but the queue device is not passed through. In the current
implementation, the status displayed is 'in_use' which is not correct; it
should be 'assigned'. This can happen if one of the queue devices
associated with a given adapter is not bound to the vfio_ap device driver.
For example:

Queues listed in /sys/bus/ap/drivers/vfio_ap:
14.0005
14.0006
14.000d
16.0006
16.000d

Queues listed in /sys/devices/vfio_ap/matrix/$UUID/matrix
14.0005
14.0006
14.000d
16.0005
16.0006
16.000d

Queues listed in /sys/devices/vfio_ap/matrix/$UUID/guest_matrix
14.0005
14.0006
14.000d

The reason no queues for adapter 0x16 are listed in the guest_matrix is
because queue 16.0005 is not bound to the vfio_ap device driver, so no
queue associated with the adapter is passed through to the guest;
therefore, each queue device for adapter 0x16 should display 'assigned'
instead of 'in_use', because those queues are not in use by a guest, but
only assigned to the mediated device.

Let's check the AP configuration for the guest to determine whether a
queue device is passed through before displaying a status of 'in_use'.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
Acked-by: Halil Pasic <pasic@linux.ibm.com>
Acked-by: Harald Freudenberger <freude@linux.ibm.com>
Link: https://lore.kernel.org/r/20231108201135.351419-1-akrowiak@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 88f41f95cc94..d6ea2fd4c2a0 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -2044,6 +2044,7 @@ static ssize_t status_show(struct device *dev,
 {
 	ssize_t nchars = 0;
 	struct vfio_ap_queue *q;
+	unsigned long apid, apqi;
 	struct ap_matrix_mdev *matrix_mdev;
 	struct ap_device *apdev = to_ap_dev(dev);
 
@@ -2051,8 +2052,21 @@ static ssize_t status_show(struct device *dev,
 	q = dev_get_drvdata(&apdev->device);
 	matrix_mdev = vfio_ap_mdev_for_queue(q);
 
+	/* If the queue is assigned to the matrix mediated device, then
+	 * determine whether it is passed through to a guest; otherwise,
+	 * indicate that it is unassigned.
+	 */
 	if (matrix_mdev) {
-		if (matrix_mdev->kvm)
+		apid = AP_QID_CARD(q->apqn);
+		apqi = AP_QID_QUEUE(q->apqn);
+		/*
+		 * If the queue is passed through to the guest, then indicate
+		 * that it is in use; otherwise, indicate that it is
+		 * merely assigned to a matrix mediated device.
+		 */
+		if (matrix_mdev->kvm &&
+		    test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
+		    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
 			nchars = scnprintf(buf, PAGE_SIZE, "%s\n",
 					   AP_QUEUE_IN_USE);
 		else
-- 
2.43.0



