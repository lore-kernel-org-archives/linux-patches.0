Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAA7353A70;
	Sat, 12 Sep 2026 08:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200264; cv=none; b=dgMevPQn9Sx3XyVWapsR8AT4X6EN2Sn1ll2cxqX+I5g/3bR5HDAP+3Y6qBp8MTuELhFFv0oLXS5LF7fLie7nNL530fCrHqH8jL8wLuFt5u9pHFp+DOq4xnembDHYMRr1nBttaw+dxwREXSiGHqAtZBTf6JFhx3GcVhwHR8MxhpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200264; c=relaxed/simple;
	bh=5BtEXzpG9HikYRB7+knyYloQW122ZMMBXupkz+FAitE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYAUOm+UKxGKXSPJnnOQgXyvE6/237o926vum/l1EZcfl00iwl3mjatK4urRGGo7GSjKXKc0xgO0HMJaFXrJN1Nsg1rZksLIwNZhZ5na9bAeS3GUkoxrAdU4YQdxvC0aiviOPO906/4DSKGcriM7AxA2fA8dEI6IVTn95aU9h8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5Y61BGY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5Y61BGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34741F000FF;
	Sat, 12 Sep 2026 08:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200262;
	bh=hsThDvsG5Yi6MuRtp7Rj2sFILHOhoXM9FvCpCUjMcAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5Y61BGYc0fErP9aUzGoKAeYEn/0CnpltyOy/jxKbscbXKJfazMAxyMCjKBI18pt+
	 W5Mc8ddIvt8nJhGa04FJZt3h8MyNw06a0MKAmo0q7FFJnbU2qjL1apk0OewsK9xyMT
	 cN3B+StZ+LpZitiZ0uX1o2dGjNGAczqcpqP0FW/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Alain Volmat <alain.volmat@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0754/1815] media: stm32: dcmi: fix some error handling bugs in probe()
Date: Sat, 12 Sep 2026 08:41:44 +0200
Message-ID: <20260912065706.608249622@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit f1d1ed39ced825615aeac61f0b6a322178756632 ]

There are a few issues here:

1) After we assign:
        chan = dma_request_chan(&pdev->dev, "tx");
   Then the error paths need to clean up before returning.  The first
   error path does a direct return.
2) The error paths check "dcmi->mdma_chan" but that is not assigned
   until later so it results in memory leaks.  Test "mdma_chan"
   instead.
3) The error handling calls dma_release_channel(dcmi->dma_chan) before
   "dcmi->dma_chan" has been assigned which leads to a NULL pointer
   dereference.  Use the "chan" variable instead.

I also moved the call to dma_release_channel() after the call to
dma_release_channel() so it mirrors the allocation code better.

Fixes: bc901885fae0 ("media: stm32: dcmi: perform dmaengine_slave_config at probe")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/st/stm32/stm32-dcmi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/st/stm32/stm32-dcmi.c b/drivers/media/platform/st/stm32/stm32-dcmi.c
index a6911a3349713..fc5acd5dbe7aa 100644
--- a/drivers/media/platform/st/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/st/stm32/stm32-dcmi.c
@@ -2024,8 +2024,10 @@ static int dcmi_probe(struct platform_device *pdev)
 	mdma_chan = dma_request_chan(&pdev->dev, "mdma_tx");
 	if (IS_ERR(mdma_chan)) {
 		ret = PTR_ERR(mdma_chan);
-		if (ret != -ENODEV)
-			return dev_err_probe(&pdev->dev, ret, "Failed to request MDMA channel\n");
+		if (ret != -ENODEV) {
+			dev_err_probe(&pdev->dev, ret, "Failed to request MDMA channel\n");
+			goto err_release_chan;
+		}
 		mdma_chan = NULL;
 	}
 
@@ -2208,12 +2210,13 @@ static int dcmi_probe(struct platform_device *pdev)
 err_media_device_cleanup:
 	media_device_cleanup(&dcmi->mdev);
 err_mdma_slave_config:
-	if (dcmi->mdma_chan)
+	if (mdma_chan)
 		gen_pool_free(dcmi->sram_pool, (unsigned long)dcmi->sram_buf, dcmi->sram_buf_size);
 err_dma_slave_config:
-	dma_release_channel(dcmi->dma_chan);
-	if (dcmi->mdma_chan)
+	if (mdma_chan)
 		dma_release_channel(mdma_chan);
+err_release_chan:
+	dma_release_channel(chan);
 
 	return ret;
 }
-- 
2.53.0



