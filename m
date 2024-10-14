Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBCD1C302E;
	Mon, 14 Oct 2024 15:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919489; cv=none; b=a2qZP+CF8WhJ1+1yg5fJpgeg4oq6JR6b7V65h6V2xaeY0qBZ7HrrgrYk80T/FB6Y7spa0n6Fpa5b9zPLqTHC+E0Q35lqicUgCCYiLhuyJS6oLx2Q5D8jicNy2CA8MXVSS+MGZw34gMwd/xoZSCJPAHZNCGQ6Fivg/2iJ42dsoxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919489; c=relaxed/simple;
	bh=VbS2I9XTSCiVXVgE5Cis1+WliWhq8+QpJ5WNfaL8YEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtbi0fweRW0snQcic+6xrr4Eys8fFGsn9KQDv4x1L0pzZBzNUiAZtw3GFTI8ojQMqIfEtwqaasvChrvBV7jl7ia7abf4+Xv5uBnQTt33Nsdm414vYwwxiHBnQ2a7tw8Dd6j2J2SqFk9vWL+PGmdhN8p+aMFNrhmjid6mJA1uS7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=On+NpMnT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="On+NpMnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5357AC4CEC3;
	Mon, 14 Oct 2024 15:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919488;
	bh=VbS2I9XTSCiVXVgE5Cis1+WliWhq8+QpJ5WNfaL8YEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=On+NpMnT4mRR1Dnza+Hd8VvITS2FJvtoiDpBNmgMJFHKj1XIB+2J3RcfZCEgqxo5U
	 jBOCSxq4gecK6bsvRW8WqTNlyNQOiCBpdw1DZvxvssPnms7vDuUJA+Pv39r359Rv5Y
	 ZvfZKMznL1JE4M4KJK4X15WggSx4LjOy6Z1jiiCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Michal Simek <michal.simek@amd.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 620/798] i2c: xiic: Use devm_clk_get_enabled()
Date: Mon, 14 Oct 2024 16:19:34 +0200
Message-ID: <20241014141242.397326272@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 5ed8a341d62f9..00998a69a6b13 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -798,16 +798,11 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 
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
@@ -819,7 +814,7 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Cannot claim IRQ\n");
-		goto err_clk_dis;
+		goto err_pm_disable;
 	}
 
 	i2c->singlemaster =
@@ -840,14 +835,14 @@ static int xiic_i2c_probe(struct platform_device *pdev)
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
@@ -858,10 +853,10 @@ static int xiic_i2c_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_clk_dis:
+err_pm_disable:
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-	clk_disable_unprepare(i2c->clk);
+
 	return ret;
 }
 
@@ -879,7 +874,6 @@ static int xiic_i2c_remove(struct platform_device *pdev)
 
 	xiic_deinit(i2c);
 	pm_runtime_put_sync(i2c->dev);
-	clk_disable_unprepare(i2c->clk);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-- 
2.43.0



