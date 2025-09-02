Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10480324B16;
	Tue,  2 Sep 2025 13:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820746; cv=none; b=Nh8b2Koidk2TdrLl0gKJFH1MwAtnoGuIrrnScr8nqJpOqeG+vpAIxxfriX011ZN4c9/EiPtuNWGacZnqIMzM6zL1NNNwyt4h2UONUzANVHEnoHJjHLee3T1tSpieMRMz3lxieMtjMkRiU5nuM+SkAFaa9S6heO7Rh3wvT+GS9Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820746; c=relaxed/simple;
	bh=Kv9BtWFaMO+yb5ULzN1ykGxK1Nj+G5UI/+3Lf0bJeBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BG8ufANPL+F9Fd3j+0lIOr0+i8xrdLrUXrakaNX5yLH1GE4ltKL9SNxo1C3srFZjgS2zi7k5WnoBYLtbgmwjFhNBG6u1cvsiz8Z9TxdjvMeAAj9s5WTZBLBmZe2OFHKsR+m2Sg1uxmedzi/LiwSJuIFtwZLR//JrtjsNfIS+Hpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spVenkCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spVenkCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093B2C4CEED;
	Tue,  2 Sep 2025 13:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820745;
	bh=Kv9BtWFaMO+yb5ULzN1ykGxK1Nj+G5UI/+3Lf0bJeBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spVenkCu2YNi78aA9ts/p6dKJ6tYF+Ea/ZSWdZhXEH5w6Mj/GacoG34Wz0Jzh2D2e
	 YsIgOuNRAmfQ5Ns638ER+D5mfLcNrIbYaGBMdT0smAu2hrtZVZz35wB1hiJqPkFU44
	 UQIPU4KDupEhFF//jnwCgoZHq4MjbLh/C60jp4io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 5.10 24/34] dma/pool: Ensure DMA_DIRECT_REMAP allocations are decrypted
Date: Tue,  2 Sep 2025 15:21:50 +0200
Message-ID: <20250902131927.579703796@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shanker Donthineni <sdonthineni@nvidia.com>

commit 89a2d212bdb4bc29bed8e7077abe054b801137ea upstream.

When CONFIG_DMA_DIRECT_REMAP is enabled, atomic pool pages are
remapped via dma_common_contiguous_remap() using the supplied
pgprot. Currently, the mapping uses
pgprot_dmacoherent(PAGE_KERNEL), which leaves the memory encrypted
on systems with memory encryption enabled (e.g., ARM CCA Realms).

This can cause the DMA layer to fail or crash when accessing the
memory, as the underlying physical pages are not configured as
expected.

Fix this by requesting a decrypted mapping in the vmap() call:
pgprot_decrypted(pgprot_dmacoherent(PAGE_KERNEL))

This ensures that atomic pool memory is consistently mapped
unencrypted.

Cc: stable@vger.kernel.org
Signed-off-by: Shanker Donthineni <sdonthineni@nvidia.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20250811181759.998805-1-sdonthineni@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/pool.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -105,8 +105,8 @@ static int atomic_pool_expand(struct gen
 
 #ifdef CONFIG_DMA_DIRECT_REMAP
 	addr = dma_common_contiguous_remap(page, pool_size,
-					   pgprot_dmacoherent(PAGE_KERNEL),
-					   __builtin_return_address(0));
+			pgprot_decrypted(pgprot_dmacoherent(PAGE_KERNEL)),
+			__builtin_return_address(0));
 	if (!addr)
 		goto free_page;
 #else


