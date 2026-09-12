Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65ADE376BCD;
	Sat, 12 Sep 2026 13:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219549; cv=none; b=J1WdaOYtk34VsqzpTeibLeTps0lXurX5Mrw24+xSFN4KDlKcZviZOajlH1wfYi9E2q1rnZVzDTgc1X2t2TnxAQct1flP4x7y2USr1kWGgbCelqluKNQXTPTJPM2KY9cPcFS0tpNOz5XptZ4E6CHdSDPnHmUUbi2ndr4ifENkgx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219549; c=relaxed/simple;
	bh=rLNYVlkmiEQNvXP6y8WJlzVtRjSn6fORUZ08UrXKnoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvqiyOQJEyO+gWWUPQsFTzTRIfBhRBcxnAA8051KMaCXBLQUTxTVyYK28T7BfuTPPP/dLAoud0UmyYSH553da9Ln80XIpor6K5n9rtd6X5ZNzdt9vtTz32nHbPZez9BuNOW6BC3PigieIoWQjJoQ7eldDxE5MA7DvN8LvIJR+S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WquqiQS2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WquqiQS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064DD1F000FF;
	Sat, 12 Sep 2026 13:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219548;
	bh=G+J21hQz+bFu3dGFyLf49avBtNcC0X3YE/v1PpDHw28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WquqiQS2g0Vhq0B2CtcEfBuxPaRJ4e1o89UEMhnSTW6MqQWf8eZOwlNbA0TQG6hKH
	 IfuGQ6ls/Z4qlBgZY6/GAYGDP1YDw05y70EP/DTNTnAp+WluHsGVBakl+HKALbQS4N
	 OBErvLkTmQIgeQ6kwSUWEdFZ4slBhO4CmBX9fJEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.12 1372/1376] pinctrl: mediatek: common-v1: Fix error checking in mtk_eint_init()
Date: Sat, 12 Sep 2026 09:03:18 +0200
Message-ID: <20260912065638.112999517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 446d28584723e5d4bcdb18cf6ef87cb2bb597dd8 upstream.

The devm_kzalloc() function doesn't return error pointers, it returns
NULL on error.  Then on the next line it checks the same pointer again
by mistake, "->base" instead of "->base[0]".

Fixes: fe412e3a6c97 ("pinctrl: mediatek: common-v1: Fix EINT breakage on older controllers")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/aAijc10fHka1WAMX@stanley.mountain
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
@@ -1018,12 +1018,12 @@ static int mtk_eint_init(struct mtk_pinc
 	pctl->eint->nbase = 1;
 	/* mtk-eint expects an array */
 	pctl->eint->base = devm_kzalloc(pctl->dev, sizeof(pctl->eint->base), GFP_KERNEL);
-	if (IS_ERR(pctl->eint->base))
+	if (!pctl->eint->base)
 		return -ENOMEM;
 
 	pctl->eint->base[0] = devm_platform_ioremap_resource(pdev, 0);
-	if (IS_ERR(pctl->eint->base))
-		return PTR_ERR(pctl->eint->base);
+	if (IS_ERR(pctl->eint->base[0]))
+		return PTR_ERR(pctl->eint->base[0]);
 
 	pctl->eint->irq = irq_of_parse_and_map(np, 0);
 	if (!pctl->eint->irq)


