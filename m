Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3273BF2F7;
	Thu, 15 Jan 2026 17:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497339; cv=none; b=ekFVdCq4sBtU25FuBC125Th4mizkbIjXTW77mbECIEepKA6s5uHoLGjvz9lATCNOxgI5nfPblKlkl4n/nQHESygt881zj9mmDvSGqNfBy2Q1YKekErbtbK4HgvMk5TzFSAebIPbZYzmU2a1PA+NkefuV7qIJaXdlCpErFKsk6vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497339; c=relaxed/simple;
	bh=kCVhgyaH15WqD9MFRD638Cl1QNh3dZpRhHszTq7eSfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrPDdM9q8jYSVhYh+E0ugxm8MyenxRJIYSQitmjAPH1z6mv+lXFQBlSlS9eNFJjiR6hFKMprGsCDRjk/0kVJZdWyHhQB10BGc5Eab2mPrCRrIjFehRzfG9QxSeKifZvLUvXau7Bi8qJaA1xAgyga02WtRebCxooVuewPOsFs14E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwD9Xngw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwD9Xngw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7001FC116D0;
	Thu, 15 Jan 2026 17:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497338;
	bh=kCVhgyaH15WqD9MFRD638Cl1QNh3dZpRhHszTq7eSfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwD9XngwiC8/onnK7suXGnyhItUYj2k6b3Sjq/uhP+AsN1uY88BhsDbwnDLOqj6R9
	 GSvBDyfeuWWvJU4iufvZkfPpnKiqy85uWB25I66ZAPXZuIatcmTKsBget3I/JUoG+m
	 Qxuv+iWhF6haD0Wo3lpLRsp6aWHt0NiLpOCGljp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philippe De Muyter <phdm@macqel.be>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 046/554] iio: imu: st_lsm6dsx: discard samples during filters settling time
Date: Thu, 15 Jan 2026 17:41:52 +0100
Message-ID: <20260115164247.913506741@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit db3c490503bee4d0611f9fc17fcd8cfe6fcdbcad ]

During digital filters settling time the driver is expected to drop
samples since they can be corrupted. Introduce the capability to drop
a given number of samples according to the configured ODR.
Add sample_to_discard for LSM6DSM-like sensors since new generation
devices (e.g. LSM6DSO) support DRDY mask where corrupted samples are
masked in hw with values greather than 0x7ffd so the driver can easily
discard them.
I have not added sample_to_discard support for LSM6DS3 or LSM6DS3H since
I do not have any sample for testing at the moment.

