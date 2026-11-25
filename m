Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626298;
	b=rUb4ur8qRoZOENnUS73sHPmPU5zZqwNaCamlrrZKh/NPR2poeBCKx0T589sDHwnvSwLX
	 q/x9Fex2kq4X2zMoM2q80mc2ZNg7XDoHZ4nVjQ8BMfUrJDIsGboqZ5YuP/ySiTSy1Vy2V
	 lZBFPI48ERXJOQNqxPX1K125IO4fG2S6uYCMesB/w59l49K1Uki83Fjmr21zGG9Ij4CxA
	 dtiChMreBqjIJKklc5gfPZ9FRu5k5fn/HVnaMzQYk/xvEoAswvm/36Smd1654vTpNzMUT
	 6/qtFVfpO77Gy4sU17CiTBvGME40AFji9Qjed+jCxahtSCZHSOCZDdocKmYxkd5R21A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DdFYz8QQQxSP0TuNAZZWwNyjGz/149GYIYRisKdBamo=;
	b=5lP9m2Qaq7n6pF6dmapdqJ3Uon6liFaXxhsow6R/tbQN0MQrctpf1YKuqHpk+SRrlGtD
	 Ff4FIV/T0GrJEidxq5h5Imj/i+M2kOUGdFN0xr2IhyF0PBmiExBmOlfLLfEiVfcRP35y3
	 YqBzovMvvz2XTkwumQ5yKZdKThPqydUoztJXgVksYCDc9Zay+9puyQU+p8bwYoQn5YaBq
	 1qbh0RdB0d0mitPVWnvfGdXetVLy+mvyL3g6xeoipaqSAblul0WnbV+0BwBfhiczICA+w
	 q9Xu5LkBuMfLKjcs/wCZsWCESeL+ya7LSzgp0/5+1RliQbZ3Cvd0mwXgR8Sv+CuAbqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CbYnCnDs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78059606A321;
	Wed, 25 Nov 2026 17:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CbYnCnDs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75711F000C0;
	Wed, 25 Nov 2026 17:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626298;
	bh=DdFYz8QQQxSP0TuNAZZWwNyjGz/149GYIYRisKdBamo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CbYnCnDsuf6VVhdF81YhFRQnmBAUWixX7bCk1Qzj/7J4B3j2eHqEFPI4VwsUTl46u
	 ZuJWG/qAgBc9OEaWfr5ytDykPMEcnzuMqvwuaQ+1OdAG49YIIHER5sW36ZpS/lTcGQ
	 0m4QjmzH9nmEpm1jYiJmcDsAKVfhQn/s7stYd2XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnav Kapoor <kapoorarnav43@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 796/816] iio: proximity: sx9324: fix out-of-bounds read of scan period table
Date: Wed, 25 Nov 2026 15:39:04 +0100
Message-ID: <20261125143907.597239736@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnav Kapoor <kapoorarnav43@gmail.com>

commit 7b5f54280f8e6ef07664f6705dd005feefbe87d1 upstream.

The scan period of the SX9324 is selected by the 5 bit wide
SX9324_REG_GNRL_CTRL0_SCANPERIOD field, so it has 32 possible values.
sx9324_scan_period_table[] however only has 16 entries, it was copied
over from the SX9310 driver where the field is only 4 bits wide.

sx9324_wait_for_sample() indexes the table with the raw field value, so
all the codes from 16 to 31 read past the end of the array. The default
value of the register is SX9324_REG_GNRL_CTRL0_SCANPERIOD_100MS (0x16,
i.e. 22), so the out-of-bounds read happens with the default
configuration of the device. It is only avoided when the device has an
interrupt line, as the wait is only done in the polling case.

The value read is then used as the duration of an msleep() call, so the
sensor is polled with a completely random delay.

Fill the table with the scan periods of all 32 codes, which are the
periods documented for the corresponding sx9324_samp_freq_table[]
entries, and add a static assertion to keep both tables in sync.

Fixes: 4c18a890dff8 ("iio:proximity:sx9324: Add SX9324 support")
Cc: stable@vger.kernel.org
Signed-off-by: Arnav Kapoor <kapoorarnav43@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/sx9324.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/iio/proximity/sx9324.c
+++ b/drivers/iio/proximity/sx9324.c
@@ -280,11 +280,20 @@ static const struct {
 	{ 0, 250000 },  /* 11111: 4 s */
 };
 
+/*
+ * The scan period of the SX9324 is selected by the 5-bit wide
+ * SX9324_REG_GNRL_CTRL0_SCANPERIOD field. The values below are the scan
+ * periods in ms of the corresponding sx9324_samp_freq_table[] entries.
+ */
 static const unsigned int sx9324_scan_period_table[] = {
-	2,   15,  30,  45,   60,   90,	 120,  200,
-	400, 600, 800, 1000, 2000, 3000, 4000, 5000,
+	1, 2, 4, 6, 8, 10, 14, 18,			/* 0x00 - 0x07 */
+	22, 26, 30, 34, 38, 42, 46, 50,			/* 0x08 - 0x0f */
+	56, 62, 68, 74, 80, 90, 100, 200,		/* 0x10 - 0x17 */
+	300, 400, 600, 800, 1000, 2000, 3000, 4000,	/* 0x18 - 0x1f */
 };
 
+static_assert(ARRAY_SIZE(sx9324_scan_period_table) == ARRAY_SIZE(sx9324_samp_freq_table));
+
 static const struct regmap_range sx9324_writable_reg_ranges[] = {
 	/*
 	 * To set COMPSTAT for compensation, even if datasheet says register is


