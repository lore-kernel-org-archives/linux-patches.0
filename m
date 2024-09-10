Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86447171671;
	Tue, 10 Sep 2024 09:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962157; cv=none; b=CfmWb8ttNramG0PN7Gzt9Z5ELWDXx2mNmecCBMbbVPbiAzLJ1iTPsJZmCiTV2OnOZ8a0Q8oJv2SGZihZk71wweZ4g/2rhrr6rZM0swMXVV3Y1xFqXp64Tomgm5BA+xEGa3IM8L1FpHr9A5h7gDzmScAlpjoXWEls0QubkVOszTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962157; c=relaxed/simple;
	bh=Y7lSGduLu5si3zoKzzw2s+I/kDbjtIVlrMsRTSbb9q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTfSb/h4EFGYRiaWDMF58uJr8axwk1giSQvYrVsdhzoJT4k+iUn6mQw/7Drvjm5lNBOJNGO6NC2pMdloxnW+Cpnu1hIXXtacJ5CsjZX8Oz2ZoHwpwpMZG2YU2z5mEGIfXVfbNURA+MsVvrsiSfv9RxQ+8vUYxav0KDMuCtNNky0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zahvsli4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zahvsli4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A865C4CEC3;
	Tue, 10 Sep 2024 09:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962157;
	bh=Y7lSGduLu5si3zoKzzw2s+I/kDbjtIVlrMsRTSbb9q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zahvsli4muwvO7XymwSK7CSQyXywJrW+NcOYSI77FTsoyetqHIFj0BtZRHJK1pOru
	 tCkpoKwvYfcPZw/HlonAvNUlUYrfUVfa/Vk2KiGelwrwgQri0Ah33If3ZpOSmFzLnK
	 W3usDFg25aUoGKye3qxdzx0JQkEQwCdVSNRErzjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Andreas Westman Dorcsak <hedmoo@yahoo.com>
Subject: [PATCH 6.10 287/375] iio: imu: inv_mpu6050: fix interrupt status read for old buggy chips
Date: Tue, 10 Sep 2024 11:31:24 +0200
Message-ID: <20240910092632.209565736@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 0a3b517c8089aa4cf339f41460d542c681409386 upstream.

Interrupt status read seems to be broken on some old MPU-6050 like
chips. Fix by reverting to previous driver behavior bypassing interrupt
status read. This is working because these chips are not supporting
WoM and data ready is the only interrupt source.

Fixes: 5537f653d9be ("iio: imu: inv_mpu6050: add new interrupt handler for WoM events")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Tested-by: Svyatoslav Ryhel <clamor95@gmail.com> # LG P895
Tested-by: Andreas Westman Dorcsak <hedmoo@yahoo.com> # LG P880
Link: https://patch.msgid.link/20240814143735.327302-1-inv.git-commit@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c
@@ -248,12 +248,20 @@ static irqreturn_t inv_mpu6050_interrupt
 	int result;
 
 	switch (st->chip_type) {
+	case INV_MPU6000:
 	case INV_MPU6050:
+	case INV_MPU9150:
+		/*
+		 * WoM is not supported and interrupt status read seems to be broken for
+		 * some chips. Since data ready is the only interrupt, bypass interrupt
+		 * status read and always assert data ready bit.
+		 */
+		wom_bits = 0;
+		int_status = INV_MPU6050_BIT_RAW_DATA_RDY_INT;
+		goto data_ready_interrupt;
 	case INV_MPU6500:
 	case INV_MPU6515:
 	case INV_MPU6880:
-	case INV_MPU6000:
-	case INV_MPU9150:
 	case INV_MPU9250:
 	case INV_MPU9255:
 		wom_bits = INV_MPU6500_BIT_WOM_INT;
@@ -279,6 +287,7 @@ static irqreturn_t inv_mpu6050_interrupt
 		}
 	}
 
+data_ready_interrupt:
 	/* handle raw data interrupt */
 	if (int_status & INV_MPU6050_BIT_RAW_DATA_RDY_INT) {
 		indio_dev->pollfunc->timestamp = st->it_timestamp;


