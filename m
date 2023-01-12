Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E022779C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9D2C433EF;
	Thu, 12 Jan 2023 14:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533225;
	bh=1aDzHVJOO/fZ4iIayeO2soOTOjlNcQS0cN0dPRM3Ufc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIbMiXpHwWPKRq9SbNG6F3gku5NDiXEs/cKqV3iUJGFgzO3Bx4YwkzzEBT7gF2haE
	 /U9qLV7DF7kVKWcqG5niOsoBV8KbtbzXGTpDbYayKhCPFiQkC7j6v+4jHO8j706YTo
	 vRC5gvu8/kWMDhF9l5ICFLONdoitrkDg8725qBj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 411/783] iommu/sun50i: Fix R/W permission check
Date: Thu, 12 Jan 2023 14:52:07 +0100
Message-Id: <20230112135543.374868542@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit eac0104dc69be50bed86926d6f32e82b44f8c921 ]

Because driver has enum type permissions and iommu subsystem has bitmap
type, we have to be careful how check for combined read and write
permissions is done. In such case, we have to mask both permissions and
check that both are set at the same time.

Current code just masks both flags but doesn't check that both are set.
In short, it always sets R/W permission, regardles if requested
permissions were RO, WO or RW. Fix that.

Fixes: 4100b8c229b3 ("iommu: Add Allwinner H6 IOMMU driver")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20221025165415.307591-4-jernej.skrabec@gmail.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/sun50i-iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index 2512eabbf4ac..68aee56e2231 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -272,7 +272,7 @@ static u32 sun50i_mk_pte(phys_addr_t page, int prot)
 	enum sun50i_iommu_aci aci;
 	u32 flags = 0;
 
-	if (prot & (IOMMU_READ | IOMMU_WRITE))
+	if ((prot & (IOMMU_READ | IOMMU_WRITE)) == (IOMMU_READ | IOMMU_WRITE))
 		aci = SUN50I_IOMMU_ACI_RD_WR;
 	else if (prot & IOMMU_READ)
 		aci = SUN50I_IOMMU_ACI_RD;
-- 
2.35.1



