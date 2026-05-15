Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C253FF1D1;
	Fri, 15 May 2026 15:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860296; cv=none; b=Aq7BUWUyK9DiwlSs/tOyZpeABqQ0iuU1/Tl5HJEp8Nj1z2KEKWyq8ZSlFPlohwohBcKvSRPGExaLVwwT3e7Hl0AAEXt05/9ovMy/jRI9CA2bp+gDdIRmQEP8xO9IVwKd43A2gUwzc1iKRj7AsfDeHXw8TsV5BnZmFjck1haZH04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860296; c=relaxed/simple;
	bh=NF/N0Buecnk9m37b9t5PDd458RZaRv2+fm48yxdLP4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyaQJzMLWLPtYTZ4wUc1D9uruMwb4wt8wwOkKU5nbfHWPh7ZrG0jAuy9xHbE1C2KKu8IPzifafHALkP7NGcRoCC44cRu1fZOLq1jb9oV8oh+AdUVmsNt1fQa/JMla6D/it72grgT4NHa/2KUUiFLAu56YZJV6IoRjMuXifY5DzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eoQxsbXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eoQxsbXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC05C2BCB0;
	Fri, 15 May 2026 15:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860296;
	bh=NF/N0Buecnk9m37b9t5PDd458RZaRv2+fm48yxdLP4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eoQxsbXQbUK0JA11rcimBDmQj40XtQbU2o2GnUsafMvq7FEEDqOnf2UqJUt7iXHSk
	 NQ92tJxs5BMRGO4IttufSPh4njQJDtmfwFOAkImRPsdOGUz1qyWTQ0JRsQTKWAc9OM
	 QuSoVbm54wuE9EAZdi0naPg6DvjxzhRMZkJs1nt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 034/144] media: i2c: imx412: Assert reset GPIO during probe
Date: Fri, 15 May 2026 17:47:40 +0200
Message-ID: <20260515154654.306522527@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


