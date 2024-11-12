Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459A821A4A8;
	Tue, 12 Nov 2024 10:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408410; cv=none; b=hq2gKrncr4L+jFz7yzPhyTESuBL0NcXUfY8QQEzl29CLPnTkCNIr/TZ/vmf0n8KgutTU/wQ1bLhTTtuIemS2twp2tUDabVzMAXWTGZI1mc2jnkOzWqWRWVrmqw5wj71D87o0gaVqgVy8ogCkqkEn4IyPDgGKAg8orG4iDiWP3XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408410; c=relaxed/simple;
	bh=vebtC8gsDeDkeTGyoVSJZEAGpJtibkID2S5awxko8fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ct8O15TQ7LSBe60CW1D2pc94Aoe4ELskkIi151XufTBK7ZbNsuD320Nx0L7/4NyMDB/1hS5jGqM9WRjLChCLKnbkJV9GA5GN1XwEKjMo3i7hggnjTUQXEugYQjQ2pFZdUY0MoZFHDVV0vlvgLDl0DjL+SEIm00Du6+OETVjkIrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zo0BQyXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zo0BQyXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA5CC4CECD;
	Tue, 12 Nov 2024 10:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408410;
	bh=vebtC8gsDeDkeTGyoVSJZEAGpJtibkID2S5awxko8fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zo0BQyXVj8LPsRtQwFnSmzIko/6i2QgN06eOp+RbZR7gxh4N8v7gOVuYKMv9yU3lF
	 urGwyWrL3aiH5/PBYjP2b+bREeWAPGA9Q/yaOuYl1Tt6+hOWddqRDX9/oT8UyqN6hU
	 TbhwMGvuxsoXcVDSKF8seb7GVLTheaH15bFjh+xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 153/184] mm/mlock: set the correct prev on failure
Date: Tue, 12 Nov 2024 11:21:51 +0100
Message-ID: <20241112101906.742717262@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yang <richard.weiyang@gmail.com>

commit faa242b1d2a97143150bdc50d5b61fd70fcd17cd upstream.

After commit 94d7d9233951 ("mm: abstract the vma_merge()/split_vma()
pattern for mprotect() et al."), if vma_modify_flags() return error, the
vma is set to an error code.  This will lead to an invalid prev be
returned.

Generally this shouldn't matter as the caller should treat an error as
indicating state is now invalidated, however unfortunately
apply_mlockall_flags() does not check for errors and assumes that
mlock_fixup() correctly maintains prev even if an error were to occur.

This patch fixes that assumption.

[lorenzo.stoakes@oracle.com: provide a better fix and rephrase the log]
Link: https://lkml.kernel.org/r/20241027123321.19511-1-richard.weiyang@gmail.com
Fixes: 94d7d9233951 ("mm: abstract the vma_merge()/split_vma() pattern for mprotect() et al.")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mlock.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index e3e3dc2b2956..cde076fa7d5e 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -725,14 +725,17 @@ static int apply_mlockall_flags(int flags)
 	}
 
 	for_each_vma(vmi, vma) {
+		int error;
 		vm_flags_t newflags;
 
 		newflags = vma->vm_flags & ~VM_LOCKED_MASK;
 		newflags |= to_add;
 
-		/* Ignore errors */
-		mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
-			    newflags);
+		error = mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
+				    newflags);
+		/* Ignore errors, but prev needs fixing up. */
+		if (error)
+			prev = vma;
 		cond_resched();
 	}
 out:
-- 
2.47.0



