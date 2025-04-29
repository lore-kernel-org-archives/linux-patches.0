Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692AF253F27;
	Tue, 29 Apr 2025 17:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949236; cv=none; b=dlt5KQGzxV9sm8xSDPmYFc1oPVxDI0JgYN2l4hsTUxrNulb5gpDU0nriHrQ7XvRcvENZm1CmGqgSubke5SPfKuRtvGoHCto0+0aLvFDxQ2CN5IEnCD5H3kKrAF0LXcGNcuO0J3jghKJR7npvqsywCL7PLH+ue9tgqWUXDDP84bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949236; c=relaxed/simple;
	bh=3XvXLXKEj8KM340idEwMW6OdiADseoQc4JbB7N7cquQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PuE9QV3WM9VMjkz4F3nYBG/O00zf2hyEkeb0dy2njN8ZJc4c0f6oljODHa0fR8uIHyZhx5dwg0UObxuqIZC7UwssFACXLHlV6IMP1SjKNDd1JzWQoGQH+wvsG0iRJ12XnLKgkKNMdpH0GG+PBAl7FZBQUYMSitVAQViH2qtUNpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfxKZ41j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfxKZ41j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1671C4CEE3;
	Tue, 29 Apr 2025 17:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949236;
	bh=3XvXLXKEj8KM340idEwMW6OdiADseoQc4JbB7N7cquQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LfxKZ41j4ydF9yTMLHeSJ58SzhuY0ltgNkV+h7l+swLU50E0RKPwYXtIlZEVqy+Vx
	 BXUUEYbHN3SzC9EunJ+onFhBuuzyBS6tpkI5C3N5QN0q0QFpUaCX55etbrlwXmhDme
	 UgFu0k9ggX4BL+b9cUMbDSmNTc2Hn5ZQLUB0Xka0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Daniel Axtens <dja@axtens.net>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 248/373] mm: fix apply_to_existing_page_range()
Date: Tue, 29 Apr 2025 18:42:05 +0200
Message-ID: <20250429161133.326434189@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

commit a995199384347261bb3f21b2e171fa7f988bd2f8 upstream.

In the case of apply_to_existing_page_range(), apply_to_pte_range() is
reached with 'create' set to false.  When !create, the loop over the PTE
page table is broken.

apply_to_pte_range() will only move to the next PTE entry if 'create' is
true or if the current entry is not pte_none().

This means that the user of apply_to_existing_page_range() will not have
'fn' called for any entries after the first pte_none() in the PTE page
table.

Fix the loop logic in apply_to_pte_range().

There are no known runtime issues from this, but the fix is trivial enough
for stable@ even without a known buggy user.

Link: https://lkml.kernel.org/r/20250409094043.1629234-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Fixes: be1db4753ee6 ("mm/memory.c: add apply_to_existing_page_range() helper")
Cc: Daniel Axtens <dja@axtens.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2570,11 +2570,11 @@ static int apply_to_pte_range(struct mm_
 	if (fn) {
 		do {
 			if (create || !pte_none(*pte)) {
-				err = fn(pte++, addr, data);
+				err = fn(pte, addr, data);
 				if (err)
 					break;
 			}
-		} while (addr += PAGE_SIZE, addr != end);
+		} while (pte++, addr += PAGE_SIZE, addr != end);
 	}
 	*mask |= PGTBL_PTE_MODIFIED;
 


