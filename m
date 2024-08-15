Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1815F7DA9E;
	Thu, 15 Aug 2024 13:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729623; cv=none; b=K2mbnlx3LllWa0SJyXPYDfyA+pOtCiu2FuvzrewD+NXh44Fw1iZCGum73dadvxJc0uE301O1+AiGn5pmx2JWH92vKddGi/Gr9Aq/LXputTTMuL3u0bO0BIhZ1n37Mx10jUW6EkbRrA0hE+YmlKzofyNkyCSUebk7mve3+Os48AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729623; c=relaxed/simple;
	bh=QkCVi2sT4cprScdYOFUfGoaZdYwrSFyGhlXH4g/iEkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0KjQIvarFuab9IbWQyTWoTEyKgpbIkfEDQBdicf8mOCZJR3aWwcf4rANUqaqN80hcpUOFnLAQjY7l2eqRqBQBuzrCNY5dLFuLLtrviaQvN0eQBJaHfhF6qXEKcCRXHEa9620fuCehbXtU16e/h7PyTHE6es/JlMrzv/OgSQLPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOk6tndK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOk6tndK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AA1C32786;
	Thu, 15 Aug 2024 13:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729623;
	bh=QkCVi2sT4cprScdYOFUfGoaZdYwrSFyGhlXH4g/iEkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOk6tndKuvdRhPkYmaxrC9AfC8hLsDyipd8FpgrDKr6rymLI6noR2FBbjp+7MgWhP
	 javcPIkEZYmWu34yHl7TyK3eGK6kW/UZ+fMUVCeejiKyuXimDHD4nIvcnY2IH+sdNM
	 CntF1WgAUIJaUdw/br48iBUuGi0TjWO4nmpW2BvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 156/484] pinctrl: single: fix possible memory leak when pinctrl_enable() fails
Date: Thu, 15 Aug 2024 15:20:14 +0200
Message-ID: <20240815131947.440049463@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 8f773bfbdd428819328a2d185976cfc6ae811cd3 ]

This driver calls pinctrl_register_and_init() which is not
devm_ managed, it will leads memory leak if pinctrl_enable()
fails. Replace it with devm_pinctrl_register_and_init().
And call pcs_free_resources() if pinctrl_enable() fails.

Fixes: 5038a66dad01 ("pinctrl: core: delete incorrect free in pinctrl_enable()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20240606023704.3931561-3-yangyingliang@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 9ad8f70206142..cd23479f352a2 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1328,7 +1328,6 @@ static void pcs_irq_free(struct pcs_device *pcs)
 static void pcs_free_resources(struct pcs_device *pcs)
 {
 	pcs_irq_free(pcs);
-	pinctrl_unregister(pcs->pctl);
 
 #if IS_BUILTIN(CONFIG_PINCTRL_SINGLE)
 	if (pcs->missing_nr_pinctrl_cells)
@@ -1885,7 +1884,7 @@ static int pcs_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto free;
 
-	ret = pinctrl_register_and_init(&pcs->desc, pcs->dev, pcs, &pcs->pctl);
+	ret = devm_pinctrl_register_and_init(pcs->dev, &pcs->desc, pcs, &pcs->pctl);
 	if (ret) {
 		dev_err(pcs->dev, "could not register single pinctrl driver\n");
 		goto free;
@@ -1918,8 +1917,10 @@ static int pcs_probe(struct platform_device *pdev)
 
 	dev_info(pcs->dev, "%i pins, size %u\n", pcs->desc.npins, pcs->size);
 
-	return pinctrl_enable(pcs->pctl);
+	if (pinctrl_enable(pcs->pctl))
+		goto free;
 
+	return 0;
 free:
 	pcs_free_resources(pcs);
 
-- 
2.43.0



