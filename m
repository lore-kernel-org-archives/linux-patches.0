Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BE115E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="baPAIeCl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965A3C433C8;
	Mon, 23 Oct 2023 11:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060485;
	bh=g9Alb47zBr1JvNFFiXXlzeOHwEDZlYS03mMHfBrNMvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=baPAIeClgB9QSxDbBk2jPACMeU/mD9Ze7GZIpag2nq990l0HGxrC5fbDZJ2P8oKt6
	 WmrCptNvT8QgyhmbJKk2E/GQfPRXHRAXFZ8cYqcH9sLySE36sq3cxKxUgAiUrknVx/
	 6hoHDMQkKp2vnrfkMcr3N8Vxi23wlJnqRc3mGMuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 187/196] gpio: vf610: mask the gpio irq in system suspend and support wakeup
Date: Mon, 23 Oct 2023 12:57:32 +0200
Message-ID: <20231023104833.664598890@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 430232619791e7de95191f2cd8ebaa4c380d17d0 ]

Add flag IRQCHIP_MASK_ON_SUSPEND to make sure gpio irq is masked on
suspend, if lack this flag, current irq arctitecture will not mask
the irq, and these unmasked gpio irq will wrongly wakeup the system
even they are not config as wakeup source.

Also add flag IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND to make sure the gpio
irq which is configed as wakeup source can work as expect.

Fixes: 7f2691a19627 ("gpio: vf610: add gpiolib/IRQ chip driver for Vybrid")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-vf610.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index e8e34d648eb2a..314dfaa633857 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -247,7 +247,8 @@ static const struct irq_chip vf610_irqchip = {
 	.irq_unmask = vf610_gpio_irq_unmask,
 	.irq_set_type = vf610_gpio_irq_set_type,
 	.irq_set_wake = vf610_gpio_irq_set_wake,
-	.flags = IRQCHIP_IMMUTABLE,
+	.flags = IRQCHIP_IMMUTABLE | IRQCHIP_MASK_ON_SUSPEND
+			| IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND,
 	GPIOCHIP_IRQ_RESOURCE_HELPERS,
 };
 
-- 
2.42.0



