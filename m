Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F6530C343;
	Tue,  2 Sep 2025 13:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819722; cv=none; b=Pph04nLJKNJEuKE7X5bYRxDJUK6Y6Zpbp/b6BKBYSb5NORhl9o2tb0sr3RgIEkdkHbLodTdVQ+5iM7OtGFGxrz9mlsKtRIWnhgwlH+StDSgIGUZ2OlJMkuzyTRnpBgglPozT35+wMIs6cy6J53NGahKmjd4tqT0AwM5LZ0S4zmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819722; c=relaxed/simple;
	bh=OCELLmvvjpzrkbTBxvGB0gLQomtbphS28I6GEiYgRv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRKZK6QXXLbZ0auzh3KtMzDOQOwQ3y/9EfsteujabbNhkriuOFVQIZPWivgw13MJ7+M8vAoFhVeE1i7mVQQf3yoCeHW2jkUFX3yxI1S/7QIEg6W6GQLAM26s6fptexLziVTSUGJgA8pDhJt5WXqLiKrN7oZrAnz4s5VHaeFR3NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfGb3nwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfGb3nwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C14C4CEED;
	Tue,  2 Sep 2025 13:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819722;
	bh=OCELLmvvjpzrkbTBxvGB0gLQomtbphS28I6GEiYgRv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hfGb3nwJYjNEGRuJg5f66CJDt7YAvJlCW5kbIkBeyivCE2+GA6XN6t72WtSC3ldrO
	 wXMxCcL1TnI2QLMYKZQxk6xX0hY1+b3k6O0J+qbDqpAzehcM5U3yeefKACi/hn3nAL
	 UQRs7ntPwDT75ynKKzg04oAXhd5au8RD1FumKXO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.16 119/142] dma/pool: Ensure DMA_DIRECT_REMAP allocations are decrypted
Date: Tue,  2 Sep 2025 15:20:21 +0200
Message-ID: <20250902131952.846490065@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


