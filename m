Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF16344DB9;
	Sat, 30 May 2026 18:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166465; cv=none; b=gJ/PC6E5VdREH19w2CVEypExOd0ozIHg8N3RxHxGj9yslAdLMie8yA1nWaU+4P40DZJpDVmN2V9xNJg85/PbfhH6heyE5xs63zKE9nYxPvfmPeC52q5941md3J6qFDuwW+ZnUZ/c07D+fQpbPgRXIsh1sakIPvhHhsAoybXy/7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166465; c=relaxed/simple;
	bh=oMUn0VArbsUMPOK0CtA/3HvTC9kb9t4DZT8W4UxJxL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWkmJyrByXzrnG24pfGXFPAZ1UpHW6SZrSOF96Yq4PLU7vNBIM/7NnWdz42OUIPnXsZYj3NO+f4vcycwVHu/gzCQmi5w6ReyqS2feeAa7VqJz2kAUMlZy/y1Ea5kidfeKYxhFfzEr2H9Ih+Q9y6ZLm8YzJxIJaLPOHOg+E4Nz70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1qBbXvtH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qBbXvtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25D11F00893;
	Sat, 30 May 2026 18:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166464;
	bh=ZqSL8975WtrLBNOoFaesfd1iGAAiXrU/A6jTrJ8W8z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1qBbXvtHcwnben6oiKfShY6iRkp4mDt+mHWzLyEuKo5i041vFLQrD77GapdoeoN9l
	 iHwUhm0EzE8L5qiVWPzSwhWYjD/2NkeanG8komAXWVcwKybH/QBhqY/jM0cOWNO6Gg
	 6T8Z3wWEr6iv3vgs2fmgfbAj8q4gzG+OXeDCzqBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 381/589] pinctrl: pinctrl-pic32: Fix resource leak
Date: Sat, 30 May 2026 18:04:22 +0200
Message-ID: <20260530160234.813347636@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a6e2a4a4ca952..07dc358359e32 100644
--- a/drivers/pinctrl/pinctrl-pic32.c
+++ b/drivers/pinctrl/pinctrl-pic32.c
@@ -2162,16 +2162,10 @@ static int pic32_pinctrl_probe(struct platform_device *pdev)
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
 
@@ -2227,16 +2221,10 @@ static int pic32_gpio_probe(struct platform_device *pdev)
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



