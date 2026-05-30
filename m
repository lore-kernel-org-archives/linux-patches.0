Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219AB248F66;
	Sat, 30 May 2026 18:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167100; cv=none; b=UpusPG7vR0Scz9UMc0xINVslCbcV/5xi9vUdTjHmGStjwDVZ9n72nIgHoQUhPnnem1YjBgneoMB7DHyqBrpojeyfuawMHjsCJ/soSGDtCa4vaQAWgoeG9VqQmh7KvIJjsd0wXrO/PLMrbA8TEXmRBUvDp+9Vnu2jcS8uBtcsQ2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167100; c=relaxed/simple;
	bh=cgm/pys4Q8qz0ObWWY6mWoz97bO97dEgTRMpP0MMEJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpemkvqmUr/DmFEiD1TPUNer6MobhPQzgpvMpNiigCixWXsOf0FfxgDPVRzrAvn8gfjzbzvkdCOlj4W1ZlAapTwabuNlp7WH+WqfzFv/f83FyJIcQ3JIro1rmf5lVI0pSzdebKJxIEOl74ty9B3TmrjHPMr3KZzGqicOFMM9At0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsDbrbr3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsDbrbr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D0B1F00893;
	Sat, 30 May 2026 18:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167099;
	bh=w7eDVZKjJ5fbUaFcTQao0qAHzG6UTRvY9+VpSht6Gg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XsDbrbr3Y53N3tx3SxW4a0kWsBwdqyxMUELnVnxGENxV/ZtBCQY1f10FZOz23nL/b
	 fEBeGfhEc0aj86sE0EK0IKm5nuQvMMgOPGREmrnBZB9/+Ucz4/Mzs56mLXWOej1zzx
	 H85zLVz865Pbwr9Tw/rWflqZHFg2LDjJo/LMjgKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 563/589] hwmon: (pmbus/adm1266) bounce blackbox records through a protocol-sized buffer
Date: Sat, 30 May 2026 18:07:24 +0200
Message-ID: <20260530160239.438270679@linuxfoundation.org>
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

commit 43cae21424ff8e33894a0f86c6b80b840c049fd7 upstream.

adm1266_pmbus_block_xfer() copies the device-supplied block payload
into the caller-provided buffer using the device-supplied length:

	memcpy(data_r, &msgs[1].buf[1], msgs[1].buf[0]);

The helper does not know how large data_r is and trusts the device to
return at most one record's worth of bytes.  adm1266_nvmem_read_blackbox()
violates that contract: it advances read_buff inside data->dev_mem in
ADM1266_BLACKBOX_SIZE (64-byte) strides while the helper is willing to
write up to ADM1266_PMBUS_BLOCK_MAX (255) bytes.  A device that returns
more than 64 bytes on the trailing record (read_buff offset 1984 in
the 2048-byte dev_mem allocation) overflows dev_mem by up to 191 bytes
before the post-call

	if (ret != ADM1266_BLACKBOX_SIZE)
		return -EIO;

can reject the response.

Contain the fix in the caller without changing the helper signature:
read each record into a 255-byte local bounce buffer that matches the
helper's maximum output, validate the returned length, and only then
copy exactly ADM1266_BLACKBOX_SIZE bytes into the dev_mem slot.

Fixes: 407dc802a9c0 ("hwmon: (pmbus/adm1266) Add Block process call")
Cc: stable@vger.kernel.org
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Link: https://lore.kernel.org/r/20260515-adm1266-fixes-v1-5-1c1ea1349cfe@nexthop.ai
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/adm1266.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -350,6 +350,7 @@ static void adm1266_init_debugfs(struct
 
 static int adm1266_nvmem_read_blackbox(struct adm1266_data *data, u8 *read_buff)
 {
+	u8 record[ADM1266_PMBUS_BLOCK_MAX];
 	int record_count;
 	char index;
 	u8 buf[I2C_SMBUS_BLOCK_MAX];
@@ -367,13 +368,14 @@ static int adm1266_nvmem_read_blackbox(s
 		return -EIO;
 
 	for (index = 0; index < record_count; index++) {
-		ret = adm1266_pmbus_block_xfer(data, ADM1266_READ_BLACKBOX, 1, &index, read_buff);
+		ret = adm1266_pmbus_block_xfer(data, ADM1266_READ_BLACKBOX, 1, &index, record);
 		if (ret < 0)
 			return ret;
 
 		if (ret != ADM1266_BLACKBOX_SIZE)
 			return -EIO;
 
+		memcpy(read_buff, record, ADM1266_BLACKBOX_SIZE);
 		read_buff += ADM1266_BLACKBOX_SIZE;
 	}
 


