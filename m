Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB5621D5B8;
	Tue,  2 Sep 2025 13:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820053; cv=none; b=U5DaSWAzUHQERvKODRyNglg0j1hmeGQ2GmAuohbJz/z2IAASC++s1EbUOv6XqfEM1hZciapg2VOpwiwMEG4vtaCZndvfvwJe3xv26AzPp7ehrHYa170gpcjBCVbzu4MCZmNl5Sn82IG6KVXlRYxl07AprH7HYtdbAvpnjpMflco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820053; c=relaxed/simple;
	bh=ZxVSu0nsCa/VfPPVP9gn03jIo22XCU3tDpO+UYqzZUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CK1FqY2SSnbp7qmZbmgP8OCXvdgQuas25H6hzb6wk7LD13L1EfZWeoCIsNdZoMPa9FbZDG14ePZQpyClt76i2/DDoec7Xr+qjjFvLeg9BPBd5kPK3WrmAWGkhP16vchjJdK+tOlFLR/dLDNbK6Ncd8+3+l5UH3noaqiHjBWCw6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vSHdLGFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vSHdLGFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977BCC4CEED;
	Tue,  2 Sep 2025 13:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820053;
	bh=ZxVSu0nsCa/VfPPVP9gn03jIo22XCU3tDpO+UYqzZUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSHdLGFT5N2NwP1/c0h/4spMbyudKsXECLkwX4QeqQWOVlBDyH2MNaWXgIrPNwCbu
	 tj5RVCf97dFG+sYV63rShOO8gQyow3up+OjPzC5fob+fSoBBjFxTBfn2hKidiRCrDp
	 avzY0Ecvz1DashJYlfx60+lfBDVTJB6eMuTGZO5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.12 79/95] dma/pool: Ensure DMA_DIRECT_REMAP allocations are decrypted
Date: Tue,  2 Sep 2025 15:20:55 +0200
Message-ID: <20250902131942.640782533@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


