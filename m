Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7581DF73C;
	Tue, 29 Apr 2025 17:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946119; cv=none; b=psx0l6rm960Pk7uH53qqf8MUC0Nq9kYA0WUmUwGTX2X9l8tWOzzDW8gjnloJGrA5ATGFohxd2fxyh6xvE6EHow+EFxAMEJwGx38dkk63f+CkhEfEjvgJlvmp6dcj9PFo6JeyDF3tVUbEnH2QyoRPG7KxEw3SVEq6YrvBX6T6gnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946119; c=relaxed/simple;
	bh=KAHGqImCvNdJbT1jeeq79QcG9KJRpeu1NZtygy6X12A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzikXgux4TwfUYGv/ru4T6i7FHTyN0U3AhHP1jTtLGyGZIc9y/Ag5GYZiwzCcWpr/H2UrgH3UK0e7XAMUEIajNgHLk6DHOeXLzVQqemCRILH48ekpIC+eSPnZ3dlGpb7RXc+18cQTNlIoegtsxOJc0hqXkE+KtW9c6pxCkXp0WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mtcQXoe1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mtcQXoe1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2953AC4CEE3;
	Tue, 29 Apr 2025 17:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946119;
	bh=KAHGqImCvNdJbT1jeeq79QcG9KJRpeu1NZtygy6X12A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mtcQXoe1N43cx6j7NjElXL/oO6bKDS2YqLHS0V2XVOjgl1zDW2DNcREu981L/ZHak
	 mu2I7JiC5pqdtviB0hi8WbStNCDd4qd2YL1TXJJ3lHqZhbYYEyPSCdLN2kvtI09sRz
	 iSEAlEYpQD+3eJXqn1sj05scAJkzJrKca6QA9+uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.14 162/311] usb: chipidea: ci_hdrc_imx: fix call balance of regulator routines
Date: Tue, 29 Apr 2025 18:39:59 +0200
Message-ID: <20250429161127.677360937@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -336,6 +336,13 @@ static int ci_hdrc_imx_notify_event(stru
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
@@ -394,6 +401,13 @@ static int ci_hdrc_imx_probe(struct plat
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
 
@@ -432,11 +446,11 @@ static int ci_hdrc_imx_probe(struct plat
 
 	ret = imx_get_clks(dev);
 	if (ret)
-		goto disable_hsic_regulator;
+		goto qos_remove_request;
 
 	ret = imx_prepare_enable_clks(dev);
 	if (ret)
-		goto disable_hsic_regulator;
+		goto qos_remove_request;
 
 	ret = clk_prepare_enable(data->clk_wakeup);
 	if (ret)
@@ -526,10 +540,7 @@ err_clk:
 	clk_disable_unprepare(data->clk_wakeup);
 err_wakeup_clk:
 	imx_disable_unprepare_clks(dev);
-disable_hsic_regulator:
-	if (data->hsic_pad_regulator)
-		/* don't overwrite original ret (cf. EPROBE_DEFER) */
-		regulator_disable(data->hsic_pad_regulator);
+qos_remove_request:
 	if (pdata.flags & CI_HDRC_PMQOS)
 		cpu_latency_qos_remove_request(&data->pm_qos_req);
 	data->ci_pdev = NULL;
@@ -557,8 +568,6 @@ static void ci_hdrc_imx_remove(struct pl
 		clk_disable_unprepare(data->clk_wakeup);
 		if (data->plat_data->flags & CI_HDRC_PMQOS)
 			cpu_latency_qos_remove_request(&data->pm_qos_req);
-		if (data->hsic_pad_regulator)
-			regulator_disable(data->hsic_pad_regulator);
 	}
 	if (data->usbmisc_data)
 		put_device(data->usbmisc_data->dev);


