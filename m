Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A741D049E;
	Wed,  2 Oct 2024 13:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876264; cv=none; b=m4T9Ga3G2Mbhxpai4UcFn33Q1pgnbLMzeh7mDShM0s3l+YUj/l9+T8h68Jt4/Wwr1X/EpDwgjn3nYcj8VgFRl5AE/Rz5nIlAOKJiZiKfZ3TmFyQQ31xbLhZuKRKma8a1yWHEHDWb09h8Tea3g9qmtw6XVm3R7pePGcjJqx7WxeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876264; c=relaxed/simple;
	bh=g8RkQdMz7e0Cc47e0afp8AI/OeJNDzlROcCIiVPE87w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXUnE3pqvgy5+pRtbG+flt57rk+RKBIv8WwjI5gOLgTKmps0SRWtef7oErujcfrHule4DGWsr0yoec/Oaqtiry6VUKG20AvgbYXH/dqEtqG/XAv3JxSL54Z1sIUuAMIBW9+9Dbqnzn3YC8O/JHm3zsGFjsOcPZLPezNAmYmAA98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZ3dFVdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZ3dFVdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F95C4CEC5;
	Wed,  2 Oct 2024 13:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876264;
	bh=g8RkQdMz7e0Cc47e0afp8AI/OeJNDzlROcCIiVPE87w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZ3dFVdxCmJQ+FPI/E9+Q1XYzL/TMOO++S5qXNlZfLvqXzghez1CCcj9MfQrSrPNS
	 rEMLP9Oa6D178aUYELkIaowEl8K27PRylOSu5y/3NKRvrcNZ5PdNDlYtFQW3VgDy8h
	 //ggIuBaid6AsJkzC4sGVQdONcnz7pLvZmhjIYSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 383/695] pinctrl: single: fix missing error code in pcs_probe()
Date: Wed,  2 Oct 2024 14:56:21 +0200
Message-ID: <20241002125837.745764713@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit cacd8cf79d7823b07619865e994a7916fcc8ae91 ]

If pinctrl_enable() fails in pcs_probe(), it should return the error code.

Fixes: 8f773bfbdd42 ("pinctrl: single: fix possible memory leak when pinctrl_enable() fails")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/20240819024625.154441-1-yangyingliang@huaweicloud.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-single.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 4da3c3f422b69..2ec599e383e4b 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -1913,7 +1913,8 @@ static int pcs_probe(struct platform_device *pdev)
 
 	dev_info(pcs->dev, "%i pins, size %u\n", pcs->desc.npins, pcs->size);
 
-	if (pinctrl_enable(pcs->pctl))
+	ret = pinctrl_enable(pcs->pctl);
+	if (ret)
 		goto free;
 
 	return 0;
-- 
2.43.0



