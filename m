Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B822248F6A;
	Tue, 11 Nov 2025 01:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824436; cv=none; b=Yen8xTSgGEyRz4UyHG6wmQwh0MWfkOibUbOPftOOGyRjTcL7qJmZ21F7wfxuHdMegkF788roxEfFxHLmE+/QccHe2jy7jFIBeGgBpY7D++OPUmwRKUcM96v8mn/oMa3My4/aiS9fM+LWwLU6uPGbsP2CZ8qTYJpeUO+oXdgY4wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824436; c=relaxed/simple;
	bh=EDgPxygAcfd7vIwr20QZtfIi+alRfJTASYhikEKOe+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fieFd0862Yo7z1Xc672PuB71a4OodsLKpsStE1tYfFE3k1sGQ/8BP6daW3xvl0766uROB3Q3NYJv9ztH2JXGwBF1GGYjCsW5p1goTnXeJmzJTeeCbnnC3Fk1fnEhau6wjS+6My/NzGzWbW8zRpnuQyvCEEP21VjT1WcmQEaCqfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EDT/AQ/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EDT/AQ/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF951C116D0;
	Tue, 11 Nov 2025 01:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824436;
	bh=EDgPxygAcfd7vIwr20QZtfIi+alRfJTASYhikEKOe+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EDT/AQ/ufmEY9skMrg5I1+4F9o99Cyt31u038dVixVGGdxE/hJimFVSVQ1DizbmsP
	 q+NiMOOzILmXuk3XuShQsZrOC++SnAMIbDRZJ5q+qFeUQj1V43wzgGQeUrOC6NomGF
	 mkKT+yObgdlX3thKufPEBgkNJ1NQ3bMLnQwXObBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 445/565] page_pool: Clamp pool size to max 16K pages
Date: Tue, 11 Nov 2025 09:45:01 +0900
Message-ID: <20251111004536.897788761@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index cc0dce5246a2b..458b040a8655d 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -208,11 +208,7 @@ static int page_pool_init(struct page_pool *pool,
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



