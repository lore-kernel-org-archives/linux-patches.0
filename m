Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0647919DF9A;
	Thu, 15 Aug 2024 13:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729776; cv=none; b=VjyKsyvPNnTPyhtATHpG7jQrWfizd+xsuueeJng+Qrwpm/cUXB5KQgQdnCKDenGRNkSrBoSP9KpBnhcUvmtI4/J+3164+aiu03BOh2KplcjziksSnZkweaBDFM2wEaBO4+BlyefcjtVwIuWjd7E6dOZ0wx96SKK0t2kAP2sSBJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729776; c=relaxed/simple;
	bh=xPKTyq/bRfh/8AaKL/yFesAtJ9e21CCWWBsZvVnervs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7oAaBiqbUO/LR+XNnLsA2W7HOoHGQnNVwLGwUWnj9bLZlRjZwq1VSkptPpTQlypGZADi1maqqD8fGno66A5C/eRFpdJ1XyZ6Anikc6fAIs8RfL4Fu7jBIczMgNWqYqE7xIOb8f0bWsr1JKqWWao+hsqLj2K/SkaypdKBPWOxLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ara0RWXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ara0RWXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B594C32786;
	Thu, 15 Aug 2024 13:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729775;
	bh=xPKTyq/bRfh/8AaKL/yFesAtJ9e21CCWWBsZvVnervs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ara0RWXYT1twlLfMS6oc7XsBzcTiqjw8iWahJG6Bif6pHC6/h/+y+Bh73cmzpscwn
	 7+8aobPwNSeZzExteZ+IGw6B9k4fYmvGwTO6xJoIulDxtnlDosXofVvNQpPgrBBswk
	 /0zyG8xm4ZZjlXKWeoMSmg8/EfO/7IsUBzeZVtp4=
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
Subject: [PATCH 5.15 162/484] fs/proc/task_mmu: indicate PM_FILE for PMD-mapped file THP
Date: Thu, 15 Aug 2024 15:20:20 +0200
Message-ID: <20240815131947.668037817@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 705a41f4d6b36..b255e3dfded14 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1471,6 +1471,8 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 		}
 #endif
 
+		if (page && !PageAnon(page))
+			flags |= PM_FILE;
 		if (page && !migration && page_mapcount(page) == 1)
 			flags |= PM_MMAP_EXCLUSIVE;
 
-- 
2.43.0



