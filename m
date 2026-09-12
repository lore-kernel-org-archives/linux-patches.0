Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B52B37757A;
	Sat, 12 Sep 2026 09:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205314; cv=none; b=ncVccjoYQw/VxDg8DMo4xU67+x5z7k39SzbAltnMnGWFCvvFgdEiuLC/0LwommVHSIGoeQpuUj12jqTTis5zuZ57T81bPqMHOllZOB43sBZdfKrs6QIWShpTrsXdKLMnJ/rPBi8HfGycyxtcduLS5aEEkt6lGtiCkS4aFMkSh8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205314; c=relaxed/simple;
	bh=mZv4Q8Ram84pfoJ9qOz2Un2NV0Ue/t7zCx4uPe+sWjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPTg3dFrKvx2Db0vQXTNh5eXXSFgUGeQhqYqY8eLKQEGlUzFtRDSILto1rbL+/QUhEnjIJ27UmfheD4HaKx7yBCS654pTAgnawIVZzspz8MSw5dRbXduN9heQSeqB5DKRBd3b+qX2RM7VJeZYqct/+SbzhhYesjpcfdG905Ff1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BHEfT6CO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BHEfT6CO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6991F000FF;
	Sat, 12 Sep 2026 09:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205313;
	bh=HZcT1OZrXVv0v9ida9kVd3et2ULrsDQJfX6sUoFmLUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BHEfT6COewmWZl/jSj//YKSc6zTKuCFlsyK6TmcFCuMva2I6U0zXRRoBpDyaDz7NO
	 maMIshOtjD2+LZwrn3qq5MvfXBDsM51rNjzoGvfFGtItK19uieCJVEPDM46Z5dt54l
	 mothQ2pMkw7ucAubBX7g4MFuAZswja/rRRayLLyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Pawlik <pawlik.dan@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1793/1815] net: airoha: npu: fix missing streaming DMA mask
Date: Sat, 12 Sep 2026 08:59:03 +0200
Message-ID: <20260912065731.128425648@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Pawlik <pawlik.dan@gmail.com>

[ Upstream commit 6fe7e31a45e3418a39e6343a85126124feec1c2f ]

The driver calls dma_set_coherent_mask() but never dma_set_mask(),
leaving the streaming DMA mask at the bus default. On the non-coherent
EN7581 platform (Cortex-A53), this causes the NPU mailbox to hang
after approximately 41 calls when using streaming DMA mappings.

Replace dma_set_coherent_mask() with dma_set_mask_and_coherent() to
set both the streaming and coherent DMA masks, matching standard
driver practice.

Fixes: 6f884eb87a79 ("net: airoha: Fix DMA direction for NPU mailbox buffer")
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20260814110017.2795022-1-pawlik.dan@gmail.com/
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20260809152813.585797-1-pawlik.dan@gmail.com/
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20260805070851.2885888-1-pawlik.dan@gmail.com/
Signed-off-by: Daniel Pawlik <pawlik.dan@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260820085941.380401-1-pawlik.dan@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_npu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_npu.c b/drivers/net/ethernet/airoha/airoha_npu.c
index b679bed952de3..4045d1eb93ea8 100644
--- a/drivers/net/ethernet/airoha/airoha_npu.c
+++ b/drivers/net/ethernet/airoha/airoha_npu.c
@@ -766,7 +766,7 @@ static int airoha_npu_probe(struct platform_device *pdev)
 		npu->irqs[i] = irq;
 	}
 
-	err = dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
+	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 	if (err)
 		return err;
 
-- 
2.53.0



