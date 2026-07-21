Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D095242CAFB;
	Tue, 21 Jul 2026 20:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664996; cv=none; b=ak4jbsFxQGKD92fIPZUOlFHCm8K2uYEs9gJOnZL2AQ847H1glLzHACmMYZNN2HYFEWF8uEhHeZf7uwdd2uj2MkCM/jYhyWA28hTQCk9d2sp8Zc0W49tmNy7lpVjga2fW9RBTypSmke5cXebr/iYI3Ui79tbuQvemiFzeeNetM3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664996; c=relaxed/simple;
	bh=jGsB2xJUqA+Eic3/IZfIjYA4qVQo5cdmZwwC/tSwgjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7re/CcvP2BJwjbvLgKyhdO1kyihQzi1F13KlLLFzB32jB4D8qK3YqXeEIrs8VgzKQLUy4bon/Btukh/CDKEy0/0g+C7/1wITaVwkC/ucodjG4WNK39ZNt5aK16d27uEfkhy5OdjlTT9Apwe4GROaC1+zL9WQ4JqD+pdt9ZlpRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kaz5PGS+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kaz5PGS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F5D1F000E9;
	Tue, 21 Jul 2026 20:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664994;
	bh=qjLA1iw5KHQz6grFv2RqBTk8+SYsLEamJZILYaMDrlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kaz5PGS+muBtZHgEYaPIEfvP12Q/fCz2BOXeYDUe1jlE7BZRVpIcjJm/ZAB49XxKt
	 5K8Efe5kboeLy3ADrVRyuuP/g/cWfpiWrz9u8BzW8J5HtU6pXWotHHcNWvdpbyYzTd
	 olq8yilIm8uIHgOKpWrMZpKfJcGDpa3cfKGSXc4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kempe <andreas.kempe@actia.se>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.6 0094/1266] iio: imu: st_lsm6dsx: deselect shub page before reading whoami
Date: Tue, 21 Jul 2026 17:08:51 +0200
Message-ID: <20260721152443.908469024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Kempe <andreas.kempe@actia.se>

commit aede83625ff5d9539508582036df30c809d51058 upstream.

As part of driver initialization, e.g. st_lsm6dsx_init_shub() selects
the shub register page using st_lsm6dsx_set_page(). Selecting the shub
register page shadows the regular register space so whoami, among other
registers, is no longer accessible.

In applications where the IMU is permanently powered separately from the
processor, there is a window where a reset of the CPU leaves the IMU in
the shub register page. Once this occurs, any subsequent probe attempt
fails because of the register shadowing.

Using the ism330dlc, the error typically looks like

    st_lsm6dsx_i2c 3-006a: unsupported whoami [10]

with the unknown whoami read from a reserved register in the shub page.

The reset register is also shadowed by the page select, preventing a
reset from recovering the chip.

Unconditionally clear the shub page before the whoami readout to ensure
normal register access and allow the initialization to proceed.

Place the fix in st_lsm6dsx_check_whoami() before the whoami check
because hw->settings, which st_lsm6dsx_set_page() relies on, is first
assigned in that function.

Placing the fix in a more logical place than the whoami check would
require a bigger restructuring of the code.

Fixes: c91c1c844ebd ("iio: imu: st_lsm6dsx: add i2c embedded controller support")
Signed-off-by: Andreas Kempe <andreas.kempe@actia.se>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -1576,6 +1576,26 @@ static int st_lsm6dsx_check_whoami(struc
 		return -ENODEV;
 	}
 
+	hw->settings = &st_lsm6dsx_sensor_settings[i];
+
+	if (hw->settings->shub_settings.page_mux.addr) {
+		/*
+		 * If the IMU has the shub page selected on init, for example
+		 * after a CPU watchdog reset while the page is selected, the
+		 * regular register space is shadowed. While the regular
+		 * register space is shadowed, the registers needed for
+		 * initializing the IMU are not available.
+		 *
+		 * Unconditionally clear the shub page selection to ensure
+		 * normal register access.
+		 */
+		err = st_lsm6dsx_set_page(hw, false);
+		if (err < 0) {
+			dev_err(hw->dev, "failed to clear shub page\n");
+			return err;
+		}
+	}
+
 	err = regmap_read(hw->regmap, ST_LSM6DSX_REG_WHOAMI_ADDR, &data);
 	if (err < 0) {
 		dev_err(hw->dev, "failed to read whoami register\n");
@@ -1588,7 +1608,6 @@ static int st_lsm6dsx_check_whoami(struc
 	}
 
 	*name = st_lsm6dsx_sensor_settings[i].id[j].name;
-	hw->settings = &st_lsm6dsx_sensor_settings[i];
 
 	return 0;
 }


