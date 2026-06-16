Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D44744102A;
	Tue, 16 Jun 2026 15:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623176; cv=none; b=V13Meht0cOQp1VoXm/8cqR6BGvOblMqWkRE6aBECqV3UKWpXee5zt2q54UF5uuQwOIhpt1PMBnaY6NgIpTXib1ybwiIyi5a8mXK9ymcwNrOohLLUnj0JnxrHgZ26jKohfJiL185yap/fpIKokms92OMr3KnRT+5vKbRedkOToLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623176; c=relaxed/simple;
	bh=5PKjrfsKkHUKBS6S7zDQNQrVZ86eVdWp+lklTVDd0k4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcJWEbd+WHwHBA/CQzMBRjoMrWcbswgC9NcgVamHiEgVlBIzrl/QEMGw3hcEiYn5/BQdAne5Ppygz7TLmVPZn/5u5E0hh/NbOK0pqmC6SlKw6VWxnsJUw3z2cnLUCkFfsnBIyqXPhK1WecmtFjFGdDrpFOd5mHRjuOClvDVCuoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vp28C5hl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vp28C5hl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070E41F00A3D;
	Tue, 16 Jun 2026 15:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623175;
	bh=nd2oQN8UghwGloAImDZ1RvC1wNfJEzQutAQUqc6xgA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vp28C5hl4Jfya1FAW0RI3PTfCCdMHYo85QBmDHwYhYxOvz35GJFS0wNgd0lYxtLX3
	 kTmBiLHZl/n+7S8j1UrrlKBkDCr2I9dAyy7xpkAHXD9FruU0eJTIFDCVyECYvFPQj6
	 SUwGKKzASI/cFKRpzCi+iQZfztQPdbZYZSx9kvGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Logan Gunthorpe <logang@deltatee.com>,
	Li RongQing <lirongqing@baidu.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 099/378] dma-mapping: direct: fix missing mapping for THRU_HOST_BRIDGE segments
Date: Tue, 16 Jun 2026 20:25:30 +0530
Message-ID: <20260616145115.543439864@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 560000d619ef162568746ce287f0c725e24ea967 ]

In dma_direct_map_sg(), the case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE
incorrectly used 'break' instead of falling through to MAP_NONE.
As a result, segments traversing the host bridge skipped the required
dma_direct_map_phys() call entirely, leaving sg->dma_address
uninitialized and leading to DMA failures. Fix this by using
'fallthrough;'.

Fixes: a25e7962db0d79 ("PCI/P2PDMA: Refactor the p2pdma mapping helpers")
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20260603013723.2439-1-lirongqing@baidu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 8f43a930716d46..306afebf54ef06 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -466,7 +466,7 @@ int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 			 * must be mapped with CPU physical address and not PCI
 			 * bus addresses.
 			 */
-			break;
+			fallthrough;
 		case PCI_P2PDMA_MAP_NONE:
 			sg->dma_address = dma_direct_map_phys(dev, sg_phys(sg),
 					sg->length, dir, attrs);
-- 
2.53.0



