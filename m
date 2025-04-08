Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856FD1B87CF;
	Tue,  8 Apr 2025 12:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114234; cv=none; b=CgnDPo7Ao3XQRZtX+V/wSzAZyRgF8r8WhcePDJlEr48j5hpavk1ESzVPWwFw2XggCaZqN8Ze5tSvwWIJr4JiREFFZjKIjQ6uZ5TBLp7RN1ooLQwsHTwFG0ahjU9oB73N4GJ2fIgDgYUaLhkhdKBkdBXuajsi5z893LUdLjBvD50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114234; c=relaxed/simple;
	bh=B1EHTJhKMrazhkJzguSBstVVMA2Z1AaO390764J727E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4bbXbxMCNaRS3dQZZhDqPfdlwKXu3qsyAP74LwGRRPO/6s46DZRCcV9b/DCEw6PsEUf1fwXAQlv9ziWgnARfNV8LTWK4/Tk0MJ2z83slojl3NnQCnxnpzaesLzj2xM/T+fZJZCTtgIcFtfEczxJb4ztVgdKF5wsK1EvIo7ttC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukKtsHsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukKtsHsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A70C4CEE5;
	Tue,  8 Apr 2025 12:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114234;
	bh=B1EHTJhKMrazhkJzguSBstVVMA2Z1AaO390764J727E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukKtsHsREK8sE9UQIzN6q5zGN4aI95eCo14cE1ZmeZuVzCWVDmKsgsUtOaOyMs716
	 h0Bb4dSAonEMNxt+Ca85DSoayHE2mAZ9MHhhYfrtCwxJ3MA58o4hstBdPQFh4CrnC7
	 tVjtGwV5oN0o10EwyIaYfzTweAv+Qe9WgGlRJE3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Steven Price <steven.price@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 030/499] dma: Introduce generic dma_addr_*crypted helpers
Date: Tue,  8 Apr 2025 12:44:02 +0200
Message-ID: <20250408104851.997229990@linuxfoundation.org>
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

[ Upstream commit b66e2ee7b6c8d45bbe4b6f6885ee27511506812c ]

AMD SME added __sme_set/__sme_clr primitives to modify the DMA address for
encrypted/decrypted traffic. However this doesn't fit in with other models,
e.g., Arm CCA where the meanings are the opposite. i.e., "decrypted" traffic
has a bit set and "encrypted" traffic has the top bit cleared.

In preparation for adding the support for Arm CCA DMA conversions, convert the
existing primitives to more generic ones that can be provided by the backends.
i.e., add helpers to
 1. dma_addr_encrypted - Convert a DMA address to "encrypted" [ == __sme_set() ]
 2. dma_addr_unencrypted - Convert a DMA address to "decrypted" [ None exists today ]
 3. dma_addr_canonical - Clear any "encryption"/"decryption" bits from DMA
    address [ SME uses __sme_clr() ] and convert to a canonical DMA address.

Since the original __sme_xxx helpers come from linux/mem_encrypt.h, use that
as the home for the new definitions and provide dummy ones when none is provided
by the architectures.

With the above, phys_to_dma_unencrypted() uses the newly added dma_addr_unencrypted()
helper and to make it a bit more easier to read and avoid double conversion,
provide __phys_to_dma().

Suggested-by: Robin Murphy <robin.murphy@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: 42be24a4178f ("arm64: Enable memory encrypt for Realms")
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20250227144150.1667735-3-suzuki.poulose@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dma-direct.h  | 12 ++++++++----
 include/linux/mem_encrypt.h | 23 +++++++++++++++++++++++
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/include/linux/dma-direct.h b/include/linux/dma-direct.h
index d20ecc24cb0f5..f3bc0bcd70980 100644
--- a/include/linux/dma-direct.h
+++ b/include/linux/dma-direct.h
@@ -78,14 +78,18 @@ static inline dma_addr_t dma_range_map_max(const struct bus_dma_region *map)
 #define phys_to_dma_unencrypted		phys_to_dma
 #endif
 #else
-static inline dma_addr_t phys_to_dma_unencrypted(struct device *dev,
-		phys_addr_t paddr)
+static inline dma_addr_t __phys_to_dma(struct device *dev, phys_addr_t paddr)
 {
 	if (dev->dma_range_map)
 		return translate_phys_to_dma(dev, paddr);
 	return paddr;
 }
 
+static inline dma_addr_t phys_to_dma_unencrypted(struct device *dev,
+						phys_addr_t paddr)
+{
+	return dma_addr_unencrypted(__phys_to_dma(dev, paddr));
+}
 /*
  * If memory encryption is supported, phys_to_dma will set the memory encryption
  * bit in the DMA address, and dma_to_phys will clear it.
@@ -94,14 +98,14 @@ static inline dma_addr_t phys_to_dma_unencrypted(struct device *dev,
  */
 static inline dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr)
 {
-	return __sme_set(phys_to_dma_unencrypted(dev, paddr));
+	return dma_addr_encrypted(__phys_to_dma(dev, paddr));
 }
 
 static inline phys_addr_t dma_to_phys(struct device *dev, dma_addr_t dma_addr)
 {
 	phys_addr_t paddr;
 
-	dma_addr = __sme_clr(dma_addr);
+	dma_addr = dma_addr_canonical(dma_addr);
 	if (dev->dma_range_map)
 		paddr = translate_dma_to_phys(dev, dma_addr);
 	else
diff --git a/include/linux/mem_encrypt.h b/include/linux/mem_encrypt.h
index ae45263892611..07584c5e36fb4 100644
--- a/include/linux/mem_encrypt.h
+++ b/include/linux/mem_encrypt.h
@@ -26,11 +26,34 @@
  */
 #define __sme_set(x)		((x) | sme_me_mask)
 #define __sme_clr(x)		((x) & ~sme_me_mask)
+
+#define dma_addr_encrypted(x)	__sme_set(x)
+#define dma_addr_canonical(x)	__sme_clr(x)
+
 #else
 #define __sme_set(x)		(x)
 #define __sme_clr(x)		(x)
 #endif
 
+/*
+ * dma_addr_encrypted() and dma_addr_unencrypted() are for converting a given DMA
+ * address to the respective type of addressing.
+ *
+ * dma_addr_canonical() is used to reverse any conversions for encrypted/decrypted
+ * back to the canonical address.
+ */
+#ifndef dma_addr_encrypted
+#define dma_addr_encrypted(x)		(x)
+#endif
+
+#ifndef dma_addr_unencrypted
+#define dma_addr_unencrypted(x)		(x)
+#endif
+
+#ifndef dma_addr_canonical
+#define dma_addr_canonical(x)		(x)
+#endif
+
 #endif	/* __ASSEMBLY__ */
 
 #endif	/* __MEM_ENCRYPT_H__ */
-- 
2.39.5



