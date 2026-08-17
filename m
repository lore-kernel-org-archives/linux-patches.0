Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E7F3AA9F8;
	Mon, 17 Aug 2026 13:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974414; cv=none; b=l6vVgPDypkD7mflwVc6w1QJFcVNpy+ACA5sIaXqLWxsjGinsApZpKaGiOCv/n3yo2xO+HPPDW48xXENQ0+OTYY3YZaajlZYhxA2eqXEcuBYhlgnnAmXu98R8fZ2RJI9Pp6n+w2ZA4PwNaB8279dmHgf3+0UdBCSxN6mkTBL1Epw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974414; c=relaxed/simple;
	bh=49XvZzmCIzouM8mdQQbd8R2R54Xj9qNYH7t09cvnFOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAYf9Sd5XE68hVbVuumXVWfH3eEaYQ5WIctX2WcbFNpoBXVPu3oDKAhQXJkpkvhVn05jsv+s6Tmf7d1lrDSS/ILn5CTd9fE81vYhPYKoj5Jace4G14+ORJZoG3RxfDEuxDzcxi/bQoi3Xaq0LABl1lxKdU4F6LS16mPj3iBso/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/dLl+Ub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/dLl+Ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FB51F00A3A;
	Mon, 17 Aug 2026 13:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974411;
	bh=ckywF+0JAa3bTnTUrwmxXBR163yD2CTZBSzFVu7qEc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M/dLl+UbqjEgrBk+eb2q9zk0AUoP9mextkp1fdWrsHatSYj3T9VmqlKUme5kWQM0O
	 x7ASjL49NyYGrJ3cDPnif5lr2+KkU5UWdnkuFTtt2QINkIAU0GA6eTc0329T6y/4VP
	 1pxBbIjopOMLGOkomrqvW2M6jAWbOFhYVpfAVP0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	liyouhong <liyouhong@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 195/271] mm/damon/ops-common: putback folios on invalid migrate nid
Date: Mon, 17 Aug 2026 15:32:00 +0200
Message-ID: <20260817132544.840210444@linuxfoundation.org>
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
@@ -391,8 +391,15 @@ unsigned long damon_migrate_pages(struct
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
 


