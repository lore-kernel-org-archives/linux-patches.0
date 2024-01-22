Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198206AA6;
	Tue, 23 Jan 2024 01:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974072; cv=none; b=L9RmEi40eXbV80O5cRAlUqz+hc+GQHAIdDISxWhGSbATChDr5xpfVNF/dMCZEh+XcW3HnT3yMok2yCn1EKKBexmRs2KA0sOyF1oCYG9J2HatZaoWVGGuuYg6sLUmge9wg5i3GpTufid8PSVuaVyVF3MalmTMYEfmNWuflG69rcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974072; c=relaxed/simple;
	bh=K/T8+aLoHHH01xsiYVUADmcC4KN2/VIM8yxH1yvkbh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3vihgb8CJncyDgE0UTlsgz73JxhVVhUu5ztjezuSoyhm4D2jqe8xKLMhHI9ToYbkkw/I4D9eMeqd1clJDfVsqaYD7XMWFmaW6lq2NUCP/8knlo2mWRgi/TKe4nx/XhHaZYOxJwyoX2IyLZDzTISpYqLnXTvjQCre/kiAojEyQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foqzr/gL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foqzr/gL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75844C43390;
	Tue, 23 Jan 2024 01:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974071;
	bh=K/T8+aLoHHH01xsiYVUADmcC4KN2/VIM8yxH1yvkbh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=foqzr/gL4Whv7BFSBABVfvLfBu1PE/C9YGPmdzvK+lUPe5USS/8MmMffazPcERF51
	 m/IcQkiPDSW11xJRLOFr+eUoO67I1tEkT2LQDphRz/9bS0W8vHrBpOf0CHw+QYhRiX
	 IunD6Ya9F7C1MraWPN/knZBEadbKJzj8ilD4+uwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/583] spi: cadence-quadspi: add missing clk_disable_unprepare() in cqspi_probe()
Date: Mon, 22 Jan 2024 15:51:18 -0800
Message-ID: <20240122235813.022604180@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 5cb475174cce1bfedf1025b6e235e2c43d81144f ]

cqspi_jh7110_clk_init() is called after clk_prepare_enable(cqspi->clk),
if it fails, it should goto label 'probe_reset_failed' to disable
cqspi->clk.

In the error path after calling cqspi_jh7110_clk_init(),
cqspi_jh7110_disable_clk() need be called.

Fixes: 33f1ef6d4eb6 ("spi: cadence-quadspi: Add clock configuration for StarFive JH7110 QSPI")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20231129081147.628004-1-yangyingliang@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-quadspi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-cadence-quadspi.c b/drivers/spi/spi-cadence-quadspi.c
index b50db71ac4cc..2064dc4ea935 100644
--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1825,7 +1825,7 @@ static int cqspi_probe(struct platform_device *pdev)
 		if (ddata->jh7110_clk_init) {
 			ret = cqspi_jh7110_clk_init(pdev, cqspi);
 			if (ret)
-				goto probe_clk_failed;
+				goto probe_reset_failed;
 		}
 
 		if (of_device_is_compatible(pdev->dev.of_node,
@@ -1872,6 +1872,8 @@ static int cqspi_probe(struct platform_device *pdev)
 probe_setup_failed:
 	cqspi_controller_enable(cqspi, 0);
 probe_reset_failed:
+	if (cqspi->is_jh7110)
+		cqspi_jh7110_disable_clk(pdev, cqspi);
 	clk_disable_unprepare(cqspi->clk);
 probe_clk_failed:
 	pm_runtime_put_sync(dev);
-- 
2.43.0



