Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89FA44B69C;
	Tue, 16 Jun 2026 15:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625153; cv=none; b=t06qPaQ9hcYXCZiYZdEZJEKmbfjmlWu1orD6gEWLDve/YGLmaFGKWQ0J3jBJWx5ziuPD3WhM6Agb8zJ4QrYsg2uhDkfT/8S4y3LneGv+lMKh+FT3vILdyszh3IKrQFgOIg18Wd9QqfKzwV8rdt5zWwTIAh+O5L5P+R0S93ov/Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625153; c=relaxed/simple;
	bh=nDZXqIHA2yRZ9d1fd1rn/yim4nX9+s2bAGDfxTE8PG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8bJSUE6rOgYHdeHerkAf36F+TUW3PH605JEbEF+/SNpKwnnfxhEhVtehBh5ThdcI9YjbCKHHUIxYRg1YavatSBm3R+pjcok02EIwujXzuNJVcr7yJngt9nlzclzsyMCi5na3uSKWK7Uy+Qcl13u5+8FwFVWOekxiydk9ZuiHPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Z5oAAIR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Z5oAAIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD14C1F00A3A;
	Tue, 16 Jun 2026 15:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625152;
	bh=4OlQFSGs20+NGHxHTIBjMKOBDgJSna5z7MBS1RuP//E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Z5oAAIR3kmfFubvc0GVsKrkxNop30epZrYfVMAdwncFC90S4qVZbl47uqSaIAdi6
	 SWYwvTQeThbvq37JTbF5g9J4wvzI9nuiqBycBk5scleauwIQNinhrM6r/1QyPEzLW7
	 jnU/s6yVf6H1to49avkt77VCHXDZLHQmhsAQO+aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 088/325] dma-debug: fix physical address retrieval in debug_dma_sync_sg_for_device
Date: Tue, 16 Jun 2026 20:28:04 +0530
Message-ID: <20260616145102.094944316@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fa4aac33391723..03780f39613cca 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -1555,7 +1555,7 @@ void debug_dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
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



