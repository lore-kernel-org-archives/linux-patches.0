Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28054257C
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4C3C433D2;
	Thu, 23 Feb 2023 13:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157642;
	bh=upiZyjBW7Zqpirs8njROxyMEciquxpbVo6QLpLFYd9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rUB4iMce4Wf4VTTrxlXqMtXUsAXTZtr7rZk8aSxQn1leMQxnnQqJBCSnfHtuGBNtk
	 jzkEYZYtW7Ss4XselxKsw1zSZe8JDMovfadJmw94rg/+gje+8qyc9zI6dzSq/9wsrv
	 huVCL7t/sGtYwU3TL2IDLq3QwS0zMZC6QFX5Unag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/25] drm/etnaviv: dont truncate physical page address
Date: Thu, 23 Feb 2023 14:06:18 +0100
Message-Id: <20230223130426.868608461@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130426.817998725@linuxfoundation.org>
References: <20230223130426.817998725@linuxfoundation.org>
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
index 9ba2fe48228f1..44fbc0a123bf3 100644
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



