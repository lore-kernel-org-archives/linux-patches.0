Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48711212568;
	Tue,  2 Sep 2025 13:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820474; cv=none; b=hui8I/+OXZeHodqh+sVimGZwP8wltyT+/6tuFsa3IjJ03E0C+PzJISfUtjw2VG1HbVpVTrlqUDVLm5QurZBSn17AULULo2a4w0TWth5Nu78wSSbs/cLvUA823ga+tWd8G+R8Jbo5TYcFeJRWsT7wmrfl76lO2V71oEMLeZUdHeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820474; c=relaxed/simple;
	bh=dnYnJF5MQeWvWyKm5rSsBG+p4lWtIKXFCC4ncRU+Wks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5/QrNHuwrmxxlvkrEmPSmMhiaByUwYVbNt9KNhZq7Erx3CMt6Py59JOIcDiKkDVxOxn5Qk4m8lwj48UdeP4udgfbgX9XiafM0kn1w5/AyH/GeBSnby7qqVb95L9UWL0i9TKc5Xk+3f9+hl1DXCR1T9Ee+I29kbFzW/4C6QMkzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=olbwcvSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="olbwcvSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6186DC4CEED;
	Tue,  2 Sep 2025 13:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820472;
	bh=dnYnJF5MQeWvWyKm5rSsBG+p4lWtIKXFCC4ncRU+Wks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=olbwcvSiz9CvTPBxqBglRcJ9JQAM4XrlP2VBBtc87tc9UwUrYezsAWGukvptLbQfO
	 znNrLXAC+8nQXzhVhmaYpFSSNz29svFdvoyhrP5zv9GAQg4n0sK2B5s3FiQpj06OuT
	 ek+UpGBpqPpYgjrWflLsFIa2sf5wNSPTcLR/DMEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.1 41/50] dma/pool: Ensure DMA_DIRECT_REMAP allocations are decrypted
Date: Tue,  2 Sep 2025 15:21:32 +0200
Message-ID: <20250902131932.149580196@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


