Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C9F1C7274;
	Tue, 15 Oct 2024 12:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993670; cv=none; b=iiE/uO3VunHID6v72Vru6MaUazURvQ1AZn0DFl0XxcwQX3OCZGGS0FU5lZciHRNU8c2cosNP1jUaoeLY0g9de0hRdYxI4iO7zZoyPrVQgkP5/xUCsPTTXI9j4UN2eqJAbU6/p0jwaJT+6l36BlXwmMvhc/UMxnzflh1oXYSSwb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993670; c=relaxed/simple;
	bh=70xiBDTfQH04Q5aTh5W8XvWNnv5W7Q3tEMzYudrC8qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNEe4gyMamlpS8C+wisCzb2/QGJVWVn3fMbADgI0ZUMwCZWC6MaOj8Ix9ylw8qud5BTS8rC2vRxE8v00GDrbB+omAZE9EtXSARNuscjFeY7elSULgD9q6VOyMU4LVHHhe5lkH+XiQzzHnngsMBN0AqJnUR8YRTPiGg9KYLiIpzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S60MAR8u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S60MAR8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8DCC4CEC6;
	Tue, 15 Oct 2024 12:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993670;
	bh=70xiBDTfQH04Q5aTh5W8XvWNnv5W7Q3tEMzYudrC8qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S60MAR8uH3ZhI/vn6XSYo+/bO1mn98rva3giItMcR29+6CSMV3B1owv5B+SeHUpTK
	 fhWodC38ZAFQ20AdWE/DW4idZIo7LZdmedUysGHUxSDg4FoQLC98DUeQ+0WmSkhajs
	 9Un6+X8/ejFPgt4agO6XoUANzrCYNAMY9dU6MZQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 479/691] spi: spi-imx: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Tue, 15 Oct 2024 13:27:07 +0200
Message-ID: <20241015112459.352679727@linuxfoundation.org>
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
index c806ee8070e5a..f22b867b8c8a9 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1761,8 +1761,8 @@ static int spi_imx_probe(struct platform_device *pdev)
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



