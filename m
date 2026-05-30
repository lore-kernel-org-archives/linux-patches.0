Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0185A15E5BB;
	Sat, 30 May 2026 18:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166979; cv=none; b=qqV3IEQ/mFp0KiUOmuIFP8U1Apx9K7UiYwiHAG9RjzKEuWwGMdmYkwsT2ShJBkgGFVvCoAGVAPpR7vDUylCSuQE6v4qiuPEJ2TNZvWtDO1mAH284fz0sEKXKt9yPoD2K8YM5juENaXjZoN403K6G/Wbr07SPjj0IccZ9AfxVaOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166979; c=relaxed/simple;
	bh=LEbjtSkvjPbzfRoXm6LCthBKEA1PytU6AoOJHsKet8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3Mtt7ShLQ/dl7fXA0LwNan3QEEDtOwcF1PSoIf8pmLDfKZ1n1t73nliz+Gb6iUWDEsg4wNOEfzhwPeTjJklVQVm8oa2DlvJll91XmmctKCkI+t2VvxZKoUfV2f6Eleok18KTF4aX1/bzA4SqmCvtmjKiFxWSngvG8I6GwiRvJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRq8PfjW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRq8PfjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449601F00893;
	Sat, 30 May 2026 18:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166978;
	bh=t5JSzqysmAA3F41Tam12C+rGrZku/6YJvsIlH4puejk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRq8PfjW8uvjIlOY24JFGXhcW+MSQmcV1Yi8lGZAlvAs1VZ9Yp1yFqr0yec/HUONM
	 WKba2HCBZfuvSAIXP4fYKKSTgXDAJRVWwYx9utRQIF2b6hpuBEnFmc52clS4ptdhMu
	 r6ncsCZo+KMuIcQgFUzhgTbmZ/56Xv2SrTFfvY3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 528/589] hwmon: (pmbus/adm1266) widen blackbox-info buffer to I2C_SMBUS_BLOCK_MAX
Date: Sat, 30 May 2026 18:06:49 +0200
Message-ID: <20260530160238.547170953@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit eee213daa1e1b402eb631bcd1b8c5aa340a6b081 upstream.

adm1266_nvmem_read_blackbox() declares a 5-byte stack buffer and
passes it to i2c_smbus_read_block_data() to retrieve the 4-byte
BLACKBOX_INFO response.  i2c_smbus_read_block_data() does not honour
caller buffer sizes -- it memcpy()s data.block[0] bytes from the
SMBus transaction (where data.block[0] is the length byte returned by
the slave device, up to I2C_SMBUS_BLOCK_MAX = 32):

	memcpy(values, &data.block[1], data.block[0]);

If the device returns any block length above 5, the call overflows
the caller's 5-byte stack buffer before the post-call

	if (ret != 4)
		return -EIO;

check has a chance to reject the response.

Widen the local buffer to I2C_SMBUS_BLOCK_MAX so the helper has room
for any well-formed SMBus block response, matching the convention used
by the other i2c_smbus_read_block_data() callers in this driver.

Fixes: 15609d189302 ("hwmon: (pmbus/adm1266) read blackbox")
Cc: stable@vger.kernel.org
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://lore.kernel.org/r/20260515-adm1266-fixes-v1-2-1c1ea1349cfe@nexthop.ai
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/adm1266.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -351,7 +351,7 @@ static int adm1266_nvmem_read_blackbox(s
 {
 	int record_count;
 	char index;
-	u8 buf[5];
+	u8 buf[I2C_SMBUS_BLOCK_MAX];
 	int ret;
 
 	ret = i2c_smbus_read_block_data(data->client, ADM1266_BLACKBOX_INFO, buf);


