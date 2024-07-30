Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9931A619E;
	Tue, 30 Jul 2024 16:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357774; cv=none; b=L6y1T2hMrvhuw9UYw/SB0Y4o3lMtTAFlKQIBJYBnOjXM4fvshR7B4WXMPe5KIJbGdBULEiNTU7goTcH81o87eBvc7TEx9IvBTc+tohqU2NMThUEpLQI8ZvpyV2uBRnFzg6pAKaXB1NdqSzyxOCHN0ScHFBcwMt8Gcni2x0Yo+W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357774; c=relaxed/simple;
	bh=UIty8w2RKTCz4IlAMiqhnmOUk7nRZwXtfg3mgF9btGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmSJxBj/AToo6xlUk6wPBuTILYNxY0h2dIRzCnYO5vMXN4WtHAM2ZXtd5lb0Z/t9QCbZpm9arjFKdQUL2X8Ycg+QR5NTH+59rfkyBSiZimCSrayTCHsu5xCHphus5cNGKrEb7EVTGJQmFekR/wbB68i3eP/8pSLn553NzS3BMuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=taFCc060; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="taFCc060"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFFAC32782;
	Tue, 30 Jul 2024 16:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357774;
	bh=UIty8w2RKTCz4IlAMiqhnmOUk7nRZwXtfg3mgF9btGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=taFCc060MpWgxAQU9KaHHZ1rvflS0rlnoJITMJCS7jwRQs0xO9w3giId86CPDu1My
	 pKVqt6XtR/vtOuN/Nlx0aw8qn4+aXKVv7vrva3Clal0AVGRkkmvIMCfbdWnz2FNoXG
	 4l/NeOzWxJCtTxLWAClRYzjZOHKtdXnTLYcKGlZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Gjorgji Rosikopulos <quic_grosikop@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 291/809] media: i2c: Fix imx412 exposure control
Date: Tue, 30 Jul 2024 17:42:47 +0200
Message-ID: <20240730151736.084969903@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit a1956bf53a2774014ee1768b484af2c38c633a25 ]

Currently we have the following algorithm to calculate what value should be
written to the exposure control of imx412.

lpfr = imx412->vblank + imx412->cur_mode->height;
shutter = lpfr - exposure;

The 'shutter' value is given to IMX412_REG_EXPOSURE_CIT however, the above
algorithm will result in the value given to IMX412_REG_EXPOSURE_CIT
decreasing as the requested exposure value from user-space goes up.

e.g.
[ 2255.713989] imx412 20-001a: Received exp 1608, analog gain 0
[ 2255.714002] imx412 20-001a: Set exp 1608, analog gain 0, shutter 1938, lpfr 3546
[ 2256.302770] imx412 20-001a: Received exp 2586, analog gain 100
[ 2256.302800] imx412 20-001a: Set exp 2586, analog gain 100, shutter 960, lpfr 3546
[ 2256.753755] imx412 20-001a: Received exp 3524, analog gain 110
[ 2256.753772] imx412 20-001a: Set exp 3524, analog gain 110, shutter 22, lpfr 3546

This behaviour results in the image having less exposure as the requested
exposure value from user-space increases.

Other sensor drivers such as ov5675, imx218, hid556 and others take the
requested exposure value and use the value directly.

Take the example of the above cited sensor drivers and directly apply the
requested exposure value from user-space. The 'lpfr' variable still
functions as before but the 'shutter' variable can be dispensed with as a
result.

Once done a similar run of the test application requesting higher exposure
looks like this, with 'exp' written directly to the sensor.

[  133.207884] imx412 20-001a: Received exp 1608, analog gain 0
[  133.207899] imx412 20-001a: Set exp 1608, analog gain 0, lpfr 3546
[  133.905309] imx412 20-001a: Received exp 2844, analog gain 100
[  133.905344] imx412 20-001a: Set exp 2844, analog gain 100, lpfr 3546
[  134.241705] imx412 20-001a: Received exp 3524, analog gain 110
[  134.241775] imx412 20-001a: Set exp 3524, analog gain 110, lpfr 3546

The result is then setting the sensor exposure to lower values results in
darker, less exposure images and vice versa with higher exposure values.

Fixes: 9214e86c0cc1 ("media: i2c: Add imx412 camera sensor driver")
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # qrb5165-rb5/imx577
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Reviewed-by: Gjorgji Rosikopulos <quic_grosikop@quicinc.com>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx412.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/imx412.c b/drivers/media/i2c/imx412.c
index 0efce329525e4..7d1f7af0a9dff 100644
--- a/drivers/media/i2c/imx412.c
+++ b/drivers/media/i2c/imx412.c
@@ -542,14 +542,13 @@ static int imx412_update_controls(struct imx412 *imx412,
  */
 static int imx412_update_exp_gain(struct imx412 *imx412, u32 exposure, u32 gain)
 {
-	u32 lpfr, shutter;
+	u32 lpfr;
 	int ret;
 
 	lpfr = imx412->vblank + imx412->cur_mode->height;
-	shutter = lpfr - exposure;
 
-	dev_dbg(imx412->dev, "Set exp %u, analog gain %u, shutter %u, lpfr %u",
-		exposure, gain, shutter, lpfr);
+	dev_dbg(imx412->dev, "Set exp %u, analog gain %u, lpfr %u",
+		exposure, gain, lpfr);
 
 	ret = imx412_write_reg(imx412, IMX412_REG_HOLD, 1, 1);
 	if (ret)
@@ -559,7 +558,7 @@ static int imx412_update_exp_gain(struct imx412 *imx412, u32 exposure, u32 gain)
 	if (ret)
 		goto error_release_group_hold;
 
-	ret = imx412_write_reg(imx412, IMX412_REG_EXPOSURE_CIT, 2, shutter);
+	ret = imx412_write_reg(imx412, IMX412_REG_EXPOSURE_CIT, 2, exposure);
 	if (ret)
 		goto error_release_group_hold;
 
-- 
2.43.0



