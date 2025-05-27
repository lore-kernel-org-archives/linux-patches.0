Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7848E263F5E;
	Tue, 27 May 2025 17:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368494; cv=none; b=Y/MWGHMh1TVaPr+atCdHq8hu3XQZbhGn+n2WTY8lUMLujCLEgC5re+qQFAFiVJ75jB2BCouhjR7gTgrtNINv56kUVX/kbw0sf8NRDJWL5yMeN0y0CVHztYg9fs5Q+X9VbGZXQhC2DV15CFRywCdMuIuojCLzF7S8xG5k5GMToRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368494; c=relaxed/simple;
	bh=JrSy3CBQjHYLdz1HPHn9p6xDmSb3tqZWb3r7qdVeTjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpTVdsi255/aaR+Pkf2WRPviuePbmkURwBZytF2Ld2damR9fmroxQeAfEhi3A8inLdLHHYmSPwRMF13vPw67L3rsWbyDUyGNLqUzrUse54agbcPTUGuJcJ+s5pJnEnhGTlFj9GG/Gy7akHr3RhSqo08OCNUXSXULbAidcHqhyR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWZPyywi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWZPyywi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01338C4CEE9;
	Tue, 27 May 2025 17:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368494;
	bh=JrSy3CBQjHYLdz1HPHn9p6xDmSb3tqZWb3r7qdVeTjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWZPyywiHX6CuuHWaVY3Jq8BIri/Oqh1GSUgrbtK8PUf9u9A+1bv7ORqUJGYWKGdI
	 RTkWJVuM1MCN+se4k79lexZOMafrYYKUHkRW+GrObsVXrKiGbgwX/a8kvF6KxUGheU
	 ibsCa4WZRxQGUicVBDNuGblnOIMyZ+Z+zy23p9Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 707/783] pinctrl: qcom: switch to devm_register_sys_off_handler()
Date: Tue, 27 May 2025 18:28:24 +0200
Message-ID: <20250527162541.910607614@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 41e452e6933d14146381ea25cff5e4d1ac2abea1 ]

Error-handling paths in msm_pinctrl_probe() don't call
a function required to unroll restart handler registration,
unregister_restart_handler(). Instead of adding calls to this function,
switch the msm pinctrl code into using devm_register_sys_off_handler().

Fixes: cf1fc1876289 ("pinctrl: qcom: use restart_notifier mechanism for ps_hold")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/20250513-pinctrl-msm-fix-v2-2-249999af0fc1@oss.qualcomm.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index 82f0cc43bbf4f..0eb816395dc64 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -44,7 +44,6 @@
  * @pctrl:          pinctrl handle.
  * @chip:           gpiochip handle.
  * @desc:           pin controller descriptor
- * @restart_nb:     restart notifier block.
  * @irq:            parent irq for the TLMM irq_chip.
  * @intr_target_use_scm: route irq to application cpu using scm calls
  * @lock:           Spinlock to protect register resources as well
@@ -64,7 +63,6 @@ struct msm_pinctrl {
 	struct pinctrl_dev *pctrl;
 	struct gpio_chip chip;
 	struct pinctrl_desc desc;
-	struct notifier_block restart_nb;
 
 	int irq;
 
@@ -1471,10 +1469,9 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 	return 0;
 }
 
-static int msm_ps_hold_restart(struct notifier_block *nb, unsigned long action,
-			       void *data)
+static int msm_ps_hold_restart(struct sys_off_data *data)
 {
-	struct msm_pinctrl *pctrl = container_of(nb, struct msm_pinctrl, restart_nb);
+	struct msm_pinctrl *pctrl = data->cb_data;
 
 	writel(0, pctrl->regs[0] + PS_HOLD_OFFSET);
 	mdelay(1000);
@@ -1485,7 +1482,11 @@ static struct msm_pinctrl *poweroff_pctrl;
 
 static void msm_ps_hold_poweroff(void)
 {
-	msm_ps_hold_restart(&poweroff_pctrl->restart_nb, 0, NULL);
+	struct sys_off_data data = {
+		.cb_data = poweroff_pctrl,
+	};
+
+	msm_ps_hold_restart(&data);
 }
 
 static void msm_pinctrl_setup_pm_reset(struct msm_pinctrl *pctrl)
@@ -1495,9 +1496,11 @@ static void msm_pinctrl_setup_pm_reset(struct msm_pinctrl *pctrl)
 
 	for (i = 0; i < pctrl->soc->nfunctions; i++)
 		if (!strcmp(func[i].name, "ps_hold")) {
-			pctrl->restart_nb.notifier_call = msm_ps_hold_restart;
-			pctrl->restart_nb.priority = 128;
-			if (register_restart_handler(&pctrl->restart_nb))
+			if (devm_register_sys_off_handler(pctrl->dev,
+							  SYS_OFF_MODE_RESTART,
+							  128,
+							  msm_ps_hold_restart,
+							  pctrl))
 				dev_err(pctrl->dev,
 					"failed to setup restart handler.\n");
 			poweroff_pctrl = pctrl;
@@ -1599,8 +1602,6 @@ void msm_pinctrl_remove(struct platform_device *pdev)
 	struct msm_pinctrl *pctrl = platform_get_drvdata(pdev);
 
 	gpiochip_remove(&pctrl->chip);
-
-	unregister_restart_handler(&pctrl->restart_nb);
 }
 EXPORT_SYMBOL(msm_pinctrl_remove);
 
-- 
2.39.5



