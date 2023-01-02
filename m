Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B539428EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C78C433EF;
	Mon,  2 Jan 2023 11:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658789;
	bh=PrGO7LBB5RviuNWPziNvAbe2FMGoUP0VMM3U0/wibf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6GICR2nffnRH2KkQ0TEgMdoMFd/2XWJ5ry47HTAcpyA+N6scSH7GyV8CF7qrMdFL
	 C7vXU7WLnKOE6gHXH5VkuGLKJHDjEtuexTRfy7klya/q3bgtLjJ1zdUEmTJvJILjyY
	 iGCEBPr9VbI3nLpnJvzgvnIsm9F0icgaN0HC2fkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	=?UTF-8?q?Jakub=20Mat=C4=9Bna?= <matenajakub@gmail.com>,
	"Kirill A . Shutemov" <kirill@shutemov.name>,
	Liam Howlett <liam.howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Michal Hocko <mhocko@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 44/71] mm, mremap: fix mremap() expanding vma with addr inside vma
Date: Mon,  2 Jan 2023 12:22:09 +0100
Message-Id: <20230102110553.341522626@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vlastimil Babka <vbabka@suse.cz>

commit 6f12be792fde994ed934168f93c2a0d2a0cf0bc5 upstream.

Since 6.1 we have noticed random rpm install failures that were tracked to
mremap() returning -ENOMEM and to commit ca3d76b0aa80 ("mm: add merging
after mremap resize").

The problem occurs when mremap() expands a VMA in place, but using an
starting address that's not vma->vm_start, but somewhere in the middle.
The extension_pgoff calculation introduced by the commit is wrong in that
case, so vma_merge() fails due to pgoffs not being compatible.  Fix the
calculation.

By the way it seems that the situations, where rpm now expands a vma from
the middle, were made possible also due to that commit, thanks to the
improved vma merging.  Yet it should work just fine, except for the buggy
calculation.

Link: https://lkml.kernel.org/r/20221216163227.24648-1-vbabka@suse.cz
Reported-by: Jiri Slaby <jirislaby@kernel.org>
  Link: https://bugzilla.suse.com/show_bug.cgi?id=1206359
Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mremap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1016,7 +1016,8 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 			long pages = (new_len - old_len) >> PAGE_SHIFT;
 			unsigned long extension_start = addr + old_len;
 			unsigned long extension_end = addr + new_len;
-			pgoff_t extension_pgoff = vma->vm_pgoff + (old_len >> PAGE_SHIFT);
+			pgoff_t extension_pgoff = vma->vm_pgoff +
+				((extension_start - vma->vm_start) >> PAGE_SHIFT);
 
 			if (vma->vm_flags & VM_ACCOUNT) {
 				if (security_vm_enough_memory_mm(mm, pages)) {


