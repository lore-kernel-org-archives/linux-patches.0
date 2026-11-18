Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020202;
	b=GxHs1U4i2mYVV8lfuD/Kxy7XhIVASKe4tlatFNo6y7yQyXIYgd0jReh8TBMazsXDF5w2
	 erPnBJ2kBIgtzxEwNGPpncM8mBIjiqpWGorndtumTrjNqajA5qpign6fdFBoR+6sB7CDE
	 j3i+x1q2J+4+VupWOxtabqTx+3/1gKmeeVkFkKMQcYvVfPPd8k4djML5/zw3ahW7nfZZe
	 NcJH6NTC4Wj2mdoVU+dTSNMH6Y3LmF2B6w8TfVynOEgJL/IOB3Q2W7UB6UGCXyg4bH02K
	 bI8z17PkPyBw06cuEvSIRlQ80rLppQ3fChZJ82OZg1RrwGeUvdwUfG+Id7w7+pKkluQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mI0sm1+7AAXEjUxOg9viiLOpylyP05xTtqGELu4Gg4Q=;
	b=GK2/8q+HEzZkQqk1/eV/S2dpRxevY3J+O7CMK8bV0xlNccc4Nknpay6qROi7b1OkMvSJ
	 x6bkuVH000qbGzRgyfOeczrcRSS/hViDfAkukOhO3X1ayaQulF+IePwiETnxxGb7njkXP
	 VZt5Y5ybE2qpB9FL+v03/kqq0jj6YMgXtJvdiwOfpYVCtuvX5E4tf7UfuekrNIjvdVdP6
	 4zT7SbfdAoEssgiXVkUH4VH+4+vum+omu7LYsNEZUEdtq0mtUMtade1BWmoHk4gdp2Y6Z
	 70Ry/RbEGAmnV3z7b69qEPvBdicVkHsvcovyfnfzo4fIfpYx/IJkaMmLpxBH1SERasA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rnYn3U6t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0090606A31C;
	Wed, 18 Nov 2026 16:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rnYn3U6t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347351F000C4;
	Wed, 18 Nov 2026 16:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020201;
	bh=mI0sm1+7AAXEjUxOg9viiLOpylyP05xTtqGELu4Gg4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rnYn3U6tPlOf8Aqx89PouW9eYp/mEZfT7uR9WryOpCum8eMO2/UtQ3DZGAvQNY90E
	 RKKTvpl8afzGi06AnGxZTave6U9XUrX95BkN4i+paZiYx+jjaalhjRK1d7AL75Gdj5
	 shcnW8A2Am1rZlg50KYDinQ/I/4mPIxSwm5BsRxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1866/2651] ARM: 9519/1: dma-mapping: Fix wrong free function in __iommu_alloc_simple() error path
Date: Wed, 18 Nov 2026 15:51:46 +0100
Message-ID: <20261118150354.156888216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 7761099dde9e8..fb2eb0ed7bb87 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1056,7 +1056,10 @@ static void *__iommu_alloc_simple(struct device *dev, size_t size, gfp_t gfp,
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



