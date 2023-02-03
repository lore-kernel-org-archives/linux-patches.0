Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBE01FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F7CC433D2;
	Fri,  3 Feb 2023 10:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419621;
	bh=qHVGKWz40xcyB0e9AaLwqgL438Tb2zBWiEAi4PrIKCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3nv3169r4FvVQGRluSZlH8qrlzUbInN89YW1DbVgkL0nh7YEfyh/x6l/5FvKu6Bo
	 JLDiTp8glUFmHPq5Om8T7ayoJs72Zom0o5Pnb7bGjIS8i1zeumAc4zVYbyLSZPJZm/
	 XhTrUC5kQe+oXwbXT3vt6+ron5LcgDvbdJDtvr8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Wang <hui.wang@canonical.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 63/80] dmaengine: imx-sdma: Fix a possible memory leak in sdma_transfer_init
Date: Fri,  3 Feb 2023 11:12:57 +0100
Message-Id: <20230203101017.921017113@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101015.263854890@linuxfoundation.org>
References: <20230203101015.263854890@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit 1417f59ac0b02130ee56c0c50794b9b257be3d17 ]

If the function sdma_load_context() fails, the sdma_desc will be
freed, but the allocated desc->bd is forgot to be freed.

We already met the sdma_load_context() failure case and the log as
below:
[ 450.699064] imx-sdma 30bd0000.dma-controller: Timeout waiting for CH0 ready
...

In this case, the desc->bd will not be freed without this change.

Signed-off-by: Hui Wang <hui.wang@canonical.com>
Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/20221130090800.102035-1-hui.wang@canonical.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/imx-sdma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 709ead443fc5..5794d3120bb8 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1347,10 +1347,12 @@ static struct sdma_desc *sdma_transfer_init(struct sdma_channel *sdmac,
 		sdma_config_ownership(sdmac, false, true, false);
 
 	if (sdma_load_context(sdmac))
-		goto err_desc_out;
+		goto err_bd_out;
 
 	return desc;
 
+err_bd_out:
+	sdma_free_bd(desc);
 err_desc_out:
 	kfree(desc);
 err_out:
-- 
2.39.0



