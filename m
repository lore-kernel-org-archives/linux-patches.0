Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDAF1A76C1;
	Tue, 30 Jul 2024 17:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360573; cv=none; b=qV4wRpEPtHowJ/zbeNP5p3/POUzNSNODKPe7oyTWkT9Pe+TQOw3PJAC8OlpcUyqttC02xmTHUQFoXb6zcREVQtjN83GlG0DqqxUAXkAuCi5Yt0cAzRjFMBW1YRY0RXt6djVtLyMRwKQdyO+cZVJh1kDJr7dUqgGwqOBYeeTDf60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360573; c=relaxed/simple;
	bh=MuWov+FlJUxLi3nVt9kkwwvgqVlWol8/RkJf+7/geXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLFSooR+EI0r43/Z+Mvlj+PFpkvanUrkGObFW3oYUnFjLHyZHR584BJuowAWrWZzqxqK//iEB15wrCWsh4bwBMhxTPx/WCo12UjUDwck2gMGsPRpV2UjhcfpKtiE+0ar3lm/IUXApJxkXUtjrcvrXDVFlPEMU8bpzPc+jVi6vWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qu6qjL2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qu6qjL2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28055C32782;
	Tue, 30 Jul 2024 17:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360572;
	bh=MuWov+FlJUxLi3nVt9kkwwvgqVlWol8/RkJf+7/geXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qu6qjL2I7rF/L5Ypndj1mD5oq3pz5vCekXu7j2qBNtmeiidkVeReTJtiNzl5HSxYo
	 0EFtgQmUu4HMHJmnQJcZ8ZieAmkGfTubp2h6SNWFWAu1VNpyAZR6Q26KLv2gLzH0Hw
	 PsupemAP3WtLOpN+M20QCexg8JOhI0021daFUnAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Jai Luthra <j-luthra@ti.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 741/809] dmaengine: ti: k3-udma: Fix BCHAN count with UHC and HC channels
Date: Tue, 30 Jul 2024 17:50:17 +0200
Message-ID: <20240730151754.217299608@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 372f8b3621294173f539b32976e41e6e12f5decf ]

Unlike other channel counts in CAPx registers, BCDMA BCHAN CNT doesn't
include UHC and HC BC channels. So include them explicitly to arrive at
total BC channel in the instance.

Fixes: 8844898028d4 ("dmaengine: ti: k3-udma: Add support for BCDMA channel TPL handling")
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Tested-by: Jayesh Choudhary <j-choudhary@ti.com>
Link: https://lore.kernel.org/r/20240607-bcdma_chan_cnt-v2-1-bf1a55529d91@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 6400d06588a24..df507d96660b9 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -4472,7 +4472,9 @@ static int udma_get_mmrs(struct platform_device *pdev, struct udma_dev *ud)
 		ud->rchan_cnt = UDMA_CAP2_RCHAN_CNT(cap2);
 		break;
 	case DMA_TYPE_BCDMA:
-		ud->bchan_cnt = BCDMA_CAP2_BCHAN_CNT(cap2);
+		ud->bchan_cnt = BCDMA_CAP2_BCHAN_CNT(cap2) +
+				BCDMA_CAP3_HBCHAN_CNT(cap3) +
+				BCDMA_CAP3_UBCHAN_CNT(cap3);
 		ud->tchan_cnt = BCDMA_CAP2_TCHAN_CNT(cap2);
 		ud->rchan_cnt = BCDMA_CAP2_RCHAN_CNT(cap2);
 		ud->rflow_cnt = ud->rchan_cnt;
-- 
2.43.0



