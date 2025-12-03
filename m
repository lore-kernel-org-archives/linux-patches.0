Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5699F3148A3;
	Wed,  3 Dec 2025 15:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776303; cv=none; b=EPJJD5eQ78M9bl2lLzUo0DaEPE0dF6zyvx72W/L9uoCTUtZMlsnxLPCC+I3Ca45/b9ee095alYk8UoerpcRCY0qGJiL8s6UGI37ijt5NmkSioed6gUyV6+TvS2wT9MU0q/erJjhWbKfisDdX8OFIhGp9IGiQxICz+PWmg+tTsQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776303; c=relaxed/simple;
	bh=WvKZCaBvG39H2XfU2PO7MX03W1eqQ49MhKmCTSALtMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YG0XSTV8hJi1aAAZPacWw0iFsg2HchReO0hfhKzV2MG11FpItW7rTlX8zssEMnBVvVhacOeFYTKC63JVQ67sZJrcxGwFiN8tKtiearKmBCb3l1QVxWPecQHWygBjyvyyAwIdu0C3bU71qeV42deHZqzqE2XZkOO89nZBVCxr6Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yqxm+/7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yqxm+/7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A3EC4CEF5;
	Wed,  3 Dec 2025 15:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776303;
	bh=WvKZCaBvG39H2XfU2PO7MX03W1eqQ49MhKmCTSALtMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yqxm+/7JMZfrt3jfbpAoGv5EyC7imfK7D4CsVypWi85OaedGUZ3/ucxOm7wzRbb3M
	 JE+8NNvCatYZdfWFNzqqhpUhkANoGvkQmAvS3chduYVjp3i3SBAbMLAzyAj4H8iVuK
	 Ndy+sLrquRTdBS6pW5G8+RCyM6NRK09WlPHio/Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/300] page_pool: Clamp pool size to max 16K pages
Date: Wed,  3 Dec 2025 16:25:47 +0100
Message-ID: <20251203152405.915266540@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a11809b3149b4..15ad99330bb9b 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -33,11 +33,7 @@ static int page_pool_init(struct page_pool *pool,
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



