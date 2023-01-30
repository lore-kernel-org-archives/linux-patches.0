Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31DC28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6888AC433D2;
	Mon, 30 Jan 2023 14:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087560;
	bh=QhQ7BzoNhchZCDAyyU04IcTh+COTyiJSpggSGvTQd38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r3srgGL8+8UmaCcjdl8yGAqSoEY0tgHj1piQ7qIk8tCJH+tLvPWflqctDXB3Ya194
	 7XIEYTD3nj7cbaFwrPNl4etqsJyTAcZZhHSwk8SmtHlWyiQSNJ4xhM0/vZ5LLrSpT6
	 M9b1PL1q3CI5jdrM+wWlXADjVeicpCHUE8KVhSUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 249/313] i2c: designware: Fix unbalanced suspended flag
Date: Mon, 30 Jan 2023 14:51:24 +0100
Message-Id: <20230130134348.309361267@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 75507a319876aba88932e2c7dab58b6c22d89f6b ]

Ensure that i2c_mark_adapter_suspended() is always balanced by a call to
i2c_mark_adapter_resumed().

dw_i2c_plat_resume() must always be called, so that
i2c_mark_adapter_resumed() is called. This is not compatible with
DPM_FLAG_MAY_SKIP_RESUME, so remove the flag.

Since the controller is always resumed on system resume the
dw_i2c_plat_complete() callback is redundant and has been removed.

The unbalanced suspended flag was introduced by commit c57813b8b288
("i2c: designware: Lock the adapter while setting the suspended flag")

Before that commit, the system and runtime PM used the same functions. The
DPM_FLAG_MAY_SKIP_RESUME was used to skip the system resume if the driver
had been in runtime-suspend. If system resume was skipped, the suspended
flag would be cleared by the next runtime resume. The check of the
suspended flag was _after_ the call to pm_runtime_get_sync() in
i2c_dw_xfer(). So either a system resume or a runtime resume would clear
the flag before it was checked.

Having introduced the unbalanced suspended flag with that commit, a further
commit 80704a84a9f8
("i2c: designware: Use the i2c_mark_adapter_suspended/resumed() helpers")

changed from using a local suspended flag to using the
i2c_mark_adapter_suspended/resumed() functions. These use a flag that is
checked by I2C core code before issuing the transfer to the bus driver, so
there was no opportunity for the bus driver to runtime resume itself before
the flag check.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: c57813b8b288 ("i2c: designware: Lock the adapter while setting the suspended flag")
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-platdrv.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index ba043b547393..74182db03a88 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -351,13 +351,11 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 
 	if (dev->flags & ACCESS_NO_IRQ_SUSPEND) {
 		dev_pm_set_driver_flags(&pdev->dev,
-					DPM_FLAG_SMART_PREPARE |
-					DPM_FLAG_MAY_SKIP_RESUME);
+					DPM_FLAG_SMART_PREPARE);
 	} else {
 		dev_pm_set_driver_flags(&pdev->dev,
 					DPM_FLAG_SMART_PREPARE |
-					DPM_FLAG_SMART_SUSPEND |
-					DPM_FLAG_MAY_SKIP_RESUME);
+					DPM_FLAG_SMART_SUSPEND);
 	}
 
 	device_enable_async_suspend(&pdev->dev);
@@ -419,21 +417,8 @@ static int dw_i2c_plat_prepare(struct device *dev)
 	 */
 	return !has_acpi_companion(dev);
 }
-
-static void dw_i2c_plat_complete(struct device *dev)
-{
-	/*
-	 * The device can only be in runtime suspend at this point if it has not
-	 * been resumed throughout the ending system suspend/resume cycle, so if
-	 * the platform firmware might mess up with it, request the runtime PM
-	 * framework to resume it.
-	 */
-	if (pm_runtime_suspended(dev) && pm_resume_via_firmware())
-		pm_request_resume(dev);
-}
 #else
 #define dw_i2c_plat_prepare	NULL
-#define dw_i2c_plat_complete	NULL
 #endif
 
 #ifdef CONFIG_PM
@@ -483,7 +468,6 @@ static int __maybe_unused dw_i2c_plat_resume(struct device *dev)
 
 static const struct dev_pm_ops dw_i2c_dev_pm_ops = {
 	.prepare = dw_i2c_plat_prepare,
-	.complete = dw_i2c_plat_complete,
 	SET_LATE_SYSTEM_SLEEP_PM_OPS(dw_i2c_plat_suspend, dw_i2c_plat_resume)
 	SET_RUNTIME_PM_OPS(dw_i2c_plat_runtime_suspend, dw_i2c_plat_runtime_resume, NULL)
 };
-- 
2.39.0



