Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D6F357CFA;
	Sat, 12 Sep 2026 11:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212500; cv=none; b=ZTAsGhGNGK4ajicZkd5Nz213qCTJE2is67jlXoBLO9B6aGsHXasW9NuDq4Yb4ZJw5HYFk1RFW7xSct2H81EhvLY+CFwLwC5whhC9L4AW0lnmygo/ascJr6XrVy2aMVZgWH54vug5sArSt01Nvdxz6mnCzGHF7zEYJBNZdyWhjZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212500; c=relaxed/simple;
	bh=b4lc/KuzDT/gehy+eGt+SdPJmXI/70Cc5zXsXL9U33g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUmzTrgapjgCsmG3tlQE414FhCtcPIXticFz7sQAvQyDSmR4SNln8XsE+RXRYIDOcKvEn5VbbA4lrqzy84IaCnzVEOchtlZdjg4g9466AbE998VA+oh8AUR485taW7DZeQvLfO/ZSvUkhQXqefz+By2eTvgViXhQurbxjCUmYXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nkM+R5oa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nkM+R5oa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDD51F000FF;
	Sat, 12 Sep 2026 11:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212498;
	bh=DBEWGlP7tLkYl/AU/nyUA74bAZPQs7pWZ9oMXvGKhAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nkM+R5oakDcgsfoxwZSV0SwqgSGPkdt3fASZLOgUI/911zhur1eKbnp4a087o5v0Z
	 qcgIxKi7OclzO2H8JTB7fitgeJnhHl+GMA5FPTdyrEpnG6jszyZuGNLHPQ4vUwhqSI
	 cX6r2C9hoKLA3a4Rdq9b+bEw3KDoiNvuymkd0zZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Pawlik <pawlik.dan@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1449/1518] net: airoha: npu: fix missing streaming DMA mask
Date: Sat, 12 Sep 2026 09:00:18 +0200
Message-ID: <20260912065656.334292727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d6547834d3c78..ddc5a6a7681b1 100644
--- a/drivers/net/ethernet/airoha/airoha_npu.c
+++ b/drivers/net/ethernet/airoha/airoha_npu.c
@@ -686,7 +686,7 @@ static int airoha_npu_probe(struct platform_device *pdev)
 		npu->irqs[i] = irq;
 	}
 
-	err = dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
+	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
 	if (err)
 		return err;
 
-- 
2.53.0



