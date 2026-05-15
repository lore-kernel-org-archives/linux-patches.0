Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE063B1029;
	Fri, 15 May 2026 16:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861952; cv=none; b=b51QSOybHd5X5JKZL343GCHmk5T7v/HwBqyb4eVa3hh8sFVHtbHJ4ESESMgg+REQ/+5rbbQezbkWutvDtpft9aWdQvWIoY/tsubl3EveRnA88JW+2DqaIeuJXiuqLCfAxwSDo+SekBFRPFFHe+coS5+lMzayFAUv3W8sXNe5MCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861952; c=relaxed/simple;
	bh=65+BT0XNefP83aUgf3x3wBEaUbIx+emwmb4H8Mn2uWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsCgrT/kX3LOrQtRD4R7AXMcKzH7a92G4xQ5gyIqu1+KsSmS+z2oFa29d2KhQXAJCM8WboiUv9Fgddhqs1xdxCEXm5zbts0bxT7U3rkCSp76vNINJovljXvgWtjml2BKUTbsWBO36yxv81WbV4Xm9T7xxMRcA+o2bh/zqt1yh6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ys1ipYox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ys1ipYox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45616C2BCB0;
	Fri, 15 May 2026 16:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861952;
	bh=65+BT0XNefP83aUgf3x3wBEaUbIx+emwmb4H8Mn2uWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ys1ipYoxsI69SqnAwQXpPlM+xB0YUyf7aNT4FQRvJViUxWFxRulsLs43dcT0USYGB
	 mNFrjVNMHiuCMuLmbQ01rS3U/9WvmPMxbzR1zRiq9F21J3vGfFV1RbpeP3nfG1Horj
	 nxsLAP30E3/bYkcxlGRrmaKu+Tqd1p0L2cSPydzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.18 050/188] media: i2c: imx412: Assert reset GPIO during probe
Date: Fri, 15 May 2026 17:47:47 +0200
Message-ID: <20260515154658.400702351@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>

commit 8467c5ff5acae28513bc1e0af535e06b41b04344 upstream.

Assert the reset GPIO before first power up. This avoids a mismatch where
the first power up (when the reset GPIO defaults deasserted) differs from
subsequent cycles.

Signed-off-by: Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>
Fixes: 9214e86c0cc1 ("media: i2c: Add imx412 camera sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx412.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/imx412.c
+++ b/drivers/media/i2c/imx412.c
@@ -925,7 +925,7 @@ static int imx412_parse_hw_config(struct
 
 	/* Request optional reset pin */
 	imx412->reset_gpio = devm_gpiod_get_optional(imx412->dev, "reset",
-						     GPIOD_OUT_LOW);
+						     GPIOD_OUT_HIGH);
 	if (IS_ERR(imx412->reset_gpio)) {
 		dev_err(imx412->dev, "failed to get reset gpio %ld\n",
 			PTR_ERR(imx412->reset_gpio));


