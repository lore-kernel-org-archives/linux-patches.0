Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B90137F738;
	Thu, 20 Aug 2026 15:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239352; cv=none; b=NbV5NsvNnEsKR7axLZNiLXG7Ae0+fhTtlmEWabLyRtvZWcdp67m87pHbvkCBFQ9KwyzjEQTAblLyebn5Qa6B/fsjqMx5nx0WjTRTtcfkCxezHf3MROhUc9Tv+KdHQlq0LQfSBlq6ZRBf/EX50Bm53WlF7MjpZDTrWLbwqknsxms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239352; c=relaxed/simple;
	bh=pbpyHVJWuFVucxC/C7Nlq+cDVGnLH3yxPZEfioROzlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVd2KBCJCClJ2jgErlYYufVTYY435mz2jRoGnzh5n9dCND42nJul4Vcr4skmw1FyrAHYbc16KuQ86aW35fs7zyQGfHK6C0efa4Jm43SjfK3UeMK3auYu4aig83A+vRYW1GKOBNGV3plOOl0XSOwzjyX5OhWuH+7bOHjyqCaZ5u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wjmdi5Qk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wjmdi5Qk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AFC1F000E9;
	Thu, 20 Aug 2026 15:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239351;
	bh=sfVgfCm8uAYvi87FZwcGJOeY7d7FROW2hZumFbLhFBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wjmdi5Qkz1rqrHPMErU7E/1H770RHHgc72u1R6M/9+SH92th0VF7NVIIxsAWlwAEo
	 84j2N/Cez9WC//yQ4pXONaydPZfWinPApjmvWR5c/vWYCZE+tKjw65dIMtjK5VKpQ8
	 3lj29RNUKL9Q86ajHZZvURJdjBFr/IvJi4/7xuIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	liyouhong <liyouhong@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/220] mm/damon/ops-common: putback folios on invalid migrate nid
Date: Thu, 20 Aug 2026 16:53:19 +0200
Message-ID: <20260820145223.766610078@linuxfoundation.org>
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

From: liyouhong <liyouhong@kylinos.cn>

[ Upstream commit 5deb65c34e682e7c5f5df417a70e223e8fcc5f5a ]

damon_pa_migrate() and damos_va_migrate() isolate folios into a local list
and then call damon_migrate_pages().  When target_nid is invalid
(including the scheme default NUMA_NO_NODE / -1), damon_migrate_pages()
returns early without putting the folios back to the LRU.

Callers then discard the list head while those folios remain isolated with
an extra reference taken by folio_isolate_lru().  The pages stay off the
LRU for as long as the mapping exists (anon active+inactive counts drop
while RSS does not), and the leftover references can pin the pages after
the mapping is gone.

Put the folios back on the invalid-nid path so ignored migration requests
still return them to the LRU.

Link: https://lore.kernel.org/20260726014815.1280757-1-dayou5941@163.com
Fixes: 7e6c3130690a ("mm/damon/ops-common: ignore migration request to invalid nodes")
Assisted-by: Cursor:grok-4.5
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: liyouhong <liyouhong@kylinos.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/paddr.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 4120a73f4933..884042856f7e 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -432,8 +432,15 @@ static unsigned long damon_pa_migrate_pages(struct list_head *folio_list,
 		return nr_migrated;
 
 	if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
-			!node_state(target_nid, N_MEMORY))
+			!node_state(target_nid, N_MEMORY)) {
+		while (!list_empty(folio_list)) {
+			struct folio *folio = lru_to_folio(folio_list);
+
+			list_del(&folio->lru);
+			folio_putback_lru(folio);
+		}
 		return nr_migrated;
+	}
 
 	noreclaim_flag = memalloc_noreclaim_save();
 
-- 
2.53.0



