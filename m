Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB79236A73;
	Tue, 17 Jun 2025 16:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178637; cv=none; b=Jl+Ly+5mmPsyDE9hExYym7fyILv7uFZpT8biZ9jjxTlMt+V3AvjKFxtunj6+9h+PiJ20yChpvLajzTZzXXC+mEPoClEVf+CQP81y9rZ2zFQ8Hx9QNBwDB5pyJkYKgHJf7W9NtHHu+YS+C8EMvWFVWej+Cgpg8bj3SE5G1r8PonQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178637; c=relaxed/simple;
	bh=1xeNF0hrjLqpazJHVC5jqNxKqNwJ2impdaZ7VMXJc6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtQtWtf/Snqex1Wukg9+Ukv9Voj+slBuMj/kOHPGBX2tVLmWP0Bw07doIElMoOTxlb+EOzxBIlVEYTqT9VKAuGqhHf5RemIm8fLpaPDIFUlVw0QwBEn6c3XrqHwNoI6QqTRRSwvnsftmarvK/L8E4cwWXzUbCCta7MY2F6FrQd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBx9WZUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBx9WZUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B84FC4CEE3;
	Tue, 17 Jun 2025 16:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178636;
	bh=1xeNF0hrjLqpazJHVC5jqNxKqNwJ2impdaZ7VMXJc6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBx9WZUcDfDFi+jdSyrUlmqgq7di137gmZsmKYqwEjrJ8DFGi0Dc9/k3j7OTTxp/2
	 W4fZIIGGMnkGtymWQMvDsj/lzbHs4Fyxo2JL5nZxeQhT2/Dc1sAKStmJ7Kq6uBwmv0
	 Kn9L52a2yjS9FrRfJ7TiiF6lmskYLvfzCjgXdmUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Nathan Lynch <nathan.lynch@amd.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 506/780] dmaengine: ti: Add NULL check in udma_probe()
Date: Tue, 17 Jun 2025 17:23:34 +0200
Message-ID: <20250617152512.112722293@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index b6255c0601bb2..aa2dc762140f6 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -5624,7 +5624,8 @@ static int udma_probe(struct platform_device *pdev)
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



