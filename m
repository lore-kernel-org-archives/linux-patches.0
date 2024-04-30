Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A4112C46B;
	Tue, 30 Apr 2024 10:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474157; cv=none; b=EzJaRsm8t+y8zfs8WxmEP2JdD1+Wzs4ikgxAnigRwNEu0KjT59FGGiLspMDZ9d7eO7Vx7mk6/+lZcK0zJ+4Ihr1cdR94CRhAXhRr4j6JSR7XfjPXmc2twYq9+wln19l+2CQaps+aiHIIxDkSa8t4v4/ZWAfdDRZVRN70prZM34M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474157; c=relaxed/simple;
	bh=Nxjq9E3L1jNLtqQG2a2NPDgAUkPJC6Y0r5Ykw+g3Tjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L23zIZaagj3/GqsarngQ7HYchY45cFC3ABSUCvIJ+ZZvHV1u0ER+8mB4BNam/65ghmSNganRyR7nZR97WJrQVgYa7Fvx26aP/zQNjuibatRZboypR/W40IxXiEJ5viucfxDeZ6RyATCTe1mOuXK+gcyzSYbyyBI+HaAtWWVkzWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9W/FWVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9W/FWVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A055C2BBFC;
	Tue, 30 Apr 2024 10:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474157;
	bh=Nxjq9E3L1jNLtqQG2a2NPDgAUkPJC6Y0r5Ykw+g3Tjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9W/FWVrmzMEPA9xEEwZ3df8cnXkFTqDRwHHZ26LVOUd/0HCpV7r8RBEANpL8tT8n
	 6OEEufwhGcyJtLGaOZhQysrLJyCNkR+kpye49vJIbYE+1n/xdz/lsbsRoNpq//yXp5
	 t1YPxJp/nMomLRsQroL5BHqd/7mz86jMj7AhH1+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Shete <pshete@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 074/228] gpio: tegra186: Fix tegra186_gpio_is_accessible() check
Date: Tue, 30 Apr 2024 12:37:32 +0200
Message-ID: <20240430103105.941150666@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prathamesh Shete <pshete@nvidia.com>

[ Upstream commit d806f474a9a7993648a2c70642ee129316d8deff ]

The controller has several register bits describing access control
information for a given GPIO pin. When SCR_SEC_[R|W]EN is unset, it
means we have full read/write access to all the registers for given GPIO
pin. When SCR_SEC[R|W]EN is set, it means we need to further check the
accompanying SCR_SEC_G1[R|W] bit to determine read/write access to all
the registers for given GPIO pin.

This check was previously declaring that a GPIO pin was accessible
only if either of the following conditions were met:

  - SCR_SEC_REN + SCR_SEC_WEN both set

    or

  - SCR_SEC_REN + SCR_SEC_WEN both set and
    SCR_SEC_G1R + SCR_SEC_G1W both set

Update the check to properly handle cases where only one of
SCR_SEC_REN or SCR_SEC_WEN is set.

Fixes: b2b56a163230 ("gpio: tegra186: Check GPIO pin permission before access.")
Signed-off-by: Prathamesh Shete <pshete@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20240424095514.24397-1-pshete@nvidia.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tegra186.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/gpio/gpio-tegra186.c b/drivers/gpio/gpio-tegra186.c
index d87dd06db40d0..9130c691a2dd3 100644
--- a/drivers/gpio/gpio-tegra186.c
+++ b/drivers/gpio/gpio-tegra186.c
@@ -36,12 +36,6 @@
 #define  TEGRA186_GPIO_SCR_SEC_REN		BIT(27)
 #define  TEGRA186_GPIO_SCR_SEC_G1W		BIT(9)
 #define  TEGRA186_GPIO_SCR_SEC_G1R		BIT(1)
-#define  TEGRA186_GPIO_FULL_ACCESS		(TEGRA186_GPIO_SCR_SEC_WEN | \
-						 TEGRA186_GPIO_SCR_SEC_REN | \
-						 TEGRA186_GPIO_SCR_SEC_G1R | \
-						 TEGRA186_GPIO_SCR_SEC_G1W)
-#define  TEGRA186_GPIO_SCR_SEC_ENABLE		(TEGRA186_GPIO_SCR_SEC_WEN | \
-						 TEGRA186_GPIO_SCR_SEC_REN)
 
 /* control registers */
 #define TEGRA186_GPIO_ENABLE_CONFIG 0x00
@@ -177,10 +171,18 @@ static inline bool tegra186_gpio_is_accessible(struct tegra_gpio *gpio, unsigned
 
 	value = __raw_readl(secure + TEGRA186_GPIO_SCR);
 
-	if ((value & TEGRA186_GPIO_SCR_SEC_ENABLE) == 0)
-		return true;
+	/*
+	 * When SCR_SEC_[R|W]EN is unset, then we have full read/write access to all the
+	 * registers for given GPIO pin.
+	 * When SCR_SEC[R|W]EN is set, then there is need to further check the accompanying
+	 * SCR_SEC_G1[R|W] bit to determine read/write access to all the registers for given
+	 * GPIO pin.
+	 */
 
-	if ((value & TEGRA186_GPIO_FULL_ACCESS) == TEGRA186_GPIO_FULL_ACCESS)
+	if (((value & TEGRA186_GPIO_SCR_SEC_REN) == 0 ||
+	     ((value & TEGRA186_GPIO_SCR_SEC_REN) && (value & TEGRA186_GPIO_SCR_SEC_G1R))) &&
+	     ((value & TEGRA186_GPIO_SCR_SEC_WEN) == 0 ||
+	     ((value & TEGRA186_GPIO_SCR_SEC_WEN) && (value & TEGRA186_GPIO_SCR_SEC_G1W))))
 		return true;
 
 	return false;
-- 
2.43.0



