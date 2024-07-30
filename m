Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790B51A76A1;
	Tue, 30 Jul 2024 17:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359495; cv=none; b=aNNgvQ7VQCL0D6MhujMOiDx8AOCUCLCNubyJT3UO+NLtAQ8FJwhKo9GRvJdgpQiBeiZz2jy2FnBgQ6qKQnlNAX31y7TvGZnSDYwveUrpZ6oluFRYDJTXbi64zUkUCZk0s6qMRKLaoNEHfg2QdBP+PdTj4VIFJqWFzsDWUEBNbHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359495; c=relaxed/simple;
	bh=o6j/PmCMfsvb+kWEnu29/nT8y1OWcGueSk8Zae55ZFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/kwFcfXVkYz3omFlm+Y1uiDXB2m3zgnW+RRD0p+znrSKt94djtWBoVmV9BFN1l23V205YqdVUzOZMTyZZva2SuoabP6Yzewj+soGJxmIP/UQsSKJSY8dC4QC0r9xD6XEja88fmZjrZWmJs5m30pbY7M5+7jr5cz3NWom3I7STU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJTIrHsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJTIrHsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC5BC32782;
	Tue, 30 Jul 2024 17:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359495;
	bh=o6j/PmCMfsvb+kWEnu29/nT8y1OWcGueSk8Zae55ZFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJTIrHscd7J4Ax3hvGhfmKOCpwKcfAiMM3vKqEngiL6fNkWNWa7yBQdEJHlWHQjHA
	 5Vu6Ypz1oXSgR1t2bHjNs12f/sRLEbBOJMtzF/oS85D7tedt2CcduzY5TXJ3h0Pqr5
	 j1CEBa2Ewwt+Cd/s9IMyp/1A/NsPTggQ35ohboAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 492/809] pinctrl: single: fix possible memory leak when pinctrl_enable() fails
Date: Tue, 30 Jul 2024 17:46:08 +0200
Message-ID: <20240730151744.170903618@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index a798f31d69542..4c6bfabb6bd7d 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1329,7 +1329,6 @@ static void pcs_irq_free(struct pcs_device *pcs)
 static void pcs_free_resources(struct pcs_device *pcs)
 {
 	pcs_irq_free(pcs);
-	pinctrl_unregister(pcs->pctl);
 
 #if IS_BUILTIN(CONFIG_PINCTRL_SINGLE)
 	if (pcs->missing_nr_pinctrl_cells)
@@ -1879,7 +1878,7 @@ static int pcs_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto free;
 
-	ret = pinctrl_register_and_init(&pcs->desc, pcs->dev, pcs, &pcs->pctl);
+	ret = devm_pinctrl_register_and_init(pcs->dev, &pcs->desc, pcs, &pcs->pctl);
 	if (ret) {
 		dev_err(pcs->dev, "could not register single pinctrl driver\n");
 		goto free;
@@ -1912,8 +1911,10 @@ static int pcs_probe(struct platform_device *pdev)
 
 	dev_info(pcs->dev, "%i pins, size %u\n", pcs->desc.npins, pcs->size);
 
-	return pinctrl_enable(pcs->pctl);
+	if (pinctrl_enable(pcs->pctl))
+		goto free;
 
+	return 0;
 free:
 	pcs_free_resources(pcs);
 
-- 
2.43.0



