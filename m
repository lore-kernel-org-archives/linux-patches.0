Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A60146D53;
	Wed, 28 Jan 2026 15:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615938; cv=none; b=rjP7V3uB1auyMKeDIr+UXYwsanASqctltXfgz6irhU7fWixuTK79gVSbkyVmCVzhaTtj2W8VGgYwwYqSG+7bqlm9taMOHlh3fzr0tNEqv2WzQU+dz+yUt0FoADkn6lfLTAnioDBzd/fkB3S0ZZx5Jk6q2ejTNSFDN0f8xkqHgZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615938; c=relaxed/simple;
	bh=PdVTuEyI2tzIsgGQ7UVAguBlD0g9xC5ChVcMlsTZW18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dpl2gg8FNF4a5cX/z7Xi4YGa0VOqyD1ezD6zpEJ2XUy/g2Pl2eA5cyGdLr4NrOo6Pqpn5PJgL0dDCkRLUjXtN+nlJE8pmjjv9WX2JhGO02u8ngO1P6PRgnUZed75baKDAeqCQItQyk9Sfb+R1OVopEKRIk/47oRPezVvTE87eto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8cUOEH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8cUOEH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E157C4CEF1;
	Wed, 28 Jan 2026 15:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615938;
	bh=PdVTuEyI2tzIsgGQ7UVAguBlD0g9xC5ChVcMlsTZW18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8cUOEH50VrcbFV0627CRFfhGC+hiF6JWXLWT/+uGvErzpM332U0fuZesf5emcz1n
	 SrU8m7P8zJRNMbI1MRADb3RTCrSo4F0DotuonW2QlWZcYDyHkn5o7MC69btiaCCLSG
	 e+p9GZlsw1b9LoblyJkTgkKQM3ViJIyIFu1tfyT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitri Fedrau <dimitri.fedrau@liebherr.com>,
	Markus Koeniger <markus.koeniger@liebherr.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 158/227] iio: accel: iis328dq: fix gain values
Date: Wed, 28 Jan 2026 16:23:23 +0100
Message-ID: <20260128145350.138624820@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Koeniger <markus.koeniger@liebherr.com>

commit b8f15d1df2e73322e2112de21a4a7f3553c7fb60 upstream.

The sensors IIS328DQ and H3LIS331DL share one configuration but
H3LIS331DL has different gain parameters, configs therefore
need to be split up.
The gain parameters for the IIS328DQ are 0.98, 1.95 and 3.91,
depending on the selected measurement range.

See sensor manuals, chapter 2.1 "mechanical characteristics",
parameter "Sensitivity".

Datasheet: https://www.st.com/resource/en/datasheet/iis328dq.pdf
Datasheet: https://www.st.com/resource/en/datasheet/h3lis331dl.pdf
Fixes: 46e33707fe95 ("iio: accel: add support for IIS328DQ variant")
Reviewed-by: Dimitri Fedrau <dimitri.fedrau@liebherr.com>
Signed-off-by: Markus Koeniger <markus.koeniger@liebherr.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/st_accel_core.c |   72 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 71 insertions(+), 1 deletion(-)

--- a/drivers/iio/accel/st_accel_core.c
+++ b/drivers/iio/accel/st_accel_core.c
@@ -517,7 +517,6 @@ static const struct st_sensor_settings s
 		.wai_addr = ST_SENSORS_DEFAULT_WAI_ADDRESS,
 		.sensors_supported = {
 			[0] = H3LIS331DL_ACCEL_DEV_NAME,
-			[1] = IIS328DQ_ACCEL_DEV_NAME,
 		},
 		.ch = (struct iio_chan_spec *)st_accel_12bit_channels,
 		.odr = {
@@ -561,6 +560,77 @@ static const struct st_sensor_settings s
 				},
 			},
 		},
+		.bdu = {
+			.addr = 0x23,
+			.mask = 0x80,
+		},
+		.drdy_irq = {
+			.int1 = {
+				.addr = 0x22,
+				.mask = 0x02,
+			},
+			.int2 = {
+				.addr = 0x22,
+				.mask = 0x10,
+			},
+			.addr_ihl = 0x22,
+			.mask_ihl = 0x80,
+		},
+		.sim = {
+			.addr = 0x23,
+			.value = BIT(0),
+		},
+		.multi_read_bit = true,
+		.bootime = 2,
+	},
+	{
+		.wai = 0x32,
+		.wai_addr = ST_SENSORS_DEFAULT_WAI_ADDRESS,
+		.sensors_supported = {
+			[0] = IIS328DQ_ACCEL_DEV_NAME,
+		},
+		.ch = (struct iio_chan_spec *)st_accel_12bit_channels,
+		.odr = {
+			.addr = 0x20,
+			.mask = 0x18,
+			.odr_avl = {
+				{ .hz = 50, .value = 0x00, },
+				{ .hz = 100, .value = 0x01, },
+				{ .hz = 400, .value = 0x02, },
+				{ .hz = 1000, .value = 0x03, },
+			},
+		},
+		.pw = {
+			.addr = 0x20,
+			.mask = 0x20,
+			.value_on = ST_SENSORS_DEFAULT_POWER_ON_VALUE,
+			.value_off = ST_SENSORS_DEFAULT_POWER_OFF_VALUE,
+		},
+		.enable_axis = {
+			.addr = ST_SENSORS_DEFAULT_AXIS_ADDR,
+			.mask = ST_SENSORS_DEFAULT_AXIS_MASK,
+		},
+		.fs = {
+			.addr = 0x23,
+			.mask = 0x30,
+			.fs_avl = {
+				[0] = {
+					.num = ST_ACCEL_FS_AVL_100G,
+					.value = 0x00,
+					.gain = IIO_G_TO_M_S_2(980),
+				},
+				[1] = {
+					.num = ST_ACCEL_FS_AVL_200G,
+					.value = 0x01,
+					.gain = IIO_G_TO_M_S_2(1950),
+				},
+				[2] = {
+					.num = ST_ACCEL_FS_AVL_400G,
+					.value = 0x03,
+					.gain = IIO_G_TO_M_S_2(3910),
+				},
+			},
+		},
 		.bdu = {
 			.addr = 0x23,
 			.mask = 0x80,


