Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8307E110;
	Tue, 29 Apr 2025 17:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948021; cv=none; b=SPX/OOxK1byZ1l9I8DvmeI1565Nmx5xFuax+zQZSoM0bUi/Bsh8sJH1n0jcosTqKRtJ5kExOmHRdWP/tnf3FCKgvjGChd/T5aZW55gU7xAY9yl8qhEv7PObx9LAjmdIwlR8voeX9l61DIsEqs/3AP8P9Mvma9EuAeAr41UKpGU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948021; c=relaxed/simple;
	bh=JNRhAtH2v5p8YDVGtRf2EEvPTZWE0x7lQNcyVeN+KiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIf5DDqnm/8FbzSfWS4EStV4P4BEtP3MXcFU8HFclJpcC72tKSSQr5BFMUsZ3RvusV98y/1Rx81NCDJqCaDrBNGjEfswIbzkegHc8ccj6r3n/YXW+lz2lvy22bnGf0tkqi7oEEMQ+p7KJdxSE3y6kM7KK4XjNCgR0WqTFYIh35s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hu+x/UhM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hu+x/UhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC09C4CEE3;
	Tue, 29 Apr 2025 17:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948021;
	bh=JNRhAtH2v5p8YDVGtRf2EEvPTZWE0x7lQNcyVeN+KiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hu+x/UhMfSQ3Nb+cEjlLgGdYjuDQKOiKLDlnkPy0N7LMkILLEgydkvqJ2FQvD2Xzm
	 SJUtsi9bcDlVVVZCShJ8x1tQyWTrNvOqLohrhmtVmACNHZZuF1pppGzgzC2KFE3esV
	 tBmM3OgrbVjYeeXZCrMBQgKDi6FNSahoG9JM9Gzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.12 140/280] usb: chipidea: ci_hdrc_imx: fix call balance of regulator routines
Date: Tue, 29 Apr 2025 18:41:21 +0200
Message-ID: <20250429161120.853859617@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


