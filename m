Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152C22459DD;
	Thu, 28 May 2026 20:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001269; cv=none; b=CEnrGW6TupzWkEg8Rpo39JFCj7AeoUOGjtmjmIoHPydbtsqKt+6Dm+4lNa4S3gGsgx/34cwHhSpKxRskJFuvt090W6tw7u9UPeh13ZvbW8qRf5pNL/q3MmcssdM9AI0PJ7BoqYzIvfsb7om8zgmOOAB38JFmXS1y1IVOkcwSWb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001269; c=relaxed/simple;
	bh=j26fEc2dmHW8pqupDzUN7RxuC7uBblboO4t0jHjuCgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vyo9JH+wMpFierxao0VdwIjXNvO7lfgVuAE0oZrad6NJQsoXrUe4nYPeX+0+uDf/S/dw3vonXSXZ2Cmy7NniNNF1vHsP+6Ehos887V41vV7oHwynIaYPCBCoXrdCCHSDvH1Fyz0NK4NtUdRr0CIvvLWIFDmyqMbVSR5s8ErE3+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmpvzCN6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmpvzCN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72ABF1F000E9;
	Thu, 28 May 2026 20:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001268;
	bh=xNc52kssG2lih/XxrqkrUx9uHpma7sX6JBNlmFEH6ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UmpvzCN69mUjZXBHMjHJRSRScjEutB6a24VHL7zHynvpSAUSEOurY1Ot9QEr8Uo3s
	 9Dmqdpd+Z2Pp7YH2pkn0bkjDYYviE/cp8lRicBS+PUEqp6n1HRRi2QrAB12Y4cWasc
	 Vyxyajy1l68CToh5Z6i7hT9JgPhereCqMI4D55nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 028/186] hwmon: (pmbus/adm1266) widen blackbox-info buffer to I2C_SMBUS_BLOCK_MAX
Date: Thu, 28 May 2026 21:48:28 +0200
Message-ID: <20260528194929.722231283@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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
@@ -349,7 +349,7 @@ static int adm1266_nvmem_read_blackbox(s
 {
 	int record_count;
 	char index;
-	u8 buf[5];
+	u8 buf[I2C_SMBUS_BLOCK_MAX];
 	int ret;
 
 	ret = i2c_smbus_read_block_data(data->client, ADM1266_BLACKBOX_INFO, buf);


