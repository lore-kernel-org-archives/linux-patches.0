Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F5E18D627;
	Tue, 10 Sep 2024 09:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961429; cv=none; b=tvuQ2Rq7dhVzITwnNDVDXpyt3B9aFfRbwzEuvhyKeoGFBds8JWIgKNGdYywoKz9LCdfMhdHtkdC3XTUSabA7zMMjrLm3L3KVYwDcoCAMeAU3CHwi6pLjVLgqQBhR2W29dpLkQZEQbEVCX46BY25z1Rk+fPqjzIg1+Pfuq7tQ9Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961429; c=relaxed/simple;
	bh=rALygXtakYD2lAqgCfF5dKGrlayQtF6/XVfM4u2kG/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjHFTh/TgbMTCEC9Yt/aCDkzOKKW1K6Hn94IwmH0sj6owrMdIUoSh4+gKPOzLDu4lpO5V7a8hGrCZ0OhOvbJPaZErphjEw9pZByvnTiypyxC2NBG4AXFW4bHEUNj+dZWDmGJ0srKg7W29j51G4fFiDiNZ7aOE7qlHYMVUa2hW+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtkJASc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtkJASc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28E7C4CECC;
	Tue, 10 Sep 2024 09:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961429;
	bh=rALygXtakYD2lAqgCfF5dKGrlayQtF6/XVfM4u2kG/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtkJASc07v0VYNED7ZhNcsZI0Tix0oPG911IbD11gqc2F20wgCOCxOMvKOXAvMPBD
	 IdZ8uv8Vk3giIfiDETXjflbcHr+5Z6BVgaorn0SHBe+AHZCFg6o9vtYIYmOtPQyRzs
	 /c50ePUIZnL3jA4PLdyMWyyS7/NBJKMoTq4Fj30c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	David Hildenbrand <david@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Pavel Emelyanov <xemul@virtuozzo.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 066/375] userfaultfd: dont BUG_ON() if khugepaged yanks our page table
Date: Tue, 10 Sep 2024 11:27:43 +0200
Message-ID: <20240910092624.441231246@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

commit 4828d207dc5161dc7ddf9a4f6dcfd80c7dd7d20a upstream.

Since khugepaged was changed to allow retracting page tables in file
mappings without holding the mmap lock, these BUG_ON()s are wrong - get
rid of them.

We could also remove the preceding "if (unlikely(...))" block, but then we
could reach pte_offset_map_lock() with transhuge pages not just for file
mappings but also for anonymous mappings - which would probably be fine
but I think is not necessarily expected.

Link: https://lkml.kernel.org/r/20240813-uffd-thp-flip-fix-v2-2-5efa61078a41@google.com
Fixes: 1d65b771bc08 ("mm/khugepaged: retract_page_tables() without mmap or vma lock")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -805,9 +805,10 @@ retry:
 			err = -EFAULT;
 			break;
 		}
-
-		BUG_ON(pmd_none(*dst_pmd));
-		BUG_ON(pmd_trans_huge(*dst_pmd));
+		/*
+		 * For shmem mappings, khugepaged is allowed to remove page
+		 * tables under us; pte_offset_map_lock() will deal with that.
+		 */
 
 		err = mfill_atomic_pte(dst_pmd, dst_vma, dst_addr,
 				       src_addr, flags, &folio);


