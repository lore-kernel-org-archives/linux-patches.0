Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A166526A08E;
	Tue,  8 Apr 2025 12:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114229; cv=none; b=TSJO62SV7Yvpr862U3ZTficdvwtIXRZVz+QQkVEzNQw4Sy6AcddMKCDpe/xFi6ngrfulvXgr4SI9zmzqIR8iWtvp5FUmBQdBbcQeiTu3ultDKNEQAdVl2d4HUP3GpLcIe8G3n9cc2dsYF29BARcqHyF1MK5tRcPpUwYSzdLZ90w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114229; c=relaxed/simple;
	bh=hMWjOMgiFraz+7s8XdAMYnndwZn3Uvm9cWDvat99ygI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oE2zT0OTftcprE1mYugfPG8ZJLduzOyn/tz/1LoPk5mmgi5Lvry5UxSjSOEiNEEKUppApsW0wW3Y6UZ0c3wGCJXJ4ixxtPiJE5JrPKNNQRdLrzFOfJWvDLUlkBCWFG3j7BFlSLKmuiEMaGE0gue3QX4kflIxkcP1cywsgiW78j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJYZzmgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJYZzmgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B83EC4CEE5;
	Tue,  8 Apr 2025 12:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114229;
	bh=hMWjOMgiFraz+7s8XdAMYnndwZn3Uvm9cWDvat99ygI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJYZzmgI74zrqW4A/o+neiZWW6OtzRRixHjWBLYL/DwB+lYOuZd94/rbeOCMfsvF2
	 vxz6Z8keVBv0shWWPgpoKSJO2e3hlHkoflw+ue4/Q4Grv0hDNmq1bMlrT8/8E1hEuV
	 ddQof0ZeQO6takU5eG0TrxJptE5IJgzskQtw6n0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Will Deacon <will@kernel.org>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 029/499] dma: Fix encryption bit clearing for dma_to_phys
Date: Tue,  8 Apr 2025 12:44:01 +0200
Message-ID: <20250408104851.971725572@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit c380931712d16e23f6aa90703f438330139e9731 ]

phys_to_dma() sets the encryption bit on the translated DMA address. But
dma_to_phys() clears the encryption bit after it has been translated back
to the physical address, which could fail if the device uses DMA ranges.

AMD SME doesn't use the DMA ranges and thus this is harmless. But as we
are about to add support for other architectures, let us fix this.

Reported-by: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Link: https://lkml.kernel.org/r/yq5amsen9stc.fsf@kernel.org
Cc: Will Deacon <will@kernel.org>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: 42be24a4178f ("arm64: Enable memory encrypt for Realms")
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20250227144150.1667735-2-suzuki.poulose@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dma-direct.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index d7e30d4f7503a..d20ecc24cb0f5 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -101,12 +101,13 @@ static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t dma_addr)
 {
 	phys_addr_t paddr;
 
+	dma_addr = __sme_clr(dma_addr);
 	if (dev->dma_range_map)
 		paddr = translate_dma_to_phys(dev, dma_addr);
 	else
 		paddr = dma_addr;
 
-	return __sme_clr(paddr);
+	return paddr;
 }
 #endif /* !CONFIG_ARCH_HAS_PHYS_TO_DMA */
 
-- 
2.39.5



