Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5581B2E7181;
	Tue, 17 Jun 2025 16:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178538; cv=none; b=jA7+QCJVgXKXV85MY2CqB53k7iWEy4Ir+uwoUJVwg/oonEZ3P1isHXlgeNtjHZy2adiKfVfxnV29bCvG83Ecqrz1Xtxoer5eU2Sk2iz6Y8AlxEx/qSNTysKKJ2STIZtFpMR0ntkFOj1gp3NQdo0AOyfgUFSFidVM0zIGJGmuk44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178538; c=relaxed/simple;
	bh=ZEprKMF5XeyFAsYBnHOVBd0r5gYgPRflJXflub+TSyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPHeSSSeJyRNNCTM43XHfy6uJ15FQ/KR0fBkFos7Ck7ptU4UuFTd14Gs073SUVGcM8XEZztqR2O81yYQV6fHI6GMFePXyvvFm4WnV/5qhx3v0D9PwymwatwrSeAbiYANoWVOL4Mxr8SZ07SOIfb13/TN1OG4J2yPo4rA8ZGO0B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tjx4MEgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tjx4MEgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CF2C4CEE3;
	Tue, 17 Jun 2025 16:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178538;
	bh=ZEprKMF5XeyFAsYBnHOVBd0r5gYgPRflJXflub+TSyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tjx4MEgVnfoLE/p+Lmg3Ubnpc+SD9uiimiv5Z7ubfw0ODIl8EzdeuRmGBf74swxq3
	 c6jSxLLsvrJI5TVAwMheAsiQtj5cFZ5S0Dk6OnIzVsoLR4QUCGTq12fgeoU+Us0uL0
	 hbUBd4/WTDMSTgTJb/5V7WEi6O68F91STSrT/FcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jonathan Stroud <jonathan.stroud@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH 6.12 492/512] usb: misc: onboard_usb_dev: Fix usb5744 initialization sequence
Date: Tue, 17 Jun 2025 17:27:38 +0200
Message-ID: <20250617152439.567916068@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Stroud <jonathan.stroud@amd.com>

commit 1143d41922c0f87504f095417ba1870167970143 upstream.

Introduce i2c APIs to read/write for proper configuration register
programming. It ensures that read-modify-write sequence is performed
and reserved bit in Runtime Flags 2 register are not touched.

Also legacy smbus block write inserted an extra count value into the
i2c data stream which breaks the register write on the usb5744.

Switching to new read/write i2c APIs fixes both issues.

Fixes: 6782311d04df ("usb: misc: onboard_usb_dev: add Microchip usb5744 SMBus programming support")
Cc: stable <stable@kernel.org>
Signed-off-by: Jonathan Stroud <jonathan.stroud@amd.com>
Co-developed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://lore.kernel.org/r/1747398760-284021-1-git-send-email-radhey.shyam.pandey@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/onboard_usb_dev.c | 100 +++++++++++++++++++++++++----
 1 file changed, 87 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/misc/onboard_usb_dev.c b/drivers/usb/misc/onboard_usb_dev.c
index 40bc98019e0b..1048e3912068 100644
--- a/drivers/usb/misc/onboard_usb_dev.c
+++ b/drivers/usb/misc/onboard_usb_dev.c
@@ -36,9 +36,10 @@
 #define USB5744_CMD_CREG_ACCESS			0x99
 #define USB5744_CMD_CREG_ACCESS_LSB		0x37
 #define USB5744_CREG_MEM_ADDR			0x00
+#define USB5744_CREG_MEM_RD_ADDR		0x04
 #define USB5744_CREG_WRITE			0x00
-#define USB5744_CREG_RUNTIMEFLAGS2		0x41
-#define USB5744_CREG_RUNTIMEFLAGS2_LSB		0x1D
+#define USB5744_CREG_READ			0x01
+#define USB5744_CREG_RUNTIMEFLAGS2		0x411D
 #define USB5744_CREG_BYPASS_UDC_SUSPEND		BIT(3)
 
 static void onboard_dev_attach_usb_driver(struct work_struct *work);
@@ -309,11 +310,88 @@ static void onboard_dev_attach_usb_driver(struct work_struct *work)
 		pr_err("Failed to attach USB driver: %pe\n", ERR_PTR(err));
 }
 
