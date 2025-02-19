Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550C91BD9DE;
	Wed, 19 Feb 2025 08:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955502; cv=none; b=qEqGTOzYw/RnG0R1+JqInv8ZLdTAA9YtzQQv2g2bM5Znb5nKLqfeEnAu2av4txbfWZ+M2ijAtJJa3qmijy688Lre+JOV5XSoR2bQfrXg/5VIHmyADp9RcrfYK761sk9P5zpkDVOdlC7tCk1h/d+RG6ekT9qOjxEP8xT43Ndf6bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955502; c=relaxed/simple;
	bh=Nq9vycatZHDnb1k7kfhd4/+/xt0Nnyjw9PixoKUCCZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBArPxU0s6YuEiH1SpkI4LOywJNQolDkvmtjVVLa9gJjTQwLgelxwvxj7JfBX5YdNgknepP+vfkRos/IaSaT0ruzcVe8JRglDpgK3MNQK90uZp4ckQQ4V4IO0C1WnDBlkr9DttYU3vF7L2mbwiC5K375mK/JMg0BSZW5L+mpE9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AfEgf+pS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AfEgf+pS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64D5C4CED1;
	Wed, 19 Feb 2025 08:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955502;
	bh=Nq9vycatZHDnb1k7kfhd4/+/xt0Nnyjw9PixoKUCCZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfEgf+pSsVSwyzbBB5COyTSZpZ6XboKRMI2Ho4udRz2S9EGXVqwdPftaIMdlUd8zP
	 Rsc7grC9Vr3LOPfdpMtAT+zliZJccdo9H9vsS3y0gwqlIVCN0aEghiVEEov5EIiIs7
	 7Lh2XQxe3v3qo1jIH0IbH82wezbwogI8EfxLi1rU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/152] pinctrl: cy8c95x0: Respect IRQ trigger settings from firmware
Date: Wed, 19 Feb 2025 09:26:56 +0100
Message-ID: <20250219082550.158047466@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f2b9db66fdb6a..d2488d80912c9 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -1281,7 +1281,7 @@ static int cy8c95x0_irq_setup(struct cy8c95x0_pinctrl *chip, int irq)
 
 	ret = devm_request_threaded_irq(chip->dev, irq,
 					NULL, cy8c95x0_irq_handler,
-					IRQF_ONESHOT | IRQF_SHARED | IRQF_TRIGGER_HIGH,
+					IRQF_ONESHOT | IRQF_SHARED,
 					dev_name(chip->dev), chip);
 	if (ret) {
 		dev_err(chip->dev, "failed to request irq %d\n", irq);
-- 
2.39.5



