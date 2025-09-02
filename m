Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64F62DAFCA;
	Tue,  2 Sep 2025 13:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820319; cv=none; b=WlgzZNV0VgQB8N/TL5dTzoOE0Y6y6pmxXV0O1nT3nywSxDpXp7lle8sZa5udd+ZzH4KpVLK175DmugSwh7EzqnmM0KaDejaUn5gDM0rjpCv9alyRgOnu21WGS60oL9uCcIQQZGKE1k8OaaD7MGDjtD/SRkRTtuK2kiy9DVKGkZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820319; c=relaxed/simple;
	bh=oLjrZIHWrjVvmn8C0ihB7u2pPpipsDftj2I6mH+1Rn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cb9Y4dYda9rCITnYs0zxXN0OIG0tJxRJKN6E7uhl4+uVY4hiJedtQUHobWtggMpWS7roRmxN/CyvT6Zi1bnsdkcKx4Y3mu8Y8WbX44FdeKSGoOwYCM33Rd7DpttpQ0jhqXMJJNfy8hN/yzbYUTKEkEvtmYcK5qatV/vwntFuQcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FO/V1RE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FO/V1RE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA09C4CEED;
	Tue,  2 Sep 2025 13:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820318;
	bh=oLjrZIHWrjVvmn8C0ihB7u2pPpipsDftj2I6mH+1Rn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FO/V1RE1Yo1rkyIiQgQrQcYvuXg0t+z+oEBo+JnVUGisCb3UACEY342l6jUVaAHb3
	 pbBP0gdPXhN7/Jhwc2OKdtMsL0/yBZwjJRa+8ZT9joNCLbGLgIwDqwMaPzpNjfr7M3
	 lAjfRm/q44sJlRtKP0fOZkQAgG570BQsASsawCcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.6 65/75] dma/pool: Ensure DMA_DIRECT_REMAP allocations are decrypted
Date: Tue,  2 Sep 2025 15:21:17 +0200
Message-ID: <20250902131937.669741500@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -102,8 +102,8 @@ static int atomic_pool_expand(struct gen
 
 #ifdef CONFIG_DMA_DIRECT_REMAP
 	addr = dma_common_contiguous_remap(page, pool_size,
-					   pgprot_dmacoherent(PAGE_KERNEL),
-					   __builtin_return_address(0));
+			pgprot_decrypted(pgprot_dmacoherent(PAGE_KERNEL)),
+			__builtin_return_address(0));
 	if (!addr)
 		goto free_page;
 #else


