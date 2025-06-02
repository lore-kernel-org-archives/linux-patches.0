Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42DF22B8B0;
	Mon,  2 Jun 2025 14:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874450; cv=none; b=itjqEAtCsrq5R2pH7wkVdKCi1UropYvfJot5A4h5kZLy3k2iDa5VnPeBT6LCeW/hX25mQs00zbbXVA2KzPYQeTujezejWqtukPuftP1FgDyiavehli837UDMw4ZDGxoOcyd06RIRcFozlPSx/3zhu3EjaivYu9hMUknpQvPfJL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874450; c=relaxed/simple;
	bh=/8uZ8LWOH+hP2G/hPjRFUedrqP+9NEwcqOJFz7N0Q7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIfK/cPHuJ4BnXqBbnvUHrvedZnR3SmmgG4y5kHB7dmQYUPEQ79Ro1bOFweQCLOm5bZMYI18MmiQ4p0cOdaMlpsl9Jj51Op6+uRsWjUJoXo1FQXL1nWNbNVsXzy59Zlfl+aMjIhRbucMXWJpmbDBhDtvtT9STH531BNe14FS4hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTaxg8Od; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTaxg8Od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF3FC4CEEB;
	Mon,  2 Jun 2025 14:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874450;
	bh=/8uZ8LWOH+hP2G/hPjRFUedrqP+9NEwcqOJFz7N0Q7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mTaxg8OdDpMlw1lnrYPUHeKruBplR/fsFxntdFYEi+xOniNRmPIiugJMIqElAv8iB
	 ycL+C50y/1orh26VOGuvcnXqxqFb8a6QRqM8zP8W06wJvEFwdLH8mbNglVFLIwfTgJ
	 mgPL9QpAzoBNlJu8GNIU1KrxJAJ1R/R3tqxg+Ty0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/204] usb: chipidea: imx: refine the error handling for hsic
Date: Mon,  2 Jun 2025 15:46:00 +0200
Message-ID: <20250602134256.750467659@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@nxp.com>

[ Upstream commit 3f4aad6e1a4c26a20700fb4f630e4e6c6831db47 ]

- -EPROBE_DEFER is an error, but without need show error message
- If pintrol is not existed, as pintrol is NULL

Signed-off-by: Peter Chen <peter.chen@nxp.com>
Stable-dep-of: 8c531e0a8c2d ("usb: chipidea: ci_hdrc_imx: implement usb_phy_init() error handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index 09a7bee7203c5..034de11a1ac11 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -340,8 +340,11 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 		pdata.flags |= CI_HDRC_IMX_IS_HSIC;
 		data->usbmisc_data->hsic = 1;
 		data->pinctrl = devm_pinctrl_get(dev);
-		if (IS_ERR(data->pinctrl)) {
-			dev_err(dev, "pinctrl get failed, err=%ld\n",
+		if (PTR_ERR(data->pinctrl) == -ENODEV)
+			data->pinctrl = NULL;
+		else if (IS_ERR(data->pinctrl)) {
+			if (PTR_ERR(data->pinctrl) != -EPROBE_DEFER)
+				dev_err(dev, "pinctrl get failed, err=%ld\n",
 					PTR_ERR(data->pinctrl));
 			return PTR_ERR(data->pinctrl);
 		}
@@ -371,13 +374,13 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 
 		data->hsic_pad_regulator =
 				devm_regulator_get_optional(dev, "hsic");
-		if (PTR_ERR(data->hsic_pad_regulator) == -EPROBE_DEFER) {
-			return -EPROBE_DEFER;
-		} else if (PTR_ERR(data->hsic_pad_regulator) == -ENODEV) {
+		if (PTR_ERR(data->hsic_pad_regulator) == -ENODEV) {
 			/* no pad regualator is needed */
 			data->hsic_pad_regulator = NULL;
 		} else if (IS_ERR(data->hsic_pad_regulator)) {
-			dev_err(dev, "Get HSIC pad regulator error: %ld\n",
+			if (PTR_ERR(data->hsic_pad_regulator) != -EPROBE_DEFER)
+				dev_err(dev,
+					"Get HSIC pad regulator error: %ld\n",
 					PTR_ERR(data->hsic_pad_regulator));
 			return PTR_ERR(data->hsic_pad_regulator);
 		}
-- 
2.39.5



