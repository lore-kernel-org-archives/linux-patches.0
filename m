Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F6B1E9081;
	Mon, 21 Oct 2024 10:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506797; cv=none; b=cPIn+YkYz+qup4VNMFmHqWFv4l85BFszZExWwNoU1Ct+iuzysFtEBbe77P0BFR/owAIwpivClzbdKqzabUbFMU7wxzMmKW07TXApfdZsiKobZ+WnL83G5xcd6B1RY9fE+nZL/lu4kf/N58lMS8/NA7SiLc4c/A2CkD9gfLpvTO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506797; c=relaxed/simple;
	bh=yDt+2hAXwCWjUVuI6BzqmSUUv9JQn9jMTQh4yZA9Qqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kg9+uw+KA4e7fSr9kR3AozejCQV0aObaf1jCPXWIs9MiBQYiak62uvXd03xEI3jjZ32e01riAQ0TbcvqyaOg4p196puGVu3TbGGfVt+Ecz8KJQLe296GUZLU73j2QLyadOOYQuPCNSEtTWH970cahjV7gGHE/UzmA3twesFcdAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuL2stc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuL2stc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF10C4CEEF;
	Mon, 21 Oct 2024 10:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506796;
	bh=yDt+2hAXwCWjUVuI6BzqmSUUv9JQn9jMTQh4yZA9Qqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uuL2stc+f//yU9im5Q7Rrwq/A5feIs1spR41MeeBxsJFdseVOSu4t4fjeEBKdwj96
	 zuA6bhTIKg17ORaHcOM/4Y/tNQvp9YfBgqpMq41S9Vl8cAlSt4SGLsKJUheCaHytE7
	 qM86MdHRWbVcj4yLs9HwofZfYQDJuh9alXDYXBxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.11 124/135] pinctrl: stm32: check devm_kasprintf() returned value
Date: Mon, 21 Oct 2024 12:24:40 +0200
Message-ID: <20241021102304.184189327@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1374,10 +1374,15 @@ static int stm32_gpiolib_register_bank(s
 
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


