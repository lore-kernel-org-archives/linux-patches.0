Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2682B279345;
	Wed, 23 Apr 2025 15:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422336; cv=none; b=gabjQZhXwa/G1h7sglEfMbPgYwqJ40J1NaCbE1dobJ51V4WULcP44LQZB2zJel8Pae0Ncu8zj8giLDZuks3YOJzsoZgqwI0Ev8s0a3GyQgtqK+jP4/rQal3T60MbcEDXayv9TIFu2kSBW5nWniRAwRLwD+43oyc6Bg18OkkODd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422336; c=relaxed/simple;
	bh=xIDXTX9qj6ww2vNZidxxNrUZmKGxrHyWB0n6Gpj8VoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4SbC+Wa0mxFJ6Wv7vyfII7HMVKkbTkVZYcsa9/rCKHQNvS+YkxwcwSOM5Dika8sOZkSltvZQ3OA6jDUigNnXJiXmnT/83/kdIiw2sLS4wgojW+PBiygT8ETikFiQWP9SLyCLTKSDP6SbIke1pjGu25kSgf9FNq4bGKuiAlAh20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnClrLzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnClrLzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8B6C4CEE2;
	Wed, 23 Apr 2025 15:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422336;
	bh=xIDXTX9qj6ww2vNZidxxNrUZmKGxrHyWB0n6Gpj8VoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnClrLzoqavyZZCo1zViepHdUq9nlPFkZQWSKwqTtNJKdKIZIcBJ8PLbfQi4ujHLJ
	 0AJiZbpD8OAwYWFbGg4BYo3mErpL+oVJTt7Ni2sEAo0QY4xCVI1jo/soiHR+RcaCps
	 AGwoIeM3yEp5cgSng762namuRWqyunBvlmY3iV/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Daniel Axtens <dja@axtens.net>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 322/393] mm: fix apply_to_existing_page_range()
Date: Wed, 23 Apr 2025 16:43:38 +0200
Message-ID: <20250423142656.635453631@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2600,11 +2600,11 @@ static int apply_to_pte_range(struct mm_
 	if (fn) {
 		do {
 			if (create || !pte_none(ptep_get(pte))) {
-				err = fn(pte++, addr, data);
+				err = fn(pte, addr, data);
 				if (err)
 					break;
 			}
-		} while (addr += PAGE_SIZE, addr != end);
+		} while (pte++, addr += PAGE_SIZE, addr != end);
 	}
 	*mask |= PGTBL_PTE_MODIFIED;
 


