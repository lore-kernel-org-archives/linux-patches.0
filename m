Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761043F660B;
	Fri, 15 May 2026 16:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862487; cv=none; b=EgUojdNBspNCINuF2G0HID5NYKmEM/OPG5oROUbLWrs+rgUklCwKJRtkhdnFTr7oQtmKK2dyLZCm4IL6Y3hoBHO7DcGQztFHhoTcQP8CRX+fqZlXGwyAZFPun8ZJp6T7D+Xy145tGnW8EgrREhL6AVp+OuWNZPEUgDxZD8CFGTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862487; c=relaxed/simple;
	bh=Y7kt41XSx5fWhl4TQQ6iSyWkfsUGnjrTQ5T045GkP0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIkLUYncRmkfP95sLKz7BW4J3Nmg12aCo2a8K0pJm4fnGA18c+ME22NR4hjTHEd9zE/SsMWHRe0COf7//ch2sI0vyxOe1/GfvHj7O/t46NekpIlHHxP6JWYyvAy4DpDh6cii49noCrltBaQK32HIvBI1lfD61h/pOXHdTGu6PMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOeZt3O0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOeZt3O0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C74DC2BCB0;
	Fri, 15 May 2026 16:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862487;
	bh=Y7kt41XSx5fWhl4TQQ6iSyWkfsUGnjrTQ5T045GkP0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOeZt3O0HUeekT4xYf37mS8BjTpv85ZMF77H+0HWbKCKV4PJTpRLHpKVR410O8wjp
	 idc5lPhO5N0Bm8DQOk5SiGIln7c3tYLgU+fec21Rx2htNbhz8h+BiGz7C0PIcIgZKZ
	 lJL/cdTclx6hJmPlyWBPuK1meRE962dMQaJ+zdCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 7.0 067/201] media: i2c: imx412: Assert reset GPIO during probe
Date: Fri, 15 May 2026 17:48:05 +0200
Message-ID: <20260515154659.986104052@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
 		dev_err(imx412->dev, "failed to get reset gpio %pe\n",
 			imx412->reset_gpio);


