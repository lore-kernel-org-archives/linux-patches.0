Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD27F3176E4;
	Wed,  8 Apr 2026 18:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674566; cv=none; b=S8PRiEKXPu7A5zvJNITVGEhnMf74V7/qI5vjn4UdhWd482quPgZCoFPHPjNQr2jt4Ryc33vfdf8GsKIYaGDfIkIWvSR/ny3U9mAQb2DZGO0V8nyX2ErSwktmIroHC1PANyJbXPcgK4o2Rr9vskgYMp9Qi5oSK2PudPvpeUlSUeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674566; c=relaxed/simple;
	bh=w+lk6yJjZ0SkX62kAQ40vITBPmZYjrzleQ6ryRuqBtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlE72jz03yLt0C79xqm3XYaP5k2xmiOrUZ2ssF3w0LC1r++vKLTKFEKG2Tljkyrzmw0JyuFqsTfImbrcBANzyXy8nfjomJ+zanC6DyoG58QQXmHmxv4UxezSZ8tUwmsTx3Xpj0sO0XjATvF3RCEGZYHir1O1ed4fKmWONdknLy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6E5mAl7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6E5mAl7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73419C19421;
	Wed,  8 Apr 2026 18:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674566;
	bh=w+lk6yJjZ0SkX62kAQ40vITBPmZYjrzleQ6ryRuqBtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6E5mAl7y9a3wth4lsPAkgMh6O5idMd61RhH6B4sdjpyvDSPF5Mql4UOqN0b7GyuJ
	 tPpU4wb2HJWmCPkjFVzCYtK8lm6SD00BeXJp8/hpFG3ZHVh0a4qrNnKWilQnt2RMUH
	 +fHDD9bDo/g6Z0CQQyxpEb2ko3aBzeHiamj8GKeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 148/311] hwmon: (tps53679) Fix device ID comparison and printing in tps53676_identify()
Date: Wed,  8 Apr 2026 20:02:28 +0200
Message-ID: <20260408175944.936595172@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

[ Upstream commit ca34ee6d0307a0b4e52c870dfc1bb8a3c3eb956e ]

tps53676_identify() uses strncmp() to compare the device ID buffer
against a byte sequence containing embedded non-printable bytes
(\x53\x67\x60). strncmp() is semantically wrong for binary data
comparison; use memcmp() instead.

Additionally, the buffer from i2c_smbus_read_block_data() is not
NUL-terminated, so printing it with "%s" in the error path is
undefined behavior and may read past the buffer. Use "%*ph" to
hex-dump the actual bytes returned.

Per the datasheet, the expected device ID is the 6-byte sequence
54 49 53 67 60 00 ("TI\x53\x67\x60\x00"), so compare all 6 bytes
including the trailing NUL.

Fixes: cb3d37b59012 ("hwmon: (pmbus/tps53679) Add support for TI TPS53676")
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260330155618.77403-1-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/tps53679.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/pmbus/tps53679.c b/drivers/hwmon/pmbus/tps53679.c
index 3bca543817a60..249974c13aa39 100644
--- a/drivers/hwmon/pmbus/tps53679.c
+++ b/drivers/hwmon/pmbus/tps53679.c
@@ -175,8 +175,8 @@ static int tps53676_identify(struct i2c_client *client,
 	ret = i2c_smbus_read_block_data(client, PMBUS_IC_DEVICE_ID, buf);
 	if (ret < 0)
 		return ret;
-	if (strncmp("TI\x53\x67\x60", buf, 5)) {
-		dev_err(&client->dev, "Unexpected device ID: %s\n", buf);
+	if (ret != 6 || memcmp(buf, "TI\x53\x67\x60\x00", 6)) {
+		dev_err(&client->dev, "Unexpected device ID: %*ph\n", ret, buf);
 		return -ENODEV;
 	}
 
-- 
2.53.0



