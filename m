Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C492AE96;
	Tue, 29 Apr 2025 17:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949471; cv=none; b=HZ+SfE210Fex6g/XU9bWY6Zbjf3dd4U92Z+29ELNsG+MGRLskNMIIW/AUX8U4k1uaQPj1lrdngzmUOK3YOrPOuV6qiqZvANfCiJrMlmEmf40YtuJE6kV+5+i8Wx4ALZH8vh2sSjQ90tRldbzCs8nlxjP+8KegS+JlqR7OeyDly4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949471; c=relaxed/simple;
	bh=j5Qzfdcxiwf4iYBrUbLEYR5fusepHYRwe5bBAPz04EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cslp/ViKjk8GUWzkExcz203+BTG8RZz5YzyUdGO1TUKTQPGbpg41zosrILkVcVSBJQ7IwOdj2ocWH/LPhyNfbtqK2jJO3aMcI7Tv9ffNUFHGVArs4IhYbO5qET6dyF3Exi73hruZTJhNTUooOM96hWxpq0wjqqj0lkMr/HChfJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGpLCLYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGpLCLYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAB4C4CEE3;
	Tue, 29 Apr 2025 17:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949471;
	bh=j5Qzfdcxiwf4iYBrUbLEYR5fusepHYRwe5bBAPz04EA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGpLCLYFKr+483z5tYAKYbNTYpSZEZ7oaz7yL2U7ow9diUqCakkj25qam2ags+Y+y
	 C3uDlEMqS67+2Jj9aOeZV/OH/KdfS/t9b2Sm1pbbbyyYk9v9qkLeft0ERttE57dNnJ
	 +lU5kGEwuJsvQfSVJB9f6Yv6ei3HvIdoEprUAJ0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.15 312/373] usb: chipidea: ci_hdrc_imx: fix call balance of regulator routines
Date: Tue, 29 Apr 2025 18:43:09 +0200
Message-ID: <20250429161135.942726220@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 8cab0e9a3f3e8d700179e0d6141643d54a267fd5 upstream.

Upon encountering errors during the HSIC pinctrl handling section the
regulator should be disabled.

Use devm_add_action_or_reset() to let the regulator-disabling routine be
handled by device resource management stack.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 4d6141288c33 ("usb: chipidea: imx: pinctrl for HSIC is optional")
Cc: stable <stable@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20250316102658.490340-3-pchelkin@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -322,6 +322,13 @@ static int ci_hdrc_imx_notify_event(stru
 	return ret;
 }
 
+static void ci_hdrc_imx_disable_regulator(void *arg)
+{
+	struct ci_hdrc_imx_data *data = arg;
+
+	regulator_disable(data->hsic_pad_regulator);
+}
+
 static int ci_hdrc_imx_probe(struct platform_device *pdev)
 {
 	struct ci_hdrc_imx_data *data;
@@ -379,6 +386,13 @@ static int ci_hdrc_imx_probe(struct plat
 					"Failed to enable HSIC pad regulator\n");
 				goto err_put;
 			}
+			ret = devm_add_action_or_reset(dev,
+					ci_hdrc_imx_disable_regulator, data);
+			if (ret) {
+				dev_err(dev,
+					"Failed to add regulator devm action\n");
+				goto err_put;
+			}
 		}
 	}
 
@@ -417,11 +431,11 @@ static int ci_hdrc_imx_probe(struct plat
 
 	ret = imx_get_clks(dev);
 	if (ret)
-		goto disable_hsic_regulator;
+		goto qos_remove_request;
 
 	ret = imx_prepare_enable_clks(dev);
 	if (ret)
-		goto disable_hsic_regulator;
+		goto qos_remove_request;
 
 	data->phy = devm_usb_get_phy_by_phandle(dev, "fsl,usbphy", 0);
 	if (IS_ERR(data->phy)) {
@@ -501,10 +515,7 @@ disable_device:
 	ci_hdrc_remove_device(data->ci_pdev);
 err_clk:
 	imx_disable_unprepare_clks(dev);
-disable_hsic_regulator:
-	if (data->hsic_pad_regulator)
-		/* don't overwrite original ret (cf. EPROBE_DEFER) */
-		regulator_disable(data->hsic_pad_regulator);
+qos_remove_request:
 	if (pdata.flags & CI_HDRC_PMQOS)
 		cpu_latency_qos_remove_request(&data->pm_qos_req);
 	data->ci_pdev = NULL;
@@ -531,8 +542,6 @@ static void ci_hdrc_imx_remove(struct pl
 		imx_disable_unprepare_clks(&pdev->dev);
 		if (data->plat_data->flags & CI_HDRC_PMQOS)
 			cpu_latency_qos_remove_request(&data->pm_qos_req);
-		if (data->hsic_pad_regulator)
-			regulator_disable(data->hsic_pad_regulator);
 	}
 	if (data->usbmisc_data)
 		put_device(data->usbmisc_data->dev);


