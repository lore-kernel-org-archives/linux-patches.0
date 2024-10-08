Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4721DE4CD;
	Tue,  8 Oct 2024 13:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393565; cv=none; b=ekwwLJLOrG0ccRSPBTMHxjxCMlg778WznQvM+eC3sHzE4YmuxaSDdSQfs/pTWrSmPRL192kRuTJgdLCNxe0jTxQutQDAGJ4axXEkRK3O3CXT3mI6Bz6mSGUwsPCjwyEbd6NqhJyg8uzTGJSf+nUjlWdehFZonPiP2t8+a8n1lHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393565; c=relaxed/simple;
	bh=914+aOZ4B8g+5sXHzfee8MlAoPHg/vAdN09lF4nfxnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGWAtfXy3YueG0OXOUeua+vl3v5iBfKvS0alZ/JYmJ453cIXBhOy5Q9UPP/oI8p+qep5uErl7j/sQo015piTzViY7A1X0SUkA0OY9NYtdlYyZw6/8T9LmduAf8GDssBzmV0+CLggoCd76mLFVhziF7rnwhXKCfaVeMoxagdeGA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=047F3gpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="047F3gpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44B7C4CEC7;
	Tue,  8 Oct 2024 13:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393565;
	bh=914+aOZ4B8g+5sXHzfee8MlAoPHg/vAdN09lF4nfxnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=047F3gpqiao/W080Y/brScRZ+IlV4XZ/7rToMMf6/Rme+Hj2BpEON6bNt5kR99HhD
	 hQtw/degUbNb/3oroVdkp0GxGHVj45HI6cJ77W3hK70AOtZDdEvOsdcvhbDowRdzIg
	 Kf9ar9C5843BKQuEqBPXqAbVAB5gDStoTBGeWHCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/386] spi: spi-cadence: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Tue,  8 Oct 2024 14:07:13 +0200
Message-ID: <20241008115636.809384185@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 67d4a70faa662df07451e83db1546d3ca0695e08 ]

It is not valid to call pm_runtime_set_suspended() for devices
with runtime PM enabled because it returns -EAGAIN if it is enabled
already and working. So, call pm_runtime_disable() before to fix it.

Fixes: d36ccd9f7ea4 ("spi: cadence: Runtime pm adaptation")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240923040015.3009329-3-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index e5140532071d2..316da99f798c8 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -665,8 +665,8 @@ static int cdns_spi_probe(struct platform_device *pdev)
 
 clk_dis_all:
 	if (!spi_controller_is_target(ctlr)) {
-		pm_runtime_set_suspended(&pdev->dev);
 		pm_runtime_disable(&pdev->dev);
+		pm_runtime_set_suspended(&pdev->dev);
 	}
 remove_ctlr:
 	spi_controller_put(ctlr);
@@ -688,8 +688,8 @@ static void cdns_spi_remove(struct platform_device *pdev)
 
 	cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
 
-	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
 
 	spi_unregister_controller(ctlr);
 }
-- 
2.43.0



