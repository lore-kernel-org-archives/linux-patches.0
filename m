Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210625FBB5;
	Tue, 13 Feb 2024 17:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845043; cv=none; b=qzrHk56T0Acqi+yhiw2SzeAfzl3yVRVefiWP2Ukqumv48I92Kr8Dj5vJoR0nJT8qkQpoz1u2/IfXvzAf4vyxmTIK6qjCnDnIPQvcuRjpGRfBjv222W5nzlmVrVC7yF6M+4F3xJ5gtXe/ONhg2nWDhOYQvn7nouAlxFf8+zxBi6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845043; c=relaxed/simple;
	bh=sW+R2FT3CVS+OSBW91LQ1iCQJuC5Vq2wiilst4Bl0Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VL9osV3oq+dklUAgACjGMvoS0p+4V6nzCO5yYRxrQjStBtoa1xAWiFX8HG+H04C+xL1vKHBvoKegPCEbz718vfqy6ahvq+Y5TRAql1abgwETr2n/l0xbag2AvIVvfpPlJJvfdhsfF6kMPj59iE9HGN4Hnai/eWksV2M3BipKw3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xb25z7fo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xb25z7fo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF3EC43390;
	Tue, 13 Feb 2024 17:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845043;
	bh=sW+R2FT3CVS+OSBW91LQ1iCQJuC5Vq2wiilst4Bl0Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xb25z7foH2xdTKxzDsTar+yBLk8NurdKn/5UWP+iBUrZafgno8nEY7eid1oyq7zpt
	 q3y6PNQA+WFLZSoTW1xob4GVRj/BtJm2qoho2UvC8vqU+rg0oS+Pz0f/e6ptx6uNVz
	 0r+yfANY1jsQnAgUiq+nAWMP2dhJZ6gPHc21UHAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 07/64] dmaengine: fix is_slave_direction() return false when DMA_DEV_TO_DEV
Date: Tue, 13 Feb 2024 18:20:53 +0100
Message-ID: <20240213171844.966411874@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c923f4e60f24..3576c6e89fea 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -954,7 +954,8 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
 
 static inline bool is_slave_direction(enum dma_transfer_direction direction)
 {
-	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
+	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM) ||
+	       (direction == DMA_DEV_TO_DEV);
 }
 
 static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
-- 
2.43.0



