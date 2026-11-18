Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031880;
	b=Izj/ERHOIlTLYZ0X/9SCicqPhOHhv5ZW9Nt68j8vBldbepJ/2wP27gu0KcYaknCMIWmC
	 eZ1rsBrjKcsLzQpfdNLtiTV8PTU7btSjbZdrehBhh3cUBqhZYgP37GhejdTjVUCYZctPx
	 8vpC55BFKU55hlf1Aq5fk51k1HgIvCbT5qmVbYV/33mjyNB5QnuWi2iaAKSgevIi9B6ZT
	 UshjVcZ+hhLEXrZvc+h8bhAiklg13vHcyOtcsnZpU/2w4YzSH7JwgPFyHXeML64ZRdXv9
	 WE+TwbNfi3nVydDKuzOAa6hTQ4tpphgp0x4dXdFqMC13RrxLDuYVFxfDui6NWAB4oiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gT0Utileon6MBx5LcaUZHQVchsU17M9voJcElA+VtZE=;
	b=a0ZE+UC2diti4pb9zXq0Za87wZafsSHvWdDkqK4n57qVNNubsxF9YaZVQAvx5OLkTKOI
	 gG/dR4SzU/5V3AaTLx3qJYwIpuh3tJ/9pKb8QnSzZMAzzIC+LcUl13CrHpKPlZMENuF9W
	 e8Pi8N9ypxCe3d4tboq9Tmvv79woHwoHbFdoX+0j8WkgFgwxZdVpq3mgqf0KmUdnBwH8X
	 /WlvOTL7AVFI62H+2BYomkmPCwhB/NDvPtCSWJOgbi+yxOuGJz6f01ZA6GDTSumKtAgF5
	 RrRsTDMpfFCn71DDinY6AQ2+pL83Dli2/jRvBL6t+IzG87Tfr+Z7Rlp4eMG1gtLhqXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T+b35Adq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C914D606A332;
	Wed, 18 Nov 2026 19:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T+b35Adq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BD81F000C6;
	Wed, 18 Nov 2026 19:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031880;
	bh=gT0Utileon6MBx5LcaUZHQVchsU17M9voJcElA+VtZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T+b35Adq8J6foHn/MR4+XMXqxxryZrEiMoc+h/HbDRoeU7OggfCAfQkefjWsdsgyS
	 gKrUuxdyzWSNUAaS6RkicseSHPUM0eL8i7VJ1mmBsm6JXXhhcF88prMpzymwn3WhCG
	 k6OKOzy8lqHZqUjdRBf/0FFzygJMCiTAMdu2EnQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1214/1756] ARM: 9519/1: dma-mapping: Fix wrong free function in __iommu_alloc_simple() error path
Date: Wed, 18 Nov 2026 15:55:41 +0100
Message-ID: <20261118150058.135006309@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 88c2d68a69c9e..44fa25ff04b1c 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1058,7 +1058,10 @@ static void *__iommu_alloc_simple(struct device *dev, size_t size, gfp_t gfp,
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



