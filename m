Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049815;
	b=unb0XufexOmu2B3txLOK8UpIaRZj1X+WvdE5d/vIqHlQx+4vxe6rxSgrK7XpoMpJXD4e
	 vrydyWyIF4iqp6UIyVlsEVfrrd0jWHasdzzIbejACmCJRNwl9zH0LHHCoh3+q3ZNi4Zjv
	 k+iAgmhmyW+WnoA2Zf5pW46K0jKGHsDCwkqhJVUcCahrrj/KUNOBa37uFZdc0zFS37Lng
	 9CULq+88VUXnFOVj6eZx1hhWxTiV5HOukyI9TGJK+G15OBYGbGbI6Wvh8wWGyj0RJH5Eh
	 KpQz/miP3V24WQ1MYWAvZMYtCf4/iMux7AgonvPRsYnqVPfGCvPQlCCKMvgVzE9Is3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VwvU9EhRWh4RNo1Zrkh7LCoovmOmoqkO95GkpKC6P0s=;
	b=pBFEyhTt4GgebovIcMPzWJUwMJWdcKCaT+PeAEdHfY0ktXnEUvvrLpiC5aExvNHAfZLo
	 KFvN8rmDNmdLPJda/c0XUwDRG/namWqKB1z+zgTYnLAQaeGZu2DmWobCRQZmOTYXAGO5B
	 nOFoQAZOqb6e1ye20wlgOTHAOQa3ixDZ+vzKnNmMvrFH2iIuPf43cFN65ZvV6Cqr7o9IW
	 WRAMet4OQFmyLrrhuwpIIcphpHQIuRVh31AHtrOcX7JPE1LUxTFVBP2M+UMA1/a2jjcGm
	 dcOec/VTCD4TBpMpmL0VBJbJ+C+c0e7vA5bEQ/BBiZTydmwxjaY0sTayUbjdlS5r9Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cTHPJ24x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93483606A31C;
	Thu, 19 Nov 2026 00:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cTHPJ24x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CA61F000C4;
	Thu, 19 Nov 2026 00:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049815;
	bh=VwvU9EhRWh4RNo1Zrkh7LCoovmOmoqkO95GkpKC6P0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTHPJ24xQZWa/mhvfWMzt5QoMbojugWpvRVqlyZbZskv9fTTroVYSo2CA3hF4PbLC
	 2ldc11v+POlM4kLjRNu1xPkCZ16kvpPRHpFv7uiUIeBjH4sFgF9f5TvgENnpnMZvCk
	 9DFNCxJqRAl0zNmEB4+iJPveU8WGkwpfpsaSq8I4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2485/2857] ARM: 9519/1: dma-mapping: Fix wrong free function in __iommu_alloc_simple() error path
Date: Wed, 18 Nov 2026 15:58:39 +0100
Message-ID: <20261118150331.039712694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 74f79365839720bdb0c6bb4fe85c5b2a929ff5d1 ]

In __iommu_alloc_simple(), when IOMMU mapping creation fails, the error
path unconditionally called __free_from_pool() regardless of the
allocation path taken.

For the COHERENT case, memory is allocated via __alloc_simple_buffer(),
which does not use the atomic pool. Calling __free_from_pool() on such
memory silently returns without freeing, causing a page memory leak.

Fix this by matching the free function to the allocation path:
- COHERENT: use __dma_free_buffer(virt_to_page(addr), size)
- non-COHERENT: use __free_from_pool(addr, size)

Fixes: 565068221b905 ("ARM: 8561/4: dma-mapping: Fix the coherent case when iommu is used")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/dma-mapping.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index d7909091cf977..39463fdc82679 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1064,7 +1064,10 @@ static void *__iommu_alloc_simple(struct device *dev, size_t size, gfp_t gfp,
 	return addr;
 
 err_mapping:
-	__free_from_pool(addr, size);
+	if (coherent_flag == COHERENT)
+		__dma_free_buffer(virt_to_page(addr), size);
+	else
+		__free_from_pool(addr, size);
 	return NULL;
 }
 
-- 
2.53.0



