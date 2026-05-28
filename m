Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC603002A0;
	Thu, 28 May 2026 20:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999709; cv=none; b=W1CcPRmU7opKMO7fOA0qrAEx52Lf9YKbaagcNf9xEd5XK7/ygg5y4vUgGya8s1Eq4fWNCQ631Za2AbAgG88IDXeJSTL54xNOol8nvHxg54YGT+PR+Swt5LhLrYyKOMbWW5Yi+37MjgBmb3+mgtFeA9AgqPpFxkdJVcjUR1iaET4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999709; c=relaxed/simple;
	bh=7kTAAIIr7+RBJCGznQ7JTsv9NZXryfnaBZe8pb4jelc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTKbIctVb366nGntAqQR5DdldQghFqufq9SSSkvVgRRcK5jYC4XOw4rpI9p+tv59pRtHsviVEUaWMUaxfdIxynvHIuQYUoOLoTvyp9Hp0NZF0EmUHKmLK3D336Immm/tFJxg3XsAc8pWtQq/zI2WL1x02qFj7F5zUNUMs18bEAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uIohPYwW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uIohPYwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB0A71F000E9;
	Thu, 28 May 2026 20:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999708;
	bh=LzZr0+CN6Vu1GFNik/wU/K9bplfc/VqXCILwVcUy9oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uIohPYwWhPmCXHSj490dVJFwtHkmm3PA1uAgBGsh9uzxVWm8e0AmstDG8xPbI1Be1
	 xk3QloUsM2TvCdfF42JXEqOJAuTQG/fuKXI8AkiM4AOgMIBVM6o3Adg66hvHBPQuU+
	 dReVjH2fcph6w57H8hMohtZ3r87GMU5r0DNPjcfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 164/377] hwmon: (pmbus/adm1266) bounce blackbox records through a protocol-sized buffer
Date: Thu, 28 May 2026 21:46:42 +0200
Message-ID: <20260528194643.178512935@linuxfoundation.org>
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
@@ -348,6 +348,7 @@ static void adm1266_init_debugfs(struct
 
 static int adm1266_nvmem_read_blackbox(struct adm1266_data *data, u8 *read_buff)
 {
+	u8 record[ADM1266_PMBUS_BLOCK_MAX];
 	int record_count;
 	char index;
 	u8 buf[I2C_SMBUS_BLOCK_MAX];
@@ -365,13 +366,14 @@ static int adm1266_nvmem_read_blackbox(s
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
 


