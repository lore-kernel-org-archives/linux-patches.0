Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149201C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:25:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849DFC433EF;
	Wed, 28 Dec 2022 16:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244753;
	bh=O6Kj21FHuFzGt3APk/bhiAea1tt3HOczigZxjaYGXc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FkCcbMRvHnAXCIq6/rFQK2X/0pptzPXvKkwQD/1+Vu0p/xJqwplLONgqAleN4n9Cd
	 ZOj0jROjgVrJ/OvwZRTA1tgK0Z3NO5bDF2tkKeV+eeNQ7dh5nLlT5HukZ0ay6eFsHX
	 757pq3OwE+al/zoPE0b4zvDLY6aIsx4aHK4rj3EA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0768/1073] iommu/sun50i: Fix reset release
Date: Wed, 28 Dec 2022 15:39:16 +0100
Message-Id: <20221228144348.873672551@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 9ad0c1252e84dbc664f0462707182245ed603237 ]

Reset signal is asserted by writing 0 to the corresponding locations of
masters we want to reset. So in order to deassert all reset signals, we
should write 1's to all locations.

Current code writes 1's to locations of masters which were just reset
which is good. However, at the same time it also writes 0's to other
locations and thus asserts reset signals of remaining masters. Fix code
by writing all 1's when we want to deassert all reset signals.

This bug was discovered when working with Cedrus (video decoder). When
it faulted, display went blank due to reset signal assertion.

Fixes: 4100b8c229b3 ("iommu: Add Allwinner H6 IOMMU driver")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20221025165415.307591-2-jernej.skrabec@gmail.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/sun50i-iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index a84c63518773..c777882d0ec2 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -27,6 +27,7 @@
 #include <linux/types.h>
 
 #define IOMMU_RESET_REG			0x010
+#define IOMMU_RESET_RELEASE_ALL			0xffffffff
 #define IOMMU_ENABLE_REG		0x020
 #define IOMMU_ENABLE_ENABLE			BIT(0)
 
@@ -893,7 +894,7 @@ static irqreturn_t sun50i_iommu_irq(int irq, void *dev_id)
 	iommu_write(iommu, IOMMU_INT_CLR_REG, status);
 
 	iommu_write(iommu, IOMMU_RESET_REG, ~status);
-	iommu_write(iommu, IOMMU_RESET_REG, status);
+	iommu_write(iommu, IOMMU_RESET_REG, IOMMU_RESET_RELEASE_ALL);
 
 	spin_unlock(&iommu->iommu_lock);
 
-- 
2.35.1



