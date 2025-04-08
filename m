Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3DD269823;
	Tue,  8 Apr 2025 11:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110372; cv=none; b=CrKNRxNtILGFrHxePiDDnIYph4t6rqJcnhinTS9JQALnvy2iHPzw5DcZBlSAG4U+1nfvrsqa68+/eeLIGZJybDdAFe0YmwtUoT9GgphzPnL/QQyhGgDKX49dISIa0Bf9cr6q6bRFK9MqX6Rn5x3GRFru6iw+bnVJPkW0jJL3ShY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110372; c=relaxed/simple;
	bh=YTFaZ3Z6OFkeaifqIb72jJYmGE7vrRRhOoVtKN2oIo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6R2AYr2pWSEIae7NDTqhIM4bW3f+fqxLzHkH65g5dmvJeCXgeFWJzfHWyRkuF7MRMpSIPgl4RwNnu7+B3MVaTUgcXKRmSFef6cIugbHAH9U3KkkJIUN7RpVv3ZpSkfBafMk2nFAjaZeAxzE8LDZ9OX9/nuRa0quuLEldvLvYnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUCkqBb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUCkqBb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BC0C4CEE5;
	Tue,  8 Apr 2025 11:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110371;
	bh=YTFaZ3Z6OFkeaifqIb72jJYmGE7vrRRhOoVtKN2oIo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUCkqBb/TCcr7UmfSZg+zsN/IH2tN2RczPKWvhU7+cXfzWrtxL6W3zTl8j6quaxNV
	 tm1yF7rHR7rmRmoMrqz2Sn9wLKF21BhJVjDZOtmt666mEisACZlEw/imXdFh3zBHvy
	 vjvCcmsHbZhfh4qtlACXpVdY0hlKJ4a9FA5d8/jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 038/731] arm64: realm: Use aliased addresses for device DMA to shared buffers
Date: Tue,  8 Apr 2025 12:38:55 +0200
Message-ID: <20250408104915.160704742@linuxfoundation.org>
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

[ Upstream commit 7d953a06241624ee2efb172d037a4168978f4147 ]

When a device performs DMA to a shared buffer using physical addresses,
(without Stage1 translation), the device must use the "{I}PA address" with the
top bit set in Realm. This is to make sure that a trusted device will be able
to write to shared buffers as well as the protected buffers. Thus, a Realm must
always program the full address including the "protection" bit, like AMD SME
encryption bits.

Enable this by providing arm64 specific dma_addr_{encrypted, canonical}
helpers for Realms. Please note that the VMM needs to similarly make sure that
the SMMU Stage2 in the Non-secure world is setup accordingly to map IPA at the
unprotected alias.

Cc: Will Deacon <will@kernel.org>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: 42be24a4178f ("arm64: Enable memory encrypt for Realms")
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20250227144150.1667735-4-suzuki.poulose@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/mem_encrypt.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/asm/mem_encrypt.h
index f8f78f622dd2c..a2a1eeb36d4b5 100644
--- a/arch/arm64/include/asm/mem_encrypt.h
+++ b/arch/arm64/include/asm/mem_encrypt.h
@@ -21,4 +21,15 @@ static inline bool force_dma_unencrypted(struct device *dev)
 	return is_realm_world();
 }
 
+/*
+ * For Arm CCA guests, canonical addresses are "encrypted", so no changes
+ * required for dma_addr_encrypted().
+ * The unencrypted DMA buffers must be accessed via the unprotected IPA,
+ * "top IPA bit" set.
+ */
+#define dma_addr_unencrypted(x)		((x) | PROT_NS_SHARED)
+
+/* Clear the "top" IPA bit while converting back */
+#define dma_addr_canonical(x)		((x) & ~PROT_NS_SHARED)
+
 #endif	/* __ASM_MEM_ENCRYPT_H */
-- 
2.39.5



