Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6968B3F789B;
	Wed, 20 May 2026 18:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300920; cv=none; b=BOmq4Qx1Jsofy57H952iQY0J0gCkDi+PK1vbDDCSYwrN+v0FStSP93FVHrPWeqScFYBub89LOjFVBhXvXPd2Z1XcTvjrtuprbqkYQJly1qot+F87n9in6TSPJepJoA0GaaJXxaBaFXEPZL7sd2kkKK/dDXoUpNzCiKj7Xos3oi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300920; c=relaxed/simple;
	bh=4jbgghEvdPfTcgYSe4ZX9wM7W15A0zPuMQcgJ9fJF2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzqScxv7IL7q0SJVdAMavSPUQbmEfa77eS/WKuOrMSa3AXbwzga7xhCVNybYNbDwQsSQmOOup1xCIKlglOY5X61PLFrbzwvps6hFakjeixWb4LQepI369wb/4HTgsSot7LMeYRiXOl7NIIg1ggUxgfWH3286WXZMDFNrViDHjSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CMIYcL+u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CMIYcL+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7788C1F00893;
	Wed, 20 May 2026 18:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300917;
	bh=gCAD1jm3f78gMfSpl6j5Aje1mVLaB4mNj2IpzcMFlKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CMIYcL+unF1nDuMxlnley8ZKnn2A5EmQo9+BtVS4ycztNMEWEHCdTFft+W+eAy27B
	 mkqAas+8afebqBMYBP2LhqIWBEnY8c1EEw0Z8ZtPmbs5Cd1jyse6OXuNhlN1dkVtV3
	 ottq2opky17otwwyprWXQZS+uz1P/Iw61Jag50RE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 358/666] pinctrl: pinctrl-pic32: Fix resource leak
Date: Wed, 20 May 2026 18:19:29 +0200
Message-ID: <20260520162118.995092010@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



