Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9331FB3;
	Tue, 27 May 2025 17:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367949; cv=none; b=jrZ+jagQUHJe9Mvdm1vgGjMMBLQmPUdnRa1c1Sw8O5B2exRGWmXSfl3A37AH3nxNNcCJkcRWgSlnQFaBluMNdiie0VGrB/nslUCX5QkC7FabFYIZdmbVroo9p2dta5dAXvF2obIcWwO7uA0QYIw5u9Oea5seR+NBIQGXXxQjbys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367949; c=relaxed/simple;
	bh=gdZKinPIfxyxn7b8t0VBt6WKEZE0fRa6xFuz9xKNXq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJEx3rPlHau+2THtT9gov4O4D1255rN0hEf+VmGt1zkc5wKem20N3CC9hyTHL50xMs0QASTlxogP9nHYJ/gPaucFFqK91JbIvklg2NpeCiZEmjfFB95XdOyhZ8aABF+dgAaYFySasZYH2Mw6KaMm2DfsWVCiUI1dJZc2qOtZQMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vnGAevC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vnGAevC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64109C4CEE9;
	Tue, 27 May 2025 17:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367948;
	bh=gdZKinPIfxyxn7b8t0VBt6WKEZE0fRa6xFuz9xKNXq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1vnGAevCk+RX54Bnd8EdrGDk07T5QuvzGbbdVCcM9KvYhG6PXi1vtT04ipU+5ReQr
	 cORHUVd2fbmMTg/KMdnm1SKnKeAVGGwaJih+1Jyo08mgMAuuGzPaCae11KZo+mtKSn
	 7Qj0w8qwAOpUnwhx4SqyTMGRzQKregKpp+FUCQxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 551/783] net: page_pool: avoid false positive warning if NAPI was never added
Date: Tue, 27 May 2025 18:25:48 +0200
Message-ID: <20250527162535.589476526@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c1e00bc4be06cacee6307cedb9b55bbaddb5044d ]

We expect NAPI to be in disabled state when page pool is torn down.
But it is also legal if the NAPI is completely uninitialized.

Reviewed-by: Mina Almasry <almasrymina@google.com>
Link: https://patch.msgid.link/20250206225638.1387810-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.h       | 12 ++++++++++++
 net/core/page_pool.c |  7 ++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.h b/net/core/dev.h
index a5b166bbd169a..caa13e431a6bc 100644
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -299,6 +299,18 @@ void xdp_do_check_flushed(struct napi_struct *napi);
 static inline void xdp_do_check_flushed(struct napi_struct *napi) { }
 #endif
 
+/* Best effort check that NAPI is not idle (can't be scheduled to run) */
+static inline void napi_assert_will_not_race(const struct napi_struct *napi)
+{
+	/* uninitialized instance, can't race */
+	if (!napi->poll_list.next)
+		return;
+
+	/* SCHED bit is set on disabled instances */
+	WARN_ON(!test_bit(NAPI_STATE_SCHED, &napi->state));
+	WARN_ON(READ_ONCE(napi->list_owner) != -1);
+}
+
 void kick_defer_list_purge(struct softnet_data *sd, unsigned int cpu);
 
 #define XMIT_RECURSION_LIMIT	8
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index ede82c610936e..cca51aa2e876f 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -25,6 +25,7 @@
 
 #include <trace/events/page_pool.h>
 
+#include "dev.h"
 #include "mp_dmabuf_devmem.h"
 #include "netmem_priv.h"
 #include "page_pool_priv.h"
@@ -1146,11 +1147,7 @@ void page_pool_disable_direct_recycling(struct page_pool *pool)
 	if (!pool->p.napi)
 		return;
 
-	/* To avoid races with recycling and additional barriers make sure
-	 * pool and NAPI are unlinked when NAPI is disabled.
-	 */
-	WARN_ON(!test_bit(NAPI_STATE_SCHED, &pool->p.napi->state));
-	WARN_ON(READ_ONCE(pool->p.napi->list_owner) != -1);
+	napi_assert_will_not_race(pool->p.napi);
 
 	mutex_lock(&page_pools_lock);
 	WRITE_ONCE(pool->p.napi, NULL);
-- 
2.39.5



