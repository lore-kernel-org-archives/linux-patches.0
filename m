Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5105A3BED2D;
	Thu, 16 Jul 2026 13:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209080; cv=none; b=D5xeoZUp1UJ8OTAeWi8jWUEicCx4e+9FW07WkDTcEygWPOjTb+xvOTt8Ch38tzvEt+tVVThZJ1OZ3IGg/Oc5qq0iVyQQ14/DO7I2UDj3RITvgnTFJBJ9uD5O+l4ijOjGEsUe387d5rvDNaVFfHhwbJo276qIRL9hpGu6ivVPYxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209080; c=relaxed/simple;
	bh=1hoTZJUn+Lc67PNzNBNYHO1HTVjixxKGxZVqdSIol2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rqH777fTXNuv/Q4aXS9/rK9cAoN8e/hhokd70Fx0qpAxw+pSIwUV9GRLjR3UV2XKFbVwo+P21KxXPOXxO0/AJeF5Hcdp3ZZ0GwSUnJ497upJFlzO0x/sLysXd9VeGjLxMrqk/qkHXrYe1ah+lc2Daq9HY6aFMTlqUCdj+QfByck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSV+xkpK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSV+xkpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C991F000E9;
	Thu, 16 Jul 2026 13:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209079;
	bh=afe7dLZSrxx3cvFrGcMygQXZcvJnDxOROIU08kXJ6os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSV+xkpK4rd6VOUyCg3w1xN03dfjY5BHwLTn5qF2Euqz9JEoOfgvQs94sWqTuzumg
	 q+hiX4Lkx/D3vgtbTOWq7XhPygOjVrrVE+UI8eNkZ36JYcUW1Q6Gucl4I6aEYwk3fX
	 6q9FSmcaJ88Lt3JbDVcgBbOqYyoz7p8dvof6VG14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herman van Hazendonk <github.com@herrie.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 049/518] iio: common: st_sensors: honour channel endianness in read_axis_data
Date: Thu, 16 Jul 2026 15:25:17 +0200
Message-ID: <20260716133048.859794481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herman van Hazendonk <github.com@herrie.org>

commit 55052184ac9011db2ea983e54d6c21f0b1079a12 upstream.

st_sensors_read_axis_data() unconditionally decoded multi-byte
results with get_unaligned_le16() / get_unaligned_le24() regardless
of the channel's declared scan_type.endianness.

For every ST sensor that has used this helper since it was introduced
this happened to be fine because the ST IMU/accel/gyro/pressure
families publish their data registers as little-endian and the
channel specs in those drivers declare IIO_LE accordingly.

The LSM303DLH magnetometer however publishes its X/Y/Z output as a
pair of big-endian bytes (the H register sits at the lower address,
0x03/0x05/0x07, and the L register immediately after), and its
channel specs in st_magn_core.c correctly declare IIO_BE -- but
read_axis_data() ignored that and decoded as little-endian, swapping
the high and low bytes of every magnetometer sample. The LSM303DLHC
and LSM303DLM share the same st_magn_16bit_channels (IIO_BE) and
were therefore byte-swapped by the same bug; users of those parts
will see different in_magn_*_raw values after this fix lands.

The bug is most visible on a stationary chip: in earth's field the
true X reading is small and the high byte sits at 0x00, so swapping
the bytes pins sysfs X at exactly the low byte's pattern (e.g. 0x00F0
= 240). Y and Z still appear "to vary" because their magnitudes are
larger and the noise in the low byte produces big swings in the
swapped high byte:

  before (LSM303DLH flat, sysfs in_magn_*_raw):
      X=240 (stuck), Y= 12032..23296, Z=-16128..-9728

  after (direct i2c-dev big-endian decode, same chip same orientation):
      X≈-4096, Y≈210, Z≈80     (sensible values reflecting earth's
                                ambient field at low gauss range)

Fix read_axis_data() to dispatch on ch->scan_type.endianness and
call get_unaligned_be16() / get_unaligned_be24() when the channel
declares IIO_BE. Existing IIO_LE consumers (st_accel, st_gyro,
st_pressure, st_lsm6dsx and others) are unaffected because their
channel specs already declare IIO_LE and the LE path is unchanged.

While restructuring the branches, replace the previously implicit
silent-success-with-uninitialised-*data fall-through for
byte_for_channel outside 1..3 with an explicit return -EINVAL. No
in-tree ST sensor publishes such a channel, but the new behaviour
is strictly safer than handing userspace garbage.

Fixes: 23491b513bcd ("iio:common: Add STMicroelectronics common library")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7 sparse smatch clang-analyzer coccinelle checkpatch
Assisted-by: Sashiko:claude-opus-4-7
Signed-off-by: Herman van Hazendonk <github.com@herrie.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/st_sensors/st_sensors_core.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/iio/common/st_sensors/st_sensors_core.c
+++ b/drivers/iio/common/st_sensors/st_sensors_core.c
@@ -498,6 +498,7 @@ static int st_sensors_read_axis_data(str
 	u8 *outdata;
 	struct st_sensor_data *sdata = iio_priv(indio_dev);
 	unsigned int byte_for_channel;
+	u32 tmp;
 
 	byte_for_channel = DIV_ROUND_UP(ch->scan_type.realbits +
 					ch->scan_type.shift, 8);
@@ -508,12 +509,22 @@ static int st_sensors_read_axis_data(str
 	if (err < 0)
 		return err;
 
-	if (byte_for_channel == 1)
-		*data = (s8)*outdata;
-	else if (byte_for_channel == 2)
-		*data = (s16)get_unaligned_le16(outdata);
-	else if (byte_for_channel == 3)
-		*data = (s32)sign_extend32(get_unaligned_le24(outdata), 23);
+	if (byte_for_channel == 1) {
+		tmp = *outdata;
+	} else if (byte_for_channel == 2) {
+		if (ch->scan_type.endianness == IIO_BE)
+			tmp = get_unaligned_be16(outdata);
+		else
+			tmp = get_unaligned_le16(outdata);
+	} else if (byte_for_channel == 3) {
+		if (ch->scan_type.endianness == IIO_BE)
+			tmp = get_unaligned_be24(outdata);
+		else
+			tmp = get_unaligned_le24(outdata);
+	} else {
+		return -EINVAL;
+	}
+	*data = sign_extend32(tmp, BYTES_TO_BITS(byte_for_channel) - 1);
 
 	return 0;
 }


