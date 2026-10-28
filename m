Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212302;
	b=qGQcsGgHMSDzeJR03odi+Vh/vcBjP87923lyvhBX/RToN9MlIEWXhcdS4URbMXmo25UY
	 y+qIlITwNNRcQMomDR2AehqwXcxpykmFDDV23nkU3po9/oTr7w4LWXC7lyUn9oAcdH14P
	 oAQOJ9z+dSZndNjJu7K3UXv5vlPxzg2FwTJsGgt2FwGmOrj9Nbpgp5non0nXvqmAcp7Ac
	 Y/spcz6QQiG5/4Xkobjb4+D6KCAbLyX7/9FKmb3ULw+KC8ZPpwqyAss4TWtUnzQhzw2rj
	 DyCs5fzTC6SOlm8Sfd7NMG/JrmAiERoY3JSN5owEZNW8C9UKQiCChTp4LB4Iws6Oekg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OMtiJHhsU4m06KdATaOo3lbjqGi+lHCjKC7vzIPuOfo=;
	b=nguKtnSEp/s10B1SrdaMbB849LUrFr3HzwpyL4tKil+J94bLDmEXnCVqYe1RRVjv5w+Q
	 kDrZB6ZTeVO/oIrmJxnlrDili+Vlw7uKAruNJtbfdkqTvylX22yALiMacHzSY2avyp0Zo
	 7YvzQfPlcjvHuR5MSG/9pRk4WcO1WjPhOfGf9cEHX4PwnVXIvRmxEDo0cUfW/f3kVnHcY
	 X63cTU6m6BH2TG6T3UnCXK0Fh2AFpWB81HtfunhpDeTbJy9EytwIvwZrV640v+uTPk6GE
	 w8EXxiZUqqEJCxl1wzE+Tpe64SB5FeJ5J8MyrZPtXX7+9TDB550lmTJxsnVy1CFdyMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Hn/Yb4EW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F9A606A326;
	Wed, 28 Oct 2026 18:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hn/Yb4EW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6061F01828;
	Wed, 28 Oct 2026 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212301;
	bh=OMtiJHhsU4m06KdATaOo3lbjqGi+lHCjKC7vzIPuOfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hn/Yb4EWVJRVsogndBuugYSqzFg1gl01nc1VIDkDrOFQoWz4SsV33fPjML4svKV4r
	 z/HY6QNIMntLz+Y/+MvZUal/EFq6QfENrhH+TR6W2iEEUBMc/TjZh/o6MlaHbsR3Qj
	 minDBPTONtV3cAE0UYZnkl6aX/rkZogkqB5TvSOk=
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
Subject: [PATCH 6.1 0105/1887] mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP
Date: Wed, 28 Oct 2026 17:36:41 +0100
Message-ID: <20261028170501.623228227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

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
---
 mm/mremap.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 6ed28eeae5a84..7e39614d2e0e6 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -693,8 +693,18 @@ static unsigned long move_vma(struct vm_area_struct *vma,
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
-- 
2.53.0



