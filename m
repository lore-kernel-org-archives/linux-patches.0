Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B12434041A;
	Sat, 30 May 2026 17:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163839; cv=none; b=TnwnNPj65KLv8cs1jkWc+4Qjep9Ro6mWWSTVZ5NczQBYPDfaQp+nvryCh4jDdiiMZ4JU1hIiN0GHfJPSGP67Z3xeIsVP3CnIAeLDKG2ZbbhddjlSCpgyZ7RDm2wKkodASF1u7/heGUY4+HSRyyTFnLeDNF76q/wAXp6F0y/qDho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163839; c=relaxed/simple;
	bh=TBU4uIUCYCDGqQXXaL/FXNj5JS4VUXdm36EOJUhSm8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMUOv6RkNIBIm2JlnDXHrtZyqEeK53BY9O8cs0GXjk3RIydm1naoD90zj/txXRMDo4LKfwvdIIi5n0od+v+rOvdXO71TbssKroGB4EP0jkICk1fi7phtL+PW/5WIt4OMYeET2jgALDBeRvfrk0dOOguLpsf5HWanJ18kSo3uj6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TEEdwbr/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEEdwbr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D741F00893;
	Sat, 30 May 2026 17:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163838;
	bh=ie9JoNePOKiuJPneVI9qtWyPvCqEQzEaK+PTXRk/Ms4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TEEdwbr/syCuzU4CcHXOM0oC+oc6Hu9gjDKvXxVvS1kcmqbOCu6YrZ2xy6F1q/LB5
	 XXulQU/VKkycH39Rz5thHEzNEujJxwdOSlU4NuPZUPMlcw0h/z2IfCrp8Z/FW4veX5
	 vFtOBfSyxuwGT6b6tQPyn3q2Pmu1shx1xda+bBCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 360/776] media: i2c: imx412: Assert reset GPIO during probe
Date: Sat, 30 May 2026 18:01:14 +0200
Message-ID: <20260530160249.878632648@linuxfoundation.org>
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


