Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E90643E4A1;
	Tue, 16 Jun 2026 15:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623182; cv=none; b=na11t9548bSE5W4WWVzKuJdttqSoRoBWh29WB2qyAvcvL+IPftTjmaeaFGfQILrPedJHI3H/LeYuQT01qQIm53MfXkfH2sKkG5a8mOUc6CKSfiDh8JUiRoYF7dCDjlFCQyHPi+Bv5uT+NP6t4mXV1jxo1CRoBEYxkkXM43Sjr2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623182; c=relaxed/simple;
	bh=dxmJtXS49ycfyTxB74MzuNqPghRubHxtAIp/Gwtb6Vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQK+yz4piUh6yFCEX0qdZeIAWwJ2WB1YCkVhMJzJS08k6IeWBkhWFlr2GkbNkGCwjMWjgAin/WCQ0b4nxJLvOPJGlVLgXTIEqqoNWtZCGcvXKX6tMTinyPmxPER63VoJAYPkrbpLfsW9te6M5XkTeLI+BFbf5lIm7p97SSjQMfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvWhs7TY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvWhs7TY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E211F000E9;
	Tue, 16 Jun 2026 15:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623181;
	bh=4r74YgxD7pXqm6fEfKXpbFGHROpJi74rfgEXivmzxjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvWhs7TY8QySp+one7KkIC+6bN0ueYLGiNLDpSvJ3TCXlMncgL4b2YU3OnVojLylt
	 X9YHKsZEVUopkc6b7vXRsCR2peNgiYqjoUXtd/21gRVhTTU6Nis6Fx7qPweUeXiaUe
	 AVq2u2xkwaW49pcMvvnTyIqL6RuanqmK6YNM5ZWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 100/378] dma-debug: fix physical address retrieval in debug_dma_sync_sg_for_device
Date: Tue, 16 Jun 2026 20:25:31 +0530
Message-ID: <20260616145115.616981334@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 9bfaa86b405381326c971984fd6da184c289713f ]

In debug_dma_sync_sg_for_device(), when iterating over a scatterlist,
the debug entry population mistakenly uses the head of the scatterlist
'sg' to fetch the physical address via sg_phys(), instead of using the
current iterator variable 's'.

This causes dma-debug to track the physical address of the very first
scatterlist entry for all subsequent entries in the list.

Fix this by passing the correct loop iterator 's' to sg_phys()

Fixes: 9d4f645a1fd49ee ("dma-debug: store a phys_addr_t in struct dma_debug_entry")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20260603123708.1665-1-lirongqing@baidu.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 3248f8b4d096de..2c0e2cd89b5ed7 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -1556,7 +1556,7 @@ void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 		struct dma_debug_entry ref = {
 			.type           = dma_debug_sg,
 			.dev            = dev,
-			.paddr		= sg_phys(sg),
+			.paddr		= sg_phys(s),
 			.dev_addr       = sg_dma_address(s),
 			.size           = sg_dma_len(s),
 			.direction      = direction,
-- 
2.53.0



