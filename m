Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BE122323;
	Thu, 18 Jan 2024 10:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575399; cv=none; b=YaG/KaOPUFQLwyzGsKEgH8c8El/ZKE5l+mp+mkoToMct+zXx4XyfT/9bVSnNtJfalJJOB1+dujlpc2pcJBrBJXpCUI9Ul34b+tsBsJgVE79XFPYcseUvTSA+3jVnIsWKkscSpKHSJ0oAdHAyi9hxLQqsEDYkKfT6UVmPpBPqMEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575399; c=relaxed/simple;
	bh=PJfUgCc1J+BwqmR2z8uLESbMNpucDplY3B0HQQx+7L4=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=ETI9JjGNhjbguSzRNrAXKlLur5lc9c+IPZXTNVUBG5inHXSTHpXkmnONncn771ClVD9d29EjTiKwinpBMhKkXGcgpkvY+3cizDX7H8WjYxcv93wtBYkyChJRJjyGwHCINlGL38J3G+IaWHefh9xwJoLzhWzMGG/ng9/3DSeBDq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IDzkn2Pt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IDzkn2Pt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B82C433F1;
	Thu, 18 Jan 2024 10:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575399;
	bh=PJfUgCc1J+BwqmR2z8uLESbMNpucDplY3B0HQQx+7L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IDzkn2PtA6rIS9dEzGcOGmPn9vGWAb/wnFBXfYYkKf+bBGosiVpEFwJwO8OOm/XwH
	 i2j1Vfgq0j5+Fu1uyIg2YY+Ho84HoZLyTzGx34DuMTNLGACGdttR8hx718l1a623IU
	 u3K4MotVQ38zuG2NQbiXWp0AsEycWTmEJacSW2hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Rudolph <patrick.rudolph@9elements.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/150] pinctrl: cy8c95x0: Fix get_pincfg
Date: Thu, 18 Jan 2024 11:49:00 +0100
Message-ID: <20240118104325.522900975@linuxfoundation.org>
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

From: Patrick Rudolph <patrick.rudolph@9elements.com>

[ Upstream commit 94c71705cc49092cef60ece13a28680809096fd4 ]

Invert the register value for PIN_CONFIG_OUTPUT_ENABLE to return
the opposite of PIN_CONFIG_INPUT_ENABLE.

Signed-off-by: Patrick Rudolph <patrick.rudolph@9elements.com>
Link: https://lore.kernel.org/r/20231219125120.4028862-3-patrick.rudolph@9elements.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-cy8c95x0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-cy8c95x0.c b/drivers/pinctrl/pinctrl-cy8c95x0.c
index 280d7ebd50b7..f2b9db66fdb6 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -714,6 +714,8 @@ static int cy8c95x0_gpio_get_pincfg(struct cy8c95x0_pinctrl *chip,
 	ret = regmap_read(chip->regmap, reg, &reg_val);
 	if (reg_val & bit)
 		arg = 1;
+	if (param == PIN_CONFIG_OUTPUT_ENABLE)
+		arg = !arg;
 
 	*config = pinconf_to_config_packed(param, (u16)arg);
 out:
-- 
2.43.0



