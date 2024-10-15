Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA491C57B1;
	Tue, 15 Oct 2024 12:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994030; cv=none; b=IeT5fZV3e1omokPd0NP0wxmozq/EaD4vVF1SarGRiinTCNF7pJGupZCAlr5cC76V4K1nxSvjUwZqKKQiJBqIcNViLc3eBb91xvBUYvHiPAHXIhYEcTTngfFvzX8CSIE1PaxNT7enPlgY5ORfDHvZ1mI8nKSYouObJFkOppCr5TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994030; c=relaxed/simple;
	bh=JrDNPls5AafvEB83+Wbqc7VhP5+n/b69R4/sfkXu3cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfDOY6W8S7gvDyLmJdwtoBEC07npLPcPUXCgNMvkXZe9S/JHyrmfUcwe3YYlS3tMVL6BdKBnwPaU6ywAorwNUZfUaW4yr+g/IbMB0L6pM++RkBw2zeUyrPbJ4mAIqH5zUgbAcKkAmE+3f+njMMekWZsu/UhBlp4C1EUL2fXlApc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ep6pDR81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ep6pDR81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DDC6C4CEC6;
	Tue, 15 Oct 2024 12:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994030;
	bh=JrDNPls5AafvEB83+Wbqc7VhP5+n/b69R4/sfkXu3cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ep6pDR81wYrzLNzxwWvSgiLXiLd6HLJeGNLuJz/2Kv4l+bjRG1Pp+XzP4pcWK6iO8
	 1PoPwNt2yZAKo7EPEZUSJW3Q+6Kc1tMKfClK1H7XylpPp/8N0GIHsbiq7IUQ7w9BrK
	 xtcKQF5wZ/q95dJxBRJQuNvJbO74dPg6UWxySppc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Michal Simek <michal.simek@amd.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 555/691] i2c: xiic: Use devm_clk_get_enabled()
Date: Tue, 15 Oct 2024 13:28:23 +0200
Message-ID: <20241015112502.367794854@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Andi Shyti <andi.shyti@kernel.org>

[ Upstream commit 8390dc7477e49e4acc9e553f385f4ff59d186efe ]

Replace the pair of functions, devm_clk_get() and clk_prepare_enable(),
with a single function devm_clk_get_enabled().

Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 0c8d604dea43 ("i2c: xiic: Fix pm_runtime_set_suspended() with runtime pm enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 2642062ce5b32..678ec68f66d60 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -837,16 +837,11 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 
 	mutex_init(&i2c->lock);
 
-	i2c->clk = devm_clk_get(&pdev->dev, NULL);
+	i2c->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(i2c->clk))
 		return dev_err_probe(&pdev->dev, PTR_ERR(i2c->clk),
-				     "input clock not found.\n");
+				     "failed to enable input clock.\n");
 
-	ret = clk_prepare_enable(i2c->clk);
-	if (ret) {
-		dev_err(&pdev->dev, "Unable to enable clock.\n");
-		return ret;
-	}
 	i2c->dev = &pdev->dev;
 	pm_runtime_set_autosuspend_delay(i2c->dev, XIIC_PM_TIMEOUT);
 	pm_runtime_use_autosuspend(i2c->dev);
@@ -858,7 +853,7 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Cannot claim IRQ\n");
-		goto err_clk_dis;
+		goto err_pm_disable;
 	}
 
 	i2c->singlemaster =
@@ -879,14 +874,14 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 	ret = xiic_reinit(i2c);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Cannot xiic_reinit\n");
-		goto err_clk_dis;
+		goto err_pm_disable;
 	}
 
 	/* add i2c adapter to i2c tree */
 	ret = i2c_add_adapter(&i2c->adap);
 	if (ret) {
 		xiic_deinit(i2c);
-		goto err_clk_dis;
+		goto err_pm_disable;
 	}
 
 	if (pdata) {
@@ -897,10 +892,10 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_clk_dis:
+err_pm_disable:
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-	clk_disable_unprepare(i2c->clk);
+
 	return ret;
 }
 
@@ -918,7 +913,6 @@ static int xiic_i2c_remove(struct platform_device *pdev)
 
 	xiic_deinit(i2c);
 	pm_runtime_put_sync(i2c->dev);
-	clk_disable_unprepare(i2c->clk);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-- 
2.43.0



