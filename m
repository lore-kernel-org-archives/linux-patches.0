Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFBC1E6DFF;
	Mon, 21 Oct 2024 10:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507165; cv=none; b=d5cRcDkP5UBwUluH7CrIr3j8QyGJOI59XCnNxkv6+Ob/gWBSm+7th2BtekiY/Pt+9dC1F5c/fVRMD+4szZUrwhUtQfo+ps2ByRR7e42x7fVkvq/98Dkxeevi6gOqw+ZJGmVNqV7EGI3M+9cIkC2oQFisuJazSH4KvIqNqhJhQlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507165; c=relaxed/simple;
	bh=favt9dLQJO5oU7OxCYMrYe4shXCzLH/yINcajU+dAgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxOlFJiREhyBnXG2PVHMefHfiHXqEY1XUev1PJ2GmCTQm4HL0Napb5rio0+C8umAjB7KN9B7vmXfJ/AKJr8velvgekWkzoTV0FfziwsgyXwnBb+LhsB7rCunlWz01qildOsDxDecBW9mhsciiXSWY3kEhFfFpw7IPKnhmrvi3AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CfXWbyIv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CfXWbyIv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30700C4CEC7;
	Mon, 21 Oct 2024 10:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507165;
	bh=favt9dLQJO5oU7OxCYMrYe4shXCzLH/yINcajU+dAgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CfXWbyIvQGkrP6qESkgDdV0cxhvshOSniQkaStv20zreECmfziHSYgM1RRMaRKoaL
	 yWDQ7/HG9izDbwpWNm98kaSefcSWBErURNXJpUTKtaMj9s0aG97sl0PErX7kIs66xU
	 IpsanRiy+X9sxETLSUJ9aRfEcdShSRKajxHUHeUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.6 111/124] pinctrl: stm32: check devm_kasprintf() returned value
Date: Mon, 21 Oct 2024 12:25:15 +0200
Message-ID: <20241021102301.011529905@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

From: Ma Ke <make24@iscas.ac.cn>

commit b0f0e3f0552a566def55c844b0d44250c58e4df6 upstream.

devm_kasprintf() can return a NULL pointer on failure but this returned
value is not checked. Fix this lack and check the returned value.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 32c170ff15b0 ("pinctrl: stm32: set default gpio line names using pin names")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://lore.kernel.org/20240906100326.624445-1-make24@iscas.ac.cn
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1387,10 +1387,15 @@ static int stm32_gpiolib_register_bank(s
 
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


