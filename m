Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A37E188017;
	Tue, 30 Jul 2024 17:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359614; cv=none; b=txUBAiV68QHL6uXsvNa2qIDBWQY8dA2+TdJ8DuSqhD6ayHFfto4OTE6Dj+98SkDU89qJ6WHKZCxQYxa0hLfcMtjktWoTAsgQpquotWZKD9iN+Lo8kNHoKno0JNr+0IVpo8cjo4aGsea4fe9W4WLCCAlegKyuFqKx596wbs467TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359614; c=relaxed/simple;
	bh=I6KwDJ5kT7jY4W6xiKA9RwIk7+Ret+GRum05vpE52mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAzCpolD3JNklsVGj6iKPPDVcsqYagpimSm2+O4BeyfTgXyyKwjpGTk6KyNBVLHlZZg9KpeEuazJac4gE706FCKLD7Um/e26P+2W+1GfgiqIY0nHF5pM4JS/h4pUt2dbFpKol1Jx+AkwvyQcq2R9FUdH/7K7xpEFR8A0OuUHEm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ps321u9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ps321u9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A974FC32782;
	Tue, 30 Jul 2024 17:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359614;
	bh=I6KwDJ5kT7jY4W6xiKA9RwIk7+Ret+GRum05vpE52mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ps321u9eB/xQom7DsTEFM3P2LFnYdpuf6ZbCJMamtSIcDAgPoOcdj076t6H8BxirR
	 50aur8gpYZ87S29vfHTwYDMYQlsM+2t+zFSvKMPBNV0VjiwUOYt/KutyaAmXgvHrIN
	 RzRozQHfNw60WcK2t9D4728K1oy7cI7o++xvHJAI=
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
Subject: [PATCH 6.10 508/809] fs/proc/task_mmu: indicate PM_FILE for PMD-mapped file THP
Date: Tue, 30 Jul 2024 17:46:24 +0200
Message-ID: <20240730151744.800512250@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 71e5039d940dc..76ad35df3b1ee 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1525,6 +1525,8 @@ static int pagemap_pmd_range(pmd_t *pmdp, unsigned long addr, unsigned long end,
 		}
 #endif
 
+		if (page && !PageAnon(page))
+			flags |= PM_FILE;
 		if (page && !migration && page_mapcount(page) == 1)
 			flags |= PM_MMAP_EXCLUSIVE;
 
-- 
2.43.0



