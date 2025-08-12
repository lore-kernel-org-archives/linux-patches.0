Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575EB3594E;
	Tue, 12 Aug 2025 19:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026138; cv=none; b=IUhZ9031/qP5Gu+VzrYaRKqgkFpCV2u8viVC6bLIyNEW/3X/BqZdxULL/7OQG8YxSD620OYHk5XrD/j8ahGKgI11Fd4zcJIAipuSqHNKzsXG0hZ3kBRrA7q9ZiRk/nLTFPuvaJP7NGZrREWtN9rj+sRjAWRHAHDET02CgSu7+2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026138; c=relaxed/simple;
	bh=MNS1w57OsAqVSvRKucvBkouKZpu1PGQjz5yCwnT+Xbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kDbAS8FEXB79kjAs9kqweOSlV/EsD820xNk06LP3GbVdPvZxaDwvzqLwiNGOo0fbKWkJPoEOUte9JDBz0yJyH98Ij/2Gkf9qm+MQlG2uar0RFIvFglN4pl0RUpjFVAuxH7pIH3cT8MEUL+W05CgygPEzuNmyS1URvn/JhvdTOp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pUatF0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pUatF0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB11C4CEF0;
	Tue, 12 Aug 2025 19:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026134;
	bh=MNS1w57OsAqVSvRKucvBkouKZpu1PGQjz5yCwnT+Xbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1pUatF0y38xlJ18CfIkP6QYHPuWzc9UETFvl5inzfxYHYBO/1x9P2RRJdFKMpuph6
	 CtG9z+WEW7xblR5hiog2E86G3sS7ibw2OW0wNBrJ1VLaXv0itC3Jl/zYg4wa3y7qSK
	 XI3YQ/iLZbAcD71TDjjf8XXzZ0ZvlaDqO1eWgQok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Ze Huang <huangze@whut.edu.cn>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 246/480] pinctrl: canaan: k230: Fix order of DT parse and pinctrl register
Date: Tue, 12 Aug 2025 19:47:34 +0200
Message-ID: <20250812174407.603780973@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ze Huang <huangze@whut.edu.cn>

[ Upstream commit d94a32ac688f953dc9a9f12b5b4139ecad841bbb ]

Move DT parse before pinctrl register. This ensures that device tree
parsing is done before calling devm_pinctrl_register() to prevent using
uninitialized pin resources.

Fixes: 545887eab6f6 ("pinctrl: canaan: Add support for k230 SoC")
Reported-by: Yao Zi <ziyao@disroot.org>
Signed-off-by: Ze Huang <huangze@whut.edu.cn>
Link: https://lore.kernel.org/20250624-k230-return-check-v1-2-6b4fc5ba0c41@whut.edu.cn
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-k230.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-k230.c b/drivers/pinctrl/pinctrl-k230.c
index 4976308e6237..d716f23d837f 100644
--- a/drivers/pinctrl/pinctrl-k230.c
+++ b/drivers/pinctrl/pinctrl-k230.c
@@ -590,6 +590,7 @@ static int k230_pinctrl_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct k230_pinctrl *info;
 	struct pinctrl_desc *pctl;
+	int ret;
 
 	info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
 	if (!info)
@@ -615,13 +616,15 @@ static int k230_pinctrl_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(info->regmap_base),
 				     "failed to init regmap\n");
 
+	ret = k230_pinctrl_parse_dt(pdev, info);
+	if (ret)
+		return ret;
+
 	info->pctl_dev = devm_pinctrl_register(dev, pctl, info);
 	if (IS_ERR(info->pctl_dev))
 		return dev_err_probe(dev, PTR_ERR(info->pctl_dev),
 				     "devm_pinctrl_register failed\n");
 
-	k230_pinctrl_parse_dt(pdev, info);
-
 	return 0;
 }
 
-- 
2.39.5



