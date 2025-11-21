Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A3E34DB72;
	Fri, 21 Nov 2025 13:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732926; cv=none; b=QVfhhUvN63RdYcIlv5e2DupknqMQD0wjEE8dcnkxiOKb3ocv1tCcvwil41Y12owrmdk2PNFRkZTg2GgzaGDwitcHF9mEOB0eGhWWKn7lq6Udnwbsb6USuKatTjvcgvKU2Bzi0KVnFgAKTCQguBGJpuFCiQhmQFtgDZ9N+UNKQss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732926; c=relaxed/simple;
	bh=N5+qyJ2glgVN6wFodkL9MDRldVl+vFhc2i58jGVHxrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9oy1u5WeiMiRzfyVvHkfzXrjtrjCiDJg5kJj3RvYk3uwSZfm3nCLnxFf/7zy3nw7UDDdO8tDOfGOFrDZVeMxzsKeAR1U7PnNqHkjxnnK/F17v6M0WsP13GF3kgL00B159MuiTK+Pf9lAGfwOROnBN89OisQ+C4TsA89BO/xAOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3m8Z5Sp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3m8Z5Sp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296A0C4CEF1;
	Fri, 21 Nov 2025 13:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732926;
	bh=N5+qyJ2glgVN6wFodkL9MDRldVl+vFhc2i58jGVHxrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3m8Z5SphiTiIue7DQpMRVQNv17egLlBHG7i8VGFY6Jq6LW1RaCP8eCUYudgrU1ey
	 CTJJ9fp6LB6/YstIPsrE/2dM2/E0BpS3/lYV20AccQNuchOgaq/TfiLWCfFTGstFcL
	 Wc5P3vLxO5oWsGfDMrpjqHurYTc52KCLBFITgVHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 292/529] page_pool: Clamp pool size to max 16K pages
Date: Fri, 21 Nov 2025 14:09:51 +0100
Message-ID: <20251121130241.416689538@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit a1b501a8c6a87c9265fd03bd004035199e2e8128 ]

page_pool_init() returns E2BIG when the page_pool size goes above 32K
pages. As some drivers are configuring the page_pool size according to
the MTU and ring size, there are cases where this limit is exceeded and
the queue creation fails.

The page_pool size doesn't have to cover a full queue, especially for
larger ring size. So clamp the size instead of returning an error. Do
this in the core to avoid having each driver do the clamping.

The current limit was deemed to high [1] so it was reduced to 16K to avoid
page waste.

[1] https://lore.kernel.org/all/1758532715-820422-3-git-send-email-tariqt@nvidia.com/

Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250926131605.2276734-2-dtatulea@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index b78c742052947..0188d7f007857 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -180,11 +180,7 @@ static int page_pool_init(struct page_pool *pool,
 		return -EINVAL;
 
 	if (pool->p.pool_size)
-		ring_qsize = pool->p.pool_size;
-
-	/* Sanity limit mem that can be pinned down */
-	if (ring_qsize > 32768)
-		return -E2BIG;
+		ring_qsize = min(pool->p.pool_size, 16384);
 
 	/* DMA direction is either DMA_FROM_DEVICE or DMA_BIDIRECTIONAL.
 	 * DMA_BIDIRECTIONAL is for allowing page used for DMA sending,
-- 
2.51.0



