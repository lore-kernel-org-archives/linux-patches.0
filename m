Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26F843ACA
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTiTjbde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF44C433C7;
	Wed, 15 Nov 2023 22:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085829;
	bh=CH6Fw4Hw859ddi6BOTQP3Ir2aZT/0/Sy253xeaW06Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTiTjbderz61b64an/XEEMjKtmCyzos/fIVFeqdLXstQuITcGV8v0aGBml0Oco09i
	 mD/s94S/QCSgBxN0DbYWBTNfjuybsNwkQrEenoj3UWWaGnbwxHBTFVKJMkuwSz1c9X
	 q9i/9oMdMRn9ttQXfF9N7bSc0KPJ4Q+Sc+N7aBSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 074/119] dmaengine: ti: edma: handle irq_of_parse_and_map() errors
Date: Wed, 15 Nov 2023 17:01:04 -0500
Message-ID: <20231115220134.937706922@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 14f6d317913f634920a640e9047aa2e66f5bdcb7 ]

Zero is not a valid IRQ for in-kernel code and the irq_of_parse_and_map()
function returns zero on error.  So this check for valid IRQs should only
accept values > 0.

Fixes: 2b6b3b742019 ("ARM/dmaengine: edma: Merge the two drivers under drivers/dma/")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/f15cb6a7-8449-4f79-98b6-34072f04edbc@moroto.mountain
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/edma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ti/edma.c b/drivers/dma/ti/edma.c
index 80b780e499711..b570f08888eeb 100644
--- a/drivers/dma/ti/edma.c
+++ b/drivers/dma/ti/edma.c
@@ -2361,7 +2361,7 @@ static int edma_probe(struct platform_device *pdev)
 	if (irq < 0 && node)
 		irq = irq_of_parse_and_map(node, 0);
 
-	if (irq >= 0) {
+	if (irq > 0) {
 		irq_name = devm_kasprintf(dev, GFP_KERNEL, "%s_ccint",
 					  dev_name(dev));
 		ret = devm_request_irq(dev, irq, dma_irq_handler, 0, irq_name,
@@ -2377,7 +2377,7 @@ static int edma_probe(struct platform_device *pdev)
 	if (irq < 0 && node)
 		irq = irq_of_parse_and_map(node, 2);
 
-	if (irq >= 0) {
+	if (irq > 0) {
 		irq_name = devm_kasprintf(dev, GFP_KERNEL, "%s_ccerrint",
 					  dev_name(dev));
 		ret = devm_request_irq(dev, irq, dma_ccerr_handler, 0, irq_name,
-- 
2.42.0



