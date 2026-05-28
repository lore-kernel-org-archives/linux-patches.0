Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C005933F5B4;
	Thu, 28 May 2026 20:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999706; cv=none; b=RZ3VnJubWYzmvKnzlmKtE+rCgmWfuDQG8xWV3JN+PTqeK+U62Pz4KXRCZfhjhS0h3GPTz7rJp0RzG10eCGkKTY70rt9XfUFo52OVKHVuyXWfdMHYNKPEd1NmEBbzy1Ji6RgU6B5porV9OU0KWSt7/Iog4TknN4SIHFRyCZqwsUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999706; c=relaxed/simple;
	bh=Nn2yLH6+xdAMFataAEn20RRUbKAFvKmGhsDxZgIB/K0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gon6HrzpSjmtTaXro0L5PGpxQnw6MIlFQ47THV22Ca9A5tkJgJwFy94CwHrxBG9X+Zg+E5XfbioBgAryvqBoX+bLVkuwEsqvhxkxJyA5jAZBITs1YtO+6CDcsFRsxEKd6dRY11NWk02+hmfEaS1ghJ3Sl60BwY2ESzIDadSiBJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oe/JFb5J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oe/JFb5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC8E1F000E9;
	Thu, 28 May 2026 20:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999705;
	bh=m6AAwWd54SnA3Y/RlJ0vySS5z0nvswAxhXati2oADY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oe/JFb5J11CrHrdpm31VdkS/bHtW6zt5sR8E+zhA6bySripRsFQ6/KJy5LrGt7aXW
	 0ezLJ3qgFmM1pgkvqV0h4YTGuuY1PYnQrw8HEJWCvX432IPnZAp/Xns+er3cvTTykX
	 FeQD1VWnsk0pxPGliTWbh0bFu02AQT7cfbwmdzaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 163/377] hwmon: (pmbus/adm1266) include PEC byte in pmbus_block_xfer read buffer
Date: Thu, 28 May 2026 21:46:41 +0200
Message-ID: <20260528194643.148586991@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit 487566cb1ccdf3756fdd7bf8d875e612ff3169bb upstream.

adm1266_pmbus_block_xfer() sets up the read transaction with

	.buf = data->read_buf,
	.len = ADM1266_PMBUS_BLOCK_MAX + 2,

but read_buf in struct adm1266_data is declared as

	u8 read_buf[ADM1266_PMBUS_BLOCK_MAX + 1];

For a max-length block response (length byte = 255 + up to 1 PEC
byte), the i2c controller is told to write 257 bytes into a 256-byte
buffer, putting one byte past the end of read_buf.  The same response
also makes the subsequent PEC compare

	if (crc != msgs[1].buf[msgs[1].buf[0] + 1])

read a byte beyond the array.

Bump the read_buf declaration to ADM1266_PMBUS_BLOCK_MAX + 2 so the
buffer can hold the length byte, up to 255 payload bytes, and the PEC
byte the i2c_msg length already accounts for.

Fixes: 407dc802a9c0 ("hwmon: (pmbus/adm1266) Add Block process call")
Cc: stable@vger.kernel.org
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://lore.kernel.org/r/20260515-adm1266-fixes-v1-4-1c1ea1349cfe@nexthop.ai
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/adm1266.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -61,7 +61,7 @@ struct adm1266_data {
 	u8 *dev_mem;
 	struct mutex buf_mutex;
 	u8 write_buf[ADM1266_PMBUS_BLOCK_MAX + 1] ____cacheline_aligned;
-	u8 read_buf[ADM1266_PMBUS_BLOCK_MAX + 1] ____cacheline_aligned;
+	u8 read_buf[ADM1266_PMBUS_BLOCK_MAX + 2] ____cacheline_aligned;
 };
 
 static const struct nvmem_cell_info adm1266_nvmem_cells[] = {


