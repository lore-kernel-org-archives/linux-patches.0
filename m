Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D972296C4;
	Tue, 15 Oct 2024 13:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998235; cv=none; b=gNLDOiFL5ck4/6+yVRApyoYILj02Svx/hXOSvlj6PtApn5VmOsYYCghSwCWHhQivcJdrb1b0PKw7/pTCstOI0MGWYzY/x/9pX5TBTWXiHC5Z9SGdlZVrTlyrp+HpIxZzqOfSidgO0Y+L4+sLOFAJgithJU//4RdmhYvYUVQmbPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998235; c=relaxed/simple;
	bh=qVNTwD6b5jmw0P9YY7NKp9xgURMmn5wz8J7I/uJ9CiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7yLMsP3v91/ZLIrn5F0HDcaeQ8jbEp8aJTdnRuX8KXF41vV0IWm5VFVefs+OYh4FsOCW/BXjiomaE6s/AHGW3HhzZAKNHuYg/Y8BXtHvG9n0Vuone9svToldg1DrDzBcVns6su+F5keFNrVAVokQUyAuNvoa0X4Od9baJWt8bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=voxpmASe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="voxpmASe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A01C4CEC6;
	Tue, 15 Oct 2024 13:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998235;
	bh=qVNTwD6b5jmw0P9YY7NKp9xgURMmn5wz8J7I/uJ9CiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=voxpmASeuTbkODiyV+QXiC5j76qz73ZJIIVrdMmRHk2IAjaBRy+XzKQgjFuGgsNio
	 crFvjAk1Xdtbo2inyIYZ4U0NIGII1eAndpuspsgd4ou+Wv92LoJBPx3rH+YLlNqaWt
	 5kC8R6lpdljs6gkRb5barp23QfPxfg//kfk4LvJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Michal Simek <michal.simek@amd.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 418/518] i2c: xiic: Use devm_clk_get_enabled()
Date: Tue, 15 Oct 2024 14:45:22 +0200
Message-ID: <20241015123933.129383528@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/i2c/busses/i2c-xiic.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -837,16 +837,11 @@ static int xiic_i2c_probe(struct platfor
 
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
@@ -858,7 +853,7 @@ static int xiic_i2c_probe(struct platfor
 
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Cannot claim IRQ\n");
-		goto err_clk_dis;
+		goto err_pm_disable;
 	}
 
 	i2c->singlemaster =
@@ -879,14 +874,14 @@ static int xiic_i2c_probe(struct platfor
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
@@ -897,10 +892,10 @@ static int xiic_i2c_probe(struct platfor
 
 	return 0;
 
-err_clk_dis:
+err_pm_disable:
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-	clk_disable_unprepare(i2c->clk);
+
 	return ret;
 }
 
@@ -918,7 +913,6 @@ static int xiic_i2c_remove(struct platfo
 
 	xiic_deinit(i2c);
 	pm_runtime_put_sync(i2c->dev);
-	clk_disable_unprepare(i2c->clk);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);


