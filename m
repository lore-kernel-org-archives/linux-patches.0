Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C923BB116;
	Fri, 15 May 2026 16:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861410; cv=none; b=Dh7wPjzBUjtgz9iYDgVB5VBZCaRjlkaiDB9JT1l3IVBvks75R8cSh0D1TUt1CDyB2RnSZA4FaBUBqtSn7HtWDlmd7uCLkvMCNnfZHE/PZtsKSEArzfqHW3JCmoLBgDtmjGUlHcROW2UYfiH/8qSebESg6UEhCyOOk7ZLfTt9OZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861410; c=relaxed/simple;
	bh=4otF4xXDaXoBYADaYdbH40vRjFgDDa0v/7jy68nHnzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0G4lYeqiSJY/xGAqdT2EpTYTGuMro09FkHL93E2zo4rAPj5arA78CP7cONtGaOFJ9xiYbkmuy6iAFDPNsMoEy1/hKxfhiwzmqvwiIbg/6PvbkzuylQzB0MNcbI+xOsvPsjADh4wKlqOjieo8y/HxivGItOTVFQUra1deJ97iAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gv4XEjRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gv4XEjRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCF3C2BCB0;
	Fri, 15 May 2026 16:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861410;
	bh=4otF4xXDaXoBYADaYdbH40vRjFgDDa0v/7jy68nHnzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gv4XEjRcHT3UcksfquvCGgkdfLy8w+p2TucZOEn0HFqttZkSCDsRx5nuwrwWnk/Dk
	 hORd76ZTrAL8utUGvUFFNB3Ous94GVimo1SnkMJnWesaeDYZCZd0F5tDdRiqLCiNqB
	 DyoAPIj8U6QENUIUkm3VnqyZqNwS9uZb95nF5g+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenmeng Liu <wenmeng.liu@oss.qualcomm.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 318/474] media: i2c: imx412: Assert reset GPIO during probe
Date: Fri, 15 May 2026 17:47:07 +0200
Message-ID: <20260515154721.892742999@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -934,7 +934,7 @@ static int imx412_parse_hw_config(struct
 
 	/* Request optional reset pin */
 	imx412->reset_gpio = devm_gpiod_get_optional(imx412->dev, "reset",
-						     GPIOD_OUT_LOW);
+						     GPIOD_OUT_HIGH);
 	if (IS_ERR(imx412->reset_gpio)) {
 		dev_err(imx412->dev, "failed to get reset gpio %ld\n",
 			PTR_ERR(imx412->reset_gpio));


