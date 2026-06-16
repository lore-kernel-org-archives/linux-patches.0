Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7006A32A3C9;
	Tue, 16 Jun 2026 17:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632017; cv=none; b=ahOcWjT9c8PmfIHMQA3sxOgD7GCDoBSbgdek2QvknQwlQeigcsYGNvjy/0hTxLHWXRMygQm+dNaU/fyn3rLnICMjaufRviSpuNw4JJ//olF6JqbmQV+ZQWuUP7/oLDMHKVUNVyU9VitZwkmeHZlqm9+YtG4ehZVb5GbC4C9qIKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632017; c=relaxed/simple;
	bh=PgjK+NSLI7clWy3j+HKaLCLEC2NK1GV49xQS3O1lpG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txmIG9uJFbeptCqXBL38XjPEIjJ2cmYv65Qs90WYs13+H0+wyo5/LYxNLIpHc879P8uyf/C2c58tlZsFZeZbiPwz3M2PgDRIwV1Wx4RFz5zZOZFDQUOt1eqjA7+JvKBG6FIOeGD518Sl7vN18a+tBjEy9S6t1Bcd7EEi01JgmxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhc2VK1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhc2VK1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B561F000E9;
	Tue, 16 Jun 2026 17:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632014;
	bh=9bi5iXuUG0g1wbh60r6gUQrKVLEs4TQDwjIvPNIdnMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lhc2VK1AgTkT8LX52aK5+2DdO6+cWH0Giun54hrNm2UZtb6JkIghB/nxFuMS1v9mW
	 e2MzlZK5Az7aEHvjIwRmWhrxJDYGrgLJM/VJ/RPOHQKS366vqGUGR0JQyGf4aSUaef
	 f4LACfrodcSa+NcadiRTVSmGyesRZGUfowwup1eE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 329/522] mm/damon/ops-common: call folio_test_lru() after folio_get()
Date: Tue, 16 Jun 2026 20:27:56 +0530
Message-ID: <20260616145141.221061388@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

[ Upstream commit d6b8b02a27b3dd09ec12144322b3dac46d9bc9ef ]

damon_get_folio() speculatively calls folio_test_lru() before
folio_try_get().  The folio can get freed and reallocated to a tail page.
In the case, VM_BUG_ON_PGFLAGS() in const_folio_flags() can be triggered.
Remove the speculative call.

Also mark folio_test_lru() check right after folio_try_get() success as no
more unlikely.

The race should be rare.  Also the problem can happen only if the kernel
has enabled CONFIG_DEBUG_VM_PGFLAGS.  No real world report of this issue
has been made so far.  This fix is based on only theoretical analysis.
That said, a bug is a bug.  A similar issue was also fixed via commit
3203b3ab0fcf ("mm/filemap: don't call folio_test_locked() without a
reference in next_uptodate_folio()").  I don't expect this change will
make a meaningful impact to DAMON performance in the real world, though I
will be happy to be corrected from the real world reports.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260525162256.8317-1-sj@kernel.org
Link: https://lore.kernel.org/20260517234112.89245-1-sj@kernel.org [1]
Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Fernand Sieber <sieberf@amazon.com>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/ops-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 0b75a8d5c70684..cea4401e95a35e 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -23,10 +23,10 @@ struct page *damon_get_page(unsigned long pfn)
 {
 	struct page *page = pfn_to_online_page(pfn);
 
-	if (!page || !PageLRU(page) || !get_page_unless_zero(page))
+	if (!page || !get_page_unless_zero(page))
 		return NULL;
 
-	if (unlikely(!PageLRU(page))) {
+	if (!PageLRU(page)) {
 		put_page(page);
 		page = NULL;
 	}
-- 
2.53.0



