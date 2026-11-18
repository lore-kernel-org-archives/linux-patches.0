Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044971;
	b=kg9pdlUaflQ2xC+r0Eszac8OBxWJR2F/9W5RV3eXVlt4n164IQrA2vL+TuZRuq7CqcjF
	 mNOid1slp+ahJped6aeOqpxHz8kPKQCl5fZUiqRwgYzLM/cx+usEtAGm5poJbB7Kyh65g
	 juOMDk62SBO8JYlqHHY19yT6HRps/hk9xTBqw343kOpVSs04wtkuoJIyHnO+gCnzC2Lj8
	 BIjoXavPm/DtpaoUBPEELdhQ9Y3cjBrK71mct7i/Sds6mrHeFCWEH0C9LHhjL2f6PqYcM
	 mt3LDczFw2Zo7rVxVGag/fkAhVrpeC75wLMUoDeTc9r845+4d13UTFUJShyt1qTq3bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=axqRPTcNkBA9icWV1gNB937G4PPs3CmDHIHJt+/gFyg=;
	b=iHoVThWILMIKDd315MjGzMOXF9qitjVpA6LOhKAle6hPAlBCkkL5kxbwsjj5SVjFfKMM
	 Adan9au2AsGZzFd3qDm5KSaYWpGrvk0HylvGQ9kqdCxeSeKNjNocdkb9ZhSPbHRZA6TFB
	 gFNlqWZDugQF3SnLsDwtCFLKpAEK6Ktn2kDHaku8LuEG8Z/3WjPg18ngbkEX9xmrtHz0q
	 ZJbv/srlFsX3rvRvVRvowMx61JYjuC+XtpKt0Ms5mKAoRLxsjdXlvJGOR2tftS4RclsBQ
	 WRiqjRpESTPR/g+VO8Dff/Zp7AQuP51CNmK0N75rarEPe/L6zzumIkC7UXataadp2pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d1pXI1yL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BAF606A330;
	Wed, 18 Nov 2026 23:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d1pXI1yL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700B41F000C4;
	Wed, 18 Nov 2026 23:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044971;
	bh=axqRPTcNkBA9icWV1gNB937G4PPs3CmDHIHJt+/gFyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1pXI1yLo31qh3eRJk5ujO22UBKM6K8sNM9HdIQj6DNyufEipQPGYsjsquVLq58gg
	 KeypH2me145fpfuWSo0KbpdxipW430anuHg5YY0zQ1FNKeIQ2DuZUm6y9X0LXBQzUz
	 10RkmkfT9e9llDpJEv/PdwVaKxSkuSssLLVt+MpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0757/2857] iio: imu: inv_icm42600: fix odr change not caught in certain cases
Date: Wed, 18 Nov 2026 15:29:51 +0100
Message-ID: <20261118150228.807785185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

[ Upstream commit f670d4d3477386d62017936f0121909f93ac17f8 ]

When using both accel and gyro with different frequencies, the ODR
change flag in the FIFO header can be sometime in a packet with
invalid data. Since we are ignoring these packets, we miss the ODR
change and any further change are blocked until sensor is turned off.

Fix this by moving the packet data validity check after the ODR change
flag check.

Fixes: ec74ae9fd37c ("iio: imu: inv_icm42600: add accurate timestamping")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c | 8 ++++----
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c  | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
index 84c8c8485e465..4b46b893295e6 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -770,15 +770,15 @@ int inv_icm42600_accel_parse_fifo(struct iio_dev *indio_dev)
 		if (size <= 0)
 			return size;
 
-		/* skip packet if no accel data or data is invalid */
-		if (accel == NULL || !inv_icm42600_fifo_is_data_valid(accel))
-			continue;
-
 		/* update odr */
 		if (odr & INV_ICM42600_SENSOR_ACCEL)
 			inv_sensors_timestamp_apply_odr(ts, st->fifo.period,
 							st->fifo.nb.total, no);
 
+		/* skip packet if no accel data or data is invalid */
+		if (accel == NULL || !inv_icm42600_fifo_is_data_valid(accel))
+			continue;
+
 		memcpy(&buffer.accel, accel, sizeof(buffer.accel));
 		/* convert 8 bits FIFO temperature in high resolution format */
 		buffer.temp = temp ? (*temp * 64) : 0;
diff --git a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
index 6e98315391912..37e45721e77ac 100644
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -782,15 +782,15 @@ int inv_icm42600_gyro_parse_fifo(struct iio_dev *indio_dev)
 		if (size <= 0)
 			return size;
 
-		/* skip packet if no gyro data or data is invalid */
-		if (gyro == NULL || !inv_icm42600_fifo_is_data_valid(gyro))
-			continue;
-
 		/* update odr */
 		if (odr & INV_ICM42600_SENSOR_GYRO)
 			inv_sensors_timestamp_apply_odr(ts, st->fifo.period,
 							st->fifo.nb.total, no);
 
+		/* skip packet if no gyro data or data is invalid */
+		if (gyro == NULL || !inv_icm42600_fifo_is_data_valid(gyro))
+			continue;
+
 		memcpy(&buffer.gyro, gyro, sizeof(buffer.gyro));
 		/* convert 8 bits FIFO temperature in high resolution format */
 		buffer.temp = temp ? (*temp * 64) : 0;
-- 
2.53.0



