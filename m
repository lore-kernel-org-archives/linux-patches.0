Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F24C1774B;
	Thu, 18 Jan 2024 10:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575321; cv=none; b=rZ9OXPfXniAVxPO4/LBug00fNJEsmFuJnqwaRcSPZ7hFyf7Jgk318qqqhebcqj4qt+QGmsoL4yPuuWTMJLIQotEb+60pb4txCugyUoB1j2TMulznfMwfgqsSnY72LR5ki4Z+LtrenOfpapbeZD393yS6IFJWSNibjmuxK6Qlabk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575321; c=relaxed/simple;
	bh=noLTKSOU0B6mhyxM5GivMUP74dS5BvE3Gmch5ommtAY=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=tHjET4KxFP0v86NhF5zqTV1w7Q6JWwgzVKot5ljUgiLiq+mP5wNrNwF32tRNoD8bFEog1uu81QafSn1SBHKsUwJGH6zhBQ3SsxiW5qxFKdkI3l+WKJqgzW7jw4qzHwf1E7HDpBMYVGlsb+OcLJH6BOfTBysMbesGXbF1roxZ/ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKU/z+Xk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKU/z+Xk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFCAC433C7;
	Thu, 18 Jan 2024 10:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575321;
	bh=noLTKSOU0B6mhyxM5GivMUP74dS5BvE3Gmch5ommtAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKU/z+Xk3/bMpsr+cUx6OiU2XQtOUA5h4dg/PlrBmwKCyTbylFPj0q5CX9FLpGNWI
	 iG3wu8LwH+x5zpQ4v8s0yerr+rYYvHs6NaplZN1TqVaWrtzWPanK22Q43SkY7M6rb2
	 SDK9jbm2TIinZ2Egh2jlT1oMcMEaZU2wvuAH5BmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Marcus Aram <marcus+oss@oxar.nl>,
	Mark Herbert <mark.herbert42@gmail.com>
Subject: [PATCH 6.6 089/150] pinctrl: amd: Mask non-wake source pins with interrupt enabled at suspend
Date: Thu, 18 Jan 2024 11:48:31 +0100
Message-ID: <20240118104324.076721447@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 2fff0b5e1a6b9c577b4dd4958902c877159c856b ]

If a pin isn't marked as a wake source processing any interrupts is
just going to destroy battery life.  The APU may wake up from a hardware
sleep state to process the interrupt but not return control to the OS.

Mask interrupt for all non-wake source pins at suspend. They'll be
re-enabled at resume.

Reported-and-tested-by: Marcus Aram <marcus+oss@oxar.nl>
Reported-and-tested-by: Mark Herbert <mark.herbert42@gmail.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2812
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20231203032431.30277-3-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-amd.c | 9 +++++++++
 drivers/pinctrl/pinctrl-amd.h | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 74241b2ff21e..86034c457c04 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -923,6 +923,15 @@ static int amd_gpio_suspend(struct device *dev)
 
 		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 		gpio_dev->saved_regs[i] = readl(gpio_dev->base + pin * 4) & ~PIN_IRQ_PENDING;
+
+		/* mask any interrupts not intended to be a wake source */
+		if (!(gpio_dev->saved_regs[i] & WAKE_SOURCE)) {
+			writel(gpio_dev->saved_regs[i] & ~BIT(INTERRUPT_MASK_OFF),
+			       gpio_dev->base + pin * 4);
+			pm_pr_dbg("Disabling GPIO #%d interrupt for suspend.\n",
+				  pin);
+		}
+
 		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
 	}
 
diff --git a/drivers/pinctrl/pinctrl-amd.h b/drivers/pinctrl/pinctrl-amd.h
index 34c5c3e71fb2..cf59089f2776 100644
--- a/drivers/pinctrl/pinctrl-amd.h
+++ b/drivers/pinctrl/pinctrl-amd.h
@@ -80,6 +80,11 @@
 #define FUNCTION_MASK		GENMASK(1, 0)
 #define FUNCTION_INVALID	GENMASK(7, 0)
 
+#define WAKE_SOURCE	(BIT(WAKE_CNTRL_OFF_S0I3) | \
+			 BIT(WAKE_CNTRL_OFF_S3)   | \
+			 BIT(WAKE_CNTRL_OFF_S4)   | \
+			 BIT(WAKECNTRL_Z_OFF))
+
 struct amd_function {
 	const char *name;
 	const char * const groups[NSELECTS];
-- 
2.43.0



