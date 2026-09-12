Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6CD32B108;
	Sat, 12 Sep 2026 15:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226526; cv=none; b=k6M4qaI9MdjoFnKPrh+9gDL+ns4fezeEuOHffXPbexBAGcyUNWR449ecuLiLhGMoWsepjy7nM0zHzqyrrbtbYyA6fcYKhTjqJuYQMn/cPqzTrPVcjX+CTgMxtmOiTOv7EsftVW3kFSSdh0f6tnrL1fmlXhmK1gzTV7tN4/Skrsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226526; c=relaxed/simple;
	bh=+B/P0Ch9r/Epbef0fhueXDvqqlqDNeq6v4l5+RNX+ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tR5zVF0Vuv1wMjSsSDxp3WhGeolXmPiM2w0C6h+ejQMD8Efe7jDoloeV50jNwDcBk1rk08mjLa54Vt7gYQOB1XMLnwe3dto5RN6b3Rb2Uag7nswBarih/n6Sa02Z4AxWsMxJOS0fVbcXC1+qoow5RQ0D1YowE4k2uMaK1dG9JzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmvZs8W7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmvZs8W7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49EF71F000FF;
	Sat, 12 Sep 2026 15:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226525;
	bh=SEIzZA7lNREOr9DVnFa9W+LE4murdH5/EjoSeLzHtUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmvZs8W7mLvb3vLvobJHS0GVVHOW2GTqWtXaB+9TsK3+Y2sJ2wVi4KGp9xzFCHmmd
	 qt1j9TGj6s8ZIOpmPyuXqvX5Zwcn9s5R+Gi8u1H+Jf6HNejfPIRSrRQE/oJqBB7RjG
	 +e3W5Xj8XYV2aQpbtc9k5fBKmw+PRwcCEHrmxWzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.6 1421/1424] pinctrl: mediatek: common-v1: Fix error checking in mtk_eint_init()
Date: Sat, 12 Sep 2026 09:04:13 +0200
Message-ID: <20260912065639.082355119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1027,12 +1027,12 @@ static int mtk_eint_init(struct mtk_pinc
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


