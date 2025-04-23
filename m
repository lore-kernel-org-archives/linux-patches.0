Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC471A9B39;
	Wed, 23 Apr 2025 14:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419816; cv=none; b=kV3w1FYEtqgj+bMfbvRsT6SaeU84dXyfaKl5Nitctyf2ZW6iKwmXRnOp469bI6mi1qPtwTTkp8ueFuqUKrRUTdD0sozL/aZp3RW7aRlpJYhlS45oMdl8yB4Vf0hktWbDymT8198V3E/7NMBxBmGJAqTk6wAmP7r9634V9S3Mrf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419816; c=relaxed/simple;
	bh=iMl4503qVCpwG9jqOncmXz5L4exucOkX/S/+aPBNWt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJ1EJ63HFE7ChpPh+jAYosAKkq19/hykJ6vjtfcZJhwW6aC6+WEmrppoHerkJPRC/FDPXTz031sPyL03qkRlp0pXlM1ASIDEj3h0Mfp6/d7EiwxLN7V4Toh0bdzPAQ3o62wBvD1p9de0DhOP9of0deHcAdxqGmyrX5DNlvlQ9Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXU84/qD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXU84/qD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4755C4CEE3;
	Wed, 23 Apr 2025 14:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419816;
	bh=iMl4503qVCpwG9jqOncmXz5L4exucOkX/S/+aPBNWt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXU84/qDe7FAVUIy+chlwRuVHq26/PiiRYxdEPrpb4m/3OHucwGbttizx464DdcNm
	 cVDwhzvfUR7rWnTf7q87Bw+WwQ422yFa8cJ2UUvFnVXbGMXb/9FJJ2U4pGE488SxJd
	 4D6LxcCoROkljTVgTjSmxBdMwgSGC9nVtPCZx44A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/393] ata: pata_pxa: Fix potential NULL pointer dereference in pxa_ata_probe()
Date: Wed, 23 Apr 2025 16:38:22 +0200
Message-ID: <20250423142643.519086917@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5275c6464f57f..821bcf20741ea 100644
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



