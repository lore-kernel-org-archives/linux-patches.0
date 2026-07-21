Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6493346A6;
	Tue, 21 Jul 2026 17:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655425; cv=none; b=hqjTuJ/YFYkbyqMD+RGToeQFKV0aojyxXBprRJ6eqZ7T5+z2P03rRGOFDHujekxkmYRGMav6DUvAqwD/YgxfezS6wk2hcCpKRbI1mAfTF0RTNFNnIviVTeEW2j58Ax2iR2AFRZOXDWNXfkTQEdOg6RjxRyXCjL8/RVdzpXzqVuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655425; c=relaxed/simple;
	bh=LiZ0qU1AON5qwpsOZqOyxJ7nB8+oZ06fmbM1y5Iwa1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvPQ98rcF+0xprTvwEBCsFxhXOiBd9RYlyRlTTRoK+3qZCUQiC8bX0iTIjamA0DzhPOKxeRQr2caFGVGsUn5JESpfyNS0h9n+NEtwr9KMVYsJiS3Ju3KJfOCbdOxHVxjSGbiK4oYhZgOwiYuZfqULRxa8gpJwdfO47afb+EZjmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+uNAmV/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+uNAmV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1386D1F000E9;
	Tue, 21 Jul 2026 17:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655422;
	bh=wd+dW1FsffLLW+GaiacTqQAflyIDVBSDXotwLXJZWCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l+uNAmV/XXllmrscilHqpxjbtN/Sci1h3tHruh0tS90K/N0hAcbXLpZ+5wtpcs0TC
	 /MVzRPDhTdxuu5rM/HLXaLrGlx+5vuES1IQs/ejrMc01h+3sCc3vZ5ksomrgq4V7gl
	 8+eOIsA1rkWRBFOXhgGL5li/edmYiWfScPr4HScQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 2035/2077] mmc: mmc_test: Fix __counted_by handling after kzalloc_flex() conversion
Date: Tue, 21 Jul 2026 17:28:28 +0200
Message-ID: <20260721152640.695755503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

commit c35fac6481a1dbb2d114dd337b54a40799437546 upstream.

Fix logic issues introduced by the kzalloc_flex() conversion in
mmc_test_alloc_mem() due to interaction with the __counted_by
annotation on the flexible array.

Bounds-checking sanitizers rely on the counter field reflecting the
allocated array size before any array access occurs. However, use
mem->cnt both as the allocation size and as the runtime insertion
index, causing incorrect indexing and potentially invalid bounds
tracking.

Initialize mem->cnt to the maximum allocated number of segments
immediately after kzalloc_flex(), then use a separate local index
variable to track successfully allocated entries. Update mem->cnt to
the actual number of initialized elements before returning or entering
the cleanup path.

Also rewrite mmc_test_free_mem() to use a forward for-loop, improving
readability and ensuring only initialized entries are freed.

Fixes: c3126dccfd7b ("mmc: mmc_test: use kzalloc_flex")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/mmc_test.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/core/mmc_test.c b/drivers/mmc/core/mmc_test.c
index ab38e4c45a8d..4dc16649e61d 100644
--- a/drivers/mmc/core/mmc_test.c
+++ b/drivers/mmc/core/mmc_test.c
@@ -318,9 +318,9 @@ static void mmc_test_free_mem(struct mmc_test_mem *mem)
 {
 	if (!mem)
 		return;
-	while (mem->cnt--)
-		__free_pages(mem->arr[mem->cnt].page,
-			     mem->arr[mem->cnt].order);
+	for (unsigned int i = 0; i < mem->cnt; i++)
+		__free_pages(mem->arr[i].page,
+			     mem->arr[i].order);
 	kfree(mem);
 }
 
@@ -341,6 +341,7 @@ static struct mmc_test_mem *mmc_test_alloc_mem(unsigned long min_sz,
 	unsigned long page_cnt = 0;
 	unsigned long limit = nr_free_buffer_pages() >> 4;
 	struct mmc_test_mem *mem;
+	unsigned int idx = 0;
 
 	if (max_page_cnt > limit)
 		max_page_cnt = limit;
@@ -375,23 +376,26 @@ static struct mmc_test_mem *mmc_test_alloc_mem(unsigned long min_sz,
 				goto out_free;
 			break;
 		}
-		mem->arr[mem->cnt].page = page;
-		mem->arr[mem->cnt].order = order;
-		mem->cnt += 1;
+		mem->arr[idx].page = page;
+		mem->arr[idx].order = order;
+		idx += 1;
 		if (max_page_cnt <= (1UL << order))
 			break;
 		max_page_cnt -= 1UL << order;
 		page_cnt += 1UL << order;
-		if (mem->cnt >= max_segs) {
+		if (idx >= mem->cnt) {
 			if (page_cnt < min_page_cnt)
 				goto out_free;
 			break;
 		}
 	}
 
+	mem->cnt = idx;
+
 	return mem;
 
 out_free:
+	mem->cnt = idx;
 	mmc_test_free_mem(mem);
 	return NULL;
 }
-- 
2.55.0



