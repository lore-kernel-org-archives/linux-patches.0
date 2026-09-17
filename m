Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27BA3A5E84;
	Thu, 17 Sep 2026 17:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664541; cv=none; b=MsdwJ5L8psUU8ZYutMLxCTzliVhTdwlEg/TiovbSV9rfJ1LEwI+zjv8GKzffoGdswwMsu4lLQ4Y3sDt+XGkFVqPOl11k4GXGZNZG6rx/o0ixhRuHTrHlBQiUZ3PB+IaBDVmFmkmM/4QZVXAiZ/6zvy8vzujda0AvQajwuDY0Fwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664541; c=relaxed/simple;
	bh=weH28EFDJwkOpHVYym7NnToAqzSyGUMaGlbjy4e1rdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8BPENeaeuIegYdiek3oi7XZ2cB5q/wQoHu5BK5Qw9AtyicKuG/kyHC1SIYq8alhkHCWDqYZVqcwe7k4Hb9/DMwo8+LOHgvlzYHwmRKBhdKCBqamQOf4o+8drv3X78XjHkCpig1iM+N37vYnMgnRVG3+gdyDsrmv35YgdbSSK1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RSVMwbd+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RSVMwbd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042F61F00893;
	Thu, 17 Sep 2026 17:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664540;
	bh=PHKdn72zFk9wDcZh9Fw5TxT4Igm8ZSk2hq20iLDKvGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RSVMwbd+wUuxQmr9NCPXOXDjsgjHZ+h8ihpJo1hIH6kDoWnHHc7I4Q71GQvfMzmpB
	 ZaRZmPa5aTL5UmDmEws2a51JVgFOG6KCMsx5vLAe+qa4Z9RWfgGeYvINgGnXk4WFFc
	 AFO2uMJxJUrcpOr+mGc9ksc6cZ//waifxx3JJlNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tze Yee Ng <tze.yee.ng@altera.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0389/1250] dmaengine: dw-axi-dmac: fix PM for system sleep and channel alloc
Date: Thu, 17 Sep 2026 16:03:04 +0100
Message-ID: <20260917151602.581027236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b0e689f48bb67..ea4e47ee0d710 100644
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



