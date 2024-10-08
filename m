Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EE61DE4CC;
	Tue,  8 Oct 2024 13:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393558; cv=none; b=gMjCQ1Vk0MepTAKBwB9Tjyc7BMjx2pP5jpHC65nm+UUiUH29kx/ZlxLXDxUXnFYYKThsprxNFykk3pl8X4gC1hSOuSXSfGDzvD8RLD0GKwDue0W/5bMekrfK82dIG+1Oacif9UlHvJC1LWDp6+hKkwa7WPOIcJPmmvkGByHh9l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393558; c=relaxed/simple;
	bh=jUt4FhE8ABsXGWI4pAukQvaBvZRutWcFwk3f5GILmok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jrxu9+WYeJ7YM6S7s/fVTyn//39GG738qyPtqpn3+HdlpSUfoEuCexH2ZmnOmK5tpjAwYe+xCJgFCtB3td+ajV/cFkYaKv9crf1VAkFHaKiV+sOOQ6QmvnQ6bzbfwx8D4Tc6X6ZmmJQv69h4OShStjZDeU2Cn6kTv5bl3mKeYBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15otroy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15otroy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38EFC4CECC;
	Tue,  8 Oct 2024 13:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393558;
	bh=jUt4FhE8ABsXGWI4pAukQvaBvZRutWcFwk3f5GILmok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15otroy4UEM3Mw4QVD6lgcWBRg6Eq0t1bXpVp5t/OViO+PhcMMDW7u83cz9fA6cFT
	 WkoxTlVdd2cQ7Djjyags/zRzd+hdj42j1jAVVZ86F+N+BWmmbo5QhS5lIptt1il2y0
	 /NsmBGR9lZA3xe9EVLKh00n+1q5OkzFChdZo4mjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 186/386] spi: spi-imx: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Tue,  8 Oct 2024 14:07:11 +0200
Message-ID: <20241008115636.731001721@linuxfoundation.org>
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
index 006860ee03ca0..daa32bde61556 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1870,8 +1870,8 @@ static int spi_imx_probe(struct platform_device *pdev)
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



