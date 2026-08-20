Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8BF383984;
	Thu, 20 Aug 2026 15:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239323; cv=none; b=LsgU+w8ZLHmT8trkGoiTyCyPQc1rkFUpmG15qcRZ9TkPdeDqfVq1NlqAcO5qeiA9iB8nYGt56Eu0fNoTt5CXLksEMFOwoYLGv5uFCHVzSPdpuSbSu35UH9R+ozCoOzXu0CITh2bmlt7sqbTzfc0kt4mXHDuQ4QXCaQ3ItoBU1H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239323; c=relaxed/simple;
	bh=JelWiorz2GgDhqi+EcQ4l+qAg4G8FRS1Jtz1/1k6yqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZ5hwJ5mvv1nUnO+OLxu2wH0pq9n6h+lQ6GcmS2RRBsO7Xv5OymYW0GE4LTw7BTRIPtnauteA+Avzp5t6yEFBrHnwQF3XHrl/2vZhLBYVBl0A7+DC6QfV3rvGKNOe9IpRAsNujdyNYMDs3nzf5x+Qg7R+KMgVC+5EXb3vqAczGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IkMJElwW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IkMJElwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CCA1F000E9;
	Thu, 20 Aug 2026 15:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239322;
	bh=PJOYnRWZUJdZ3EP7KRp5PuN41fTL4nwXce2XQcnJ43Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IkMJElwWx94+d4UXodhRvZS6J7b3dll7g6GJ+ZpF1cQal7r5XlcTGjyacFTKV6Af0
	 tBD/AMfrMbsa2V4RzgM6PLxYDSp3qo3+f8zZVrTJP3c7ZOdIHFgeG1Jp4kva+WwPJR
	 yZvElBu7Xh76dBXP9J1kEdz+ENfxGr9cHN/PIzvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Honggyu Kim <honggyu.kim@sk.com>,
	Hyeongtak Ji <hyeongtak.ji@sk.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 010/220] mm/damon: adjust isolated pages stat for DAMOS_MIGRATE_{HOT,COLD}
Date: Thu, 20 Aug 2026 16:53:20 +0200
Message-ID: <20260820145223.797217001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

[ Upstream commit 1ec0e6b6f7321feb769f50d2f094a0aa6c2eda63 ]

Callers of migrate_pages() should adjust NR_MIGRATED_{ANON,FILE} for
isolations and putback of the folios.  That for migration succeeded folios
is done by migrate_pages(), in migrate_folio_done().  That for MR_DEMOTION
reason is an exception though.

DAMOS_MIGRATE_{HOT,COLD} call migrate_pages() but mistakenly not doing the
stat adjustment.  As a result, use of DAMOS_MIGRATE_{HOT,COLD} could
corrupt the stat.  It could confuse too_many_isolated(), make compaction
and reclaim to behave in unexpected ways.  The stat corruption can be
reproduced and confirmed using DAMON user-space tool [1] on NUMA systems,
like below.

    $ numactl --hardware
    available: 2 nodes (0-1)
    [...]
    $ sudo ./damo start --damos_action migrate_hot 1
    $ sudo cat /proc/sys/vm/stat_refresh
    $ sudo dmesg
    [...]
    [   80.215554] vmstat_refresh: nr_isolated_anon -5578
    [   80.216842] vmstat_refresh: nr_isolated_file -34400

This issue was discovered [2] by Sashiko.

Link: https://lore.kernel.org/20260728140404.94476-1-sj@kernel.org
Link: https://github.com/damonitor/damo [1]
Link: https://lore.kernel.org/20260726164356.87940-1-sj@kernel.org [2]
Fixes: b51820ebea65 ("mm/damon/paddr: introduce DAMOS_MIGRATE_COLD action for demotion")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Cc: Hyeongtak Ji <hyeongtak.ji@sk.com>
Cc: <stable@vger.kernel.org> # 6.11.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/paddr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 884042856f7e..d4a4d51750f5 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -414,6 +414,8 @@ static unsigned int damon_pa_migrate_folio_list(struct list_head *folio_list,
 	while (!list_empty(folio_list)) {
 		folio = lru_to_folio(folio_list);
 		list_del(&folio->lru);
+		node_stat_sub_folio(folio, NR_ISOLATED_ANON +
+				folio_is_file_lru(folio));
 		folio_putback_lru(folio);
 	}
 
@@ -437,6 +439,8 @@ static unsigned long damon_pa_migrate_pages(struct list_head *folio_list,
 			struct folio *folio = lru_to_folio(folio_list);
 
 			list_del(&folio->lru);
+			node_stat_sub_folio(folio, NR_ISOLATED_ANON +
+					folio_is_file_lru(folio));
 			folio_putback_lru(folio);
 		}
 		return nr_migrated;
@@ -487,6 +491,8 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s)
 
 		if (!folio_isolate_lru(folio))
 			goto put_folio;
+		node_stat_add_folio(folio, NR_ISOLATED_ANON +
+				folio_is_file_lru(folio));
 		list_add(&folio->lru, &folio_list);
 put_folio:
 		addr += folio_size(folio);
-- 
2.53.0



