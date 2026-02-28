Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7416132AABE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301236; cv=none; b=DeOZrC3EDVZqLpBR6Q+jfhCObN2J992NrNZDbQxLJeJqkdIBzu2Fi3eYDuc3votacYs3BfjowpcxCIOKO1TrOuPrTCwXuh6gS19wcUk+p2q2r7bDL5tkD11tWb65Xz9EGNu7RvY6YVqdRU2hN3IDZr7nmNSxr0VsSzJtQpOrmxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301236; c=relaxed/simple;
	bh=dLPGJNofiRNB53LoWfuvKRZy9fh8nZFlbeV2LQiNivc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmtR/VA2XVfRLSD8uU/n649RAyXOw3ust77piiGRfku4VxAn2Wj80EFhKPYo1hBy2HqaN+gdoR2HwNcUkkXPxsbK1SmIiLT7QYqX3sbtNXXeelLzg5i5ddFp7s+93mmqB8IplXRD0yOyN0QYr9B+jUknAokcKyBaqa/Wy41M+sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/QBq2T3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/QBq2T3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14C0C116D0;
	Sat, 28 Feb 2026 17:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301236;
	bh=dLPGJNofiRNB53LoWfuvKRZy9fh8nZFlbeV2LQiNivc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/QBq2T3BbnkRmMCZZUX8DS9QYinkhIuqFTq+dnYC4pvNdG7PodVZjFO0CC1DT569
	 k7Ma7j+MlyRxdxVAjp28qpATt1Fh9+ouXcASs0B+AHhi1u1WD2iNJYZJDXPH3Xzwoh
	 kkgKnuFanFsFTsHhwayKrjBSdc3plWgDf3KY030pBXQMAtI/TWgVoyuWPqSTdjFOXc
	 2cJe7UwelU+W1K71Fvzn//OODCHXkB9EgxlR4S/eE937zEpwxhyILxIdhOkBxNlvnY
	 460Hr3Wo2H/GwTSS6yKXn7642gznSF/MsyNHuBJexXAPG1eAVcLfH8C6Mcr6bam8fQ
	 axJj3PwoMVt3g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiri Pirko <jiri@nvidia.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 415/752] dma-mapping: avoid random addr value print out on error path
Date: Sat, 28 Feb 2026 12:42:06 -0500
Message-ID: <20260228174750.1542406-415-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 47322c469d4a63ac45b705ca83680671ff71c975 ]

dma_addr is unitialized in dma_direct_map_phys() when swiotlb is forced
and DMA_ATTR_MMIO is set which leads to random value print out in
warning. Fix that by just returning DMA_MAPPING_ERROR.

Fixes: e53d29f957b3 ("dma-mapping: convert dma_direct_*map_page to be phys_addr_t based")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20260209153809.250835-2-jiri@resnulli.us
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/direct.h b/kernel/dma/direct.h
index da2fadf45bcd6..62f0d9d0ba02e 100644
--- a/kernel/dma/direct.h
+++ b/kernel/dma/direct.h
@@ -88,7 +88,7 @@ static inline dma_addr_t dma_direct_map_phys(struct device *dev,
 
 	if (is_swiotlb_force_bounce(dev)) {
 		if (attrs & DMA_ATTR_MMIO)
-			goto err_overflow;
+			return DMA_MAPPING_ERROR;
 
 		return swiotlb_map(dev, phys, size, dir, attrs);
 	}
-- 
2.51.0

