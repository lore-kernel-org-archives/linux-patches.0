Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCAE3B776C;
	Mon, 23 Mar 2026 15:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278889; cv=none; b=BI6s8qnuf/rqk2ePVKSBgcs5RUN0VDLtv5H9urOhgFHc38g56Ogsm80mMI4S/k8FJtKbccfL15zCOUP3c2YEQ46NKVyltXnkszVhxbZQDAgo4y0SwjoZNdLbOKv7Uh5xST96cJEjN3+FnBwX0roz4gyKdGi3APp4HI/E0SuVGTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278889; c=relaxed/simple;
	bh=KOEQxLzB/fzWYrKdUeFfqd0kp/RLePSliTmEkXiu910=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uS7h8acx1Kf6pDiVHIEFoc7V55Flt2qtODg9XQac5L/ohjD4LFWbpA+S0p7889d72Y8h4ifZzHKKoL+pnAcLZTVd430nIyyE2A5U1SxXa478HwI/dw9/YOR7q6DL8onaUpJwFDsP98mcaWcFLJhAHmA5AYdHjXpC7lWeq4kpZPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxMzZCy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxMzZCy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50678C4CEF7;
	Mon, 23 Mar 2026 15:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278888;
	bh=KOEQxLzB/fzWYrKdUeFfqd0kp/RLePSliTmEkXiu910=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxMzZCy6wvbtx/a5AviokMXxmu4W7zgS312xbI46MZflhBF02ay7ZjQa98PzLgqbw
	 p9mMX6ge5obveiglt8TMFuCX+zeopAXm0clpyG+Yx6AfDIRdYcul67dX6JkQbxOIB7
	 EdtgQIBLpVYCLGf3m3U6sNdqRlHWF/rwPRsyYvRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ying <liying3@sungrowpower.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	Gregory Price <gourry@gourry.net>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 6.6 450/567] mm/mempolicy: fix wrong mmap_read_unlock() in migrate_to_node()
Date: Mon, 23 Mar 2026 14:46:10 +0100
Message-ID: <20260323134545.115871073@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David Hildenbrand (Arm)" <david@kernel.org>

The backport of commit 091c1dd2d4df ("mm/mempolicy: fix migrate_to_node()
assuming there is at least one VMA in a MM") contains an error:
migrate_to_node() does not lock the mmap_lock itself, that is handled by
the caller instead.

So let's drop the wrong mmap_read_unlock(). Fortunately, this path is
very hard to hit in practice.

Fixes: a13b2b9b0b0b ("mm/mempolicy: fix migrate_to_node() assuming there is at least one VMA in a MM")
Reported-by: Li Ying <liying3@sungrowpower.com>
Closes: https://lore.kernel.org/r/aaZgUNxAyKC2IwuG@casper.infradead.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: <stable@vger.kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mempolicy.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1071,10 +1071,8 @@ static long migrate_to_node(struct mm_st
 
 	VM_BUG_ON(!(flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)));
 	vma = find_vma(mm, 0);
-	if (unlikely(!vma)) {
-		mmap_read_unlock(mm);
+	if (unlikely(!vma))
 		return 0;
-	}
 
 	/*
 	 * This does not migrate the range, but isolates all pages that


