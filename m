Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48432690CB;
	Tue,  8 Apr 2025 11:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110366; cv=none; b=SGTb/9r9bs/MhTBLIsAqFTXr5sQhrqtDw1ci/HevEd5Pvmobdjh/tL9jnsavCAmzz0rWc0KwVutJLethL665wRUi60WosDejmtALZW4bNWVJfqpFZK5pcg2JPi5PuhFXbNaiXtSoBI3m9pjBCVenBuVdwHgLGEG4eCnRRbjXms4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110366; c=relaxed/simple;
	bh=IT41Gdg/sJ6pRJQLK7Q9r8iiumaW9HmDzPA2ExQDSHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suGXzNYM3Hvzc/zKjbrYHLOD7a0ourQ3QOloqogZwXWOzAEncrUL3Fn1PZ8Q5h17ohOyS1g9EuwE4G0LzITVkVAG8HSaoow6VIs9Nfketys8Zp8dsstmkUGMVGFseCPgSMS/xQhoHDAhTBErS7xOns49spm5FtF0srG0i+aj6aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W1fyGPQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W1fyGPQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D042C4CEE5;
	Tue,  8 Apr 2025 11:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110366;
	bh=IT41Gdg/sJ6pRJQLK7Q9r8iiumaW9HmDzPA2ExQDSHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W1fyGPQLXl0YDSyKmeeicHZi94GlmYqonhApjZWjWIBTUVX/vloltY386BuEngZU2
	 1qMsYTS4Kl+fjZnguvJcJ0Or0KfWg4sQFLqFEpfUhvysEvj5nTvgHQa2kmFl+5MW8N
	 HxIis/+hFkeQB4bbnAj45j2YUIxMX/eDpbSr6dmQ=
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
Subject: [PATCH 6.14 036/731] dma: Fix encryption bit clearing for dma_to_phys
Date: Tue,  8 Apr 2025 12:38:53 +0200
Message-ID: <20250408104915.113690085@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



