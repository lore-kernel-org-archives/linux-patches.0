Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6E463D5;
	Thu, 15 Aug 2024 14:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732346; cv=none; b=g1F1UqOmP6TM1WqlavhGU8E0xrcnW2FWbNmV7dy9jZ6x1jGKxnqdN7BVjHDCZeldBrVFGDR8dD4/OlpXCR9cEfrJSSN1fMaNTkNcKKHCJ7yvOdcJFAQMsdP8d3EtmE1wkbOHXBwwhydxW/kyJfyIewumc5XGp6eQFmQRLTveAqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732346; c=relaxed/simple;
	bh=WR9MClY/hGyRgRVeacXAyx96sViRYNE6baxO7vN/CmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1ds3UTAP1cXqxsOAhj9VXj6QqtPYJDl2kF7Ywk3GdV6OTWB+VQ7pVjredNJCWA2FV4+ccPWec6egswMaMd1Llzolkz1bFzzxf2gsxoD3oFmY/7QB12E6gk9osz0hwNPd+DYP2r8M63OPgrhGYWfBhrP9qJ9WL9YRVZUzr7CjOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwO07DjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwO07DjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FB7C32786;
	Thu, 15 Aug 2024 14:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732346;
	bh=WR9MClY/hGyRgRVeacXAyx96sViRYNE6baxO7vN/CmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwO07DjBlXnkVAqG4KU/Tp3VJ2Ii+TRzaJFhLjrDjL0fVEpk5Fu8mFHF7wSydX63j
	 dSIUr9XKryyEHxOTmhFPD6hjn1rI6URJK2WgrldydE95NI694X8eh6od1sq/gtiihg
	 I1SRfXbhJJff6bIBCPwAz7brTI+U9vrTEHJsJ+Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Lance Yang <ioworker0@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/352] fs/proc/task_mmu: indicate PM_FILE for PMD-mapped file THP
Date: Thu, 15 Aug 2024 15:23:06 +0200
Message-ID: <20240815131923.890372142@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 3f9f022e975d930709848a86a1c79775b0585202 ]

Patch series "fs/proc: move page_mapcount() to fs/proc/internal.h".

With all other page_mapcount() users in the tree gone, move
page_mapcount() to fs/proc/internal.h, rename it and extend the
documentation to prevent future (ab)use.

... of course, I find some issues while working on that code that I sort
first ;)

We'll now only end up calling page_mapcount() [now
folio_precise_page_mapcount()] on pages mapped via present page table
entries.  Except for /proc/kpagecount, that still does questionable
things, but we'll leave that legacy interface as is for now.

Did a quick sanity check.  Likely we would want some better selfestest for
/proc/$/pagemap + smaps.  I'll see if I can find some time to write some
more.

This patch (of 6):

Looks like we never taught pagemap_pmd_range() about the existence of
PMD-mapped file THPs.  Seems to date back to the times when we first added
support for non-anon THPs in the form of shmem THP.

Link: https://lkml.kernel.org/r/20240607122357.115423-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240607122357.115423-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Lance Yang <ioworker0@gmail.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/task_mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 39b1038076c3e..97023c0dca60a 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1468,6 +1468,8 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 		}
 #endif
 
+		if (page && !PageAnon(page))
+			flags |= PM_FILE;
 		if (page && !migration && page_mapcount(page) == 1)
 			flags |= PM_MMAP_EXCLUSIVE;
 
-- 
2.43.0



