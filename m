Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F15F381D1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWJJVHJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C46EC433CB;
	Wed, 15 Nov 2023 20:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078471;
	bh=GgZynByfMzkzWtqsnJy57gjMSba074xcvetUNHrdWms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWJJVHJ09Ar7r3Rq9yUkSocGp53loIkVDFl4FL1b7tHXSq1RWQMqc2sEjhINKaueF
	 nYYL12ETOAzt0e7RM4PMjCQoDDQmEALxkC8UDCJCsR0PWL/kFZh8dBMW1inPycEiKH
	 XQmqCdFdHwEk2UMAQR8G5jFnFuvKQDJnLiEex/dM=
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
Subject: [PATCH 6.1 342/379] net: page_pool: add missing free_percpu when page_pool_init fail
Date: Wed, 15 Nov 2023 14:26:57 -0500
Message-ID: <20231115192705.379171133@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2396c99bedeaa..caf6d950d54ad 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -209,8 +209,12 @@ static int page_pool_init(struct page_pool *pool,
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



