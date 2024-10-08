Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6BF1D0BAA;
	Tue,  8 Oct 2024 12:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390492; cv=none; b=cFGC302vLuO80GxIh78Ptjn0CBXoAny9/n3femTkOQoaaXffQCwFwqhVUZsGP/pXSHaw6Jp91D+L37xCQvCSYqdBWcs4qL0Dnw5jSXk0gFAD20R395RjzvRLFwK1vHXPr6CZQW8FcPuRUTWG7uTT/lTOn7kW+yNK4Lxl2M21DxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390492; c=relaxed/simple;
	bh=LwOS6LnhyiF33ggj2Vw6uBKAjZFWHkKUymZUdR9d9HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awq1tYZlSx4HlE/Aue0MKxqSFPE0xqGQwCdee7OKc4yHJUb0cxNs0WB/0lfevJFw1+NhRC8q7LCphzry3AgjrjGh8+y8/j9rBUqRXBbgSB5CBl+Z1wyxmU/mwPCD4/VhKwOVF954l739vIhrE4qUc8qvVar6K5cQ2TEG+eae4QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQiQgTeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQiQgTeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4F2C4CEC7;
	Tue,  8 Oct 2024 12:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390492;
	bh=LwOS6LnhyiF33ggj2Vw6uBKAjZFWHkKUymZUdR9d9HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQiQgTeMRVBZoDm3nmOP/yUiUpJwjTujFneetKxs+z1eX7xZ+gqm7hdKqg/e+SgJu
	 hQ53rf6YQUbFV1Ln7iEMQMsPh3nk4vDE3wlaNtj8PzwiBgPGhuMHVR4ExzrxMUdsVH
	 FBpmZkCIWkHmhr01tMpUrGdjiiBle40jWAxJiPgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.10 306/482] spi: bcm63xx: Fix missing pm_runtime_disable()
Date: Tue,  8 Oct 2024 14:06:09 +0200
Message-ID: <20241008115700.476659310@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit 265697288ec2160ca84707565d6641d46f69b0ff upstream.

The pm_runtime_disable() is missing in the remove function, fix it
by using devm_pm_runtime_enable(), so the pm_runtime_disable() in
the probe error path can also be removed.

Fixes: 2d13f2ff6073 ("spi: bcm63xx-spi: fix pm_runtime")
Cc: stable@vger.kernel.org # v5.13+
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Suggested-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20240819123349.4020472-3-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-bcm63xx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -584,13 +584,15 @@ static int bcm63xx_spi_probe(struct plat
 
 	bcm_spi_writeb(bs, SPI_INTR_CLEAR_ALL, SPI_INT_STATUS);
 
-	pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		goto out_clk_disable;
 
 	/* register and we are done */
 	ret = devm_spi_register_controller(dev, host);
 	if (ret) {
 		dev_err(dev, "spi register failed\n");
-		goto out_pm_disable;
+		goto out_clk_disable;
 	}
 
 	dev_info(dev, "at %pr (irq %d, FIFOs size %d)\n",
@@ -598,8 +600,6 @@ static int bcm63xx_spi_probe(struct plat
 
 	return 0;
 
-out_pm_disable:
-	pm_runtime_disable(&pdev->dev);
 out_clk_disable:
 	clk_disable_unprepare(clk);
 out_err:


