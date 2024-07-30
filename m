Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91A41A6199;
	Tue, 30 Jul 2024 16:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357114; cv=none; b=L01sdLruUeRXnluZD59oYU4vwKVgRJzo/sMrhG0jYrz/5CBkUWLQuWu2DLoDNJVNbLCH+1/eDXzbYzOOHfW4Y3bOSAgjAXB05fBSG4/AFSPRm0F6MWRDsYBRMQT7rUK/IZi2/eqTidq9fxlgbx969UwYsq5niKmbuUI+hbUlj94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357114; c=relaxed/simple;
	bh=jH2HVD34jCmJnHSpKEdQbS8qiJCtYbXHb5jLh3NXf3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pypSNJFRSOKQ+dY5ekZxIXOV8j0hvWBhFMwJdKHIrOQ3p3W6PU5dTDFVb8SjoeUp+ij+IcOzqBLo4QzgbEGXfBCKvHiOIf0ctaVtpcMH7vVutOos7wQBqdgovvULBu/HE84YHRJdrcv2TN/gl1EQvO2FX9CuBA0HII5+9EIfVUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CGcD6peF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CGcD6peF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59092C32782;
	Tue, 30 Jul 2024 16:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357113;
	bh=jH2HVD34jCmJnHSpKEdQbS8qiJCtYbXHb5jLh3NXf3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGcD6peF9YHi8fCpVJUSjG79GWtJmeTTF4IYFPcEpKui9bcLCTzTO3HFQEa3x7C0c
	 rtBZWH2pqo6gFilJU09yd38U5oB50znN67bBy+7/PZmwV2FANB6JEcb5YHYoJ8Zq2P
	 VKfW3npXKtv0uyT279uDg2XFUkJ/RCEtovSANyLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>,
	Adam Ford <aford173@gmail.com>
Subject: [PATCH 6.6 201/568] media: i2c: imx219: fix msr access command sequence
Date: Tue, 30 Jul 2024 17:45:08 +0200
Message-ID: <20240730151647.732989347@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 3cdc776e0a5f1784c3ae5d3371b64215c228bf1f ]

It was reported to me that the imx219 didn't work on one of our
development kits partly because the access sequence is incorrect.
The datasheet I could find [1] for this camera has the access sequence:
Seq. No. Address (Hex) data
1        30EB          05
2        30EB          0C
3        300A          FF
4        300B          FF
5        30EB          05
6        30EB          09

but the driver swaps the first two elements. Laurent pointed out on IRC
that the original code used the correct sequence for 1920x1080 but the
current sequence for 3280x2464 and 1640x1232. During refactoring of the
init sequence the current order was used for all formats.

Switch to using the documented sequence.

Link: https://www.opensourceinstruments.com/Electronics/Data/IMX219PQ.pdf [1]
Fixes: 8508455961d5 ("media: i2c: imx219: Split common registers from mode tables")
Fixes: 1283b3b8f82b ("media: i2c: Add driver for Sony IMX219 sensor")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Tested-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Adam Ford <aford173@gmail.com>  #imx8mp-beacon-kit
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index 3afa3f79c8a26..a9a8cd148f4fc 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -188,8 +188,8 @@ static const struct cci_reg_sequence imx219_common_regs[] = {
 	{ IMX219_REG_MODE_SELECT, 0x00 },	/* Mode Select */
 
 	/* To Access Addresses 3000-5fff, send the following commands */
-	{ CCI_REG8(0x30eb), 0x0c },
 	{ CCI_REG8(0x30eb), 0x05 },
+	{ CCI_REG8(0x30eb), 0x0c },
 	{ CCI_REG8(0x300a), 0xff },
 	{ CCI_REG8(0x300b), 0xff },
 	{ CCI_REG8(0x30eb), 0x05 },
-- 
2.43.0



