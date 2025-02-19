Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A7C1C7013;
	Wed, 19 Feb 2025 08:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953828; cv=none; b=FLL+iBLCIqVStYIBecnygIy4XY6RHlpUTpN2xzDDlgEP7huA1RzQdgItIJ/fSi4tw6EHjSWFKIuiDO51om0XljNlOMtcIE3fVkbncCmFo+UwuliDx+phI/ByA9yTBSAUaBsq7tph4LTfnc7wGAiqS2Oo2/zCJMPePBk9/uAH3ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953828; c=relaxed/simple;
	bh=PgB5yqrpeAReGkpKmXQS/0st0k6Z94WCSUZqePdr0QE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFTaJm6XZtMFX4037hiqLB0G+07YJolrOFf8pStNnju7oEeCz449FA/N4SMKYSpddtf75Vn6LQu6ES1U3wvIVMjtaf7ApHPv67GH1+yRdUy5TK1KFRdZJArkG4pBv8Dhskq8lajSeDQEyfQi9aQcK+HThgMjbPKNz2TWYquhLfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqScCagm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqScCagm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79BD0C4CEE6;
	Wed, 19 Feb 2025 08:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953827;
	bh=PgB5yqrpeAReGkpKmXQS/0st0k6Z94WCSUZqePdr0QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqScCagmJhRBkX9q2lPIUE4CcYcx94FIIGhZRuhYu7ZJumPodFG52PYYhggZGT4s5
	 Ba1ZmmW1JRYYa7UZZjflvbfnhsnd7JWFzTC7waM9f4QK/HPReummaTxFjSSPVQ4o1t
	 zc8pZVvQU4epJ3J3Tpgz3DmaSGMefTTvD6krhTuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 011/274] pinctrl: cy8c95x0: Respect IRQ trigger settings from firmware
Date: Wed, 19 Feb 2025 09:24:25 +0100
Message-ID: <20250219082609.979576302@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 1ddee69108d305bbc059cbf31c0b47626796be77 ]

Some of the platforms may connect the INT pin via inversion logic
effectively make the triggering to be active-low.
Remove explicit trigger flag to respect the settings from firmware.

Without this change even idling chip produces spurious interrupts
and kernel disables the line in the result:

  irq 33: nobody cared (try booting with the "irqpoll" option)
  CPU: 0 UID: 0 PID: 125 Comm: irq/33-i2c-INT3 Not tainted 6.12.0-00236-g8b874ed11dae #64
  Hardware name: Intel Corp. QUARK/Galileo, BIOS 0x01000900 01/01/2014
  ...
  handlers:
  [<86e86bea>] irq_default_primary_handler threaded [<d153e44a>] cy8c95x0_irq_handler [pinctrl_cy8c95x0]
  Disabling IRQ #33

Fixes: e6cbbe42944d ("pinctrl: Add Cypress cy8c95x0 support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/20250117142304.596106-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-cy8c95x0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-cy8c95x0.c b/drivers/pinctrl/pinctrl-cy8c95x0.c
index 75100a9fb8e4c..d73004b4a45e7 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -1355,7 +1355,7 @@ static int cy8c95x0_irq_setup(struct cy8c95x0_pinctrl *chip, int irq)
 
 	ret = devm_request_threaded_irq(chip->dev, irq,
 					NULL, cy8c95x0_irq_handler,
-					IRQF_ONESHOT | IRQF_SHARED | IRQF_TRIGGER_HIGH,
+					IRQF_ONESHOT | IRQF_SHARED,
 					dev_name(chip->dev), chip);
 	if (ret) {
 		dev_err(chip->dev, "failed to request irq %d\n", irq);
-- 
2.39.5



