Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F6431CA57;
	Mon, 18 Aug 2025 13:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522424; cv=none; b=YCeF4KOqNOKHpPeRJVePkvHi2p5Ly7NGjNJs4cD+EQm/lOF4mOPd9CsdrIuveqMXpPL/2WjxqxOXTifhr9thOcfUbZ8UUFZtJQ3/QdJthA6Hl1mmfWWWYw2gra3ppApIsdISwodOQbVeuDPkO1NokIuZKkbTFNWcnWdUuD2imMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522424; c=relaxed/simple;
	bh=oUZgIIX/UEUmMztdsVUMp1tajVy4ISBeiTXPRAa0Ias=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4VW8+pRzhlJTZciZL3LWp56xjgeVBpHFOG+mHxC3/fgbNmIS4UoziiOmxHuxqhl+25z0J9jhSLlbpaOmhT5lrDLpQ9IaWGwpGfaL6hEzpC+ukJatqLMK3GYERvDuX9Gga7OaoHfTEfuBl4lWD2tKJpoPspiDEJ3GCYaTLiyPVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fasTUX09; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fasTUX09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BB2C4CEEB;
	Mon, 18 Aug 2025 13:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522424;
	bh=oUZgIIX/UEUmMztdsVUMp1tajVy4ISBeiTXPRAa0Ias=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fasTUX099rKL0ik3iFFP8vLfxeDEmwNVahE3n5eX1EDdyUaqXIkutSVwJTPXk6IHr
	 uRbILB/HYXPD7XoW9m+rdocZ8g5XdtDM2LoU483qLNAmZJtGvSN6WIMSQshKDgpQCZ
	 wsxiMgQJ/hh7TxxMFUuCvLw2paXCVat/Q/MXkMag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheick Traore <cheick.traore@foss.st.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 312/444] pinctrl: stm32: Manage irq affinity settings
Date: Mon, 18 Aug 2025 14:45:38 +0200
Message-ID: <20250818124500.646191279@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Cheick Traore <cheick.traore@foss.st.com>

[ Upstream commit 4c5cc2f65386e22166ce006efe515c667aa075e4 ]

Trying to set the affinity of the interrupts associated to stm32
pinctrl results in a write error.

Fill struct irq_chip::irq_set_affinity to use the default helper
function.

Signed-off-by: Cheick Traore <cheick.traore@foss.st.com>
Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Link: https://lore.kernel.org/20250610143042.295376-3-antonio.borneo@foss.st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 03f3f707d275..2659a854a514 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -407,6 +407,7 @@ static struct irq_chip stm32_gpio_irq_chip = {
 	.irq_set_wake	= irq_chip_set_wake_parent,
 	.irq_request_resources = stm32_gpio_irq_request_resources,
 	.irq_release_resources = stm32_gpio_irq_release_resources,
+	.irq_set_affinity = IS_ENABLED(CONFIG_SMP) ? irq_chip_set_affinity_parent : NULL,
 };
 
 static int stm32_gpio_domain_translate(struct irq_domain *d,
-- 
2.39.5



