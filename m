Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804EF1CAA99;
	Thu, 17 Apr 2025 18:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915088; cv=none; b=W6MqaUQuWS3hLggQV/yIPkpC/1+XA/M5QF60cqLyy3zhQLnkhl9acdOkxZNevvCOLef61rNEorrna2aJ6jEQfbi27q+E5HAw3hO9+4lO1HUvFlrfUtS8Ow3ULnS+Hu4cpEKKi7rncmlCceXbspotOdTy9fSVcqSpRiF/8+3WuHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915088; c=relaxed/simple;
	bh=LX38bJFZIVoVt2mAQwTVnz2FKywlFLrzzL5i8ZqRiQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNv790YzBpkxRIydqAD9my3tAMk8IerTscfR7VsSCjV1yq8Hepn+7pqyED1aLmzaZKvST1oA0M0Xh7ErXmk9ySRd43GCQrV5yGK0yabrFmNkCRwPilDuqFtMU1OgFKIyV8VoJ5QMgshqiafkaQTKQgPEwRALR3d0HcqznOAlsLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y+SWQWwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y+SWQWwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A902C4CEE4;
	Thu, 17 Apr 2025 18:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915088;
	bh=LX38bJFZIVoVt2mAQwTVnz2FKywlFLrzzL5i8ZqRiQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y+SWQWweKGH8vTlQKCx52PcDtiIbROeCf+0ssx1p6ic5cvd0WsWAoHly1Cq1osLR+
	 tOT4Iodc1OwEE7WmIADIzXI52nizCclMwtK6JxgCfXc2/BRpzK3KhaqbMIvkTTxz51
	 YxtnzcgyVStACxd8T9eJ61g1f9jF+fw/ifkuyAhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/393] ata: pata_pxa: Fix potential NULL pointer dereference in pxa_ata_probe()
Date: Thu, 17 Apr 2025 19:47:04 +0200
Message-ID: <20250417175108.207913854@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit ad320e408a8c95a282ab9c05cdf0c9b95e317985 ]

devm_ioremap() returns NULL on error. Currently, pxa_ata_probe() does
not check for this case, which can result in a NULL pointer dereference.

Add NULL check after devm_ioremap() to prevent this issue.

Fixes: 2dc6c6f15da9 ("[ARM] pata_pxa: DMA-capable PATA driver")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_pxa.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ata/pata_pxa.c b/drivers/ata/pata_pxa.c
index 538bd3423d859..1bdcd6ee741d3 100644
--- a/drivers/ata/pata_pxa.c
+++ b/drivers/ata/pata_pxa.c
@@ -223,10 +223,16 @@ static int pxa_ata_probe(struct platform_device *pdev)
 
 	ap->ioaddr.cmd_addr	= devm_ioremap(&pdev->dev, cmd_res->start,
 						resource_size(cmd_res));
+	if (!ap->ioaddr.cmd_addr)
+		return -ENOMEM;
 	ap->ioaddr.ctl_addr	= devm_ioremap(&pdev->dev, ctl_res->start,
 						resource_size(ctl_res));
+	if (!ap->ioaddr.ctl_addr)
+		return -ENOMEM;
 	ap->ioaddr.bmdma_addr	= devm_ioremap(&pdev->dev, dma_res->start,
 						resource_size(dma_res));
+	if (!ap->ioaddr.bmdma_addr)
+		return -ENOMEM;
 
 	/*
 	 * Adjust register offsets
-- 
2.39.5



