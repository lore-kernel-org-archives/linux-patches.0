Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90224BEE32;
	Sat, 12 Sep 2026 11:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212110; cv=none; b=hjFvvd7yAMtaB/ISJ5NqmiXA3LxhZt+rjTEnrvk2D6jP+nX0Z61bDKQ4b9oMMD8sO/lpjoXFIxab5NpmNGDH6e3H59yAwGhcdO6AZuWkf/gV/hYvex3FRHa38zboxir6oYc5yIXcAjlkHFD6ZMrdS5m6FfV6pQKmnnRfsd5XxAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212110; c=relaxed/simple;
	bh=1M0mfJFhaf3nxCTxKso5m6DGIvnvsNgF2wsEmOB+sWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jv1kJsG+oA/YZQMMYDqoDcLARz5DtB/G6LNxoSmH40wqV/pnkqL10bqk4Ch7C27KbtKJM4xLmTjTNPgIggPIpblEggNVCny7LReygsz93q1k7qPJerjVbdf4jemeKiuUwhzZyOGjVCLb5CjGnY5yMfiz3UFrE5xdISSDZZqZvwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X1EjSGh8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X1EjSGh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9771F000FF;
	Sat, 12 Sep 2026 11:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212109;
	bh=MiwRvvTAt8UxSjn/I1CtaNPc6ZBLQp0LUKoGyvQ5ZiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X1EjSGh8TQLXF88rOp3c754QTWyi9EK2XRMfBS6oW4SIekUbVPsqIscLEEJ/QKgCs
	 KX4OrP9Xa8cZq9sDl3CFJDokk2e2CR2j3S+lP5OrKVy5PxoPmNz+jhdVTztrqkmkW8
	 s5jXZ+q4/TJy2nNVOiongzaBhtqAWto74c6haSFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmo Chou <chou.cosmo@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1368/1518] rtc: pcf85363: Add error checking to regmap calls in probe()
Date: Sat, 12 Sep 2026 08:58:57 +0200
Message-ID: <20260912065654.487264939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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



