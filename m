Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D2A257C
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5430C433EF;
	Thu, 23 Feb 2023 13:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157709;
	bh=rekeavdwujp1WWCkzH5G6l9JbuSauzkF+AdoyKWGXUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/82nSUn+vEOdrajJUe8OJfwJKQiHpTOgEMUxaM0P725szXqNPj1NZUzSnYlvKDwV
	 EQzwi/tS0eBGnaD8b8jZJk4Ff5PdC6NIFzk0J3zKg5pV1yIqmnAXO2+9NpH46+Teh1
	 fe+gIEmH0VXumVN4vPLjMQZU1Xgp5mP8t4cpA4lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 01/46] drm/etnaviv: dont truncate physical page address
Date: Thu, 23 Feb 2023 14:06:08 +0100
Message-Id: <20230223130431.632783144@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit d37c120b73128690434cc093952439eef9d56af1 ]

While the interface for the MMU mapping takes phys_addr_t to hold a
full 64bit address when necessary and MMUv2 is able to map physical
addresses with up to 40bit, etnaviv_iommu_map() truncates the address
to 32bits. Fix this by using the correct type.

Fixes: 931e97f3afd8 ("drm/etnaviv: mmuv2: support 40 bit phys address")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
index 55479cb8b1ac3..67bdce5326c6e 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
@@ -80,10 +80,10 @@ static int etnaviv_iommu_map(struct etnaviv_iommu_context *context, u32 iova,
 		return -EINVAL;
 
 	for_each_sgtable_dma_sg(sgt, sg, i) {
-		u32 pa = sg_dma_address(sg) - sg->offset;
+		phys_addr_t pa = sg_dma_address(sg) - sg->offset;
 		size_t bytes = sg_dma_len(sg) + sg->offset;
 
-		VERB("map[%d]: %08x %08x(%zx)", i, iova, pa, bytes);
+		VERB("map[%d]: %08x %pap(%zx)", i, iova, &pa, bytes);
 
 		ret = etnaviv_context_map(context, da, pa, bytes, prot);
 		if (ret)
-- 
2.39.0



