Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2D78F5C;
	Mon,  1 Apr 2024 16:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990190; cv=none; b=HhgguvO5OCCBOERzpvalJdVqhevK6KXuGl4zcdfO12uGhO0/w92y7PZ9rdXFcBfatx8Sn/VPuXeZWcy8MFLeMwpuwt78Khd9Wtljn1vsn+AyB2CK7NqxQoHFFbV1PH54Cr2bok9Bnqt7o3lqMXCPcaPOnLOVRtUD0EKPEWHWG1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990190; c=relaxed/simple;
	bh=A2T9HxyvPB8EZBT2wYHqhJoyqdQxUDltA1q0SHXxyto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaKvcVAUR2OF1OiBV1QhM/O2NsG6U8D2ljD0Uk9cV8uZKCQOaWgghq3sNEbkcRspaJw8ODAW9ytYF6xGm48rlMUWbILw4LGhyyFEfG7ILgEBsTVcUr6MCPCrHRg5ycPVwaOoR5w44rcEdfGEjG01C77x7fr/T3i6gjWltmc3XI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uiF2QUi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uiF2QUi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A337BC433F1;
	Mon,  1 Apr 2024 16:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990190;
	bh=A2T9HxyvPB8EZBT2wYHqhJoyqdQxUDltA1q0SHXxyto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uiF2QUi7Wqyj1/eivSbb/ibeH4YxnyCBXX33l0VnNcTO5UIsMypj0RcadyyhvA0kL
	 cyxZkM6dCISewBcr6+2snUrdmQbh3hcReeNK3A5jPddjoCj2kV42pU5CwpxOvYzvsW
	 nU+suaUFv/G6G+mqq/ikej0+PNVFy1tseUYUiV9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 246/396] iio: imu: inv_mpu6050: fix FIFO parsing when empty
Date: Mon,  1 Apr 2024 17:44:55 +0200
Message-ID: <20240401152555.248565049@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 60caa8b33bd682a9ed99d1fc3f91d74e1acc9922 upstream.

Now that we are reading the full FIFO in the interrupt handler,
it is possible to have an emply FIFO since we are still receiving
1 interrupt per data. Handle correctly this case instead of having
an error causing a reset of the FIFO.

Fixes: 0829edc43e0a ("iio: imu: inv_mpu6050: read the full fifo when processing data")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://lore.kernel.org/r/20240219154825.90656-1-inv.git-commit@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
index 66d4ba088e70..d4f9b5d8d28d 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_ring.c
@@ -109,6 +109,8 @@ irqreturn_t inv_mpu6050_read_fifo(int irq, void *p)
 	/* compute and process only all complete datum */
 	nb = fifo_count / bytes_per_datum;
 	fifo_count = nb * bytes_per_datum;
+	if (nb == 0)
+		goto end_session;
 	/* Each FIFO data contains all sensors, so same number for FIFO and sensor data */
 	fifo_period = NSEC_PER_SEC / INV_MPU6050_DIVIDER_TO_FIFO_RATE(st->chip_config.divider);
 	inv_sensors_timestamp_interrupt(&st->timestamp, fifo_period, nb, nb, pf->timestamp);
-- 
2.44.0