+static int onboard_dev_5744_i2c_read_byte(struct i2c_client *client, u16 addr, u8 *data)
+{
+	struct i2c_msg msg[2];
+	u8 rd_buf[3];
+	int ret;
+
+	u8 wr_buf[7] = {0, USB5744_CREG_MEM_ADDR, 4,
+			USB5744_CREG_READ, 1,
+			addr >> 8 & 0xff,
+			addr & 0xff};
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	msg[0].len = sizeof(wr_buf);
+	msg[0].buf = wr_buf;
+
+	ret = i2c_transfer(client->adapter, msg, 1);
+	if (ret < 0)
+		return ret;
+
+	wr_buf[0] = USB5744_CMD_CREG_ACCESS;
+	wr_buf[1] = USB5744_CMD_CREG_ACCESS_LSB;
+	wr_buf[2] = 0;
+	msg[0].len = 3;
+
+	ret = i2c_transfer(client->adapter, msg, 1);
+	if (ret < 0)
+		return ret;
+
+	wr_buf[0] = 0;
+	wr_buf[1] = USB5744_CREG_MEM_RD_ADDR;
+	msg[0].len = 2;
+
+	msg[1].addr = client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len = 2;
+	msg[1].buf = rd_buf;
+
+	ret = i2c_transfer(client->adapter, msg, 2);
+	if (ret < 0)
+		return ret;
+	*data = rd_buf[1];
+
+	return 0;
+}
+
+static int onboard_dev_5744_i2c_write_byte(struct i2c_client *client, u16 addr, u8 data)
+{
+	struct i2c_msg msg[2];
+	int ret;
+
+	u8 wr_buf[8] = {0, USB5744_CREG_MEM_ADDR, 5,
+			USB5744_CREG_WRITE, 1,
+			addr >> 8 & 0xff,
+			addr & 0xff,
+			data};
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	msg[0].len = sizeof(wr_buf);
+	msg[0].buf = wr_buf;
+
+	ret = i2c_transfer(client->adapter, msg, 1);
+	if (ret < 0)
+		return ret;
+
+	msg[0].len = 3;
+	wr_buf[0] = USB5744_CMD_CREG_ACCESS;
+	wr_buf[1] = USB5744_CMD_CREG_ACCESS_LSB;
+	wr_buf[2] = 0;
+
+	ret = i2c_transfer(client->adapter, msg, 1);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 static int onboard_dev_5744_i2c_init(struct i2c_client *client)
 {
 #if IS_ENABLED(CONFIG_USB_ONBOARD_DEV_USB5744)
 	struct device *dev = &client->dev;
 	int ret;
+	u8 reg;
 
 	/*
 	 * Set BYPASS_UDC_SUSPEND bit to ensure MCU is always enabled
@@ -321,21 +399,17 @@ static int onboard_dev_5744_i2c_init(struct i2c_client *client)
 	 * The command writes 5 bytes to memory and single data byte in
 	 * configuration register.
 	 */
-	char wr_buf[7] = {USB5744_CREG_MEM_ADDR, 5,
-			  USB5744_CREG_WRITE, 1,
-			  USB5744_CREG_RUNTIMEFLAGS2,
-			  USB5744_CREG_RUNTIMEFLAGS2_LSB,
-			  USB5744_CREG_BYPASS_UDC_SUSPEND};
+	ret = onboard_dev_5744_i2c_read_byte(client,
+					     USB5744_CREG_RUNTIMEFLAGS2, &reg);
+	if (ret)
+		return dev_err_probe(dev, ret, "CREG_RUNTIMEFLAGS2 read failed\n");
 
-	ret = i2c_smbus_write_block_data(client, 0, sizeof(wr_buf), wr_buf);
+	reg |= USB5744_CREG_BYPASS_UDC_SUSPEND;
+	ret = onboard_dev_5744_i2c_write_byte(client,
+					      USB5744_CREG_RUNTIMEFLAGS2, reg);
 	if (ret)
 		return dev_err_probe(dev, ret, "BYPASS_UDC_SUSPEND bit configuration failed\n");
 
-	ret = i2c_smbus_write_word_data(client, USB5744_CMD_CREG_ACCESS,
-					USB5744_CMD_CREG_ACCESS_LSB);
-	if (ret)
-		return dev_err_probe(dev, ret, "Configuration Register Access Command failed\n");
-
 	/* Send SMBus command to boot hub. */
 	ret = i2c_smbus_write_word_data(client, USB5744_CMD_ATTACH,
 					USB5744_CMD_ATTACH_LSB);
-- 
2.49.0



