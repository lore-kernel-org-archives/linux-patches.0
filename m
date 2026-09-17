Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8805E4FD261;
	Thu, 17 Sep 2026 18:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668032; cv=none; b=lkHN6VOBrdNIHCHL4hxBYeOUZjn2QBq/OZDBcy/l8XOP+LCFIFlmadPVf+C3MapdCkjV974r102aeZfJvF+3FHTVR+4tGqqbge6NZg01Kc5kZmjdpqS0hrpc+PwXmuqofkKCWNeCMQcPvnaxxSWoy7Xk8i9nNhR4C/K6+g+4tIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668032; c=relaxed/simple;
	bh=SUdNPiyo+pCPlRlMzCqMPvXTugJp/B1CE8JP/oJRMvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/9EdgeZf+we7zeNLh6jh693630VF8jiObed1Z82Mr5Qu9h6RPtx2x3VSgrXfBsOUrDSp+TLArzPyyJapC8mSpbrLafoMuuQCMb9v0pJTf4iz7rjIcTYaL1qaWFzeSbmthjQekyWLywCDiMBLNxevnKUgwd8jVMef9kVVwPzlLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUNaElZG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUNaElZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6ED1F000FF;
	Thu, 17 Sep 2026 18:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668030;
	bh=XCegzEccFonHFem1lWGV5H6PlpfVUWOD/LZC1yBErG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RUNaElZG0Q1KJ7frFw11gEckf/VYH5v0iqP2D8C6xHDX228XmOfxBDjM7x2hPfw+9
	 2Gz5Q3ugFC94N6EX3ReYMnhkhuqBh+JAWHifdLBHAO0XAkq2j4swjQPOMJhrgLLYfs
	 IUCsygj3FiSPz6C51yljbcF4IkEw377c6pm9I5HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tze Yee Ng <tze.yee.ng@altera.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0283/1102] dmaengine: dw-axi-dmac: fix PM for system sleep and channel alloc
Date: Thu, 17 Sep 2026 16:03:46 +0100
Message-ID: <20260917151546.718257688@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tze Yee Ng <tze.yee.ng@altera.com>

[ Upstream commit df0c2dc68770cf43f15df40b184df030b850ea05 ]

The driver only had runtime PM callbacks. If a channel stayed allocated
across system suspend/resume, the runtime usage count could remain
non-zero while hardware state (DMAC_CFG, clocks) was lost, and
axi_dma_runtime_resume() would not run to restore it.

Add system-sleep PM ops that use pm_runtime_force_suspend() and
pm_runtime_force_resume() so suspend/resume reuses the existing
axi_dma_suspend() and axi_dma_resume() paths.

Replace pm_runtime_get() with pm_runtime_resume_and_get() in
dma_chan_alloc_chan_resources() so clocks are enabled before a client
can immediately submit a transfer and touch MMIO.

Signed-off-by: Tze Yee Ng <tze.yee.ng@altera.com>
Link: https://patch.msgid.link/18bf778a3a1cc2f377ef8eb0d1508d8ac6371896.1779688569.git.tze.yee.ng@altera.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index adef111aca31e..eee37f3de0da3 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -516,11 +516,17 @@ static void dw_axi_dma_synchronize(struct dma_chan *dchan)
 static int dma_chan_alloc_chan_resources(struct dma_chan *dchan)
 {
 	struct axi_dma_chan *chan = dchan_to_axi_dma_chan(dchan);
+	int ret;
+
+	ret = pm_runtime_resume_and_get(chan->chip->dev);
+	if (ret < 0)
+		return ret;
 
 	/* ASSERT: channel is idle */
 	if (axi_chan_is_hw_enable(chan)) {
 		dev_err(chan2dev(chan), "%s is non-idle!\n",
 			axi_chan_name(chan));
+		pm_runtime_put(chan->chip->dev);
 		return -EBUSY;
 	}
 
@@ -531,12 +537,11 @@ static int dma_chan_alloc_chan_resources(struct dma_chan *dchan)
 					  64, 0);
 	if (!chan->desc_pool) {
 		dev_err(chan2dev(chan), "No memory for descriptors\n");
+		pm_runtime_put(chan->chip->dev);
 		return -ENOMEM;
 	}
 	dev_vdbg(dchan2dev(dchan), "%s: allocating\n", axi_chan_name(chan));
 
-	pm_runtime_get(chan->chip->dev);
-
 	return 0;
 }
 
@@ -1652,6 +1657,8 @@ static void dw_remove(struct platform_device *pdev)
 }
 
 static const struct dev_pm_ops dw_axi_dma_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
 	SET_RUNTIME_PM_OPS(axi_dma_runtime_suspend, axi_dma_runtime_resume, NULL)
 };
 
-- 
2.53.0



