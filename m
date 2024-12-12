Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C21222D62;
	Thu, 12 Dec 2024 17:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023533; cv=none; b=JSOv2AhZiB6O1nVGeB3fxmH4KdrKQGbkz6O+G1zJ+/JansIzzeXBcK0mM3pCt4gQkIyL9zOmwvuRucIXI2cvLCSTGbYr5Mmh72/y2MqoLWHZdOw78t9fDB1qD6OWlYE36U8JdhIHrOfWkCiNhU64y33zjaBysHapCzwzqyifh28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023533; c=relaxed/simple;
	bh=pt7mVEovaL36Kn+UuWrxFAYdd6gW1NwUraD+awE7dmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sAHGfXSzm2SvTnWuBa/Uv53U+fov/8T2lBJWbkhaWIEaiXf26fOYDlXxdKY8bogEbQxxxPq2c7ixSoRXY+n+3AVVWWhHLR3c2MEu8Ew+Ym7YHH0paV7FxYXm802bNwebxAVmxB1f/901hWCsX6imRTg+7QxpUb1fdzlgUQTLH+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJirw5d+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJirw5d+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66397C4CED0;
	Thu, 12 Dec 2024 17:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023532;
	bh=pt7mVEovaL36Kn+UuWrxFAYdd6gW1NwUraD+awE7dmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJirw5d+0ZnGIqtSoilPfajuo60F1hL0KAK368kkuaPycQn1EcBzFlv23PhoGaMFd
	 CAjfRI3KiPBLsHIL/ut/kXI2lYFmoToUbfVwW3YKV9fQCZZhvLZqf0qMgGCtRWhEvz
	 6DqgsFHoUvi1KwBX8kHbaETDSNPzD1VhDrdjvAL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy-ld Lu <andy-ld.lu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 547/565] mmc: mtk-sd: Fix error handle of probe function
Date: Thu, 12 Dec 2024 16:02:22 +0100
Message-ID: <20241212144333.477850486@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Andy-ld Lu <andy-ld.lu@mediatek.com>

commit 291220451c775a054cedc4fab4578a1419eb6256 upstream.

In the probe function, it goes to 'release_mem' label and returns after
some procedure failure. But if the clocks (partial or all) have been
enabled previously, they would not be disabled in msdc_runtime_suspend,
since runtime PM is not yet enabled for this case.

That cause mmc related clocks always on during system suspend and block
suspend flow. Below log is from a SDCard issue of MT8196 chromebook, it
returns -ETIMEOUT while polling clock stable in the msdc_ungate_clock()
and probe failed, but the enabled clocks could not be disabled anyway.

[  129.059253] clk_chk_dev_pm_suspend()
[  129.350119] suspend warning: msdcpll is on
[  129.354494] [ck_msdc30_1_sel : enabled, 1, 1, 191999939,   ck_msdcpll_d2]
[  129.362787] [ck_msdcpll_d2   : enabled, 1, 1, 191999939,         msdcpll]
[  129.371041] [ck_msdc30_1_ck  : enabled, 1, 1, 191999939, ck_msdc30_1_sel]
[  129.379295] [msdcpll         : enabled, 1, 1, 383999878,          clk26m]

Add a new 'release_clk' label and reorder the error handle functions to
make sure the clocks be disabled after probe failure.

Fixes: ffaea6ebfe9c ("mmc: mtk-sd: Use readl_poll_timeout instead of open-coded polling")
Fixes: 7a2fa8eed936 ("mmc: mtk-sd: use devm_mmc_alloc_host")
Signed-off-by: Andy-ld Lu <andy-ld.lu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: stable@vger.kernel.org
Message-ID: <20241107121215.5201-1-andy-ld.lu@mediatek.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/mtk-sd.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/mmc/host/mtk-sd.c
+++ b/drivers/mmc/host/mtk-sd.c
@@ -2612,7 +2612,7 @@ static int msdc_drv_probe(struct platfor
 	ret = msdc_ungate_clock(host);
 	if (ret) {
 		dev_err(&pdev->dev, "Cannot ungate clocks!\n");
-		goto release_mem;
+		goto release_clk;
 	}
 	msdc_init_hw(host);
 
@@ -2622,14 +2622,14 @@ static int msdc_drv_probe(struct platfor
 					     GFP_KERNEL);
 		if (!host->cq_host) {
 			ret = -ENOMEM;
-			goto host_free;
+			goto release;
 		}
 		host->cq_host->caps |= CQHCI_TASK_DESC_SZ_128;
 		host->cq_host->mmio = host->base + 0x800;
 		host->cq_host->ops = &msdc_cmdq_ops;
 		ret = cqhci_init(host->cq_host, mmc, true);
 		if (ret)
-			goto host_free;
+			goto release;
 		mmc->max_segs = 128;
 		/* cqhci 16bit length */
 		/* 0 size, means 65536 so we don't have to -1 here */
@@ -2654,9 +2654,10 @@ static int msdc_drv_probe(struct platfor
 end:
 	pm_runtime_disable(host->dev);
 release:
-	platform_set_drvdata(pdev, NULL);
 	msdc_deinit_hw(host);
+release_clk:
 	msdc_gate_clock(host);
+	platform_set_drvdata(pdev, NULL);
 release_mem:
 	if (host->dma.gpd)
 		dma_free_coherent(&pdev->dev,


