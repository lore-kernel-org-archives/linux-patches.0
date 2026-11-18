Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039056;
	b=4O8IV2XArWfLUcdWa6JvgszM27jMFu/FCSAlxuaMqiD2HIjQoy9n45DtfaAwnmjjhag2
	 9JQOvTV/3san+BFRwh+UFgsZiQ8JGDIzy0jqon6/PZoH68wyaso9OObeL2wXtonLFPA4/
	 T4a0w33msQD6RPl5fzlOXl+3tKJSOI5FTErEYRCn72TI9lvN4MexEwY5UEJDvmSNQamXn
	 KTy4Pd/+67ag4C6Bx5vX8GcJ2bDXEbrFu73pP8I1QbKBDJsalSgU7DYdB7uTqyRh3LZiY
	 1KxPOsZpRgvXt0Ebt2oSFH3UnBdipMj5uY+uUNN+qldEHgb3xTeDesh4hcQGSbIjz1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aCBB+5xJj54DWhDgUDpYgMS8D1RkK72nOWrDVoyp3jk=;
	b=fwMmz62mlco7oTVdKqBw1MrGjWHrtXnVgz+IeYp5vNq675xVKD75dozUkIyojTLCs5xY
	 pxdeCrpRVshFEWDUKXqZmlc8GaxYVw+ePKk3MOR3YQytezNnxCCkTGU661we6kD4/o/aH
	 /67v7EuwAcZ+eIrhuEoOuWM+qMTNpwmi8iP6crKXrVjIzoKejJYdBWt28sp4uVBR/v4bY
	 QcCExzOkib09hdz5CxbGJ4FrcisFOHNOgo9e8b5IkBtYyIL5W5rG8ncjALUWRcHd8mmHt
	 XYJcSwOi84oLqr4k/aWtRjNpOnS00sBoLy/1bnCfrhSepsTi+HY8/6HAkVeorq+FQCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HtGOdutD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AAF606A33B;
	Wed, 18 Nov 2026 21:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HtGOdutD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456861F000C5;
	Wed, 18 Nov 2026 21:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039056;
	bh=aCBB+5xJj54DWhDgUDpYgMS8D1RkK72nOWrDVoyp3jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtGOdutDsp6B9btJ8bKUNXfYXSSH/1MfeceMc7CUOnx2eSJHwHSju6icbBzWR7i0h
	 NhfI4hFb4Qr1eVWQ26GRRtkPcJ//mC/a81xBo/hms132Sjv5DeMuCqwJfbq6qO7KVl
	 ZdJWgiPLfhdy0ifDkTNu3AnS5Y2ljiDpS6wFmka8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1921/3318] mm/khugepaged: flush deferred unmaps before dropping a failed folio
Date: Wed, 18 Nov 2026 15:42:23 +0100
Message-ID: <20261118150419.640675373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 854e5ff8b3ce2a776586cabebaeae645c992345b ]

collapse_file() can fail its reference-count or dirty-folio check after
unmapping with TTU_BATCH_FLUSH.  Both paths put back the isolated folio,
then unlock it and drop the lookup reference before reaching the common
try_to_unmap_flush().

The page-cache reference does not keep the folio stable once the lock is
released.  Another collapse can replace and free it.  With its PTEs
already gone, that collapse cannot flush the first task's per-task TLB
batch, and retract_page_tables() skips short or unaligned VMAs.  A CPU can
therefore retain a user translation to the freed folio.  This has been
reproduced with unprivileged MADV_COLLAPSE on a memfd.

Flush at out_unlock while the lookup reference and folio lock are still
held.  The common flush continues to cover the accumulated pagelist on
both success and rollback, preserving batching on successful collapses.

Link: https://lore.kernel.org/20261007041001.43181-1-kylebot@openai.com
Fixes: 6d9df8a5889c ("mm/thp: collapse_file() do try_to_unmap(TTU_BATCH_FLUSH)")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Assisted-by: LLM
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
[ sashal: Adapted folio-based cleanup context to the existing unlock_page(page) and put_page(page) calls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c0a3d09cfd976..8a907d636c454 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1999,6 +1999,11 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 		list_add_tail(&page->lru, &pagelist);
 		continue;
 out_unlock:
+		/*
+		 * The page may have been unmapped with TTU_BATCH_FLUSH.
+		 * Flush before releasing the lock and our last reference.
+		 */
+		try_to_unmap_flush();
 		unlock_page(page);
 		put_page(page);
 		goto xa_unlocked;
@@ -2024,9 +2029,8 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 xa_unlocked:
 
 	/*
-	 * If collapse is successful, flush must be done now before copying.
-	 * If collapse is unsuccessful, does flush actually need to be done?
-	 * Do it anyway, to clear the state.
+	 * Flush before copying the pages, or releasing them in rollback.
+	 * This is a no-op if out_unlock already flushed the batch.
 	 */
 	try_to_unmap_flush();
 
-- 
2.53.0



