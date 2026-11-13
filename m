Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585593;
	b=REPcUcPR6uPf/Afmwj3nboKxHHUUCmtKGcXx7IQvG1e/7+gmuKNfb9APw+x1hLrOHIya
	 yH9JVhuoxNnYrUt7bi2W7+xlDZx5JhTwxdQQxr5SjHytm9Ij8wBru88RPgX1nNDqjh9sk
	 B5ZNgMpgEuiXGGJb+n8BWC8uqrWVKcm9lBEl3mDskSPZ145VnoDlZGqWmCEY43lV9aU+R
	 j3kOtSQKqBqS7FZXWK61U7hs73HZAxOWw6pMk+ZlH9pojnVe+ZY2+XqAMdkE0oIvAH2gy
	 WnoRYHslFMS778qCL0LEbaarTk4E4gZSBSoRRlz5d/HVzmyO0nKDwO1Do0GPMDtU0LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pR17OCh99UMVpwxowEXDeVvELHO59Agytc/j28JIZUM=;
	b=VUCGQ5+oMa3LgxrZI2wwnhD6rEW1+tMzZQgfR6qeY0/7mZ7wqBW1Ia4smQtrpI4WON2+
	 bppY2lkZ7Bp7V7CYsz4D/Rv0ZkrqOhnYqONDwwlyYSi4zH0IkZ1YF3TCEJZ0ad6YkBM9r
	 pJQOTeihQ+gT0e/mJp1Tt1gwx3cMr7W1ArBw5fPxjRCudb3o67ZlL0bb/QS/uaf7T5fgP
	 Zsz819uqxpo6H3KGtHDJqbC8heffNh03OhBr/QATcsYIp2VXtV+GIyLreDFYpzOa8sjJG
	 LcFzphYdUaHiE3d3bjWp5tYlryishWVN74pkqIyIJmpxxqWuibZLCgAFoEBK60KLYuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I6hfK6fD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E403E606FFDF;
	Fri, 13 Nov 2026 15:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I6hfK6fD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C86A1F000C4;
	Fri, 13 Nov 2026 15:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585592;
	bh=pR17OCh99UMVpwxowEXDeVvELHO59Agytc/j28JIZUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6hfK6fDVpGpJgDadDUurHQ+8QY3dYVB6uLvlPD1FpwHRKnOjDiiOwknuUyjvXo7N
	 tv5/YxwWmi3n5R952OvPSIjb4uo+PYzVOPF0hzR5bczH1/jd9Z75wglwAUovoOgRWw
	 XDGoRyImaByHZcYYgZtqZdfK+SVHwcHmBjIp5S2Q=
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
Subject: [PATCH 7.3 221/507] mm/khugepaged: flush deferred unmaps before dropping a failed folio
Date: Fri, 13 Nov 2026 10:48:45 -0500
Message-ID: <20261113153801.983045197@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b717de08e3c8b..16444bd7f1c0a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2488,6 +2488,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		index += folio_nr_pages(folio);
 		continue;
 out_unlock:
+		/*
+		 * The folio may have been unmapped with TTU_BATCH_FLUSH.
+		 * Flush before releasing the lock and our last reference.
+		 */
+		try_to_unmap_flush();
 		folio_unlock(folio);
 		folio_put(folio);
 		goto xa_unlocked;
@@ -2498,9 +2503,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 xa_unlocked:
 
 	/*
-	 * If collapse is successful, flush must be done now before copying.
-	 * If collapse is unsuccessful, does flush actually need to be done?
-	 * Do it anyway, to clear the state.
+	 * Flush before copying the folios, or releasing them in rollback.
+	 * This is a no-op if out_unlock already flushed the batch.
 	 */
 	try_to_unmap_flush();
 
-- 
2.53.0



