Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88C57BB14;
	Wed, 21 Feb 2024 13:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523057; cv=none; b=WkC8TH3p7Jc5J1nIMDqFBtpmCbNeLgAcFLlhclweiZb3eEbTwl9ohFHqEsAsC99ZDMCqsIhB8gWYwKKyyeKGtKrSkJIBmX8d3J+KQlS35cm8hgQJDJTSg0NyT4WGQQv//U5/9KM0La8OhJx4mI69L6gR5cS4SEkPjrD68mD6eno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523057; c=relaxed/simple;
	bh=8dd0irrc/Juh0UQq2lbvb0uyQ1PsymQ0+SvJ+IkgbXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2s7MtPXNKg+3HdSIsvaq+upLT6sXWJoT30TQAlafzZ1FC/efH03I95I8/TlRV+0MviKdqrbHdPr9ZL/HdsXrvWZYVOFXingFU+imSoWQW/9eou2bjbRjsp1pEWvSR6dTE4MFClWvGiSnC1BmMKcnHRfi7BUpiRU8GI+FAFiXkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVuLwrVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVuLwrVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D794BC43399;
	Wed, 21 Feb 2024 13:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523057;
	bh=8dd0irrc/Juh0UQq2lbvb0uyQ1PsymQ0+SvJ+IkgbXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVuLwrVQ78ljAvYErqIDLvx+MqdLVcCfJwIeugJzei73lMLYpeop/KCc03mP8CYAq
	 nyS0825zSYVAZmzmX+YCzC6/ocKMZ4EFB/Ovp8tTWDJvqIr3LjAqCVZM8sV2o6NeK5
	 OAuwHh5u70Um5+B+lkigITirwWxmaT9BSEjvF9mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 301/476] dmaengine: fix is_slave_direction() return false when DMA_DEV_TO_DEV
Date: Wed, 21 Feb 2024 14:05:52 +0100
Message-ID: <20240221130019.122039397@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9000f3ffce8b..04826a793039 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -959,7 +959,8 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
 
 static inline bool is_slave_direction(enum dma_transfer_direction direction)
 {
-	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
+	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM) ||
+	       (direction == DMA_DEV_TO_DEV);
 }
 
 static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
-- 
2.43.0



