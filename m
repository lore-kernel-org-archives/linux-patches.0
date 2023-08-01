Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFC96AAD
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6B5C433C9;
	Tue,  1 Aug 2023 09:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882185;
	bh=q1hYGR0jJ/OuvYz1wD4cfBq35LF9jS0vb5wek+lMblQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEKRbygePK179opbu0URSMC8o6VPyqcJDQcexnPF+X7uWXyjm49qcTWWWhNLWVCUO
	 ThDsBaeuFyqEMse6ygkkJIq2xSRg8A18iuekjycOnS16wiXphuyDTZ/e+S2nL16J6y
	 x2dsR1v/d7WjuG+pHuoxVtPpe8hD1W+Dx7RN+KWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/228] gpio: mvebu: fix irq domain leak
Date: Tue,  1 Aug 2023 11:17:54 +0200
Message-ID: <20230801091923.432652312@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 644ee70267a934be27370f9aa618b29af7290544 ]

Uwe Kleine-König pointed out we still have one resource leak in the mvebu
driver triggered on driver detach. Let's address it with a custom devm
action.

Fixes: 812d47889a8e ("gpio/mvebu: Use irq_domain_add_linear")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mvebu.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-mvebu.c b/drivers/gpio/gpio-mvebu.c
index f86b6c3bc1604..0ba9d04183a60 100644
--- a/drivers/gpio/gpio-mvebu.c
+++ b/drivers/gpio/gpio-mvebu.c
@@ -1112,6 +1112,13 @@ static int mvebu_gpio_probe_syscon(struct platform_device *pdev,
 	return 0;
 }
 
+static void mvebu_gpio_remove_irq_domain(void *data)
+{
+	struct irq_domain *domain = data;
+
+	irq_domain_remove(domain);
+}
+
 static int mvebu_gpio_probe(struct platform_device *pdev)
 {
 	struct mvebu_gpio_chip *mvchip;
@@ -1246,13 +1253,18 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	err = devm_add_action_or_reset(&pdev->dev, mvebu_gpio_remove_irq_domain,
+				       mvchip->domain);
+	if (err)
+		return err;
+
 	err = irq_alloc_domain_generic_chips(
 	    mvchip->domain, ngpios, 2, np->name, handle_level_irq,
 	    IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_LEVEL, 0, 0);
 	if (err) {
 		dev_err(&pdev->dev, "couldn't allocate irq chips %s (DT).\n",
 			mvchip->chip.label);
-		goto err_domain;
+		return err;
 	}
 
 	/*
@@ -1292,10 +1304,6 @@ static int mvebu_gpio_probe(struct platform_device *pdev)
 	}
 
 	return 0;
-
-err_domain:
-	irq_domain_remove(mvchip->domain);
-	return err;
 }
 
 static struct platform_driver mvebu_gpio_driver = {
-- 
2.39.2



