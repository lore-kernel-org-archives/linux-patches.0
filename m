Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608359443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA15C433C8;
	Sun, 13 Aug 2023 21:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962239;
	bh=HQoPu4vPDZo5US+TpbT9lcOlZ+zKsoTKjnC/I46JQ+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwBp9oWCoqMDuYr40eMLouSadORYRsu7eXsMKQi4BI7pfMnOB1pmCIyto5qhJNAgf
	 89y/biEPtqgTBCLDfww9qBKtjxtGfFpo5kXxDW/vAMlUTR8dd6OXxW3Kv+RVYFEmkG
	 Dh3uvWQOJ8Bqid89kUat/199O5zfhECuWy6tHl30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.4 164/206] dmaengine: mcf-edma: Fix a potential un-allocated memory access
Date: Sun, 13 Aug 2023 23:18:54 +0200
Message-ID: <20230813211729.720654587@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 0a46781c89dece85386885a407244ca26e5c1c44 upstream.

When 'mcf_edma' is allocated, some space is allocated for a
flexible array at the end of the struct. 'chans' item are allocated, that is
to say 'pdata->dma_channels'.

Then, this number of item is stored in 'mcf_edma->n_chans'.

A few lines later, if 'mcf_edma->n_chans' is 0, then a default value of 64
is set.

This ends to no space allocated by devm_kzalloc() because chans was 0, but
64 items are read and/or written in some not allocated memory.

Change the logic to define a default value before allocating the memory.

Fixes: e7a3ff92eaf1 ("dmaengine: fsl-edma: add ColdFire mcf5441x edma support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/f55d914407c900828f6fad3ea5fa791a5f17b9a4.1685172449.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/mcf-edma.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/dma/mcf-edma.c
+++ b/drivers/dma/mcf-edma.c
@@ -190,7 +190,13 @@ static int mcf_edma_probe(struct platfor
 		return -EINVAL;
 	}
 
-	chans = pdata->dma_channels;
+	if (!pdata->dma_channels) {
+		dev_info(&pdev->dev, "setting default channel number to 64");
+		chans = 64;
+	} else {
+		chans = pdata->dma_channels;
+	}
+
 	len = sizeof(*mcf_edma) + sizeof(*mcf_chan) * chans;
 	mcf_edma = devm_kzalloc(&pdev->dev, len, GFP_KERNEL);
 	if (!mcf_edma)
@@ -202,11 +208,6 @@ static int mcf_edma_probe(struct platfor
 	mcf_edma->drvdata = &mcf_data;
 	mcf_edma->big_endian = 1;
 
-	if (!mcf_edma->n_chans) {
-		dev_info(&pdev->dev, "setting default channel number to 64");
-		mcf_edma->n_chans = 64;
-	}
-
 	mutex_init(&mcf_edma->fsl_edma_mutex);
 
 	mcf_edma->membase = devm_platform_ioremap_resource(pdev, 0);


