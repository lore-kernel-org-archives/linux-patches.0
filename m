Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A2C2D24AD;
	Tue, 30 Sep 2025 14:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243844; cv=none; b=llMGAIS4sjow3q3nv8Xj1l44JQz+pbDM7pCsCJW/WIy5azGEpHhtclvI96gfgNLio50wo7mUilUCBed9dqC+BXsdDgMeARwRAmg6z2vFbSTq8P0u+K8VLXM2XwHeDbZqTjVl5YUi4whhrWXFLzec9Pqa7kj3Accoi8OTlzkWbSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243844; c=relaxed/simple;
	bh=JmjRPzjq5rCCh2DqgOUSmIu1JoLLfrRr4dEKHcqzhU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PRzVMlXxceqgd6Sn59ymaBdkdGN4tvOUfw4ri8bIaJnbbVjdhdmbSEIDM69/hVcUsLg9kMo1Mks69aZdyKfG/wCRMRipCKAGluj6oUkgI4QDGnD/EXaeuzX2dlHVC5FeoyrhyngL7AjQc10TP7IFcItaWA4mAh+x8DqQfPku7MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xEJcfoNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xEJcfoNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D380C116B1;
	Tue, 30 Sep 2025 14:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243844;
	bh=JmjRPzjq5rCCh2DqgOUSmIu1JoLLfrRr4dEKHcqzhU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xEJcfoNz4dmsNp49/2kmTJ5bmO0q6j43M/OAk0Zeuw1ozAgBgeJPZDraYYlsBAZEN
	 TG7mQiASnUKd92pei89396LV3PDVece/JT0EmZEJgrm37QIc/4M9IMGNR9xPxNF7OM
	 cHUz9DWltfcu767DfnqLWBoMrZ/rcMPml25yjhh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Roxell <anders.roxell@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/81] dmaengine: ti: edma: Fix memory allocation size for queue_priority_map
Date: Tue, 30 Sep 2025 16:46:28 +0200
Message-ID: <20250930143820.758977866@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anders Roxell <anders.roxell@linaro.org>

[ Upstream commit e63419dbf2ceb083c1651852209c7f048089ac0f ]

Fix a critical memory allocation bug in edma_setup_from_hw() where
queue_priority_map was allocated with insufficient memory. The code
declared queue_priority_map as s8 (*)[2] (pointer to array of 2 s8),
but allocated memory using sizeof(s8) instead of the correct size.

This caused out-of-bounds memory writes when accessing:
  queue_priority_map[i][0] = i;
  queue_priority_map[i][1] = i;

The bug manifested as kernel crashes with "Oops - undefined instruction"
on ARM platforms (BeagleBoard-X15) during EDMA driver probe, as the
memory corruption triggered kernel hardening features on Clang.

Change the allocation to use sizeof(*queue_priority_map) which
automatically gets the correct size for the 2D array structure.

Fixes: 2b6b3b742019 ("ARM/dmaengine: edma: Merge the two drivers under drivers/dma/")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Link: https://lore.kernel.org/r/20250830094953.3038012-1-anders.roxell@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/edma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ti/edma.c b/drivers/dma/ti/edma.c
index 01089e5c565f3..7a0f188fb43c5 100644
--- a/drivers/dma/ti/edma.c
+++ b/drivers/dma/ti/edma.c
@@ -2029,8 +2029,8 @@ static int edma_setup_from_hw(struct device *dev, struct edma_soc_info *pdata,
 	 * priority. So Q0 is the highest priority queue and the last queue has
 	 * the lowest priority.
 	 */
-	queue_priority_map = devm_kcalloc(dev, ecc->num_tc + 1, sizeof(s8),
-					  GFP_KERNEL);
+	queue_priority_map = devm_kcalloc(dev, ecc->num_tc + 1,
+					  sizeof(*queue_priority_map), GFP_KERNEL);
 	if (!queue_priority_map)
 		return -ENOMEM;
 
-- 
2.51.0



