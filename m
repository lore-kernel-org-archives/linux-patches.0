Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8F035AC1E;
	Tue, 16 Jun 2026 16:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626800; cv=none; b=JmfOnF/dSnLgM0ZWkz5hPHlBtiyQx6gTHvt9bMbFpAVyw8+sS84XCKhpG6tg6Zc0gIgPKfnJWXn6PhNqYXlW/IFVofarmNV9Tz73oWNRS+PoMnUUutDP+s1c+xEJPZKYtRP0ssGB98tCAqn9rh2MoSnljAqBAP0Qg4Il6HYm6hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626800; c=relaxed/simple;
	bh=ouj4tCVAgGurB52+rPJg7NQvfDDExNYbEtTuVoTWEzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4RvMLRGKBeDjG+GmJMcvaFHsOsz3Kz//hyt3uOJck5wenfYjLcOpQdPQnaCT796DfQfuos5L8GDqV/ssPShYRoishHqh5kJV47Bam3EPihhocu1klZYPQejLkoLIVk9n0h+rdMQvO26Uy0GLaauu0Gt4TjvuKX9A6bhRquVho4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghlPnq39; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghlPnq39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D8C1F000E9;
	Tue, 16 Jun 2026 16:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626798;
	bh=qmHjyq7LORLwUG/bUJdxssYolVOJESXRDUpZFnD0uyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghlPnq39JTHGmw4YGNIknbQ55mtLR3bkIM27/qMfUqw+BVoOpG3iXmtlg56TitmAJ
	 Fm0Xc/lkyMj0uDyxOEXtf8n0hWXodhDO5GtwTbo9rU30Cs8DtJyyppEBeiycCOiCbC
	 pZwD7hUkYTxOJU94L9Wv6lCFT8eJOgxVHwINA7OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/261] dma-debug: fix physical address retrieval in debug_dma_sync_sg_for_device
Date: Tue, 16 Jun 2026 20:28:31 +0530
Message-ID: <20260616145048.494689048@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 035dda07ab0d08..b1192cff035924 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -1573,7 +1573,7 @@ void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
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



