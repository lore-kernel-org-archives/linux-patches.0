Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BF28BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD6FC433EF;
	Tue, 28 Mar 2023 15:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015749;
	bh=ifmrUBFPf/r7wdc0/9GqPYIDEGZnjFzjv8eq4qDJV/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dn21EeC1KkUs0kFygIbcUpVKdZxWSV9hdw4GtnqPpdvzWg0DRHvHn7LN4mlQ7nZnb
	 Con/1gQLrSBbfAUR0UDYb2O7pQYFO1gPb0jBfiCjfWs0jyfBOsdB+Eebg6GngD0LUk
	 /okfDVNKmjguDEzoZ3taXzVPAdAvTIaP0/OkfyaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Subject: [PATCH 6.1 162/224] usb: dwc2: fix a devres leak in hw_enable upon suspend resume
Date: Tue, 28 Mar 2023 16:42:38 +0200
Message-Id: <20230328142624.124305974@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

commit f747313249b74f323ddf841a9c8db14d989f296a upstream.

Each time the platform goes to low power, PM suspend / resume routines
call: __dwc2_lowlevel_hw_enable -> devm_add_action_or_reset().
This adds a new devres each time.
This may also happen at runtime, as dwc2_lowlevel_hw_enable() can be
called from udc_start().

This can be seen with tracing:
- echo 1 > /sys/kernel/debug/tracing/events/dev/devres_log/enable
- go to low power
- cat /sys/kernel/debug/tracing/trace

A new "ADD" entry is found upon each low power cycle:
... devres_log: 49000000.usb-otg ADD 82a13bba devm_action_release (8 bytes)
... devres_log: 49000000.usb-otg ADD 49889daf devm_action_release (8 bytes)
...

A second issue is addressed here:
- regulator_bulk_enable() is called upon each PM cycle (suspend/resume).
- regulator_bulk_disable() never gets called.

So the reference count for these regulators constantly increase, by one
upon each low power cycle, due to missing regulator_bulk_disable() call
in __dwc2_lowlevel_hw_disable().

The original fix that introduced the devm_add_action_or_reset() call,
fixed an issue during probe, that happens due to other errors in
dwc2_driver_probe() -> dwc2_core_reset(). Then the probe fails without
disabling regulators, when dr_mode == USB_DR_MODE_PERIPHERAL.

Rather fix the error path: disable all the low level hardware in the
error path, by using the "hsotg->ll_hw_enabled" flag. Checking dr_mode
has been introduced to avoid a dual call to dwc2_lowlevel_hw_disable().
"ll_hw_enabled" should achieve the same (and is used currently in the
remove() routine).

Fixes: 54c196060510 ("usb: dwc2: Always disable regulators on driver teardown")
Fixes: 33a06f1300a7 ("usb: dwc2: Fix error path in gadget registration")
Cc: stable <stable@kernel.org>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/r/20230316084127.126084-1-fabrice.gasnier@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/platform.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -91,13 +91,6 @@ static int dwc2_get_dr_mode(struct dwc2_
 	return 0;
 }
 
-static void __dwc2_disable_regulators(void *data)
-{
-	struct dwc2_hsotg *hsotg = data;
-
-	regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies), hsotg->supplies);
-}
-
 static int __dwc2_lowlevel_hw_enable(struct dwc2_hsotg *hsotg)
 {
 	struct platform_device *pdev = to_platform_device(hsotg->dev);
@@ -108,11 +101,6 @@ static int __dwc2_lowlevel_hw_enable(str
 	if (ret)
 		return ret;
 
-	ret = devm_add_action_or_reset(&pdev->dev,
-				       __dwc2_disable_regulators, hsotg);
-	if (ret)
-		return ret;
-
 	if (hsotg->clk) {
 		ret = clk_prepare_enable(hsotg->clk);
 		if (ret)
@@ -168,7 +156,7 @@ static int __dwc2_lowlevel_hw_disable(st
 	if (hsotg->clk)
 		clk_disable_unprepare(hsotg->clk);
 
-	return 0;
+	return regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies), hsotg->supplies);
 }
 
 /**
@@ -607,7 +595,7 @@ error_init:
 	if (hsotg->params.activate_stm_id_vb_detection)
 		regulator_disable(hsotg->usb33d);
 error:
-	if (hsotg->dr_mode != USB_DR_MODE_PERIPHERAL)
+	if (hsotg->ll_hw_enabled)
 		dwc2_lowlevel_hw_disable(hsotg);
 	return retval;
 }


