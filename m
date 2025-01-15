Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B108248BB0;
	Wed, 15 Jan 2025 10:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938785; cv=none; b=TVI3a8ZCg92ezy7XU+VgymBWwJG3ex+Xc6CbNqpCqqCh/Hs7Cm156TkuOT8v212Ixc4ryqFRBSa+lXH/JXtTqUCOEAbdIcHPkn3rxFSkIq1XLYyu8MFQajcrCfDnOHhHDukfKrPAiJ5+c24oZajB723YK++SI/2rpBHg75cG4Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938785; c=relaxed/simple;
	bh=NGOsI984LTN8JyOiJW7f67xi3yOa1f9nY+0Yho0kVLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEjkJRSk6IU9kG8RuswgJllL2djJDMuROfHN7yET0dVMse4VEgvkX11dHLO8bYx/UZ2RlEPAtdCqg3QAERkJgdAFhNfhjPCNo8jCtoRAIX2vVGFx14qlhkET5N2aZha0Nc6FzsvhB1aYrAzDHXd8QshlTLagJeG8pjFfyX7bHFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eXFHJBsv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eXFHJBsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD1CC4CEDF;
	Wed, 15 Jan 2025 10:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938785;
	bh=NGOsI984LTN8JyOiJW7f67xi3yOa1f9nY+0Yho0kVLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXFHJBsvz3PxF9DUoWrqqbblaZ5LiT3O4iAAus0kJY25hKclixxQwBekFbVgmxgWl
	 g1OduJlB2x31LkZ421P9NzQ3uUI6PsyupCi2Soy3w29UAE9n+qxShwkJwfnkfTOOjc
	 86sSNKUtEgvsNyQ4wypqY6Qxy8SS13W/l4Q/utl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.6 097/129] usb: chipidea: ci_hdrc_imx: decrement devices refcount in .remove() and in the error path of .probe()
Date: Wed, 15 Jan 2025 11:37:52 +0100
Message-ID: <20250115103558.234546667@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit 74adad500346fb07d69af2c79acbff4adb061134 upstream.

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
---
 drivers/usb/chipidea/ci_hdrc_imx.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -362,25 +362,29 @@ static int ci_hdrc_imx_probe(struct plat
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
 			/* no pad regulator is needed */
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
@@ -394,13 +398,14 @@ static int ci_hdrc_imx_probe(struct plat
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
@@ -409,7 +414,8 @@ static int ci_hdrc_imx_probe(struct plat
 			dev_err(dev,
 				"pinctrl_hsic_active lookup failed, err=%ld\n",
 					PTR_ERR(data->pinctrl_hsic_active));
-			return PTR_ERR(data->pinctrl_hsic_active);
+			ret = PTR_ERR(data->pinctrl_hsic_active);
+			goto err_put;
 		}
 	}
 
@@ -513,6 +519,8 @@ disable_hsic_regulator:
 	if (pdata.flags & CI_HDRC_PMQOS)
 		cpu_latency_qos_remove_request(&data->pm_qos_req);
 	data->ci_pdev = NULL;
+err_put:
+	put_device(data->usbmisc_data->dev);
 	return ret;
 }
 
@@ -536,6 +544,7 @@ static void ci_hdrc_imx_remove(struct pl
 		if (data->hsic_pad_regulator)
 			regulator_disable(data->hsic_pad_regulator);
 	}
+	put_device(data->usbmisc_data->dev);
 }
 
 static void ci_hdrc_imx_shutdown(struct platform_device *pdev)


