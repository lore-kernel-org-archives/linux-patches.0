Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9041E1FECBE;
	Wed, 19 Feb 2025 08:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954764; cv=none; b=DmNgqfGnuNWBGtV1Zs9RIqrq0VezfNrD4WNS9o/jNjf2rGJ10F9EkXrwF0jnFEPCH1lfiUBK/FAEt3Tct3QrCyn69ne+9xRwjlMg2bjzfUnp06j2Re4rufDMxlniuy857IdhuHOxDJRrhqKkC3Y5YypHNNJ8LiA9BeuqV7LnCEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954764; c=relaxed/simple;
	bh=KjNsuu+QQy2UzEpmhy6po8RBko1hnzk+g3tqqaZ6fyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MqpyYi+49mYUK42yaiyLi4gI4P9+BpKzGkO1DCUqzVI/Z4cGeGnoXcN54NCZJkqDMT5l0K1UCckrdqSYooLqSf+2EXTUWi3wn5oYZ96a238hbEfSqu9UnU7udJXe8ZNBoQYMHT8BRZyovZNeEH+T0La87g0Um1i+cQIzfDCNLX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfjMa9qS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfjMa9qS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4708C4CED1;
	Wed, 19 Feb 2025 08:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954764;
	bh=KjNsuu+QQy2UzEpmhy6po8RBko1hnzk+g3tqqaZ6fyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfjMa9qS5eIBwdQTqTSRy+pDVOatoXoQ/Q1dGSgFOlTHCZhuF0HcSPyrJ3AdXXk5z
	 c8xR88nDAnzASko+UpHkCYRxGq4deGrx87dPWHOyyMFtktgD8NNwa7wQS6gEx5FBsd
	 VPcMH/+os0X6dSL80odkkBCtANAiAqmn8cTewpWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/230] pinctrl: cy8c95x0: Respect IRQ trigger settings from firmware
Date: Wed, 19 Feb 2025 09:25:25 +0100
Message-ID: <20250219082602.023620805@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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
index 8e65797192abc..7a6a1434ae7f4 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -1373,7 +1373,7 @@ static int cy8c95x0_irq_setup(struct cy8c95x0_pinctrl *chip, int irq)
 
 	ret = devm_request_threaded_irq(chip->dev, irq,
 					NULL, cy8c95x0_irq_handler,
-					IRQF_ONESHOT | IRQF_SHARED | IRQF_TRIGGER_HIGH,
+					IRQF_ONESHOT | IRQF_SHARED,
 					dev_name(chip->dev), chip);
 	if (ret) {
 		dev_err(chip->dev, "failed to request irq %d\n", irq);
-- 
2.39.5



