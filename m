Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1326B515899;
	Wed, 30 Sep 2026 16:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784511; cv=none; b=WrVF5+kdlzIrTQBzb70HUGDyk6XIKQYgSuXzDWpnwUI0XTSVWk/NOZv0kQgFDfRvCSEv/dK0ZcXdRFT0/q3RzPi2iZNI0/37VCEm9uGl/s9VJwNbpbgspKKT3knsbgIDa76TSe1EzE/iwBRIjdvIlC7tem3wbsg5uuxFcwZv1ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784511; c=relaxed/simple;
	bh=PAJrknLKRGP3V2GGx+llj71i7An9ua+wehFXY0JodOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cO8JF8THNdsHMqhuy4aKMvWBKjD2aRN1m30yY/VXLWmyt9yMiRXOCCnOwmcWyvvyjuRBFPgBdx2QbvUtedEANkz3RAenp0S2dhnL70jsNC9XmFZpbBv06WwOFYUTgFtHI3JBAopPP67Jgbz3cOoPWBlW3FinwKYrtDjJq/hiKQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=og38jggc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="og38jggc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B921F00893;
	Wed, 30 Sep 2026 16:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784502;
	bh=mk8dCDaSndN9QLt2DjtF8y7Cs+LIiBGG/yIB4dPgIck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=og38jggc/GcR4YBmVnzdam901T5VdmU30NT9fvuxKsAlQ4lfffCYrutyR5/AcuYuX
	 R45ShlFHXNkHjwngQqAxJ5x96y3+TFNv7O/AV6MYkzvM7nF0r+NNIkI1DjHfOeFQoV
	 Dw7yBbV4irRi7LX/79FT5kJr7gFoKN5WlF+Ccj4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tze Yee Ng <tze.yee.ng@altera.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 179/982] dmaengine: dw-axi-dmac: fix PM for system sleep and channel alloc
Date: Wed, 30 Sep 2026 17:15:15 +0200
Message-ID: <20260930152420.658968491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 46b080941b621..d313db5379f8c 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -464,11 +464,17 @@ static void dw_axi_dma_synchronize(struct dma_chan *dchan)
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
 
@@ -479,12 +485,11 @@ static int dma_chan_alloc_chan_resources(struct dma_chan *dchan)
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
 
@@ -1548,6 +1553,8 @@ static int dw_remove(struct platform_device *pdev)
 }
 
 static const struct dev_pm_ops dw_axi_dma_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
 	SET_RUNTIME_PM_OPS(axi_dma_runtime_suspend, axi_dma_runtime_resume, NULL)
 };
 
-- 
2.53.0



