Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D883C23392B;
	Sat, 30 May 2026 18:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164301; cv=none; b=ZYNLwP5jA6urvWSNoFhykDcGeMNIklCBdqpNPAdJP2XHz3C7I/fNp2KtYo+4LfskZZ3na5yK+ZJaVHbjdSzzmbhz5Lo2PVjRWg5pTZPLQMbIfFyucMV0dR8z/9Y0wWSE1cWxlCPV+WVegKMz6jfUTX2bx6vPRx2ghkjEcCjYl08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164301; c=relaxed/simple;
	bh=p/AxBpVNdibaEL8T2fVTBcMgc5/uh4twPzQ5c7RPNhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieMw34lWhXX40ojJGZqLSNQlmH/HAmBjK7nUo+GPG/yf3SgTvMiwQJ8C/+NWArMqTgKKpZswyp9EdqDBvRN57uphLjwuAaNEE+Jb+4+Bou0Fy398AX5g8gsRcA7CymlqniOaHeRhPjbAdpexCOKhAKokofdFhzuWTZxmSNaI8EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmLoHGwU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmLoHGwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1E31F00893;
	Sat, 30 May 2026 18:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164300;
	bh=g0uajM3Ra2hUcGWn3gCp6Buk7VFqg9r19fCmfo5Id/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VmLoHGwUU/8RdV4TSkoA59M/8xlY+KESu2mNZt34moxjuu/EIlH9X2FAE7nnv5w/3
	 eRZ0yKkzOwvYDmn3JFG+7VdjucgZ3M5E5+QBQRZooeqb7X5UZ7nhKtEGb+Fg3XtdVZ
	 evmnBK/aRbg+AABMp/VOuG70YMDIyEBJx2A61GrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 513/776] pinctrl: pinctrl-pic32: Fix resource leak
Date: Sat, 30 May 2026 18:03:47 +0200
Message-ID: <20260530160253.513153599@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 748dabd8db6e8..19763697a0a42 100644
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



