Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056288;
	b=fcyJp1RyigIxgzJQ7EVeUem10WSIYu/pRINkSbjVbfNOoq0YRbl/FzZca6MqgLDaFY2B
	 iRG7rd13xbSiDMdN3DnakZEbVkaAn5sI5nebZsGuLx9VpUNShUopYcbQyjx+MaSgdFbbI
	 0X3TvL7e37nej8HFe/a+xrlf+g239o63zfxvgcofy14zO83A4xuTVJGyo2MqZS18OPomQ
	 /V2zERXd/wH8qONUAtJT6bBN2t/76FzF2ONcdyV5Z01WWgt1RCT4ge9FU7lxBkKCQyU6A
	 vGRTjBBVEiEP3+Jntf4fdI9ToYiTLvq3SmHrREvv2EjMvpan+HSOGm3hfR0x5680YKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056288;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D0OlvKOr6nnWp2HXWW2eATDmyvewx9T4HTBVS0JKkkk=;
	b=Bpn0GJ0km7xBPaI8LFlpmsx/DmNQK9cgPGLH0GjZhyZQvoLcU8oVgkDP+DxlVXrASV8a
	 /4YQjK7Z8efxZlV/wfMVYv47Q8UAQTqjzvu0/wmivFROVf22lGHYIM/dSgD9T5CWnTkah
	 lus6AI8UNVpDdkOQjbbUY9VojWC8L2+ZpI0RKlN5oeDNyORO+dzxUTTWr4z5uo7XWh79R
	 YyWrh31C1fTpNCnuHhwa0BI47DYEA3311FCU9wHuDqhnRK/cht1fgywstUb93RbcWvKSk
	 rZApc51aL77fs/FkGfEnAwvB/qKyhDpUu74osxAg2Gw/uIGVpVzAKafmVDgIw8RAQBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HnvQcM8j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7FC606A31C;
	Thu, 19 Nov 2026 02:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HnvQcM8j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075751F000C5;
	Thu, 19 Nov 2026 02:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056288;
	bh=D0OlvKOr6nnWp2HXWW2eATDmyvewx9T4HTBVS0JKkkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HnvQcM8jjrqluzDEKcMCoGr/0NXIoGYmJi9nfG7Gu+jPJbNXyKHLUdkzwqRUCxxgO
	 ehoAUFOqNox+OiPK3lWClc6Jg6b7V1iVv6iQYwQyoeNULAa9pjm/7g9vT22zl5urtV
	 39QoJY6gxWmzJrBrSNTxJ0EQ6Sf/NH79Qx8o9lh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1933/2214] ARM: 9519/1: dma-mapping: Fix wrong free function in __iommu_alloc_simple() error path
Date: Wed, 18 Nov 2026 16:00:09 +0100
Message-ID: <20261118150128.331061454@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4b61541853ea1..5ed43e3bcb818 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1407,7 +1407,10 @@ static void *__iommu_alloc_simple(struct device *dev, size_t size, gfp_t gfp,
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



