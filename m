Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE4E1917CD;
	Tue, 30 Jul 2024 16:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355869; cv=none; b=PQ3uUqDNToztFxOl5TBSdWV1DxqXQrXuo4gZ6l7W16MoPGlSmVK3FIvcyz7lDwRf46GGIOhhFA+p8T1uG+mu6q60KGQwSiFB2yTtnybNxDcJhjiUJ+K78k+AnixdsrSzOBxp/tjGy7GFrHxD/ZErSB1V4Ro0y0ng026T+op6vHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355869; c=relaxed/simple;
	bh=MAgn2A4UpSwM894RfHTd0Icc9QjoNqdGi1HGzmTR3Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbindLOsr/kxWibQ39TLWfGSS60gQ6+gArt8zenvrbu/vchCkpOa1Q4ml2hh+UQSBA+8X0yUIS5St1nNNlnAHFFWtbRxBH+iiSFKRD7UzafFBuseoGWJDoFR5ajVqWOtOgMqLgmhTE4R4pCV2558fHfEcLwWwwu7Yk4k2CJOzmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P64kVqlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P64kVqlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62BFC32782;
	Tue, 30 Jul 2024 16:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355869;
	bh=MAgn2A4UpSwM894RfHTd0Icc9QjoNqdGi1HGzmTR3Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P64kVqlGSXu6ERixq4yx0UDg9zlHmZNGpy3ncEEhVIPzI4IL1v8E9phOpcu+N2g6Q
	 FRw9aTX9tZEfUhPX0Zyc9rDQcswwxxUHWQf2jQb1ED5A302gQ8thCGWrYDtXZ4LtBm
	 +iRRfwS62jaysfJQbJ5Y3yhytRE/ZKgaMhk3HTC0=
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
Subject: [PATCH 6.1 139/440] media: i2c: Fix imx412 exposure control
Date: Tue, 30 Jul 2024 17:46:12 +0200
Message-ID: <20240730151621.310954107@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7f6d29e0e7c40..77fa6253ba3e3 100644
--- a/drivers/media/i2c/imx412.c
+++ b/drivers/media/i2c/imx412.c
@@ -544,14 +544,13 @@ static int imx412_update_controls(struct imx412 *imx412,
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
@@ -561,7 +560,7 @@ static int imx412_update_exp_gain(struct imx412 *imx412, u32 exposure, u32 gain)
 	if (ret)
 		goto error_release_group_hold;
 
-	ret = imx412_write_reg(imx412, IMX412_REG_EXPOSURE_CIT, 2, shutter);
+	ret = imx412_write_reg(imx412, IMX412_REG_EXPOSURE_CIT, 2, exposure);
 	if (ret)
 		goto error_release_group_hold;
 
-- 
2.43.0



