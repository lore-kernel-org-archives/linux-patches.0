Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8844E2FD1AD;
	Tue, 12 Aug 2025 18:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024293; cv=none; b=sKhk8Ta9P1EhaDWJ3MiIiiawWyaDOt47StrE7tOfjbbzvTEeSPzt46NyuO6pWNCLVcEd0r4IGQMEWjBNgwq1t1e6UegdCgYGKVpntEA0/Nzr6V/Ss5aZuM5o+PVAXPB4igEkxbhystFykt2kdvUhkwTmCOjoKg1rlgtaZWb45DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024293; c=relaxed/simple;
	bh=ZQHZNurwaOeVW9bY50mZfU2yCkXRh9o5hxu06OShF7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbIZDd33JspoFzXKL0BDd0gJsjQlL/dM6m6cwYHhCnT2UpJqczua7c1CegxOKY8sZljPllaRtUkWiFtp4xy0zhPXaGhbmQRVXC0/jBNLhv/HLdlSOmFtH3vhh5ZxKWnOr5Dm5krIOfGSFeGFD8zdYBvsKCQDCZuRnAmEQwVrOsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxTwJlN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxTwJlN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98BFC4CEF0;
	Tue, 12 Aug 2025 18:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024293;
	bh=ZQHZNurwaOeVW9bY50mZfU2yCkXRh9o5hxu06OShF7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DxTwJlN3TCV60pi8leh5ZXNXRbPTY/TlhE8akUaheKij1qMkWWMx+YgSPeapyoT9f
	 ymHiLLr88jw1oF6Mh7LA+98h6i9x++nxvkpqFH64DO9d4Kr8LLiBq+ys5aCJc6Y17K
	 oBz3ImvAEGdm23QGOObWAqQURsAMfIjq4QEiGJWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Ze Huang <huangze@whut.edu.cn>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 330/627] pinctrl: canaan: k230: Fix order of DT parse and pinctrl register
Date: Tue, 12 Aug 2025 19:30:25 +0200
Message-ID: <20250812173431.848800536@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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



