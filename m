Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86902472AF;
	Mon, 23 Jun 2025 13:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686220; cv=none; b=VPxo8LjbtggWEJnXjuvOut+SfygZRLDrKFlOwdB8Syj66BS+cv9Q6RXvMDxcOmEZYGfNToxAomAgTG75ovpmIZyiJAVLpmElEOIWAur7wn4CJc7ifulnrBQoFNqtjwx2eM5wkUZ3MYqxQGY0JWWGV4J9llodEF/uiZvP8Fy4WvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686220; c=relaxed/simple;
	bh=2zmzCXy9avrhcvjaObcILQjGUTTuLjFnozqzViL3pLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aR0jKKftclQOnY52gY1kiB3XwBJGeA6Asx8KlIPQQlDLDGqVQiUHXZx0FTXWNx0OdYXFVqbjLw1h+L+suQvHdseKswdn2BfCPqXRyYQ3yYX7j8hijC2SX0nD0LDSwt3HE3m9us7nsuFZ/TF3xvE36/mVcBUbaTgMlrnL8Mb8yFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKGl4zTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKGl4zTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C05C4CEEA;
	Mon, 23 Jun 2025 13:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686220;
	bh=2zmzCXy9avrhcvjaObcILQjGUTTuLjFnozqzViL3pLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKGl4zTyf0LSrBTvlhNZu5yeoai4PJzmk1tiL8NDolWiFdcDfSVApHtLxy4JPXp+H
	 omrdwRCQ0l1o0XUXBdvpQIPL2CgD7fvNoSAE5wxqhROWj9o6o/xB6HwtUAQJOijlMg
	 kaGmPqtirWM6uQXPWKTT7dIBLfLn8iVVxqMyhsxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Nathan Lynch <nathan.lynch@amd.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/411] dmaengine: ti: Add NULL check in udma_probe()
Date: Mon, 23 Jun 2025 15:04:09 +0200
Message-ID: <20250623130636.157280162@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit fd447415e74bccd7362f760d4ea727f8e1ebfe91 ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
udma_probe() does not check for this case, which results in a NULL
pointer dereference.

Add NULL check after devm_kasprintf() to prevent this issue.

Fixes: 25dcb5dd7b7c ("dmaengine: ti: New driver for K3 UDMA")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Nathan Lynch <nathan.lynch@amd.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20250402023900.43440-1-bsdhenrymartin@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 1ca552a324778..ce5875a00f28d 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -5425,7 +5425,8 @@ static int udma_probe(struct platform_device *pdev)
 		uc->config.dir = DMA_MEM_TO_MEM;
 		uc->name = devm_kasprintf(dev, GFP_KERNEL, "%s chan%d",
 					  dev_name(dev), i);
-
+		if (!uc->name)
+			return -ENOMEM;
 		vchan_init(&uc->vc, &ud->ddev);
 		/* Use custom vchan completion handling */
 		tasklet_setup(&uc->vc.task, udma_vchan_complete);
-- 
2.39.5



