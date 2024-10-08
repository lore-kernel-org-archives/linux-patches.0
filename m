Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FE41DF995;
	Tue,  8 Oct 2024 12:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392204; cv=none; b=ZLRxteSwVM3YvupI8UTZWYcYXxBmgwIGSsvoRTAMAyct46h7SWBTg0Hh5bkUIpXEIulSqos8ysbALOH4QZGfPXFvML1Q9H05cNbYGh/B4lWcf5OgrLH4BSDoUADqoRzixxg9gKxxC3Kyj44TFC/jHC6TI+d7wHd4/k2DL0aBbr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392204; c=relaxed/simple;
	bh=FkzOADYzbyNYi1PneAgVB6DJ4Hfjl18gqOGUifaA+Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foauC6wA0HOgxnUiCWFuWB5lKwJkaIqZWAN/48mow9SGay+oHNiWPh0wOHDL0iBtOyWcAspo0+JPG8NWIj/t2YZwj8dDXy5xT8nNmiuXhmYVjLSjDOtGbN7GYlzpgA8/TUqfcC3ixz20RQTdxSJnnpjYcZ+vkFGw6NEYiYc9aOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMxNCzuR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMxNCzuR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B765C4CEC7;
	Tue,  8 Oct 2024 12:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392204;
	bh=FkzOADYzbyNYi1PneAgVB6DJ4Hfjl18gqOGUifaA+Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMxNCzuRifOfIBaIr2+NxK/O6dFxgchXgmzLCFUkpkOTG44xiHzICbcUkpRAV4/3+
	 kVp4mCJiEPCUa4KiISdMrD7rKoeIxfLWuloVnHFCA18ZAiEOTBj2s5zD/U+zplPiYd
	 PWzn5Hkz6NIsvb69LWOiisTb7xIaNxa0AIy7yELY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 315/558] spi: spi-imx: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Tue,  8 Oct 2024 14:05:45 +0200
Message-ID: <20241008115714.705863087@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit b6e05ba0844139dde138625906015c974c86aa93 ]

It is not valid to call pm_runtime_set_suspended() for devices
with runtime PM enabled because it returns -EAGAIN if it is enabled
already and working. So, call pm_runtime_disable() before to fix it.

Fixes: 43b6bf406cd0 ("spi: imx: fix runtime pm support for !CONFIG_PM")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240923040015.3009329-2-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 85bd1a82a34eb..4c31d36f3130a 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1865,8 +1865,8 @@ static int spi_imx_probe(struct platform_device *pdev)
 		spi_imx_sdma_exit(spi_imx);
 out_runtime_pm_put:
 	pm_runtime_dont_use_autosuspend(spi_imx->dev);
-	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(spi_imx->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 
 	clk_disable_unprepare(spi_imx->clk_ipg);
 out_put_per:
-- 
2.43.0



