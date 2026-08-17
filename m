Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20493F9F25;
	Mon, 17 Aug 2026 13:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974421; cv=none; b=j2IVQJ8+bUnw6mwGGDP/8YD22JaSafeJQo9amxsN5sQ0XCy937K1/Y1wq/sLPDNxCw+NgYLok/dtissM5veUbugZRV2l457ge4dCc/cAmXX0A+F9qW3YvtDg0SLkdmpHlDYhk+vI6v8ojVTnpyTov1FWcpQD2NSdOWIkONYOesc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974421; c=relaxed/simple;
	bh=SsM6KBhOekdAGjaqyPvwOkVfel7cPNYMhs6/Vt1X62s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GLha/67vZywZ8394g+hJfNwHnbsLuSu3qCK69eKULhTYNodJBLjh31QjVb/SpHXgoK0HMKLg30DnvMhQx39fZskbbpSwaHpDn1Xl+sRwH0+G7fW9RHz3I1X+Q0IRvATGFMYPsjTgFLV+LeXqWRFfDiMAE8vBEAQ3S0A+h6ysniw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JwnehFQY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JwnehFQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3491F000E9;
	Mon, 17 Aug 2026 13:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974417;
	bh=uE8O3KbgU+xzpk3Y482LuR5yEB2y3UiPvyhZ3rYOW0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JwnehFQYx8Pm5UCO2FcyYBQhOv+qQ2IB8AZ/GmkWzQ+8H5SkcvPrzF/CJD4PLpDJX
	 5KAhb/Ak25hK0jtmTSlHkDBdf3qUlehX0R9YhQDPQc+81aJZcDyLIoFb/K5NIRyf15
	 +mhmsVanxAzC9tytG4l9Fy1ytcEqBMyY9IuIbdK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Honggyu Kim <honggyu.kim@sk.com>,
	Hyeongtak Ji <hyeongtak.ji@sk.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 197/271] mm/damon: adjust isolated pages stat for DAMOS_MIGRATE_{HOT,COLD}
Date: Mon, 17 Aug 2026 15:32:02 +0200
Message-ID: <20260817132544.927329465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

commit 1ec0e6b6f7321feb769f50d2f094a0aa6c2eda63 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/ops-common.c |    4 ++++
 mm/damon/paddr.c      |    2 ++
 mm/damon/vaddr.c      |    3 ++-
 3 files changed, 8 insertions(+), 1 deletion(-)

--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -374,6 +374,8 @@ keep:
 	while (!list_empty(folio_list)) {
 		folio = lru_to_folio(folio_list);
 		list_del(&folio->lru);
+		node_stat_sub_folio(folio, NR_ISOLATED_ANON +
+				folio_is_file_lru(folio));
 		folio_putback_lru(folio);
 	}
 
@@ -396,6 +398,8 @@ unsigned long damon_migrate_pages(struct
 			struct folio *folio = lru_to_folio(folio_list);
 
 			list_del(&folio->lru);
+			node_stat_sub_folio(folio, NR_ISOLATED_ANON +
+					folio_is_file_lru(folio));
 			folio_putback_lru(folio);
 		}
 		return nr_migrated;
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -277,6 +277,8 @@ static unsigned long damon_pa_migrate(st
 
 		if (!folio_isolate_lru(folio))
 			goto put_folio;
+		node_stat_add_folio(folio, NR_ISOLATED_ANON +
+				folio_is_file_lru(folio));
 		list_add(&folio->lru, &folio_list);
 put_folio:
 		addr += folio_size(folio);
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -627,7 +627,8 @@ static void damos_va_migrate_dests_add(s
 isolate:
 	if (!folio_isolate_lru(folio))
 		return;
-
+	node_stat_add_folio(folio, NR_ISOLATED_ANON +
+			folio_is_file_lru(folio));
 	list_add(&folio->lru, &migration_lists[i]);
 }
 


