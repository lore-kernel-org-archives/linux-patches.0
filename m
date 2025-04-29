Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFEE20C488;
	Tue, 29 Apr 2025 18:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950118; cv=none; b=rLQt+EfUOq7SspGWEKTv3FUZcbcLsWkqJBkVeSXjD+v5p3S+2MIIQnqu6zJ4L6AZb3Uv0Q95WiofWOSs1sBc8OPCTZY4VbVueOgoxdnkQm102vLjXxBA5WNsdA8Jf2ofXT7yLw2hF5zwXrjgRepPs9V0ducK6/htJnOx+yzcM9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950118; c=relaxed/simple;
	bh=qXQBp7YfNYYWFn4JeLwdun329a5gxmuwvY1N5qKI2iU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCfnPI6oQZqAdGsp3l6rOTCN5wX4k8VRgmscs8kwJ63NwSlKxdqQKKjGpMPU5fJlpVPb/vivh8g2MX4ymDVH92bqjwCgL7hlnj21Zxyy4oc1/glSngCVhnrWky10BssoaQ9dgsovXhzU8Q2nSJloDxfe6b/kP+UvA2ztgA7mIWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOJVkc6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOJVkc6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461BFC4CEE3;
	Tue, 29 Apr 2025 18:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950117;
	bh=qXQBp7YfNYYWFn4JeLwdun329a5gxmuwvY1N5qKI2iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOJVkc6OsHAhKsEunNNFFyFAOx+wqXjb2Q2B87ANYkeFmBjST8fFO7K1/TAvJI9uO
	 gNMZQ1HXGIF3Ia5LR4dRZNVBSvmDT+7cDB2IfJvQrzsNI23pT7bMLmksWPejIXWqth
	 JabuRurgBWm8P3JqJvAdZdDlXV372T7HvgtKo5d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Stockmann <lukas.stockmann@siemens.com>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 122/167] rtc: pcf85063: do a SW reset if POR failed
Date: Tue, 29 Apr 2025 18:43:50 +0200
Message-ID: <20250429161056.679252748@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Stockmann <lukas.stockmann@siemens.com>

[ Upstream commit 2b7cbd98495f6ee4cd6422fe77828a19e9edf87f ]

Power-on Reset has a documented issue in PCF85063, refer to its datasheet,
section "Software reset":

"There is a low probability that some devices will have corruption of the
registers after the automatic power-on reset if the device is powered up
with a residual VDD level. It is required that the VDD starts at zero volts
at power up or upon power cycling to ensure that there is no corruption of
the registers. If this is not possible, a reset must be initiated after
power-up (i.e. when power is stable) with the software reset command"

Trigger SW reset if there is an indication that POR has failed.

Link: https://www.nxp.com/docs/en/data-sheet/PCF85063A.pdf
Signed-off-by: Lukas Stockmann <lukas.stockmann@siemens.com>
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://lore.kernel.org/r/20250120093451.30778-1-alexander.sverdlin@siemens.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf85063.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf85063.c b/drivers/rtc/rtc-pcf85063.c
index 6ffdc10b32d32..4a29b44e75e6a 100644
--- a/drivers/rtc/rtc-pcf85063.c
+++ b/drivers/rtc/rtc-pcf85063.c
@@ -35,6 +35,7 @@
 #define PCF85063_REG_CTRL1_CAP_SEL	BIT(0)
 #define PCF85063_REG_CTRL1_STOP		BIT(5)
 #define PCF85063_REG_CTRL1_EXT_TEST	BIT(7)
+#define PCF85063_REG_CTRL1_SWR		0x58
 
 #define PCF85063_REG_CTRL2		0x01
 #define PCF85063_CTRL2_AF		BIT(6)
@@ -606,7 +607,7 @@ static int pcf85063_probe(struct i2c_client *client)
 
 	i2c_set_clientdata(client, pcf85063);
 
-	err = regmap_read(pcf85063->regmap, PCF85063_REG_CTRL1, &tmp);
+	err = regmap_read(pcf85063->regmap, PCF85063_REG_SC, &tmp);
 	if (err) {
 		dev_err(&client->dev, "RTC chip is not present\n");
 		return err;
@@ -616,6 +617,22 @@ static int pcf85063_probe(struct i2c_client *client)
 	if (IS_ERR(pcf85063->rtc))
 		return PTR_ERR(pcf85063->rtc);
 
+	/*
+	 * If a Power loss is detected, SW reset the device.
+	 * From PCF85063A datasheet:
+	 * There is a low probability that some devices will have corruption
+	 * of the registers after the automatic power-on reset...
+	 */
+	if (tmp & PCF85063_REG_SC_OS) {
+		dev_warn(&client->dev,
+			 "POR issue detected, sending a SW reset\n");
+		err = regmap_write(pcf85063->regmap, PCF85063_REG_CTRL1,
+				   PCF85063_REG_CTRL1_SWR);
+		if (err < 0)
+			dev_warn(&client->dev,
+				 "SW reset failed, trying to continue\n");
+	}
+
 	err = pcf85063_load_capacitance(pcf85063, client->dev.of_node,
 					config->force_cap_7000 ? 7000 : 0);
 	if (err < 0)
-- 
2.39.5



