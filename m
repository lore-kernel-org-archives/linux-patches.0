Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD8E183CD5;
	Tue, 30 Jul 2024 16:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356991; cv=none; b=NhLfCeeQn+ezIw+dYAq/tKQdfKJivt7X0RWORuwgxFuCgmCLPzZprhpllvOIUxmu14zrg3P501pipI0BckIwljsXQX8cWy6//ua/z66+sSbZ8uS2v0tcYFDnHLCzLT+Sx0tC5VE24Bf6JEajYyx/Au3GPqrsmp8e2uM0XCFAZ8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356991; c=relaxed/simple;
	bh=Jsskh6XgeeGjxi+yNWByRmoMQ6AvXHcZHmlytOZr4n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZAdMI0GEOWNEnkT3BthwkmgAHwSb7uePx7Xm42yqvmHgkkYuMpW+Lhm+rotlZM7NiCzfoCZDI49kI1Wez9YLZHT/RLjk5/DqFlE3M5Jhc8QpNEv2pLMUtSuN1mnpz74N/waH3Q1FzIhhmNoTAuiYz6qf5IenGn+c+BJxz3vjQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkLr3fM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkLr3fM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE36C32782;
	Tue, 30 Jul 2024 16:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356990;
	bh=Jsskh6XgeeGjxi+yNWByRmoMQ6AvXHcZHmlytOZr4n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkLr3fM5oWrFoLSY9zmpiqdDBpU0gMDEazGAse3aO+jSOnIeBHgF26IuAXskPFqs0
	 LQAZu7YTRh5BiZ/HT6rISB83dgi4xyF2AfFQzzHKOqzLhl1okniXAICfYQt155tWNP
	 tvqxA9ABDdmUwkmQ2n99OEvVhi3vtUMZj9xfuGN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 248/440] pinctrl: ti: ti-iodelay: fix possible memory leak when pinctrl_enable() fails
Date: Tue, 30 Jul 2024 17:48:01 +0200
Message-ID: <20240730151625.537101055@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 9b401f4a7170125365160c9af267a41ff6b39001 ]

This driver calls pinctrl_register_and_init() which is not
devm_ managed, it will leads memory leak if pinctrl_enable()
fails. Replace it with devm_pinctrl_register_and_init().
And add missing of_node_put() in the error path.

Fixes: 5038a66dad01 ("pinctrl: core: delete incorrect free in pinctrl_enable()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20240606023704.3931561-4-yangyingliang@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/ti/pinctrl-ti-iodelay.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
index 75a2243ee87cc..f3411e3eaf2ea 100644
--- a/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
+++ b/drivers/pinctrl/ti/pinctrl-ti-iodelay.c
@@ -883,7 +883,7 @@ static int ti_iodelay_probe(struct platform_device *pdev)
 	iod->desc.name = dev_name(dev);
 	iod->desc.owner = THIS_MODULE;
 
-	ret = pinctrl_register_and_init(&iod->desc, dev, iod, &iod->pctl);
+	ret = devm_pinctrl_register_and_init(dev, &iod->desc, iod, &iod->pctl);
 	if (ret) {
 		dev_err(dev, "Failed to register pinctrl\n");
 		goto exit_out;
@@ -891,7 +891,11 @@ static int ti_iodelay_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, iod);
 
-	return pinctrl_enable(iod->pctl);
+	ret = pinctrl_enable(iod->pctl);
+	if (ret)
+		goto exit_out;
+
+	return 0;
 
 exit_out:
 	of_node_put(np);
@@ -908,9 +912,6 @@ static int ti_iodelay_remove(struct platform_device *pdev)
 {
 	struct ti_iodelay_device *iod = platform_get_drvdata(pdev);
 
-	if (iod->pctl)
-		pinctrl_unregister(iod->pctl);
-
 	ti_iodelay_pinconf_deinit_dev(iod);
 
 	/* Expect other allocations to be freed by devm */
-- 
2.43.0



