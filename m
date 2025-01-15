Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB82248BD1;
	Wed, 15 Jan 2025 10:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938487; cv=none; b=sEsqYfY+zn3l8rmuid4RfCIMu8/0VrgtfE4HaL11PbgcyxvaKD+bBz0RuEoUsggSxCSX0PDwMATDE0P7ty3FIlxLkWmWT5DMnA+m2ytdxnJ6bE1TMj12J4LpZlHmr48jIWpF4R4CnP83SL8lGU3fx8RSBeCMV3lvkEmMDvjBQAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938487; c=relaxed/simple;
	bh=NWgtYKd5cPjkMHerMbj0g8cDeRCoA/dy64825gA88G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Du3v1xmm1WF8gOk1puBHn9VxgRzj4wiv0Uzlwu6hH6RMOAY31tQP5A/EZi3ZyXAbPNEledR42X9b4fjlg2UMF6NcBWRjlKYrE06H+w31Ko8hGZBuaNLI6vRj9L64OodCL5wAugLp5rn3++BBsn6WUu3qSfa47P455Gg8vHaIA6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0RDGTcIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0RDGTcIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284A5C4CEE2;
	Wed, 15 Jan 2025 10:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938487;
	bh=NWgtYKd5cPjkMHerMbj0g8cDeRCoA/dy64825gA88G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0RDGTcIKRB6emg7sHwKIJ9hLg9VPH2jzXupzQBoqdcsjdL19tqhoR3Zvj+N6Vme5o
	 xWvl6kPaXefsldabWWBhoVXUiBhLSrqhoxG4pLRuJA6iH+e5bLtW2AyiDo/Cj8NYZj
	 PadkFx5iSwzgNLjO2JCZGqtMwp8YyNqYI4nXAheY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 168/189] iio: imu: inv_icm42600: fix timestamps after suspend if sensor is on
Date: Wed, 15 Jan 2025 11:37:44 +0100
Message-ID: <20250115103613.107183786@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 65a60a590142c54a3f3be11ff162db2d5b0e1e06 upstream.

Currently suspending while sensors are one will result in timestamping
continuing without gap at resume. It can work with monotonic clock but
not with other clocks. Fix that by resetting timestamping.

Fixes: ec74ae9fd37c ("iio: imu: inv_icm42600: add accurate timestamping")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://patch.msgid.link/20241113-inv_icm42600-fix-timestamps-after-suspend-v1-1-dfc77c394173@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -822,6 +822,8 @@ out_unlock:
 static int inv_icm42600_resume(struct device *dev)
 {
 	struct inv_icm42600_state *st = dev_get_drvdata(dev);
+	struct inv_icm42600_sensor_state *gyro_st = iio_priv(st->indio_gyro);
+	struct inv_icm42600_sensor_state *accel_st = iio_priv(st->indio_accel);
 	int ret;
 
 	mutex_lock(&st->lock);
@@ -842,9 +844,12 @@ static int inv_icm42600_resume(struct de
 		goto out_unlock;
 
 	/* restore FIFO data streaming */
-	if (st->fifo.on)
+	if (st->fifo.on) {
+		inv_sensors_timestamp_reset(&gyro_st->ts);
+		inv_sensors_timestamp_reset(&accel_st->ts);
 		ret = regmap_write(st->map, INV_ICM42600_REG_FIFO_CONFIG,
 				   INV_ICM42600_FIFO_CONFIG_STREAM);
+	}
 
 out_unlock:
 	mutex_unlock(&st->lock);


