Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73D52E414;
	Mon, 30 Dec 2024 15:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574082; cv=none; b=SI4auShEogMM9e3s16lnlSMaFgSdFTjtNwLw+5Q1LJvQZBrVv51bPbqwaJ03CHB6KEE2Ol9YixV6NIAku5125+sCUDS05ocpTxPFcTUuSnDgiHe8JTOo/glvyewz4FDU9iYStP7wTqbV0jDKaWpFi0RrOI3RW5uNT6xzhJP1r/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574082; c=relaxed/simple;
	bh=GQiKbwIauiIXP6mTLObBPag2090l91df87irG5w5N3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IO1hgE6w8fhp8pCfu7nX780YzrlNBgO0q5STC4wsnAK3Kg8iZIZfq5iaIADdgJySfxHlGKLuzYMW4UvoM2vpBjJbMN1sTHuX+hfWaMKM3JKI+XT3uEtPRoPVHvOuTpOcaE5zuypD7XPF4sPsRj+ZanWYBsTQ7HG02QusAP71MW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RkkXiS1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkkXiS1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F0AC4CED0;
	Mon, 30 Dec 2024 15:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574082;
	bh=GQiKbwIauiIXP6mTLObBPag2090l91df87irG5w5N3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkkXiS1RFhkzJr8MQS9hd0Yk4FoUmy7v+ydyheI0gna9YRr+LMqLpSt5ed2S1qJH5
	 13CEAZljF4CI1pTh1AVbV3iCD4eyEb3EScx/llnub1yfq9TDJkHjUr0MZlhoW8luY4
	 mWlOGM/r7qtWAbcBXHQzWXZKPIyCLUHOaSYwdCPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 032/114] dmaengine: fsl-edma: implement the cleanup path of fsl_edma3_attach_pd()
Date: Mon, 30 Dec 2024 16:42:29 +0100
Message-ID: <20241230154219.300675251@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit ccfa3131d4a0347988e73638edea5c8281b6d2c7 upstream.

Current implementation of fsl_edma3_attach_pd() does not provide a
cleanup path, resulting in a memory leak. For example,
dev_pm_domain_detach() is not called after dev_pm_domain_attach_by_id(),
and the device link created with the DL_FLAG_STATELESS is not released
explicitly.

Therefore, provide a cleanup function fsl_edma3_detach_pd() and call it
upon failure. Also add a devm_add_action_or_reset() call with this
function after a successful fsl_edma3_attach_pd().

Fixes: 72f5801a4e2b ("dmaengine: fsl-edma: integrate v3 support")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://lore.kernel.org/r/20241221075712.3297200-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/fsl-edma-common.h |    1 +
 drivers/dma/fsl-edma-main.c   |   41 ++++++++++++++++++++++++++++++++++++-----
 2 files changed, 37 insertions(+), 5 deletions(-)

--- a/drivers/dma/fsl-edma-common.h
+++ b/drivers/dma/fsl-edma-common.h
@@ -166,6 +166,7 @@ struct fsl_edma_chan {
 	struct work_struct		issue_worker;
 	struct platform_device		*pdev;
 	struct device			*pd_dev;
+	struct device_link		*pd_dev_link;
 	u32				srcid;
 	struct clk			*clk;
 	int                             priority;
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -417,10 +417,33 @@ static const struct of_device_id fsl_edm
 };
 MODULE_DEVICE_TABLE(of, fsl_edma_dt_ids);
 
+static void fsl_edma3_detach_pd(struct fsl_edma_engine *fsl_edma)
+{
+	struct fsl_edma_chan *fsl_chan;
+	int i;
+
+	for (i = 0; i < fsl_edma->n_chans; i++) {
+		if (fsl_edma->chan_masked & BIT(i))
+			continue;
+		fsl_chan = &fsl_edma->chans[i];
+		if (fsl_chan->pd_dev_link)
+			device_link_del(fsl_chan->pd_dev_link);
+		if (fsl_chan->pd_dev) {
+			dev_pm_domain_detach(fsl_chan->pd_dev, false);
+			pm_runtime_dont_use_autosuspend(fsl_chan->pd_dev);
+			pm_runtime_set_suspended(fsl_chan->pd_dev);
+		}
+	}
+}
+
+static void devm_fsl_edma3_detach_pd(void *data)
+{
+	fsl_edma3_detach_pd(data);
+}
+
 static int fsl_edma3_attach_pd(struct platform_device *pdev, struct fsl_edma_engine *fsl_edma)
 {
 	struct fsl_edma_chan *fsl_chan;
-	struct device_link *link;
 	struct device *pd_chan;
 	struct device *dev;
 	int i;
@@ -436,15 +459,16 @@ static int fsl_edma3_attach_pd(struct pl
 		pd_chan = dev_pm_domain_attach_by_id(dev, i);
 		if (IS_ERR_OR_NULL(pd_chan)) {
 			dev_err(dev, "Failed attach pd %d\n", i);
-			return -EINVAL;
+			goto detach;
 		}
 
-		link = device_link_add(dev, pd_chan, DL_FLAG_STATELESS |
+		fsl_chan->pd_dev_link = device_link_add(dev, pd_chan, DL_FLAG_STATELESS |
 					     DL_FLAG_PM_RUNTIME |
 					     DL_FLAG_RPM_ACTIVE);
-		if (!link) {
+		if (!fsl_chan->pd_dev_link) {
 			dev_err(dev, "Failed to add device_link to %d\n", i);
-			return -EINVAL;
+			dev_pm_domain_detach(pd_chan, false);
+			goto detach;
 		}
 
 		fsl_chan->pd_dev = pd_chan;
@@ -455,6 +479,10 @@ static int fsl_edma3_attach_pd(struct pl
 	}
 
 	return 0;
+
+detach:
+	fsl_edma3_detach_pd(fsl_edma);
+	return -EINVAL;
 }
 
 static int fsl_edma_probe(struct platform_device *pdev)
@@ -544,6 +572,9 @@ static int fsl_edma_probe(struct platfor
 		ret = fsl_edma3_attach_pd(pdev, fsl_edma);
 		if (ret)
 			return ret;
+		ret = devm_add_action_or_reset(&pdev->dev, devm_fsl_edma3_detach_pd, fsl_edma);
+		if (ret)
+			return ret;
 	}
 
 	if (drvdata->flags & FSL_EDMA_DRV_TCD64)


