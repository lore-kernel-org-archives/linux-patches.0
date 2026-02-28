Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C809E33F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301166; cv=none; b=jDS18/ESnI4ONi8+NYVXnVaod95Dn/3fYKTBqNr+tkeItWI/3oVvea5pFxsQwNHEeXDEwE0PGPpHEbDhwLkrZygkc4m+g5PtbYf7YA7mGrvcs5ioW9kiUdxTKYq9FVBQq8f9K20havo6/EYY1x/hlK6azCwR/g4BEgAmm7PN8i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301166; c=relaxed/simple;
	bh=HdA84fezaPdN0UlF5lqo0bMf88YR7QriDE+7rE1Cuwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=toWhWNbzyR2saon2WAz/cbqOSsd57gud3TAZIXfb11OMTiEMKNudOoagD4VxkWmAJwn58GXnuhxPm/Zh37l2qSGmZmZGhvmXqwK4JIqSJim8dKiELvZ0OzSnct6Be41JGgxPm2zfvjm6RogcYsAtrqom934ZsISIB9J0DyvkkHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bJlkFYGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bJlkFYGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5ABC116D0;
	Sat, 28 Feb 2026 17:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301166;
	bh=HdA84fezaPdN0UlF5lqo0bMf88YR7QriDE+7rE1Cuwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJlkFYGVWhU5L8y2MeKrkOt/1AP0s0QcLZoa+O//DBFVjrDIed4KKzByMF11kbLVM
	 La5+O0mrtGtpjL3MWCcv6of8paArBAGIXl/AwFbwhLe4VsGjVKRR8R01VSDGB1wmnT
	 wBGHd23DaLr9UISbcIqmAPNLCPx15KipxWRe2g+DUJB2XsGFuOOvyC/glY9yvPvED6
	 jRmKFdqVBKM9woH58C+tFAQZJP3oRprdIH0TuCN4mqMCZY8vfwpmcad2U+QePBohTz
	 gTAY0yb0Hg/W/B1/dAcjkkQKXJwWYsRgb0JJ7hkKHZphkuhihOvcONAwL+OXn9Fy95
	 0JMaYcPtYYVTg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Cl=C3=A9ment=20Le=20Goffic?= <clement.legoffic@foss.st.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Le=20Goffic?= <legoffic.clement@gmail.com>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 332/752] dmaengine: stm32-mdma: initialize m2m_hw_period and ccr to fix warnings
Date: Sat, 28 Feb 2026 12:40:43 -0500
Message-ID: <20260228174750.1542406-332-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Clément Le Goffic <clement.legoffic@foss.st.com>

[ Upstream commit aaf3bc0265744adbc2d364964ef409cf118d193d ]

m2m_hw_period is initialized only when chan_config->m2m_hw is true. This
triggers a warning:
‘m2m_hw_period’ may be used uninitialized [-Wmaybe-uninitialized]
Although m2m_hw_period is only used when chan_config->m2m_hw is true and
ignored otherwise, initialize it unconditionally to 0.

ccr is initialized by stm32_mdma_set_xfer_param() when the sg list is not
empty. This triggers a warning:
‘ccr’ may be used uninitialized [-Wmaybe-uninitialized]
Indeed, it could be used uninitialized if the sg list is empty. Initialize
it to 0.

Signed-off-by: Clément Le Goffic <clement.legoffic@foss.st.com>
Reviewed-by: Clément Le Goffic <legoffic.clement@gmail.com>
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://patch.msgid.link/20251217-mdma_warnings_fix-v2-1-340200e0bb55@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32/stm32-mdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/stm32/stm32-mdma.c b/drivers/dma/stm32/stm32-mdma.c
index 080c1c725216c..b87d41b234df1 100644
--- a/drivers/dma/stm32/stm32-mdma.c
+++ b/drivers/dma/stm32/stm32-mdma.c
@@ -731,7 +731,7 @@ static int stm32_mdma_setup_xfer(struct stm32_mdma_chan *chan,
 	struct stm32_mdma_chan_config *chan_config = &chan->chan_config;
 	struct scatterlist *sg;
 	dma_addr_t src_addr, dst_addr;
-	u32 m2m_hw_period, ccr, ctcr, ctbr;
+	u32 m2m_hw_period = 0, ccr = 0, ctcr, ctbr;
 	int i, ret = 0;
 
 	if (chan_config->m2m_hw)
-- 
2.51.0

