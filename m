Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ABD2C237E;
	Mon, 17 Aug 2026 13:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975152; cv=none; b=s9wcx6t/Y5YSkVO/xosJJFI/EpX27tuziBTEQiaBuBrYGgzv5tfyH80Mq2WSFdBNH2rrO7+PPZV4lboOlnZoE800/9CPV9PS6Shrb7ltXfUYcZW2O/kN9OOGWq8lRBtM03vpUzw+hkE0kEiMzuwPQxqeVtMOKLTH4sVNllbR1mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975152; c=relaxed/simple;
	bh=r0y0xEGWf2zLiAwZ8p4OW+dCpybpBcfM1YSRiJaUguU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2DqwOmBuJM49Zq+7nzpIIzw1/S1QjJYw18E7FX+2pt2ezdBTYL5jOFN38cOI2fNw0JYtQOgdqzJZFFXnqiGQrB4db5GDFCug+QEjRWGnPwDYiATSELbGcKpiDq+UXT2LYRrv9r3Bumvr4KRtQI3Wyi0dXvapZKY+Y0iRr6oLzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcn/GVCL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcn/GVCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9023B1F000E9;
	Mon, 17 Aug 2026 13:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975151;
	bh=vbZ7JJuyO/OBl9v/4sPqTffuiJTVxdREs2Xne1At0KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcn/GVCLYv2jO9J+Cn1C8IYgf3m5L9uuEOhqbR8e++xdfP5n8gqE+39a/1rjmzUav
	 hynN2r97lS53Z9bC3qMbxQAhMDYw7DdA9GxNHVuMNoh166zyYXC2YwMBJRbt91HzIk
	 Rhv5EatDsnc6gm+LSrmD1XoLPXgArQ+qzAefQ3lM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	liyouhong <liyouhong@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 180/250] mm/damon/ops-common: putback folios on invalid migrate nid
Date: Mon, 17 Aug 2026 15:32:21 +0200
Message-ID: <20260817132543.946925031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: liyouhong <liyouhong@kylinos.cn>

commit 5deb65c34e682e7c5f5df417a70e223e8fcc5f5a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/ops-common.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -385,8 +385,15 @@ unsigned long damon_migrate_pages(struct
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
 


