Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44512FDC5E;
	Sat, 30 May 2026 17:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162163; cv=none; b=GKrSZ31HwRXFgW9C2+xRqoSQgN+mVN3Q4J+iO+21ibEYyip95sFZ5fmuiC7oPItS9MRGfAThXvV0VHlMQI8aS2Xh+2SgZde6ey8yct6eqiQGZRIzSK7Jfyl/4LUF4DSQH7ei9D9rjZd7tBiJdemBDL67D9cExBKjtQSboH/3Nfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162163; c=relaxed/simple;
	bh=0oq705O3hSIj0+trKnS6IDcMcWMZXUiO7ymqwljmpe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiIGRSyiGuHynORPzciC52fdGZHGDrnpjIKZ5nep97ZLERqH1x/MfNT4T6Pk0JmXJvIcqlGi0hoUjKQsufJwWea9TblspEKu2Vq/F2kDIaIM5jRPB2+ogpSIan1EmccJQ7zOC6jvGQFUemknaeK59aPK2IIlt9J8cXB4dD4l7HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yeU6tuWp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yeU6tuWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81F71F00893;
	Sat, 30 May 2026 17:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162162;
	bh=7niFXu7eqAnSJMX/xGgYn8UUNtC1q8C+K+U2V+lRJ5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yeU6tuWpt+wVVJ3JM7vrwnwd6udxOgF9/BW3Liw5HTGiB5F8eP9dRymaQxnQlD9a3
	 0dwpw9PNA/W1XqAmwQOzP+YrPAYEEw8eJXxqGcOlp5v1Y6+KwBMMLAmrE4j0fnxcW5
	 XCN9Mt5idU/UKMFxor5T+vBbdNG42BqFKMKmR0NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 840/969] hwmon: (pmbus/adm1266) widen blackbox-info buffer to I2C_SMBUS_BLOCK_MAX
Date: Sat, 30 May 2026 18:06:04 +0200
Message-ID: <20260530160323.849581580@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


