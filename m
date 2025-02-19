Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842191DF75A;
	Wed, 19 Feb 2025 09:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956269; cv=none; b=lLxi2+HKy4ynj+do2axoyVeSDan76hfcPDQZ0Tt8e8KUZVVyuPR9SJ0426HlbenLHLSQW16bAXgoRzZ3j3avB1i/+Rl2CkeWi/VSweyY+ZaMQZEWl7oiaQ82V512NRijlIjNNgI7II4vUEhFE0RbdQtpX5bD5+FBZKd7nQzsbSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956269; c=relaxed/simple;
	bh=9XiBYLDfR5nFYXkpWugJBFh0Dls4BxPFS6gskZwGK+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ff8+tNTSvOkyLIMForlWu4h4e/Y1Xr6Nr/ZacY+vrD6PwMRvOSpWmFbtoxw8nLTxns/SlDj2xfuYvKZFNtzttaSQDitE6AyRtUISYb2vhyi1SGAajIa+IzPxH9tdAOGqsKkhMVY1FbVxXIYJDy58HDzEOddzt+nJUkrr0SibYi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sd2IlLLH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sd2IlLLH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B75C4CED1;
	Wed, 19 Feb 2025 09:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956269;
	bh=9XiBYLDfR5nFYXkpWugJBFh0Dls4BxPFS6gskZwGK+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sd2IlLLHaLuLpECJJqczcj9eLW04r7njPwiTF7IGqNxu7ReJGskgahgI0pyESHHE/
	 COoO5TacYh30Ub2gVkS1RCMcnOnCtvxS1EJbEXlHAMeoOPXky9TdOTFomSZxF2GoqV
	 vIL8sWByAqPu+DzXjU9gOhsRMssWj4cJGQ1t6cVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/578] pinctrl: stm32: check devm_kasprintf() returned value
Date: Wed, 19 Feb 2025 09:22:07 +0100
Message-ID: <20250219082657.824728316@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit b0f0e3f0552a566def55c844b0d44250c58e4df6 ]

devm_kasprintf() can return a NULL pointer on failure but this returned
value is not checked. Fix this lack and check the returned value.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 32c170ff15b0 ("pinctrl: stm32: set default gpio line names using pin names")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://lore.kernel.org/20240906100326.624445-1-make24@iscas.ac.cn
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 451bc9aea9a1 ("pinctrl: stm32: Add check for clk_enable()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 7599c66abdf06..755dcf1fa767e 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1384,10 +1384,15 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl, struct fwnode
 
 	for (i = 0; i < npins; i++) {
 		stm32_pin = stm32_pctrl_get_desc_pin_from_gpio(pctl, bank, i);
-		if (stm32_pin && stm32_pin->pin.name)
+		if (stm32_pin && stm32_pin->pin.name) {
 			names[i] = devm_kasprintf(dev, GFP_KERNEL, "%s", stm32_pin->pin.name);
-		else
+			if (!names[i]) {
+				err = -ENOMEM;
+				goto err_clk;
+			}
+		} else {
 			names[i] = NULL;
+		}
 	}
 
 	bank->gpio_chip.names = (const char * const *)names;
-- 
2.39.5



