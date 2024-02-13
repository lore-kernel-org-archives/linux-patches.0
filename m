Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B4A60267;
	Tue, 13 Feb 2024 17:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845219; cv=none; b=DYVqedtkop2cDZrYSaOp4IK7qF58uAXfHasGvabsLEAPtVSkWwBmpR5OoyvpTwrnewy8AeozC5th80bpTzIrrIH5BbIWF0hS1DWxDic5EzU6OEi5DOmA8UDnDG1gCbzmk1wYVSgy+dVLZSz0Yx6JT0xzbaDgOCl6adWpbjK3GLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845219; c=relaxed/simple;
	bh=+E4AmGPgqthgks8juJupYrENfR0HaQi0llxE2qEsSAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbXmpfP76Oa6v6DGXM6Upc0uc+Fk6iwf+5SkqKfYTKbJrU2gI3/6coGjJY0hRzcvraVJHUHGGoWFzEqO3pDp8AZ/NPHCosvLMNsYcEJ6E7yV2/r1EQ7NsvivFAEpW8yv+7Iewo2sjoYTWrIbo+6MVKCYnHOozyxUdV3XHaPTTXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNC6+LyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNC6+LyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37FE5C433C7;
	Tue, 13 Feb 2024 17:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845218;
	bh=+E4AmGPgqthgks8juJupYrENfR0HaQi0llxE2qEsSAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNC6+LyPOklsvbmn3IgZlF9YKvEl/tSZ24/P7TmfRgxDZp/pghTNNzMAh0gZV1OBo
	 D+iS9t1ZoRbZlXgHu5x9CIy7PwyY6xM41XxAS42W3FPP/Dn556xqXUcCtyH9jsF87J
	 6cbKwP38Yos4LU3q6TsnVrgTTbIl9EVAQUHttAlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/121] dmaengine: fix is_slave_direction() return false when DMA_DEV_TO_DEV
Date: Tue, 13 Feb 2024 18:20:17 +0100
Message-ID: <20240213171853.200110283@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit a22fe1d6dec7e98535b97249fdc95c2be79120bb ]

is_slave_direction() should return true when direction is DMA_DEV_TO_DEV.

Fixes: 49920bc66984 ("dmaengine: add new enum dma_transfer_direction")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240123172842.3764529-1-Frank.Li@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dmaengine.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index c3656e590213..cff3dba65820 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -955,7 +955,8 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
 
 static inline bool is_slave_direction(enum dma_transfer_direction direction)
 {
-	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
+	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM) ||
+	       (direction == DMA_DEV_TO_DEV);
 }
 
 static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
-- 
2.43.0



