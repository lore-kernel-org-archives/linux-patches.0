Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA601E7C02;
	Tue, 15 Oct 2024 11:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992321; cv=none; b=EfFDYoV5cmA35IN2wvdS1UG6K4/KN9RfuHf9a3kOx6W0+lDmvZIKpig2XhdBQguhQK83eqh5qLxJU0jSpxrNeVumsDRgsOjLe+MnrdTH/Vm9Sa8Ddu55WsP+xAIxAcxT8ZU52ofbhT2Kl7dBRljwengmtkJb7ffMvRMKVYG/bmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992321; c=relaxed/simple;
	bh=qH0eMBKuYseWzEDrxGeoCDW5D2DZBRA7ns/BYkwQ6GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uy/KJRnto5Hz5c+Artv8/IMTy5BgaqusbdXUs19YY9E5RzF/OWLfTJ1g88m8nHMu/qUki0kaK5z9iaz+k2EmdRIt18QpU8TWyj9bm/FOfPEXjKAe6+iJdcPH9Yt8Hcut5njIcXPndCbfLy2kRFORswe/L5X+kDg7TeKQ0kZsG7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNxI2hI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNxI2hI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F521C4CEC6;
	Tue, 15 Oct 2024 11:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992320;
	bh=qH0eMBKuYseWzEDrxGeoCDW5D2DZBRA7ns/BYkwQ6GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNxI2hI1ULSiUKi7TuIwH05yGsx7VV/TWQ+N1RexRJeIQ9nmHlRbtRoC8etfTuJNM
	 WYjrOSNEC9DHU9jxaMAnecu2myUtaO+iHwsy32ghXCN0vuCmFa29NljWJHtwYyTtnj
	 gFIHW4UJ3QXM6nQjEdHFXVNCA77SXGh6Y3dNFQX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patryk Biel <pbiel7@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/691] hwmon: (pmbus) Conditionally clear individual status bits for pmbus rev >= 1.2
Date: Tue, 15 Oct 2024 13:19:49 +0200
Message-ID: <20241015112441.974422413@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patryk Biel <pbiel7@gmail.com>

[ Upstream commit 20471071f198c8626dbe3951ac9834055b387844 ]

The current implementation of pmbus_show_boolean assumes that all devices
support write-back operation of status register to clear pending warnings
or faults. Since clearing individual bits in the status registers was only
introduced in PMBus specification 1.2, this operation may not be supported
by some older devices. This can result in an error while reading boolean
attributes such as temp1_max_alarm.

Fetch PMBus revision supported by the device and modify pmbus_show_boolean
so that it only tries to clear individual status bits if the device is
compliant with PMBus specs >= 1.2. Otherwise clear all fault indicators
on the current page after a fault status was reported.

Fixes: 35f165f08950a ("hwmon: (pmbus) Clear pmbus fault/warning bits after read")
Signed-off-by: Patryk Biel <pbiel7@gmail.com>
Message-ID: <20240909-pmbus-status-reg-clearing-v1-1-f1c0d68c6408@gmail.com>
[groeck:
 Rewrote description
 Moved revision detection code ahead of clear faults command
 Assigned revision if return value from PMBUS_REVISION command is 0
 Improved return value check from calling _pmbus_write_byte_data()]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus.h      |  6 ++++++
 drivers/hwmon/pmbus/pmbus_core.c | 17 ++++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus.h b/drivers/hwmon/pmbus/pmbus.h
index e2a570930bd7..62260553f483 100644
--- a/drivers/hwmon/pmbus/pmbus.h
+++ b/drivers/hwmon/pmbus/pmbus.h
@@ -409,6 +409,12 @@ enum pmbus_sensor_classes {
 enum pmbus_data_format { linear = 0, direct, vid };
 enum vrm_version { vr11 = 0, vr12, vr13, imvp9, amd625mv };
 
+/* PMBus revision identifiers */
+#define PMBUS_REV_10 0x00	/* PMBus revision 1.0 */
+#define PMBUS_REV_11 0x11	/* PMBus revision 1.1 */
+#define PMBUS_REV_12 0x22	/* PMBus revision 1.2 */
+#define PMBUS_REV_13 0x33	/* PMBus revision 1.3 */
+
 struct pmbus_driver_info {
 	int pages;		/* Total number of pages */
 	u8 phases[PMBUS_PAGES];	/* Number of phases per page */
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index cc9ce5b2f0f2..1ef214a8a01b 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -82,6 +82,8 @@ struct pmbus_data {
 
 	u32 flags;		/* from platform data */
 
+	u8 revision;	/* The PMBus revision the device is compliant with */
+
 	int exponent[PMBUS_PAGES];
 				/* linear mode: exponent for output voltages */
 
@@ -930,9 +932,14 @@ static int pmbus_get_boolean(struct i2c_client *client, struct pmbus_boolean *b,
 
 	regval = status & mask;
 	if (regval) {
-		ret = _pmbus_write_byte_data(client, page, reg, regval);
-		if (ret)
-			goto unlock;
+		if (data->revision >= PMBUS_REV_12) {
+			ret = _pmbus_write_byte_data(client, page, reg, regval);
+			if (ret)
+				goto unlock;
+		} else {
+			pmbus_clear_fault_page(client, page);
+		}
+
 	}
 	if (s1 && s2) {
 		s64 v1, v2;
@@ -2370,6 +2377,10 @@ static int pmbus_init_common(struct i2c_client *client, struct pmbus_data *data,
 			data->flags |= PMBUS_WRITE_PROTECTED | PMBUS_SKIP_STATUS_CHECK;
 	}
 
+	ret = i2c_smbus_read_byte_data(client, PMBUS_REVISION);
+	if (ret >= 0)
+		data->revision = ret;
+
 	if (data->info->pages)
 		pmbus_clear_faults(client);
 	else
-- 
2.43.0



