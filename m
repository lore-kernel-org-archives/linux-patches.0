Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3D341C302;
	Sat, 12 Sep 2026 16:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232379; cv=none; b=qRyDgGu10aTFmFFRbwes27nwck6P19Ze0oEVoZl0smNmqYQ92xv+OoZJSnJ2RkTi80x/DYy2uWo6GpE5fzpbSlbaiahZFwk9ucWvFK8gXLmyLs6RVl9Ng9PDkArptQOOSda40SFL/oScc9ZGBWvCx3GujncVxMAeYkWeRMI9B9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232379; c=relaxed/simple;
	bh=mwzK0VjfpGQGQgiuf6T07v/j38C3Xxj7D8Iwx7FZCR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htmXpZwx38oLD/WF0oJjPv7XvYv0GkOet4RdZDlwXGfGfAl7+bsx6Yo3HIp9rEHZ9qTbodX1e9qb1zVJfNLNcadT/xWB4C3PkwbPvj1qcXy12r9kGIRtFjFPjVUHxC2MuCXCGC+6j1rxNtEQIQmFOGmOWdNyZSbZIj8Lsl8a35M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnZdJmR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnZdJmR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096351F000FF;
	Sat, 12 Sep 2026 16:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232378;
	bh=zMOp5imRNn/uvwLI9DpAC56JXeWNot60TpEWCBcHBq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xnZdJmR/6hY3hLmr7jdmVy38BD+TTE0filshhjtpS6Ow7DlDmHIDP+QDLZrfIHWDy
	 t0zt8IoHrDtSTLjK7D39VfA28g8cJMQu81s/F9g/TXfmk2v5O82U3iC2JljFphXiAK
	 0h5b0R8D0Y/veQyGo9TDrz1ErOubtf7RofouMthw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.1 1188/1191] pinctrl: mediatek: common-v1: Fix error checking in mtk_eint_init()
Date: Sat, 12 Sep 2026 09:05:16 +0200
Message-ID: <20260912065614.816793002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1015,12 +1015,12 @@ static int mtk_eint_init(struct mtk_pinc
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


