Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52463AFD11;
	Sat, 30 May 2026 17:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163263; cv=none; b=tya+9rusdoYJ2aHtXICvfPJLayhAFDpi06tNdskxf8FAkK19H7/FVwyICyblcmtR6Cxupkgpxh4fg13TwyRdMsNEUQE5rL96pusGtz00k6XcBTIP6s7kIq9irwI+a9LYwr8qnXYDLUaUvxnh5n/cPmPyNpFU4fkZGY/k0srbsNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163263; c=relaxed/simple;
	bh=mAWZalFcoovaESc6AQuraaNB/wvg2iAXpIyaSuVfK4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbFA8EIQcaEaPcPd/AD8vJgEQ4LhlfoDnB0+erqXYw1/HaOY5+wG2xNYRDJK3B4sFWCDILj4XsgohY1qeWoZaJpBEbGiQMFuZ3LOK6vCk9D8hAihWnRSu5e6p/tVP6sTewMok/3dnnxCrMUDU2nYOr6y8+qRPnRRuKSTHu9AYMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQdpJ3Dy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQdpJ3Dy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709151F00898;
	Sat, 30 May 2026 17:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163259;
	bh=O79isbwYpN8pL4Yfox79wY81/ZINSon2LcGaC/PmfJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQdpJ3DyfjlyldQ8rKn/CS1FeAHIzyPszdrmdA/oK66fVw690b3/w6+Mh7Dxm238v
	 UYs1sURIAvkLxNiQ/IzcjVkLXGVAimqj7XtDtcs+BuS4oaqVyJFjBiGLsEIrQsX33r
	 YfgdY6scUTcHD2ydLeNEWV2iX6c/EPg2lDy6ayeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 205/776] media: i2c: imx219: Check return value of devm_gpiod_get_optional() in imx219_probe()
Date: Sat, 30 May 2026 17:58:39 +0200
Message-ID: <20260530160245.807144245@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

commit 943b1f27a3eead21b22e2531a5432ea5910b60eb upstream.

The devm_gpiod_get_optional() function may return an error pointer
(ERR_PTR) in case of a genuine failure during GPIO acquisition,
not just NULL which indicates the legitimate absence of an optional
GPIO.

Add an IS_ERR() check after the function call to catch such errors and
propagate them to the probe function, ensuring the driver fails to load
safely rather than proceeding with an invalid pointer.

Fixes: 1283b3b8f82b ("media: i2c: Add driver for Sony IMX219 sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx219.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -1435,6 +1435,9 @@ static int imx219_probe(struct i2c_clien
 	/* Request optional enable pin */
 	imx219->reset_gpio = devm_gpiod_get_optional(dev, "reset",
 						     GPIOD_OUT_HIGH);
+	if (IS_ERR(imx219->reset_gpio))
+		return dev_err_probe(dev, PTR_ERR(imx219->reset_gpio),
+				     "failed to get reset gpio\n");
 
 	/*
 	 * The sensor must be powered for imx219_identify_module()


