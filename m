Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEA51E5020;
	Mon, 21 Oct 2024 10:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506800; cv=none; b=nkHImsUI1gs4a+mli0gOqEAMkTX4d0Yc8qyumDnUj3QuEE2+CpYyvQYR50U5C83lE8TnM61Wp5SVlSIDOieZPgkCnglBjdrqg4MAxu7Nxk5jrzbbmRsZZgeTU7xgDwJu4itI2w3MgXUYT1/pvbMvBVt2C38kTU77RvlR1DJCqzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506800; c=relaxed/simple;
	bh=96ZPD/Bp4o+NEDy9+amBMoWuUDK2oztbEFaqThh+Ic8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEBn+sK5C1Wlf5pNYbsNDv0p3A8plhaHYoFgCiLpKxk6hxhzvqsjIKf6f1yruEEAHEDu8u/Jp3uFCoy6d1upTr1p/knYxpQKhXjQqtpPtl/wEaw6OPujTZFyOyKxgO8S241o5CWoM8DMV9lhU4zkahPWU16TllgG7Iff+RJC1YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a673/qg7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a673/qg7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6B1C4CEEB;
	Mon, 21 Oct 2024 10:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506800;
	bh=96ZPD/Bp4o+NEDy9+amBMoWuUDK2oztbEFaqThh+Ic8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a673/qg7N6Xd9vLeid60srsVm4SgwMcxfWuziCQ9vJVUpyHJO7uTaccl2FIEHOLWc
	 G/4PWycxYEZWULCLws6PPkGqMw1iJfqRaMhKPHQImG3nAYqYFxOTvDeJ8I1wtpnsWd
	 C1Zzeyh+nX4KYhcWNcatUBIcnAE6KeO4/t8J+oHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.11 125/135] pinctrl: apple: check devm_kasprintf() returned value
Date: Mon, 21 Oct 2024 12:24:41 +0200
Message-ID: <20241021102304.223279387@linuxfoundation.org>
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


