Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23824C2E0;
	Mon, 23 Jun 2025 21:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714280; cv=none; b=PDd3wzWMW7jKl1qReQgfdyuJHmlUch0z8pDvxMRgjy/AuYFRnY1NbyjteRS+uKFsDkVYS/D7weJPlNPa0+3MdcuTw0KNp6B9hcN+b1e6joti45Wh0fXDSDVTvcuLvp3rXu6qhAS5T48SOHVPSdLzJD0wTwCRCGXRwGqhozro04Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714280; c=relaxed/simple;
	bh=EoZDJGrraGdPOofVqoLZd0/hnB0dTvUTYd76Cozn/o0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HerGwussRWYHWi819eOS3wLiQqUfQLsuAZXUEvxoHK0FAE6GeEEVSmKHuF0JrT3bdDltvn6FIlmOlXr5CaAOPNon3HzMjjTRNxpDrkJtJZUdJrsdycI+P6BL8rhTDYnVGD1XlgH8qRYI/o7FLRUiAnDcRdncYPT/x1lyBpmbKf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqDGQLhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqDGQLhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42834C4CEEA;
	Mon, 23 Jun 2025 21:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714279;
	bh=EoZDJGrraGdPOofVqoLZd0/hnB0dTvUTYd76Cozn/o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqDGQLhdsvjeslRC3ZjjCsSXJjqL7/y4CkaELDSlbatdAt/v/ivfpLX01v4dssJ8a
	 YG+K3hX5PJjgp8qF52XXvc6H22cD/w7aVYzfVi8hrgf/GkVg1C3MUAXUk5yXVkLP4t
	 ZjukyfKy3xuKqLJ3foEUn1MpfXAOyxCFxtQ3CBig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Nathan Lynch <nathan.lynch@amd.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/508] dmaengine: ti: Add NULL check in udma_probe()
Date: Mon, 23 Jun 2025 15:03:19 +0200
Message-ID: <20250623130649.069448334@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index edad538928dd7..1d12dc141070a 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -5490,7 +5490,8 @@ static int udma_probe(struct platform_device *pdev)
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



