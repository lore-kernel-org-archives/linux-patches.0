Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE863F8706;
	Wed, 20 May 2026 18:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302381; cv=none; b=I8txvVI6NZrXn1mM21Ms7pk84fvwxQrAC+Usc4hrW/vljOyaGyEgPTJrfb5+ShYSEf0W910qxO9yvf+3IRzL0PKAiYh7DCu+s7aG3Eb6UpJNV6mKzRA1rdJF+Y1vDZk/ziUMCHF2ETrmo22r0PKgx8A9Of0yDdWeCHodR0mdJaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302381; c=relaxed/simple;
	bh=R7AVEkwPleYOLD1Lmu3sLII6cPtqIKOvY3dOUkX43uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/PJsKoJD3tJVYGfDfZgC5BtaJDRZJkTh4lYfEqUWMcg2QSXQJBTotqEMiwjCCxwhV+sKNEmUCIw5FQFqltJzP6odqyBfGzFqhzu4lMb9/2Pc5bAmq8Sm4EFcuZX+WvU5RzGfKTpbMxwGo4fwiBqyq+XB/swMvw53zZVbPpder0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODvlqWiU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODvlqWiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039F81F000E9;
	Wed, 20 May 2026 18:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302380;
	bh=6epOETupvezAWJkqbx0Z59qEfQ/XtHq9LjsMBeyizG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ODvlqWiUhWyszsCJ1PHEYPL5ThJoQ9WAdSMdDtUZoi1XvjqlROknEeeWX1qI1FFF9
	 u2+W2Y/2W78frbat0j3KtZy4sLcN4rktp7JlAlUc6nmzj5y1CCto5HKXmO2FavjC8b
	 cb/0nmijj7xMsbZhtw/6LB9li4MyCgGAjZY2fnvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/508] pinctrl: pinctrl-pic32: Fix resource leak
Date: Wed, 20 May 2026 18:21:07 +0200
Message-ID: <20260520162103.939272420@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit fe5560688f3ba98364c7de7b4f8dc240ffd1ff75 ]

Fix three possible resource leaks by using the devres version of
clk_prepare_enable(). Also, update error message accordingly.

Detected by Smatch:
drivers/pinctrl/pinctrl-pic32.c:2211 pic32_pinctrl_probe() warn:
'pctl->clk' from clk_prepare_enable() not released on lines: 2208.

drivers/pinctrl/pinctrl-pic32.c:2274 pic32_gpio_probe() warn:
'bank->clk' from clk_prepare_enable() not released on lines: 2264,2272.

Fixes: 2ba384e6c3810 ("pinctrl: pinctrl-pic32: Add PIC32 pin control driver")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-pic32.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-pic32.c b/drivers/pinctrl/pinctrl-pic32.c
index bf827ab081a1d..f87b5964e8b31 100644
--- a/drivers/pinctrl/pinctrl-pic32.c
+++ b/drivers/pinctrl/pinctrl-pic32.c
@@ -2173,16 +2173,10 @@ static int pic32_pinctrl_probe(struct platform_device *pdev)
 	if (IS_ERR(pctl->reg_base))
 		return PTR_ERR(pctl->reg_base);
 
-	pctl->clk = devm_clk_get(&pdev->dev, NULL);
+	pctl->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(pctl->clk)) {
 		ret = PTR_ERR(pctl->clk);
-		dev_err(&pdev->dev, "clk get failed\n");
-		return ret;
-	}
-
-	ret = clk_prepare_enable(pctl->clk);
-	if (ret) {
-		dev_err(&pdev->dev, "clk enable failed\n");
+		dev_err(&pdev->dev, "Failed to get and enable clock\n");
 		return ret;
 	}
 
@@ -2238,16 +2232,10 @@ static int pic32_gpio_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
-	bank->clk = devm_clk_get(&pdev->dev, NULL);
+	bank->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(bank->clk)) {
 		ret = PTR_ERR(bank->clk);
-		dev_err(&pdev->dev, "clk get failed\n");
-		return ret;
-	}
-
-	ret = clk_prepare_enable(bank->clk);
-	if (ret) {
-		dev_err(&pdev->dev, "clk enable failed\n");
+		dev_err(&pdev->dev, "Failed to get and enable clock\n");
 		return ret;
 	}
 
-- 
2.53.0



