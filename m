Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6DC63D5;
	Thu, 15 Aug 2024 14:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732233; cv=none; b=BM/KaabztTqwIdWwkO//ho/xgJ020kUrrHDgCxaDuysddTLDaeoHDHb+7023QQi/SMnr56gABjjvqEhpjLt0TO7IbsALwy2zZMjooE4CgkSn5Qrci7Md86VAu5WyrDlkKHUd141LYYk5cQ4dfsyjL2pO1OSPltwsm2VZb1v8gvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732233; c=relaxed/simple;
	bh=I9uUhB4ku36Zk6IeXtdGTosmdegFtUgZDE2uG/E5aTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jumPDgIw8283AMsrdBY5SR9iv07E5rYZeaCVw1GY7APHw/v1qV6Qyku+CLJjQqx3hd+/Ih2RENjhgCJMHVAVnhjFBhshIv3gDYiEv2wlasMu5cIc3kFo+CNsLf1zgGYcelqcE0dzaRqK8QpfO6yBC5UpFQbrEQyJXtpMvGDq+B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GS1xhqi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GS1xhqi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E244C32786;
	Thu, 15 Aug 2024 14:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732233;
	bh=I9uUhB4ku36Zk6IeXtdGTosmdegFtUgZDE2uG/E5aTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GS1xhqi+UxdfSy34HSePKAmuUBtP9F340tP1WnZJCdFcjC8AoHoJ8AKC2fJDxsbQ4
	 Pryq6n0inQzqdP11bWMu3KXW6pmu8G5udqK0rQBuECSlm1Jc+NvSAN3eR5GZsG2D5D
	 7M6WAu2i2Yt1dg/WypkLtBMes3ij7+T6cKezalEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 084/352] drm/etnaviv: fix DMA direction handling for cached RW buffers
Date: Thu, 15 Aug 2024 15:22:30 +0200
Message-ID: <20240815131922.493765711@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 58979ad6330a70450ed78837be3095107d022ea9 ]

The dma sync operation needs to be done with DMA_BIDIRECTIONAL when
the BO is prepared for both read and write operations.

Fixes: a8c21a5451d8 ("drm/etnaviv: add initial etnaviv DRM driver")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gem.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem.c b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
index 424474041c943..aa372982335e9 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -364,9 +364,11 @@ static void *etnaviv_gem_vmap_impl(struct etnaviv_gem_object *obj)
 
 static inline enum dma_data_direction etnaviv_op_to_dma_dir(u32 op)
 {
-	if (op & ETNA_PREP_READ)
+	op &= ETNA_PREP_READ | ETNA_PREP_WRITE;
+
+	if (op == ETNA_PREP_READ)
 		return DMA_FROM_DEVICE;
-	else if (op & ETNA_PREP_WRITE)
+	else if (op == ETNA_PREP_WRITE)
 		return DMA_TO_DEVICE;
 	else
 		return DMA_BIDIRECTIONAL;
-- 
2.43.0



