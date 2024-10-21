Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959AC1E7C36;
	Mon, 21 Oct 2024 10:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507168; cv=none; b=dSHroF7Ad4+iEY9qWaOKRYj/NPg5Ouhbiz4xZOOy22+oPgjMP6CX/Dd2t0xIGCRCWuUCM9J+WQgx0y18b844NG9de6ZsYiqjIwkqST8fNYl4cw+6KGZyNOT9VyU++HnNJTLZF49edNTTRs6RAVPk+8MQJ6vvFvOVbFkP2sI/ivY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507168; c=relaxed/simple;
	bh=R6GlN8re+345BfbpaT/gU4oN1JE8KtHKpumZEiULK2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q9O/fpnt/GFQ57UpMssrqw6WNKR0Xg6QGMHwmZjwzSVOdDUJJpcM2XoZTpB2TiOWoibWwOeaBdgo1porpBDWu1W3RqhrhQp3vOgXEI4mj9U4gfdKTjRtUwhrRSnMbtag4XBWlnJtOkG66jlBXas5oH2knUo/s5xMIJuIzaVtTZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omPugwfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omPugwfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19510C4AF0E;
	Mon, 21 Oct 2024 10:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507168;
	bh=R6GlN8re+345BfbpaT/gU4oN1JE8KtHKpumZEiULK2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omPugwfdlaXLLbxjRc4U+1KvNxCm/SAObr75kxeZdD4TuFQf6iUWD/n62XuFkldH2
	 48Viy7NwTv8lbzXfF7d1d2s7ra5I8Fx9bSAZblMi9yV4xCC+CGwoK59rpJSbUwovEn
	 XMXoQuKcYMZUkPXjcqiyrPEsEX6x9AUxc5Ur/AnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.6 112/124] pinctrl: apple: check devm_kasprintf() returned value
Date: Mon, 21 Oct 2024 12:25:16 +0200
Message-ID: <20241021102301.049201104@linuxfoundation.org>
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

commit 665a58fe663ac7a9ea618dc0b29881649324b116 upstream.

devm_kasprintf() can return a NULL pointer on failure but this returned
value is not checked. Fix this lack and check the returned value.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: a0f160ffcb83 ("pinctrl: add pinctrl/GPIO driver for Apple SoCs")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/20240905020917.356534-1-make24@iscas.ac.cn
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/pinctrl-apple-gpio.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pinctrl/pinctrl-apple-gpio.c
+++ b/drivers/pinctrl/pinctrl-apple-gpio.c
@@ -474,6 +474,9 @@ static int apple_gpio_pinctrl_probe(stru
 	for (i = 0; i < npins; i++) {
 		pins[i].number = i;
 		pins[i].name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "PIN%u", i);
+		if (!pins[i].name)
+			return -ENOMEM;
+
 		pins[i].drv_data = pctl;
 		pin_names[i] = pins[i].name;
 		pin_nums[i] = i;


