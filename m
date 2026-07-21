Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC639322DB7;
	Tue, 21 Jul 2026 17:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653400; cv=none; b=UUT4p1BqrEEAxQnVonrxHlNytVbBFKhfFY4h/eA70ZmPhz0VEfNffJJhUY0KtEAMaM8fikVXSqTlDjOH2VOMNlakzLK06PXRy6mg21WqwytPtOSk7DA7/ndRuYoYhn6ZZtbXAsj1B0tJaOuP/qEOVJMEm9XeAjRvJvx9ZIpH3rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653400; c=relaxed/simple;
	bh=JFOVMoANZLBDzWXXRIzhujQji7rScsZaA52sNOKqWcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifsZYDHcqcDUSJLdle4l1jYAydwGdNs/dJ9PpDbMUMq39haGgaoO0kdeWudzXAJdsGz7fGgn+G1I5jrq7UNy7b3bbfBK+YAvLKoaUNdAOcgQsGjHTTAwMqwL9imCzRCiqxVJSMwfEY7yY4u9driitZ7I1LtpKM7LOIG5l4p8dwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GNirmV8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GNirmV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAD61F000E9;
	Tue, 21 Jul 2026 17:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653398;
	bh=XRdGTPg6VJ5fbVoBglQVaxNycUWhyK8eHLlvJIZafIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0GNirmV8lUyiKo7icDPMtssyWcybB5rrEcs0k343datRp3LYoci/sDxD2qTOWKvLi
	 XpiMghSWNaASyt8QC/K3LTb+3Z2rB/ZMZ57jNQ1kLaPMk+E/jX9CgIDW4kL+FE/arJ
	 mS8XUIJhp9uveNLOy8ARaYk0iUMlaok7chqZesWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1312/2077] gpio: mvebu: fail probe if gpiochip registration fails
Date: Tue, 21 Jul 2026 17:16:25 +0200
Message-ID: <20260721152623.766562546@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 479e91fc92416a4d54d2b3150aa1e4550d9cc759 ]

mvebu_gpio_probe() registers the GPIO chip with
devm_gpiochip_add_data() but ignores the return value. If registration
fails, probe continues and leaves later code operating on a GPIO chip
that was never published to gpiolib.

Return the registration error so the device fails probe cleanly.

Fixes: fefe7b092345 ("gpio: introduce gpio-mvebu driver for Marvell SoCs")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260624131645.86884-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index c030d1f00abcae..689dc6354c2d78 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1221,7 +1221,10 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 		BUG();
 	}
 
-	devm_gpiochip_add_data(&pdev->dev, &mvchip->chip, mvchip);
+	err = devm_gpiochip_add_data(&pdev->dev, &mvchip->chip, mvchip);
+	if (err)
+		return dev_err_probe(&pdev->dev, err,
+				     "failed to register gpiochip\n");
 
 	/* Some MVEBU SoCs have simple PWM support for GPIO lines */
 	if (IS_REACHABLE(CONFIG_PWM)) {
-- 
2.53.0



