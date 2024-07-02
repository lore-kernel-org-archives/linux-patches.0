Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D301BD002;
	Tue,  2 Jul 2024 17:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940327; cv=none; b=mJYC1YlXw0SyEilhUudlLid0vav1fjTGGwUrSkSlpjRnsjtak6kWTVuXkr1w8hIbYtRoM04m17UyvvumnStMiXieO6dkgHneBB6ppAZsFtrHGI2PiuqUmaIyVfY1jx6UKGN8dJE8ntUEqR4vV+K8JYZcEZW9ylqi9cpRi/MI4Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940327; c=relaxed/simple;
	bh=ghxwVPj3pWKrA3pHlLW1JMK5ekvKcEN7DmJ0dAT5Tao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iM+m1pRZbFShMQuH2eRWH1G7Myob7f7ern67XHA+Yblwr2XwUepDv5C074XoDdR6uwdeqr0uzq16YI2RUFvanZBjZPIanh5mYSeKOHEf7GeYlEeTLQkQO2G9W/1i3cwJIkgcFWh900AIc0luMYfNHGQk5Q4Aq6OiZZSCHTFtPMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIaDb8b0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIaDb8b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D44C4AF0A;
	Tue,  2 Jul 2024 17:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940327;
	bh=ghxwVPj3pWKrA3pHlLW1JMK5ekvKcEN7DmJ0dAT5Tao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIaDb8b0E9tbbagHStbWT4iWQ/NnjnmvOpfGDRsicmM5rd7FywURhJnOS2K1nOZET
	 kwDk3WVWRopEJzqmFyuweSm3meMn2CvUwWRu2EJhoYMWjbfNiEVgCl+GIfkxWS/bUf
	 SlLduCRbdeMF0fMFDcdPyHVUfbbXKwT5tsN6t4dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.9 114/222] pinctrl: qcom: spmi-gpio: drop broken pm8008 support
Date: Tue,  2 Jul 2024 19:02:32 +0200
Message-ID: <20240702170248.326065604@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 8da86499d4cd125a9561f9cd1de7fba99b0aecbf upstream.

The SPMI GPIO driver assumes that the parent device is an SPMI device
and accesses random data when backcasting the parent struct device
pointer for non-SPMI devices.

Fortunately this does not seem to cause any issues currently when the
parent device is an I2C client like the PM8008, but this could change if
the structures are reorganised (e.g. using structure randomisation).

Notably the interrupt implementation is also broken for non-SPMI devices.

Also note that the two GPIO pins on PM8008 are used for interrupts and
reset so their practical use should be limited.

Drop the broken GPIO support for PM8008 for now.

Fixes: ea119e5a482a ("pinctrl: qcom-pmic-gpio: Add support for pm8008")
Cc: stable@vger.kernel.org	# 5.13
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240529162958.18081-9-johan+linaro@kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
@@ -1206,7 +1206,6 @@ static const struct of_device_id pmic_gp
 	{ .compatible = "qcom,pm7325-gpio", .data = (void *) 10 },
 	{ .compatible = "qcom,pm7550ba-gpio", .data = (void *) 8},
 	{ .compatible = "qcom,pm8005-gpio", .data = (void *) 4 },
-	{ .compatible = "qcom,pm8008-gpio", .data = (void *) 2 },
 	{ .compatible = "qcom,pm8019-gpio", .data = (void *) 6 },
 	/* pm8150 has 10 GPIOs with holes on 2, 5, 7 and 8 */
 	{ .compatible = "qcom,pm8150-gpio", .data = (void *) 10 },


