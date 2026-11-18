Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055376;
	b=y7dNNcqzmrrKd6SSzb464Eb5max/D6xM7jgObqr/oIkHLsECB/h2ZOcZr18wAJJKEZdd
	 uBOYm40c2vrptunVNX86TWHBJKzN9/PuzzrBnQETNgaaMLyPXvLjbK3rFOEC/zuAeA4tc
	 FAJMsObdCeEKQmDOm1UmlFCYqclk7lp3sVHI9rDuIobukuLY+7DYO0B3GsCLzUqdGSPjl
	 kAKIE3+NQyVM5Guqq+GLm4XuM3G6GgAEoDsFndHzsWGk38GWbD/yOCRnO/T+dzhcMOeiI
	 Bv5rTvtYWvoH+Mo6jXaROIsGV9WVhxCpwGHxbspW4UPVrurkXs3ioE7tA48tTTUD71A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1SShBBMspQKtDBMX0jsTWhWkVCTsu+V2Q4jJmFlhY54=;
	b=QpNPfj+K98wvrig2s3BznsXTsfssTZxwhfACWJXpQA8JUBXq8tSE3eCgizQ0KDUdn9vZ
	 tlwXwbdVO+Ygy6n+gYeF9W2V9w2/CJ5B31BsiLSCM/GOfgJxbP5TnWMIJq2ZOZLQiBgGs
	 Mr/mtKmbE41l1mI6dIy6zeIJeC54xr4k30o+qJRUL8bOJwAe/TQQhrFKru5emoi2ZAHBp
	 MiCyRnAsJfhNcURFWAe9yhJiQTLR13YaLlN2vk6VycHk4M47NPw62J18//6YVvQ1aQrHW
	 XXQn4Niahv1bWmeKbQBokgHD3dBvCg8Iv00xh/iev2p9XxAXJMZDOwC86tdDmRcp+Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ysrEs2/i";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB425606A32F;
	Thu, 19 Nov 2026 02:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ysrEs2/i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E921F000C4;
	Thu, 19 Nov 2026 02:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055376;
	bh=1SShBBMspQKtDBMX0jsTWhWkVCTsu+V2Q4jJmFlhY54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysrEs2/ilRmspX6bmDwK8uggUR+c/fLpjrI2PpoizXQwuKpj7OBF/6d9BKeCOlKKP
	 Jv2O0DfDMzfD0qYkEi1/4sXBMe9VJyjWHq4M5xm//FOZ8apvz7nI9TmILO3Odem7TL
	 aNFQhDb2vcuMXPQ5qxvUHK/rnc0cNQmCQ8VT2MTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Tejun Heo <tj@kernel.org>,
	Xin Yin <yinxin.x@bytedance.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1610/2214] writeback: size foreign flushes by target wb dirty pages
Date: Wed, 18 Nov 2026 15:54:46 +0100
Message-ID: <20261118150116.342469496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Yin <yinxin.x@bytedance.com>

[ Upstream commit 168a8c13159c6e3f0f08da6f8fa2f633a91ba9fd ]

Foreign dirty tracking records the bdi and wb memcg IDs of recently
dirtied foreign inodes. When the source memcg needs foreign writeback,
mem_cgroup_flush_foreign() queues WB_REASON_FOREIGN_FLUSH to the
recorded target bdi_writeback.

cgroup_writeback_by_id() currently sizes this best-effort work from the
target memcg's NR_FILE_DIRTY counter. The work is scoped to one target
wb, so a memcg-wide dirty count can over-size a single-bdi flush when
the target memcg has dirty pages on other devices. It can also under-size
the flush when the target wb has dirty pages charged to other memcgs.

Over-sizing keeps the target wb busy longer and can delay later
writeback work. Under-sizing can finish before enough pages are written
back for the source memcg.

Use the target wb's WB_RECLAIMABLE counter and keep the existing 25%
headroom. This keeps the budget aligned with the writeback object being
queued.

Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Xin Yin <yinxin.x@bytedance.com>
Link: https://patch.msgid.link/20260924065443.1650126-1-yinxin.x@bytedance.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index acc639682c7d5..35cf8e71f1411 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1084,7 +1084,7 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 	struct cgroup_subsys_state *memcg_css;
 	struct bdi_writeback *wb;
 	struct wb_writeback_work *work;
-	unsigned long dirty;
+	long dirty;
 	int ret;
 
 	/* lookup bdi and memcg */
@@ -1113,16 +1113,13 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 	}
 
 	/*
-	 * The caller is attempting to write out most of
-	 * the currently dirty pages.  Let's take the current dirty page
-	 * count and inflate it by 25% which should be large enough to
-	 * flush out most dirty pages while avoiding getting livelocked by
-	 * concurrent dirtiers.
-	 *
-	 * BTW the memcg stats are flushed periodically and this is best-effort
-	 * estimation, so some potential error is ok.
+	 * The caller is attempting to write out most of the target wb's
+	 * currently dirty pages.  Size the work from the wb's reclaimable pages
+	 * and inflate the count by 25%, which should be large enough to flush
+	 * out most dirty pages while avoiding getting livelocked by concurrent
+	 * dirtiers.
 	 */
-	dirty = memcg_page_state(mem_cgroup_from_css(memcg_css), NR_FILE_DIRTY);
+	dirty = wb_stat_sum(wb, WB_RECLAIMABLE);
 	dirty = dirty * 10 / 8;
 
 	/* issue the writeback work */
-- 
2.53.0



