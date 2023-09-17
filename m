Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A6753B4
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C28AC433C7;
	Sun, 17 Sep 2023 19:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979274;
	bh=t4BSd2GEtYfygBlC/ZWM1pKxkLSrzA580agPmyYE7lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALNfNzOnMh4MM/+GguWBI5hWa3vYbi5hlWJCfTD56Q/2sDUutPm/Hs+lo6irqY2rE
	 MVSXMeB7MKUUiUCEft2T8jtovZiodQDGGi5C8ubLPdiPt+RflwONFSjZ7tfHEGbkQS
	 1a3rkaPhhS45xzl9KA/Jet7KK6oC4scuNkceJMfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruan Jinjie <ruanjinjie@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 265/406] dmaengine: ste_dma40: Add missing IRQ check in d40_probe
Date: Sun, 17 Sep 2023 21:11:59 +0200
Message-ID: <20230917191108.219336425@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ruanjinjie <ruanjinjie@huawei.com>

[ Upstream commit c05ce6907b3d6e148b70f0bb5eafd61dcef1ddc1 ]

Check for the return value of platform_get_irq(): if no interrupt
is specified, it wouldn't make sense to call request_irq().

Fixes: 8d318a50b3d7 ("DMAENGINE: Support for ST-Ericssons DMA40 block v3")
Signed-off-by: Ruan Jinjie <ruanjinjie@huawei.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230724144108.2582917-1-ruanjinjie@huawei.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index b35b97cb8fd25..d99fec8215083 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3598,6 +3598,10 @@ static int __init d40_probe(struct platform_device *pdev)
 	spin_lock_init(&base->lcla_pool.lock);
 
 	base->irq = platform_get_irq(pdev, 0);
+	if (base->irq < 0) {
+		ret = base->irq;
+		goto destroy_cache;
+	}
 
 	ret = request_irq(base->irq, d40_handle_interrupt, 0, D40_NAME, base);
 	if (ret) {
-- 
2.40.1