Reported-by: Philippe De Muyter <phdm@macqel.be>
Tested-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/21dcd94935c147ef9b1da4984b3da6264ee9609e.1677496295.git.lorenzo@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: c6d702f2b771 ("iio: imu: st_lsm6dsx: Fix measurement unit for odr struct member")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h       | 11 ++++
 .../iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c    | 57 ++++++++++++++++---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c  | 18 ++++++
 3 files changed, 78 insertions(+), 8 deletions(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
index 6a6e963fe9731..d448c802572eb 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -124,6 +124,13 @@ struct st_lsm6dsx_odr_table_entry {
 	int odr_len;
 };
 
+struct st_lsm6dsx_samples_to_discard {
+	struct {
+		u32 milli_hz;
+		u16 samples;
+	} val[ST_LSM6DSX_ODR_LIST_SIZE];
+};
+
 struct st_lsm6dsx_fs {
 	u32 gain;
 	u8 val;
@@ -286,6 +293,7 @@ struct st_lsm6dsx_ext_dev_settings {
  * @irq_config: interrupts related registers.
  * @drdy_mask: register info for data-ready mask (addr + mask).
  * @odr_table: Hw sensors odr table (Hz + val).
+ * @samples_to_discard: Number of samples to discard for filters settling time.
  * @fs_table: Hw sensors gain table (gain + val).
  * @decimator: List of decimator register info (addr + mask).
  * @batch: List of FIFO batching register info (addr + mask).
@@ -319,6 +327,7 @@ struct st_lsm6dsx_settings {
 	} irq_config;
 	struct st_lsm6dsx_reg drdy_mask;
 	struct st_lsm6dsx_odr_table_entry odr_table[2];
+	struct st_lsm6dsx_samples_to_discard samples_to_discard[2];
 	struct st_lsm6dsx_fs_table_entry fs_table[2];
 	struct st_lsm6dsx_reg decimator[ST_LSM6DSX_ID_MAX];
 	struct st_lsm6dsx_reg batch[2];
@@ -340,6 +349,7 @@ enum st_lsm6dsx_fifo_mode {
  * @hw: Pointer to instance of struct st_lsm6dsx_hw.
  * @gain: Configured sensor sensitivity.
  * @odr: Output data rate of the sensor [Hz].
+ * @samples_to_discard: Number of samples to discard for filters settling time.
  * @watermark: Sensor watermark level.
  * @decimator: Sensor decimation factor.
  * @sip: Number of samples in a given pattern.
@@ -354,6 +364,7 @@ struct st_lsm6dsx_sensor {
 	u32 gain;
 	u32 odr;
 
+	u16 samples_to_discard;
 	u16 watermark;
 	u8 decimator;
 	u8 sip;
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
index 9ebaf73561336..635a9018e7dba 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_buffer.c
@@ -459,17 +459,31 @@ int st_lsm6dsx_read_fifo(struct st_lsm6dsx_hw *hw)
 			}
 
 			if (gyro_sip > 0 && !(sip % gyro_sensor->decimator)) {
-				iio_push_to_buffers_with_timestamp(
-					hw->iio_devs[ST_LSM6DSX_ID_GYRO],
-					&hw->scan[ST_LSM6DSX_ID_GYRO],
-					gyro_sensor->ts_ref + ts);
+				/*
+				 * We need to discards gyro samples during
+				 * filters settling time
+				 */
+				if (gyro_sensor->samples_to_discard > 0)
+					gyro_sensor->samples_to_discard--;
+				else
+					iio_push_to_buffers_with_timestamp(
+						hw->iio_devs[ST_LSM6DSX_ID_GYRO],
+						&hw->scan[ST_LSM6DSX_ID_GYRO],
+						gyro_sensor->ts_ref + ts);
 				gyro_sip--;
 			}
 			if (acc_sip > 0 && !(sip % acc_sensor->decimator)) {
-				iio_push_to_buffers_with_timestamp(
-					hw->iio_devs[ST_LSM6DSX_ID_ACC],
-					&hw->scan[ST_LSM6DSX_ID_ACC],
-					acc_sensor->ts_ref + ts);
+				/*
+				 * We need to discards accel samples during
+				 * filters settling time
+				 */
+				if (acc_sensor->samples_to_discard > 0)
+					acc_sensor->samples_to_discard--;
+				else
+					iio_push_to_buffers_with_timestamp(
+						hw->iio_devs[ST_LSM6DSX_ID_ACC],
+						&hw->scan[ST_LSM6DSX_ID_ACC],
+						acc_sensor->ts_ref + ts);
 				acc_sip--;
 			}
 			if (ext_sip > 0 && !(sip % ext_sensor->decimator)) {
@@ -659,6 +673,30 @@ int st_lsm6dsx_flush_fifo(struct st_lsm6dsx_hw *hw)
 	return err;
 }
 
+static void
+st_lsm6dsx_update_samples_to_discard(struct st_lsm6dsx_sensor *sensor)
+{
+	const struct st_lsm6dsx_samples_to_discard *data;
+	struct st_lsm6dsx_hw *hw = sensor->hw;
+	int i;
+
+	if (sensor->id != ST_LSM6DSX_ID_GYRO &&
+	    sensor->id != ST_LSM6DSX_ID_ACC)
+		return;
+
+	/* check if drdy mask is supported in hw */
+	if (hw->settings->drdy_mask.addr)
+		return;
+
+	data = &hw->settings->samples_to_discard[sensor->id];
+	for (i = 0; i < ST_LSM6DSX_ODR_LIST_SIZE; i++) {
+		if (data->val[i].milli_hz == sensor->odr) {
+			sensor->samples_to_discard = data->val[i].samples;
+			return;
+		}
+	}
+}
+
 int st_lsm6dsx_update_fifo(struct st_lsm6dsx_sensor *sensor, bool enable)
 {
 	struct st_lsm6dsx_hw *hw = sensor->hw;
@@ -678,6 +716,9 @@ int st_lsm6dsx_update_fifo(struct st_lsm6dsx_sensor *sensor, bool enable)
 			goto out;
 	}
 
+	if (enable)
+		st_lsm6dsx_update_samples_to_discard(sensor);
+
 	err = st_lsm6dsx_device_set_enable(sensor, enable);
 	if (err < 0)
 		goto out;
diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
index dd674f3119ad2..f4872860cb458 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -622,6 +622,24 @@ static const struct st_lsm6dsx_settings st_lsm6dsx_sensor_settings[] = {
 				.fs_len = 4,
 			},
 		},
+		.samples_to_discard = {
+			[ST_LSM6DSX_ID_ACC] = {
+				.val[0] = {  12500, 1 },
+				.val[1] = {  26000, 1 },
+				.val[2] = {  52000, 1 },
+				.val[3] = { 104000, 2 },
+				.val[4] = { 208000, 2 },
+				.val[5] = { 416000, 2 },
+			},
+			[ST_LSM6DSX_ID_GYRO] = {
+				.val[0] = {  12500,  2 },
+				.val[1] = {  26000,  5 },
+				.val[2] = {  52000,  7 },
+				.val[3] = { 104000, 12 },
+				.val[4] = { 208000, 20 },
+				.val[5] = { 416000, 36 },
+			},
+		},
 		.irq_config = {
 			.irq1 = {
 				.addr = 0x0d,
-- 
2.51.0



