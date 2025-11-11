Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E1A2DC32A;
	Tue, 11 Nov 2025 01:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823680; cv=none; b=Omr4kwHilBCfMcfiVXEzYgKw7yGqBtBYPH2ovRmhcjeVKc9Lcd4lrSO9MtTiLTEaITxVuEh5THUvDyYDyKhCJP3DiUadzHWhLS15bbNhpnFXQuJGSenEUVaNhK1K+lf/3StFiaBPcCruyWRSbyNnaFcKN9srkatdajsLaGpcw5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823680; c=relaxed/simple;
	bh=jxmJhfxPYn8BKEmG9C0YlcYPaMMpzI13ByFbRwLBRCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyVOzfjNBUe7/9rY1MbaRst3fdZFH65WxWCf5Ek+Yn6CFMpvhQ7fnEoXpS++MkVysxb2hbAea2vFNiFqqmTvvsLBkHkytokgNiZzAr5Ef4eSiXEPpGLU+eYmp0skFK/iFQJgm/vZxyC7hm39F9MkbUpqiHRfhz/ydTs0MNMHoMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSfD4JBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSfD4JBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31528C16AAE;
	Tue, 11 Nov 2025 01:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823680;
	bh=jxmJhfxPYn8BKEmG9C0YlcYPaMMpzI13ByFbRwLBRCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSfD4JBwVyxKYMq52ODRKBn9FOjYMbeVrpe9sHZwLMB6LN6tO2LlzhiRuWyH68vJV
	 0txXI8eeRC1Fhe7ZbfHnBKYKUKwGlKuuXJkDMwVbm85warwzWCtyZPXIgzV4qY8/f2
	 ZmuRLC9FWp9gFtwCNaUqEEr8fpS8XpGWoxgNZIXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cryolitia PukNgae <cryolitia@uniontech.com>,
	Andy Shevchenko <andy@kernel.org>,
	Alex Lanzano <lanzano.alex@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 349/849] iio: imu: bmi270: Match PNP ID found on newer GPD firmware
Date: Tue, 11 Nov 2025 09:38:39 +0900
Message-ID: <20251111004544.857229858@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cryolitia PukNgae <cryolitia@uniontech.com>

[ Upstream commit dc757dc1572d579c2634c05d0a03c5676227c571 ]

GPD devices originally used BMI160 sensors with the "BMI0160" PNP ID.
When they switched to BMI260 sensors in newer hardware, they reused
the existing Windows driver which accepts both "BMI0160" and "BMI0260"
IDs. Consequently, they kept "BMI0160" in DSDT tables for new BMI260
devices, causing driver mismatches in Linux.

1. GPD updated BIOS v0.40+[1] for newer devices to report "BMI0260" for
BMI260 sensors to avoid loading the bmi160 driver on Linux. While this
isn't Bosch's VID;
2. Bosch's official Windows driver uses "BMI0260" as a compatible ID
3. We're seeing real devices shipping with "BMI0260" in DSDT

The DSDT excerpt of GPD G1619-04 with BIOS v0.40:

Scope (_SB.I2CC)
{
    Device (BMA2)
    {
        Name (_ADR, Zero)  // _ADR: Address
        Name (_HID, "BMI0260")  // _HID: Hardware ID
        Name (_CID, "BMI0260")  // _CID: Compatible ID
        Name (_DDN, "Accelerometer")  // _DDN: DOS Device Name
        Name (_UID, One)  // _UID: Unique ID
        Method (_CRS, 0, NotSerialized)  // _CRS: Current Resource Settings
        {
            Name (RBUF, ResourceTemplate ()
            {
                I2cSerialBusV2 (0x0069, ControllerInitiated, 0x00061A80,
                    AddressingMode7Bit, "\\_SB.I2CC",
                    0x00, ResourceConsumer, , Exclusive,
                    )
            })
            Return (RBUF) /* \_SB_.I2CC.BMA2._CRS.RBUF */
        }
        # omit some noise
    }
}

Link: http://download.softwincn.com/WIN%20Max%202024/Max2-7840-BIOS-V0.41.zip #1
Signed-off-by: Cryolitia PukNgae <cryolitia@uniontech.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Acked-by: Alex Lanzano <lanzano.alex@gmail.com>
Link: https://patch.msgid.link/20250821-bmi270-gpd-acpi-v4-1-5279b471d749@uniontech.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/bmi270/bmi270_i2c.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/imu/bmi270/bmi270_i2c.c b/drivers/iio/imu/bmi270/bmi270_i2c.c
index c77839b03a969..b909a421ad017 100644
--- a/drivers/iio/imu/bmi270/bmi270_i2c.c
+++ b/drivers/iio/imu/bmi270/bmi270_i2c.c
@@ -41,6 +41,8 @@ static const struct i2c_device_id bmi270_i2c_id[] = {
 static const struct acpi_device_id bmi270_acpi_match[] = {
 	/* GPD Win Mini, Aya Neo AIR Pro, OXP Mini Pro, etc. */
 	{ "BMI0160",  (kernel_ulong_t)&bmi260_chip_info },
+	/* GPD Win Max 2 2023(sincice BIOS v0.40), etc. */
+	{ "BMI0260",  (kernel_ulong_t)&bmi260_chip_info },
 	{ }
 };
 
-- 
2.51.0



