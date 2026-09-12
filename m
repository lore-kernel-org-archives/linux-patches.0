Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231D33750CB;
	Sat, 12 Sep 2026 08:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200052; cv=none; b=jIptpom/s1YbMGxzje6wx9Bmon8P+vwIaPhA0vFJFOcAQ/EboSoslUtRmK40ezl/WpQTt/gs+JBkgWSiwM7TCJKcyDkeNwq4Mp8SKbxnBrVIA+RVdhMUjlnxNc49BE18HOysHkKZbsKyfFD7+fzWBLg5k/L0QdL3Y1/oeYDfDGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200052; c=relaxed/simple;
	bh=GRAbvFo+pKXbUpJfsfDCZ2UA+X1VY6cT/quqIT/Zb2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+O3x4XIOYGITPrwIhxPGc4jn1kiaJYtlk0frxuZ9jF6JQtUauWqaung4z45g+Rs7++B3t//k+czmqUSTnryoiXqzfBBbUcnl+4kbC74FY0NIl4TCTagh5/jrSEmVQW9GxMZUuJRepb1+9hj8XWJgKQDcjnRIdt2D3Hw58qiE7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iJOFmPQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iJOFmPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8DD81F000FF;
	Sat, 12 Sep 2026 08:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200051;
	bh=3R/GvigLxwWB/Ll0QsLYpcw3Oy6KHng6Xln5LWSrO9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2iJOFmPQq9l3G1JabhMWGfyHUnnnwi8aJNAGQOZriOOKPaYTBS/50ixRLf6BY1xES
	 YwDf3ppnGmXVvnEeDIC/rVce/gAlY7+h/+7M7UCYOdCrmqdYq5D2QmxOkXSTf7GXAg
	 q2g9rBZVHdPICX0x9n5NRevUoiRXg+8JZtoUa+t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0711/1815] media: stm32: dcmi: fix error handling on MDMA pool alloc failure
Date: Sat, 12 Sep 2026 08:41:01 +0200
Message-ID: <20260912065705.585575503@linuxfoundation.org>
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

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit 1bc5946763067d5b8dde2e5c11d7a7ddb89c8937 ]

Properly return an error if of_gen_pool_get or gen_pool_dma_zalloc
fails during the chained DMA probing.

Fixes: 87ebce19aa03 ("media: stm32: dcmi: addition of DMA-MDMA chaining support")
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/st/stm32/stm32-dcmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/st/stm32/stm32-dcmi.c b/drivers/media/platform/st/stm32/stm32-dcmi.c
index eeb0199864dd1..a6911a3349713 100644
--- a/drivers/media/platform/st/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/st/stm32/stm32-dcmi.c
@@ -2050,6 +2050,7 @@ static int dcmi_probe(struct platform_device *pdev)
 		dcmi->sram_pool = of_gen_pool_get(pdev->dev.of_node, "sram", 0);
 		if (!dcmi->sram_pool) {
 			dev_info(&pdev->dev, "No SRAM pool, can't use MDMA chaining\n");
+			ret = -ENOMEM;
 			goto err_dma_slave_config;
 		}
 
@@ -2061,6 +2062,7 @@ static int dcmi_probe(struct platform_device *pdev)
 						     &dcmi->sram_dma_buf);
 		if (!dcmi->sram_buf) {
 			dev_err(dcmi->dev, "Failed to allocate from SRAM\n");
+			ret = -ENOMEM;
 			goto err_dma_slave_config;
 		}
 
-- 
2.53.0



