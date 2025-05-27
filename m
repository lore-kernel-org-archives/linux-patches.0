Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D25278750;
	Tue, 27 May 2025 17:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366001; cv=none; b=a5AvZvK3/AZ/R5BD/gdOeddyz0nO9Ld2XJpl8QHymWsihNJvltXrHICvyb8bDCcz6XHVlOAN/hrhvarHZXUQb1tlkHfZJ9tgkbhf0amxDfrJ6WPwaEibju//cPX96qg2aUwIDyTUM8iIN/4mVrPrO9TYv1FcuSNNf0Xj+kH6pOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366001; c=relaxed/simple;
	bh=wCS/mD26Lx9WvipeIqiqJoHgna6tQ2Z7Ihvnklyw/4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxbCh652oHmhmybeclL90urxCl/JgxBb78uMqzmCtjehIm/nI/AlD5gRL8oyOKevePkhWtCdJoKqWRI+bhZpPCVWffKwzGGJsLfH8bNZVQFtaqW0D9Gona02/ts9eT4Qj/5nZUWzqK6RZ/u8sWFzUskT2r85G9UdwauOo+srRj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcPibci+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcPibci+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 047A0C4CEE9;
	Tue, 27 May 2025 17:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366000;
	bh=wCS/mD26Lx9WvipeIqiqJoHgna6tQ2Z7Ihvnklyw/4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcPibci+uDiiQVNF3y7mjL/h9txkdTMalyEzRi7dqaS1uTc2ljov76QzS71ThxD/H
	 2QApR5nQeuEuGeSiA01eQlxNnpmwrNwUV0DOA4UJEq2+54SXHm6t5rUaA8eundldWi
	 KD9pZ3RIa7XpIUiuDqcoR+DalGwpUXV/NTNxF8bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 559/626] pinctrl: qcom: switch to devm_register_sys_off_handler()
Date: Tue, 27 May 2025 18:27:32 +0200
Message-ID: <20250527162507.680984785@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index a6bdff7a0bb25..018e96d921c05 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -43,7 +43,6 @@
  * @pctrl:          pinctrl handle.
  * @chip:           gpiochip handle.
  * @desc:           pin controller descriptor
- * @restart_nb:     restart notifier block.
  * @irq:            parent irq for the TLMM irq_chip.
  * @intr_target_use_scm: route irq to application cpu using scm calls
  * @lock:           Spinlock to protect register resources as well
@@ -63,7 +62,6 @@ struct msm_pinctrl {
 	struct pinctrl_dev *pctrl;
 	struct gpio_chip chip;
 	struct pinctrl_desc desc;
-	struct notifier_block restart_nb;
 
 	int irq;
 
@@ -1470,10 +1468,9 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
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
@@ -1484,7 +1481,11 @@ static struct msm_pinctrl *poweroff_pctrl;
 
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
@@ -1494,9 +1495,11 @@ static void msm_pinctrl_setup_pm_reset(struct msm_pinctrl *pctrl)
 
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
@@ -1598,8 +1601,6 @@ void msm_pinctrl_remove(struct platform_device *pdev)
 	struct msm_pinctrl *pctrl = platform_get_drvdata(pdev);
 
 	gpiochip_remove(&pctrl->chip);
-
-	unregister_restart_handler(&pctrl->restart_nb);
 }
 EXPORT_SYMBOL(msm_pinctrl_remove);
 
-- 
2.39.5



