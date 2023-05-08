Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C169168CB
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AB9C433EF;
	Mon,  8 May 2023 10:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541208;
	bh=AXJkpZ9JRhjiJl1jigINIdJrv4oj98063XQaj7pNkds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIIJg6gh/6d4Aak/9XpxoYmABhj1oh8W5gMdAAcz055cHu86h2+yv3/mhUz5QSca4
	 aGRZEpzk+RE41ufRufUyy0duy0rdju5R2Pdvf1PNd7cw9oi3Ty/Oyb9mIptmf706lT
	 c6NFw4Q3JqXVgL42TxLYVE/DvmvovKn1dL4vNWOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.2 041/663] media: ov8856: Do not check for for module version
Date: Mon,  8 May 2023 11:37:47 +0200
Message-Id: <20230508094429.798850933@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ricardo Ribalda <ribalda@chromium.org>

commit 5a4e1b5aed2a36a10d6a3b30fafb6b3bf41c3186 upstream.

It the device is probed in non-zero ACPI D state, the module
identification is delayed until the first streamon.

The module identification has two parts: deviceID and version. To rea
the version we have to enable OTP read. This cannot be done during
streamon, becase it modifies REG_MODE_SELECT.

Since the driver has the same behaviour for all the module versions, do
not read the module version from the sensor's OTP.

Cc: stable@vger.kernel.org
Fixes: 0e014f1a8d54 ("media: ov8856: support device probe in non-zero ACPI D state")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov8856.c |   40 ----------------------------------------
 1 file changed, 40 deletions(-)

--- a/drivers/media/i2c/ov8856.c
+++ b/drivers/media/i2c/ov8856.c
@@ -1709,46 +1709,6 @@ static int ov8856_identify_module(struct
 		return -ENXIO;
 	}
 
-	ret = ov8856_write_reg(ov8856, OV8856_REG_MODE_SELECT,
-			       OV8856_REG_VALUE_08BIT, OV8856_MODE_STREAMING);
-	if (ret)
-		return ret;
-
-	ret = ov8856_write_reg(ov8856, OV8856_OTP_MODE_CTRL,
-			       OV8856_REG_VALUE_08BIT, OV8856_OTP_MODE_AUTO);
-	if (ret) {
-		dev_err(&client->dev, "failed to set otp mode");
-		return ret;
-	}
-
-	ret = ov8856_write_reg(ov8856, OV8856_OTP_LOAD_CTRL,
-			       OV8856_REG_VALUE_08BIT,
-			       OV8856_OTP_LOAD_CTRL_ENABLE);
-	if (ret) {
-		dev_err(&client->dev, "failed to enable load control");
-		return ret;
-	}
-
-	ret = ov8856_read_reg(ov8856, OV8856_MODULE_REVISION,
-			      OV8856_REG_VALUE_08BIT, &val);
-	if (ret) {
-		dev_err(&client->dev, "failed to read module revision");
-		return ret;
-	}
-
-	dev_info(&client->dev, "OV8856 revision %x (%s) at address 0x%02x\n",
-		 val,
-		 val == OV8856_2A_MODULE ? "2A" :
-		 val == OV8856_1B_MODULE ? "1B" : "unknown revision",
-		 client->addr);
-
-	ret = ov8856_write_reg(ov8856, OV8856_REG_MODE_SELECT,
-			       OV8856_REG_VALUE_08BIT, OV8856_MODE_STANDBY);
-	if (ret) {
-		dev_err(&client->dev, "failed to exit streaming mode");
-		return ret;
-	}
-
 	ov8856->identified = true;
 
 	return 0;


