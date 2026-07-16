Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5BD31E849;
	Thu, 16 Jul 2026 13:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209109; cv=none; b=VW49VH38mCJ2SMpI7QrbLfBaUsoEFE2qKiEAAv/zlN6uudh1c2Z8gMEZs4VPJJojOXKwoXGaMnBDag6noYI/JZWTi57VyI2hU+M+HVvbBjVdXWNdyWZ07ZS9cnYk5UrUQ/pNcpSX1VOsE3U0PgdqPXq6t1OkbW9M6xJs+oL4png=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209109; c=relaxed/simple;
	bh=SnN83gRH22mNayxl/OsrN/XkHlT9AQhAXDJTJoaayCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0m35fruknRETLLEtmVxwO+nUTQVcSQaSmcnTWNdBYVIaZarVnD+X6bN53jj7BNda/e64nZZ033rhjpuCUR2hQjCHcPP8kLdXvo2/2Fef0hZmg+hDBK87Kf4t1YKzJWcBeFcdCCzK+SlsDiDhyOdI9QHcygbMmeMfjGllnxlIwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3+ec4bW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3+ec4bW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EDB1F000E9;
	Thu, 16 Jul 2026 13:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209108;
	bh=FxtFzM7buJ9vTRp6uEDNrKdZzFVb3gv4CEbJKlshDr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z3+ec4bWrlYHO4J5WwqQInysvdpPwNn1P5tSUd5WKEE46ZItxL5Xe4e45e+SqHq4+
	 BAfkF3jOer00gV8zJzMouRRl4eaWdaCmVcn/cAsLAgYm5cnkrhPiw0PWOv+QoJUBB0
	 spY2zzorhvHUd/6nzPezXQLjJ2kSiWgfj9PpTEfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kempe <andreas.kempe@actia.se>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 059/518] iio: imu: st_lsm6dsx: deselect shub page before reading whoami
Date: Thu, 16 Jul 2026 15:25:27 +0200
Message-ID: <20260716133049.075921597@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1660,6 +1660,26 @@ static int st_lsm6dsx_check_whoami(struc
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
@@ -1672,7 +1692,6 @@ static int st_lsm6dsx_check_whoami(struc
 	}
 
 	*name = st_lsm6dsx_sensor_settings[i].id[j].name;
-	hw->settings = &st_lsm6dsx_sensor_settings[i];
 
 	return 0;
 }


