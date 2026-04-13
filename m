Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81DBD30B53F;
	Mon, 13 Apr 2026 16:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097396; cv=none; b=mEuq/SsoiDLvCXcc+N4Y7jVdE2CXOULl4KGmE+rh19SfA/6ygC+RsJyRFCBuF8tirpz+KOISpGfNTMypLHIgvqY57WqKzVLn96ia9hybIkkAbIvJSlSoL9xOYmppA2ebeY4nFZFuOnjC5cU27fTZQe2yq6Jtg0fn7fg0vDoqDiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097396; c=relaxed/simple;
	bh=ucqcG72Jyn3JE+5OnEDXWSzA68TgYGC94hLGYSe7LVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RoVF1xeTdGDpqqc3fZAmobr/3JPpLZMV52qt8loVKg3DFDCzipuaMerzprKL3d9cmXW/PBmgzNf+QO438e8dbi/+e76MVD5Se0NnPLjryMnvwuPQeCf5MugewblFQF/kkOqBrzlsuMjkPeWZXUc8bp96F1LvN7WV98tBlS3RuUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2Ashg+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2Ashg+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B55BC2BCAF;
	Mon, 13 Apr 2026 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097396;
	bh=ucqcG72Jyn3JE+5OnEDXWSzA68TgYGC94hLGYSe7LVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2Ashg+sUdV+gidgbUdvXjOinaKIacGmHiB0FFr8pmp9ZIc2S17niD4icuWJ66cBe
	 U4EUazh1HC/mDipMEa0RUcOZ3OV1SX9Lp1aUf8Aje3oFeegHBUc+onUSMAgekCwkWo
	 eeHFE7j9cITsJPikO7DDN1AQ/cFWljTBHgcI6+mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 119/570] regulator: pca9450: Correct interrupt type
Date: Mon, 13 Apr 2026 17:54:10 +0200
Message-ID: <20260413155834.900588065@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 5d0efaf47ee90ac60efae790acee3a3ed99ebf80 ]

Kernel warning on i.MX8MP-EVK when doing module test:
irq: type mismatch, failed to map hwirq-3 for gpio@30200000!

Per PCA945[X] specification: The IRQ_B pin is pulled low when any unmasked
interrupt bit status is changed and it is released high once application
processor read INT1 register.

So the interrupt should be configured as IRQF_TRIGGER_LOW, not
IRQF_TRIGGER_FALLING.

Fixes: 0935ff5f1f0a4 ("regulator: pca9450: add pca9450 pmic driver")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://patch.msgid.link/20260310-pca9450-irq-v1-1-36adf52c2c55@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pca9450-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pca9450-regulator.c b/drivers/regulator/pca9450-regulator.c
index 756e4807d27a7..ba629181b0869 100644
--- a/drivers/regulator/pca9450-regulator.c
+++ b/drivers/regulator/pca9450-regulator.c
@@ -773,7 +773,7 @@ static int pca9450_i2c_probe(struct i2c_client *i2c,
 	if (pca9450->irq) {
 		ret = devm_request_threaded_irq(pca9450->dev, pca9450->irq, NULL,
 						pca9450_irq_handler,
-						(IRQF_TRIGGER_FALLING | IRQF_ONESHOT),
+						(IRQF_TRIGGER_LOW | IRQF_ONESHOT),
 						"pca9450-irq", pca9450);
 		if (ret != 0) {
 			dev_err(pca9450->dev, "Failed to request IRQ: %d\n",
-- 
2.51.0



