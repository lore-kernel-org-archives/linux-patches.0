Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B5D221F14;
	Tue, 17 Jun 2025 16:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177438; cv=none; b=BExdj1M9HoLDahAlJ/hUUHyeTiP4G2LkjhPaxWNszYnxre5vv9CSLwXJRC6DlPFf/vMXxaGOTUgpYf/5I+lXoES6wUJ4Cfmi/mkSG+qBMNH7C2by7TRzU9/erdUFjio4rvJ1zULB3TPhVDwiqftKh6JQQA0+dHmVD7hZ4iLT2fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177438; c=relaxed/simple;
	bh=AQTdHGlY25lJX1rWElR3fuMSyYNBVAvzg54lwdEuWyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSgpVebU3xwhEXHW1QMBnuA0y9ezXFikanj8zwxhBdbjTi8vaf+fNTH1lEk547ZF+W0M5B5cFIam6mGSN/JFrXTIcpw+HubMJA/9hVwmlbnq4Nf/pAw3xzN1PbM/+iKoo2v5qe3MzXLQE1Soi/+7Va0NDqfeT1YI68rsy+4H9EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rckrtljH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rckrtljH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA04C4CEF0;
	Tue, 17 Jun 2025 16:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177438;
	bh=AQTdHGlY25lJX1rWElR3fuMSyYNBVAvzg54lwdEuWyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rckrtljH/03HVuJFdE/LUT1rz+yfIx0+f28uIq8RO/nLO8S9FKRHMZIBYTX6qjD6B
	 Ru4qawMaohctz/W+J5O5FSGWrYKhHTcAgeQcGEEai5UDft+ORidj8tjKLkJqevFRCq
	 0MOylrIXP+kHXe0GO/GP3TjWu/jRSliJEFp/vxvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Nathan Lynch <nathan.lynch@amd.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 315/512] dmaengine: ti: Add NULL check in udma_probe()
Date: Tue, 17 Jun 2025 17:24:41 +0200
Message-ID: <20250617152432.379124964@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index 7d89385c3c450..38b54719587cf 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -5572,7 +5572,8 @@ static int udma_probe(struct platform_device *pdev)
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



