Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442023A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foRQAhi5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7953C433CA;
	Wed, 15 Nov 2023 19:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077835;
	bh=j2KEYlzgfsJLKEDidkXcwtZld7EuNwgX8LhJKFKsl2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=foRQAhi55ILQBaDKuJs3ve58AvleV6xRO7ORcYk+jHFHa1zjPjD/cAZFA/cHjBFSC
	 kJ0pVNVt3o1JI2uNOsZ/jAEb3B65dAr7ypsywPjsgOm+UcnkbrbwV1HmKOm79p0veh
	 UIn1bUxpA76O1dwv+o32xqrPhzSHlqUv1C7viTEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 549/603] net: page_pool: add missing free_percpu when page_pool_init fail
Date: Wed, 15 Nov 2023 14:18:14 -0500
Message-ID: <20231115191649.722516978@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 8ffbd1669ed1d58939d6e878dffaa2f60bf961a4 ]

When ptr_ring_init() returns failure in page_pool_init(), free_percpu()
is not called to free pool->recycle_stats, which may cause memory
leak.

Fixes: ad6fa1e1ab1b ("page_pool: Add recycle stats")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Link: https://lore.kernel.org/r/20231030091256.2915394-1-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 77cb75e63aca1..31f923e7b5c40 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -221,8 +221,12 @@ static int page_pool_init(struct page_pool *pool,
 		return -ENOMEM;
 #endif
 
-	if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
+	if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0) {
+#ifdef CONFIG_PAGE_POOL_STATS
+		free_percpu(pool->recycle_stats);
+#endif
 		return -ENOMEM;
+	}
 
 	atomic_set(&pool->pages_state_release_cnt, 0);
 
-- 
2.42.0



