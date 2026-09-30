Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1A13B71B6;
	Wed, 30 Sep 2026 17:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789954; cv=none; b=VTbARG/+lF6b+szy+XNAe/Adl84c7QrCs2ivHv26SsSzNT5EJ+fRT+3OEFIhi0gmtib7PDjsIm3Hf5IGwtN0LEVgAACzmO/KqRqw/H6CjH6ioPdNnFyxbJxA+QxEumkbjIgAWA6PnJstuGyW+rqrlH31+N7yZobzU+d+gHZ9rbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789954; c=relaxed/simple;
	bh=inG/WtbR/LkkyEYBQRhGw4sNt0Px3w54fyKzaLBjZZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KGNz0oDnJG599VPN87r5DcecD+IvaWyfa9cMEqtLc2da33luttM9mueRSfAIi2Pb/dLNYVn/EDoN//PKz3o09I1LzsEv+8tDpKMDL0tmzMlrys1WB5RxzCE23tEWLV8Z4yK1r7b64JqRZxWgy9xDjR493rZpxwnROngdMeZo8xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEIatOEX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEIatOEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BDF1F000FF;
	Wed, 30 Sep 2026 17:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789953;
	bh=L3xW5NosPupHL+3I+c/sdNzrAErOHNfoOhyEe6WyxjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nEIatOEX58De4TGGpJFjh6NhydWebuqwOH2v6KNVJwLI2+wTQoF864YJVKRCrOULi
	 dmwIxyWyR9EYD/tUyLoitXvmSW4CIffGiR+BjleubuMTMgV4Wl+2Hv1cEKu7JTMLHx
	 8T075laOS6M2N+ukuMroInNpBLuh7Qo/uu0z//0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	syzbot+f12658786a4153df5113@syzkaller.appspotmail.com,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Li Xinhai <lixinhai.lxh@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 659/877] mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP
Date: Wed, 30 Sep 2026 17:26:10 +0200
Message-ID: <20260930152428.882545879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>

[ Upstream commit 35b0fb391b0df57383bc15985bb769f4555c97ba ]

Uniquely an mremap() invocation using the MREMAP_DONTUNMAP flag can reset
a faulted VMA into an unfaulted one.

It does so after the page tables have been moved to the copied VMA with
MREMAP_DONTUNMAP leaving the old VMA in place which is naturally unfaulted
as the page tables it had are no longer present.

However, in doing so, it violates the invariant that the anonymous page
offset of an unfaulted VMA is vma->vm_start >> PAGE_SHIFT.

This is because a VMA may have been faulted in, mremap()'d (causing a
delta between its page offset and vma->vm_start >> PAGE_SHIFT), and then
mremap()'d again with MREMAP_DONTUNMAP resulting in the unfaulting.

This condition is a violation of a fundamental assumption in mm, but now
also triggers an assert in assert_sane_pgoff() which explicitly checks for
this condition.

Correct it by resetting the VMA's page offset at the point of completing
the MREMAP_DONTUNMAP operation.

Link: https://lore.kernel.org/20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org
Fixes: 1583aa278f5f ("mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a87853b.ae6ddae5.3da009.0023.GAE@google.com/
Tested-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ adapted dontunmap_complete() changes to move_vma() using direct vm_pgoff assignment instead of unavailable helpers. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mremap.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -811,8 +811,18 @@ static unsigned long move_vma(struct vm_
 		 * table has been moved.
 		 */
 		if (new_vma != vma && vma->vm_start == old_addr &&
-			vma->vm_end == (old_addr + old_len))
+			vma->vm_end == (old_addr + old_len)) {
+			const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
+
 			unlink_anon_vmas(vma);
+			/*
+			 * The VMA is now unfaulted and it is an invariant that
+			 * unfaulted anonymous VMAs have page offset equal to
+			 * vma->vm_start >> PAGE_SHIFT.
+			 */
+			if (vma_is_anonymous(vma) && !vma->vm_file)
+				vma->vm_pgoff = pgoff_unfaulted;
+		}
 
 		/* Because we won't unmap we don't need to touch locked_vm */
 		return new_addr;


