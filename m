Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6326D1774B;
	Thu, 18 Jan 2024 11:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575704; cv=none; b=h3pXqr6pAV2v/fJc8atCXgrXPoWYdBU7DqaxDiWrDyL89nkH08gERNw59OxFvToLKmcnFOjFvqQFPWZSjbeT/bJctKMwW/hxq3TOV6fOp9+vz48yl8u/oN2ranGbjlgj7w0wr2x2+DCTVxtQH83cvoGa5OU2MzDBcAmmrb4Nj4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575704; c=relaxed/simple;
	bh=gHUQ/oF0m5GJ2z7vNe5cuMlkYnY6Hi3t4EqnftT3dKY=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=WsXL0Zvlz40ds37C/o6JmewEmto0wVZ7k/ei2Rn9IbEXG7z0aPEabOftmsU9WYHJvaPaOkQaMsUnz6PuaCnD0h+fDB71EQs+0Oi8c9OnipncCq8L4us5+0kAYKPyGY2OwdybjcRXeEjeIo2mJOzKdu4qQysTcEg2JLP2Odq7B8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDcvkrpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDcvkrpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89FBC433F1;
	Thu, 18 Jan 2024 11:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575704;
	bh=gHUQ/oF0m5GJ2z7vNe5cuMlkYnY6Hi3t4EqnftT3dKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDcvkrpfp5RhhgwFh2Nyd/4TH6ezeFWfIrROWUi/GYGyEe9F0S0qXCb8ONphOUsW9
	 GdiKDOJnjTnPlYDPtAapIh/H3E4GWWyiNL9RrVyXH9/gC9jWENrsXmaP6WC1GcDxS6
	 QtV6JAjFuxlb/sc05yOIe8nELCVDUpJUSfjGrQ0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Rudolph <patrick.rudolph@9elements.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/100] pinctrl: cy8c95x0: Fix get_pincfg
Date: Thu, 18 Jan 2024 11:49:24 +0100
Message-ID: <20240118104314.211957789@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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
index 99c3fe4ca518..5abab6bc763a 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -749,6 +749,8 @@ static int cy8c95x0_gpio_get_pincfg(struct cy8c95x0_pinctrl *chip,
 	ret = regmap_read(chip->regmap, reg, &reg_val);
 	if (reg_val & bit)
 		arg = 1;
+	if (param == PIN_CONFIG_OUTPUT_ENABLE)
+		arg = !arg;
 
 	*config = pinconf_to_config_packed(param, (u16)arg);
 out:
-- 
2.43.0



