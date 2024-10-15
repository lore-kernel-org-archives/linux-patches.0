Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483121C57B1;
	Tue, 15 Oct 2024 12:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994037; cv=none; b=COHovx3I5iRlQQLnN5TdwPhAN+kLsmHwyAeJ+M+XNf+9DW2y4GHQl9mzAHh1R/UqrSd6FMOEcSzvR2YTEwgW9tfkyw5W/7pyyzo/BoOjOP2adS6cwmvG0igdY1IVuR9pyXuQms3eZs7UmgM1dmfcGmkzT/OR+wPuxTS9pe/6rjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994037; c=relaxed/simple;
	bh=bsNX3mzYZMtWlu+inQPFLSSoBBIsUY8qiQFdKdb/Cbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djXdJ33iflgS9gGCDJhPPtHiUsfG+yxXt84xJG/BghHBNMk+cDiH6UCIq0KuH6jPs9lmZIp3WufSj8yxPun7qHiMVTaDyac4XAoXvMsGPFHWjgZRkLyTy5YHryQzvPDegNlOdM6xqKFt0pmPRxiiOrlXdcTpiQYipdSvqaY2kIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zj6o7jQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zj6o7jQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADED8C4CEC6;
	Tue, 15 Oct 2024 12:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994037;
	bh=bsNX3mzYZMtWlu+inQPFLSSoBBIsUY8qiQFdKdb/Cbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zj6o7jQjJDQ9yfOYxmU/RN6a8Yx3z6mf0zr6uMpfTLPTxW6LM8MuRw8notCLKXRel
	 aQ0hHyl6O5Eo7eVjtl3Dj8XZrWGtSymlmjshtlYY1wgtYiR1nQz9mk3GbAvFS1p20/
	 mTyXfWfztzDVyhznKuYgO7pYeFhQwLILJDyJoHIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 557/691] spi: bcm63xx: Fix missing pm_runtime_disable()
Date: Tue, 15 Oct 2024 13:28:25 +0200
Message-ID: <20241015112502.450486976@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 265697288ec2160ca84707565d6641d46f69b0ff ]

The pm_runtime_disable() is missing in the remove function, fix it
by using devm_pm_runtime_enable(), so the pm_runtime_disable() in
the probe error path can also be removed.

Fixes: 2d13f2ff6073 ("spi: bcm63xx-spi: fix pm_runtime")
Cc: stable@vger.kernel.org # v5.13+
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20240819123349.4020472-3-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index 51296615536a9..695ac74571286 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -595,13 +595,15 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 
 	bcm_spi_writeb(bs, SPI_INTR_CLEAR_ALL, SPI_INT_STATUS);
 
-	pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		goto out_clk_disable;
 
 	/* register and we are done */
 	ret = devm_spi_register_master(dev, master);
 	if (ret) {
 		dev_err(dev, "spi register failed\n");
-		goto out_pm_disable;
+		goto out_clk_disable;
 	}
 
 	dev_info(dev, "at %pr (irq %d, FIFOs size %d)\n",
@@ -609,8 +611,6 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 
 	return 0;
 
-out_pm_disable:
-	pm_runtime_disable(&pdev->dev);
 out_clk_disable:
 	clk_disable_unprepare(clk);
 out_err:
-- 
2.43.0



