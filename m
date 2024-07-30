Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6E51A76DD;
	Tue, 30 Jul 2024 17:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359779; cv=none; b=STObh2ElfI68Lyjd28yRB4MXhpqGQ5LSv2DGKtFxMYJsS2WB3FV/4VKSIkSRfaiV/BZd3TQuzy1cEJuuPHm1ZH7zH/qV3XPaZ7c9nN/yeR38I0OUFPLK6ZSis4gjK1EBjdixXOgX0ZRjRyJvHROdL7T0r9DqS5sfzHiHbNu/itk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359779; c=relaxed/simple;
	bh=HSRFZ7A4pdtj+5SRLbcZcFSconct94JKnZ3brLEzs1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gh0a0BxgWJ5AGb8RGgWM6vUeKF8aMX88TV3aLcPTNfq+rIMNw5RN3pe18Yv961fZSscfdPzfJp7T9I5yVQi6PUHO9d+2tMx0plZAl7rOfuS7/4E9vrROLodiTHpiULHKvDMcv0/xqRAuz4JbNiReuEKqySMwm2+nJzsT6V2xn/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lp4Q7Lo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lp4Q7Lo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DD8C32782;
	Tue, 30 Jul 2024 17:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359779;
	bh=HSRFZ7A4pdtj+5SRLbcZcFSconct94JKnZ3brLEzs1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lp4Q7Lo0j+Iwff3054Oo2iS63ioiWCjUU6DSVszhX/XGXTTj9tcgOkdmYWJJVrnXV
	 SQVhy6sdmr2CjxvFwAHJkhPOLZWAM1+FFJyKJEke0m/roprCeewopk7H5fW3NPu0Fu
	 xBh3IUzsijP+/cN+Q6YTW2egNtzFBvdvtLc8hvI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 531/809] mailbox: mtk-cmdq: Move devm_mbox_controller_register() after devm_pm_runtime_enable()
Date: Tue, 30 Jul 2024 17:46:47 +0200
Message-ID: <20240730151745.710533982@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason-JH.Lin <jason-jh.lin@mediatek.com>

[ Upstream commit a8bd68e4329f9a0ad1b878733e0f80be6a971649 ]

When mtk-cmdq unbinds, a WARN_ON message with condition
pm_runtime_get_sync() < 0 occurs.

According to the call tracei below:
  cmdq_mbox_shutdown
  mbox_free_channel
  mbox_controller_unregister
  __devm_mbox_controller_unregister
  ...

The root cause can be deduced to be calling pm_runtime_get_sync() after
calling pm_runtime_disable() as observed below:
1. CMDQ driver uses devm_mbox_controller_register() in cmdq_probe()
   to bind the cmdq device to the mbox_controller, so
   devm_mbox_controller_unregister() will automatically unregister
   the device bound to the mailbox controller when the device-managed
   resource is removed. That means devm_mbox_controller_unregister()
   and cmdq_mbox_shoutdown() will be called after cmdq_remove().
2. CMDQ driver also uses devm_pm_runtime_enable() in cmdq_probe() after
   devm_mbox_controller_register(), so that devm_pm_runtime_disable()
   will be called after cmdq_remove(), but before
   devm_mbox_controller_unregister().

To fix this problem, cmdq_probe() needs to move
devm_mbox_controller_register() after devm_pm_runtime_enable() to make
devm_pm_runtime_disable() be called after
devm_mbox_controller_unregister().

Fixes: 623a6143a845 ("mailbox: mediatek: Add Mediatek CMDQ driver")
Signed-off-by: Jason-JH.Lin <jason-jh.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index 4aa394e91109c..63b5e3fe75281 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -662,12 +662,6 @@ static int cmdq_probe(struct platform_device *pdev)
 		cmdq->mbox.chans[i].con_priv = (void *)&cmdq->thread[i];
 	}
 
-	err = devm_mbox_controller_register(dev, &cmdq->mbox);
-	if (err < 0) {
-		dev_err(dev, "failed to register mailbox: %d\n", err);
-		return err;
-	}
-
 	platform_set_drvdata(pdev, cmdq);
 
 	WARN_ON(clk_bulk_prepare(cmdq->pdata->gce_num, cmdq->clocks));
@@ -695,6 +689,12 @@ static int cmdq_probe(struct platform_device *pdev)
 	pm_runtime_set_autosuspend_delay(dev, CMDQ_MBOX_AUTOSUSPEND_DELAY_MS);
 	pm_runtime_use_autosuspend(dev);
 
+	err = devm_mbox_controller_register(dev, &cmdq->mbox);
+	if (err < 0) {
+		dev_err(dev, "failed to register mailbox: %d\n", err);
+		return err;
+	}
+
 	return 0;
 }
 
-- 
2.43.0



