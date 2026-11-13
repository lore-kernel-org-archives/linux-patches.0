Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591103;
	b=OXWbVAmiMDy8/2vHCK150xCraAUlgLouATXm2oWg9Iw+hFHPgth38JGecdsZYv0qYrAn
	 vpi94+p07dBpaIL86ce8RKkeTTFmn2Q0sTW7Gjp5SJrfqlUs/oDFR/NjQhf3R+2VsEu6x
	 YrY2tnzSNhxXNuwByJUKBmmnOrWmvJcmLOPG/lZb6VvhXl8DvMyltWzTGZW7M264MJoWO
	 Wae/v/sWFy0Rw17nBKtuqJizwYk4oPn0sRQMOMMuFSZtkoG+6Toewymr4yZCT4JlKKRqf
	 BzYxsPs+XLOrcEfLkdqo03UpfM1+U3FYUhliyCAhZO0eUBdC5HAvZKtxB43IJS8SGqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9DAMFNR44Auac8ju6mfVtVshxy/yyqthH6Rs9pogqnI=;
	b=4iGVA1AqGsoclHDnNxLNcVk6SH5a7NAOgBRa/cUX5KNNTAdFpL9sen9ok5n00rbsTmxt
	 /1gLFta/1dtFCrzQODZQzj01nQjQv4zSaKIjld6P37zHXNCLyDn5nykligcBzSZWF3zfL
	 zsYuL/q5kgF1G/6V/UR+MH1075YdtI5W+a6VDAlkRPebr/kgBZOUbEH4/Gdq1z6MQ2sX0
	 W75FWuTYeq9Sfg0hfipcH7BrhYbr/3ouJElIr+FifrlRpLiOEYPH6sA6uMXmIDDqy5rYK
	 LdX6xZycuedL0dbPeU4LQ+NSfr81ByJA3WBml8Wna8oPEvI8kkkcaucC8koWrHUK8Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mc1tL4Fn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88BC606BD0D;
	Fri, 13 Nov 2026 17:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mc1tL4Fn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C251F000C4;
	Fri, 13 Nov 2026 17:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591103;
	bh=9DAMFNR44Auac8ju6mfVtVshxy/yyqthH6Rs9pogqnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mc1tL4FneKtri3o8y6YmiT71Rlo49OndtdWeffom817aH8dClVbhlzyly5g/vprNr
	 foBnyiLVq4MCkqb8O4V/GbKln6TluAOeo7L8TbJGdOnAixVNbOY7xZEmPEKYMu0tyi
	 UHeK+mjobEs84YiWAhc11ZuF9PN6RTdjrvHWnbf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 257/670] hwmon: (lm87) Fix drvdata type confusion in vrm_show() and vrm_store()
Date: Fri, 13 Nov 2026 10:47:01 -0500
Message-ID: <20261113153820.547075429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 5b51ff0887b9f88d042b92dd07fcdda4132f0ebc ]

When an LM87 or ADM1024 device is probed with VID support enabled, reading
from or writing to the vrm sysfs attribute triggers a driver data type
confusion in vrm_show() and vrm_store() in drivers/hwmon/lm87.c.

In lm87_probe(), the driver stores the struct lm87_data pointer on the I2C
client via i2c_set_clientdata() and passes the struct i2c_client pointer as
the drvdata argument to devm_hwmon_device_register_with_groups(), which
attaches the attribute groups to the registered hwmon device with client as
its driver_data. Unlike the other sysfs callbacks that retrieve client via
dev_get_drvdata() and then obtain data via i2c_get_clientdata(), vrm_show()
and vrm_store() assign dev_get_drvdata(dev) directly to struct lm87_data *.
Dereferencing data->vrm therefore accesses the struct i2c_client instance
at offsetof(struct lm87_data, vrm), causing vrm_show() to leak an unrelated
byte from struct i2c_client to userspace and vrm_store() to corrupt a byte
within struct i2c_client while failing to update the actual VRM value.

Fix the problem by assigning the return value from dev_get_drvdata(dev) to
struct i2c_client *client and using i2c_get_clientdata() to get the actual
client data.

Fixes: 00a0c905ab4b ("hwmon: (lm87) Use hwmon to create the sysfs groups")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm87.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/lm87.c b/drivers/hwmon/lm87.c
index d2d970e73c616..bdd633feb2ba8 100644
--- a/drivers/hwmon/lm87.c
+++ b/drivers/hwmon/lm87.c
@@ -600,13 +600,16 @@ static DEVICE_ATTR_RO(cpu0_vid);
 static ssize_t vrm_show(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
-	struct lm87_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = dev_get_drvdata(dev);
+	struct lm87_data *data = i2c_get_clientdata(client);
+
 	return sprintf(buf, "%d\n", data->vrm);
 }
 static ssize_t vrm_store(struct device *dev, struct device_attribute *attr,
 			 const char *buf, size_t count)
 {
-	struct lm87_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = dev_get_drvdata(dev);
+	struct lm87_data *data = i2c_get_clientdata(client);
 	unsigned long val;
 	int err;
 
-- 
2.53.0



