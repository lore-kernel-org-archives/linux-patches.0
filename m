Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39D0290A
	for <patches@lists.linux.dev>; Fri, 28 Apr 2023 11:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A07C433EF;
	Fri, 28 Apr 2023 11:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682681301;
	bh=by/1dlldZF+tEZOPpYdKb2cW6x/lxYc9g3u5HfYzVL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cb3gu7/J2ssoqfiZmuYQaDRTyJLrRWDu2Ix8OCg+5GUAckt97shby+4htRWNtbrx8
	 /6vmZGIOzLH+okQhtlhS6DOegYJ3k3uz+fANQK4JJy7PY2VfYLEvIW2R1jaINsz37r
	 Fau4WXGBXJsg7376T/NB5DC2gcc393wQKoYpiJk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Fabian Vogt <fvogt@suse.com>
Subject: [PATCH 6.3 09/11] mm/mremap: fix vm_pgoff in vma_merge() case 3
Date: Fri, 28 Apr 2023 13:27:44 +0200
Message-Id: <20230428112040.202040068@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230428112039.886496777@linuxfoundation.org>
References: <20230428112039.886496777@linuxfoundation.org>
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

commit 7e7757876f258d99266e7b3c559639289a2a45fe upstream.

After upgrading build guests to v6.3, rpm started segfaulting for
specific packages, which was bisected to commit 0503ea8f5ba7 ("mm/mmap:
remove __vma_adjust()"). rpm is doing many mremap() operations with file
mappings of its db. The problem is that in vma_merge() case 3 (we merge
with the next vma, expanding it downwards) vm_pgoff is not adjusted as
it should when vm_start changes. As a result the rpm process most likely
sees data from the wrong offset of the file. Fix the vm_pgoff
calculation.

For case 8 this is a non-functional change as the resulting vm_pgoff is
the same.

Reported-and-bisected-by: Jiri Slaby <jirislaby@kernel.org>
Reported-and-tested-by: Fabian Vogt <fvogt@suse.com>
Link: https://bugzilla.suse.com/show_bug.cgi?id=1210903
Fixes: 0503ea8f5ba7 ("mm/mmap: remove __vma_adjust()")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -978,7 +978,7 @@ struct vm_area_struct *vma_merge(struct
 			vma = next;			/* case 3 */
 			vma_start = addr;
 			vma_end = next->vm_end;
-			vma_pgoff = mid->vm_pgoff;
+			vma_pgoff = next->vm_pgoff - pglen;
 			err = 0;
 			if (mid != next) {		/* case 8 */
 				remove = mid;


