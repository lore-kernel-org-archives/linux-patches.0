Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CB83AFD15;
	Sat, 12 Sep 2026 09:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204857; cv=none; b=QZIEbtCEq7fG+D5mufV1uZxA/oAUdnwM6jccrpUcrGO5qSvqvKfPbGlNP97Q2zuWT6tBhr113ZZbKpOVKe5nZSO1QMk1TSwJUgcVFX3gv4+d2DsUHaQgBmZ3d864VdqgZ2FU5F9bmwgrRGSuF5JacL30foPCLv44QJXnA4c5CGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204857; c=relaxed/simple;
	bh=0/pD51nvRSfEu/I+2fUr/HKp6xfNyZOo4/CVl2m4FoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gH0tl444PFtCX+4oZlhGT4/8c97QcKN7ogDJCXKYQ/lekitE3Tsufu6BiImJVX1rNmNED3gRqTsj3kCaJdwqYqmg49WRhJmRsJEOaKfgikhW5x9w38FaLTztn0nPGD4KnYiFvBVYHolg8lYJml+0VCDZOBYiwUWzMM1R9CuJOfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4zfAnzc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4zfAnzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900DC1F000FF;
	Sat, 12 Sep 2026 09:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204855;
	bh=sP21H/a6CT8gIXIEC9WxFBRsjm0J5QGO2jqsmsR6Cws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4zfAnzc0oL2LL4Si2JsNNoUeExtbPZkw1YBTMUjC5XFv45M/gqqipqKkU5qEXVJ6
	 pXb175jqIfpWPSXtMGXANB7aDtDDWtSRCctTyXvQPebRJORyGi296f30GKuiO0uPj/
	 DDeUAY9HSzJrL38IWsA3cRDw6q8oyWjDWO87T0dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmo Chou <chou.cosmo@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1692/1815] rtc: pcf85363: Add error checking to regmap calls in probe()
Date: Sat, 12 Sep 2026 08:57:22 +0200
Message-ID: <20260912065728.702292476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmo Chou <chou.cosmo@gmail.com>

[ Upstream commit 78acddfde75177a27000f076e3e828743e38877e ]

The probe() function ignores errors returned by regmap operations.
If an I2C transport error occurs (e.g., -ENXIO), the driver continues
probing and may register a non-functional RTC device.

Propagate errors from all unchecked regmap calls in probe() using
dev_err_probe().

Fixes: fd9a6a13949a ("rtc: pcf85363: add support for the quartz-load-femtofarads property")
Signed-off-by: Cosmo Chou <chou.cosmo@gmail.com>
Link: https://lore.kernel.org/linux-rtc/20260716125142.1801599-1-chou.cosmo@gmail.com/
Link: https://patch.msgid.link/20260717193705.2003175-1-chou.cosmo@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf85363.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-pcf85363.c b/drivers/rtc/rtc-pcf85363.c
index 540042b9eec8f..ccc7834e57599 100644
--- a/drivers/rtc/rtc-pcf85363.c
+++ b/drivers/rtc/rtc-pcf85363.c
@@ -426,8 +426,8 @@ static int pcf85363_probe(struct i2c_client *client)
 
 	err = pcf85363_load_capacitance(pcf85363, client->dev.of_node);
 	if (err < 0)
-		dev_warn(&client->dev, "failed to set xtal load capacitance: %d",
-			 err);
+		return dev_err_probe(&client->dev, err,
+				     "failed to set xtal load capacitance\n");
 
 	pcf85363->rtc->ops = &rtc_ops;
 	pcf85363->rtc->range_min = RTC_TIMESTAMP_BEGIN_2000;
@@ -436,9 +436,16 @@ static int pcf85363_probe(struct i2c_client *client)
 	wakeup_source = device_property_read_bool(&client->dev,
 						  "wakeup-source");
 	if (client->irq > 0 || wakeup_source) {
-		regmap_write(pcf85363->regmap, CTRL_FLAGS, 0);
-		regmap_update_bits(pcf85363->regmap, CTRL_PIN_IO,
-				   PIN_IO_INTAPM, PIN_IO_INTA_OUT);
+		err = regmap_write(pcf85363->regmap, CTRL_FLAGS, 0);
+		if (err)
+			return dev_err_probe(&client->dev, err,
+					     "failed to clear flags\n");
+
+		err = regmap_update_bits(pcf85363->regmap, CTRL_PIN_IO,
+					 PIN_IO_INTAPM, PIN_IO_INTA_OUT);
+		if (err)
+			return dev_err_probe(&client->dev, err,
+					     "failed to set interrupt pin mode\n");
 	}
 
 	if (client->irq > 0) {
-- 
2.53.0



