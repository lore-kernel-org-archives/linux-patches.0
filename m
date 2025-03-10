Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8156A17CA12;
	Mon, 10 Mar 2025 17:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629244; cv=none; b=Zn8VzN+Wcf6RYu8e11i9vH9d8b9tA3mTMxOjPwogprLczjRPofcgqZf4LlEIYxc+djIr6bwYhX9NcPKKOuv7jSRNPvz1QOwMfgfuTu4trunkDFnDYqyAjgCSOG0822gtgXszke6TU90YHIV+kIE1UzYLl08QusZGQ7hu48O6G+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629244; c=relaxed/simple;
	bh=y319Qc3YBRPmDvsVfyeE6MFvZALEDX1huIRr0oLvjpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1hqCKvl0TmUqVgxPo+0cdN4OQ++hU9uO2S0eh7YYw3FtszgHOTY4JA5cfOIsOJ2qE883acup7qOD2D2HTuZ5xSJCeJ6410slkiVe9cpENiNRA0D4o7RyKqLp/yT3XoRtAGE4le9Kr8+jhxa4l2XQ1353rS/Cm7/UuhXhEsZS7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hq+30Owh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hq+30Owh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087D4C4CEE5;
	Mon, 10 Mar 2025 17:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629244;
	bh=y319Qc3YBRPmDvsVfyeE6MFvZALEDX1huIRr0oLvjpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hq+30OwhNhNRnK3IrWr8WDwSAEAR3SqvsQqv6240RPXEMVu3X32V/WK66g5aJUjYP
	 fTT809n+3OvqNoDbjYlWTMRqMoNv1BaRI3aKKSr+7QhkTobX6GXOGguef4IknydvgO
	 /hbA4Yw8Oew1gYY6j9SxbTEwdUnWaQXkMRWSedGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 228/620] usb: chipidea: ci_hdrc_imx: decrement devices refcount in .remove() and in the error path of .probe()
Date: Mon, 10 Mar 2025 18:01:14 +0100
Message-ID: <20250310170554.631794958@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 74adad500346fb07d69af2c79acbff4adb061134 ]

Current implementation of ci_hdrc_imx_driver does not decrement the
refcount of the device obtained in usbmisc_get_init_data(). Add a
put_device() call in .remove() and in .probe() before returning an
error.

This bug was found by an experimental static analysis tool that I am
developing.

Cc: stable <stable@kernel.org>
Fixes: f40017e0f332 ("chipidea: usbmisc_imx: Add USB support for VF610 SoCs")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20241216015539.352579-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index 9f4253777d0de..13731e85980e2 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -355,25 +355,29 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 		data->pinctrl = devm_pinctrl_get(dev);
 		if (PTR_ERR(data->pinctrl) == -ENODEV)
 			data->pinctrl = NULL;
-		else if (IS_ERR(data->pinctrl))
-			return dev_err_probe(dev, PTR_ERR(data->pinctrl),
+		else if (IS_ERR(data->pinctrl)) {
+			ret = dev_err_probe(dev, PTR_ERR(data->pinctrl),
 					     "pinctrl get failed\n");
+			goto err_put;
+		}
 
 		data->hsic_pad_regulator =
 				devm_regulator_get_optional(dev, "hsic");
 		if (PTR_ERR(data->hsic_pad_regulator) == -ENODEV) {
 			/* no pad regualator is needed */
 			data->hsic_pad_regulator = NULL;
-		} else if (IS_ERR(data->hsic_pad_regulator))
-			return dev_err_probe(dev, PTR_ERR(data->hsic_pad_regulator),
+		} else if (IS_ERR(data->hsic_pad_regulator)) {
+			ret = dev_err_probe(dev, PTR_ERR(data->hsic_pad_regulator),
 					     "Get HSIC pad regulator error\n");
+			goto err_put;
+		}
 
 		if (data->hsic_pad_regulator) {
 			ret = regulator_enable(data->hsic_pad_regulator);
 			if (ret) {
 				dev_err(dev,
 					"Failed to enable HSIC pad regulator\n");
-				return ret;
+				goto err_put;
 			}
 		}
 	}
@@ -387,13 +391,14 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 			dev_err(dev,
 				"pinctrl_hsic_idle lookup failed, err=%ld\n",
 					PTR_ERR(pinctrl_hsic_idle));
-			return PTR_ERR(pinctrl_hsic_idle);
+			ret = PTR_ERR(pinctrl_hsic_idle);
+			goto err_put;
 		}
 
 		ret = pinctrl_select_state(data->pinctrl, pinctrl_hsic_idle);
 		if (ret) {
 			dev_err(dev, "hsic_idle select failed, err=%d\n", ret);
-			return ret;
+			goto err_put;
 		}
 
 		data->pinctrl_hsic_active = pinctrl_lookup_state(data->pinctrl,
@@ -402,7 +407,8 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 			dev_err(dev,
 				"pinctrl_hsic_active lookup failed, err=%ld\n",
 					PTR_ERR(data->pinctrl_hsic_active));
-			return PTR_ERR(data->pinctrl_hsic_active);
+			ret = PTR_ERR(data->pinctrl_hsic_active);
+			goto err_put;
 		}
 	}
 
@@ -502,6 +508,8 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 	if (pdata.flags & CI_HDRC_PMQOS)
 		cpu_latency_qos_remove_request(&data->pm_qos_req);
 	data->ci_pdev = NULL;
+err_put:
+	put_device(data->usbmisc_data->dev);
 	return ret;
 }
 
@@ -525,6 +533,7 @@ static void ci_hdrc_imx_remove(struct platform_device *pdev)
 		if (data->hsic_pad_regulator)
 			regulator_disable(data->hsic_pad_regulator);
 	}
+	put_device(data->usbmisc_data->dev);
 }
 
 static void ci_hdrc_imx_shutdown(struct platform_device *pdev)
-- 
2.39.5



