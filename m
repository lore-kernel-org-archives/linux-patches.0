Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585391;
	b=VIg/OoGqLfA4NIKFdDj3RuuNELXU2WuELXxcV056UNZzo9rMPSm7mNnwgV1HTrnRI3sH
	 A/3STAPjtQ/3/D60m3HxGSlo6V3XVY3auA1KEQVXdZ1FQtQFWE46Yv15mJtzmkZEPn4lc
	 7+i8QQVublV8phaliP+ksa/+XGP84aQTjxJMg9/w0AnngtN1dBvcCy9d8uKWSExQ1pJcu
	 YKxs3xq7Dpdohf+zd+lZjQHufVPHSlTyQdF4RF8at+/Zkx53SaJ4JQ0TSC2H6fk3XH7v0
	 oyQHU43HMs7d3d0ixx62NJgM46gIMOUjWkUAPGjC1ye9kaF8RQgHx3adFzp4TZ/3eyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Kzl4yyCCCZLtF5RG8NKIkrsOJvcvSgNZNGczoLeeSRY=;
	b=nIfy5NCqwLH25YSe0eclOF4fs0m/GqJNjNCmlXbAyDn6T6Gw2PReIj4R84TPJusjbsS2
	 s20196g1Hk/SyVvyqbIxIzyHx1gTD5BKnUBRF1EntCO43ufion79pFjAh6hDq/LVMDLkt
	 vsthjum2qCfjzRv2ljzDlc90A/fIk3Zn/IOi94w94VZ/Cleoo8zeTx1JzbHI7l4yaaJO2
	 MQecyWhcqc1VAZIScNIP1gXEBOUvmlTf/meYb17yvAocXvdee8LOGfMwBciU0sjBKz143
	 5aXdACFVcDAn7XcLaPTAPjCzXOFMRtXb0jDw+KostFufgIPM+Z7XxD+6zftLVeUmiRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DGi/5Cd7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BC46070FDD;
	Fri, 13 Nov 2026 15:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DGi/5Cd7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0351F000CE;
	Fri, 13 Nov 2026 15:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585391;
	bh=Kzl4yyCCCZLtF5RG8NKIkrsOJvcvSgNZNGczoLeeSRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DGi/5Cd73cFpzLPyDfenWKcFqXcKEo3RQVb8weuF5ujwg3Ekajp9CE8liS4LFm4Vu
	 MfF5ahDQKikcqPBHRohzQvGYwUSDxvIAMRaLS3KUr1wDC0K5z277T7hfjbZOP1hStO
	 3WHFZraXUNHQ15+6rvKsq4wTRfg35VPXgsfcW8is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yili Zhang <zhangyili01@baidu.com>,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 063/507] dma-buf: Fix IOVA offset when linking phys vecs to sgt
Date: Fri, 13 Nov 2026 10:46:07 -0500
Message-ID: <20261113153755.684133436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yili Zhang <zhangyili01@baidu.com>

[ Upstream commit d57e3a7d880d783c64aa29457d78b0e3c5a40e3c ]

The dma_buf_phys_vec_to_sgt() routine links every physical range into
the allocated IOVA space at offset zero instead of advancing the offset
by the already mapped length. This breaks the THRU_HOST_BRIDGE flow
whenever phys_vec contains more than one entry: the second and
subsequent dma_iova_link() calls try to install mappings on top of
PTEs that already exist, which fails and makes the whole conversion
return an error.

Fix it by passing the accumulated mapped_len as the IOVA offset. This
matches the pattern used by all other dma_iova_link() callers and is
consistent with the rest of the function: dma_iova_sync() and the
error path in dma_iova_destroy() both operate on the [0, mapped_len)
prefix of the IOVA space, which assumes that the ranges were linked
contiguously starting at offset 0.

Fixes: 3aa31a8bb11e ("dma-buf: provide phys_vec to scatter-gather mapping routine")
Cc: stable@vger.kernel.org
Signed-off-by: Yili Zhang <zhangyili01@baidu.com>
Reviewed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Reviewed-by: Leon Romanovsky <leon@kernel.org>
Link: https://lore.kernel.org/r/20260924065508.27245-1-zhangyili01@baidu.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-buf-mapping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index 833be519e1e6a..ef0f22854d018 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -156,7 +156,7 @@ struct sg_table *dma_buf_phys_vec_to_sgt(struct dma_buf_attachment *attach,
 						       phys_vec[i].paddr);
 		} else if (dma_use_iova(dma->state)) {
 			ret = dma_iova_link(attach->dev, dma->state,
-					    phys_vec[i].paddr, 0,
+					    phys_vec[i].paddr, mapped_len,
 					    phys_vec[i].len, dir,
 					    DMA_ATTR_MMIO);
 			if (ret)
-- 
2.53.0



