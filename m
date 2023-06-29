Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23D914267
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6241DC433C8;
	Thu, 29 Jun 2023 18:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064308;
	bh=48ryNnyA5tmHpYaJLFFRJKpeWWN9uk3DTdWcDhavplc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GUmjiFV5BIucgCf9MclnASXXGZtQvU+fQxkT8Lm5KT27vDZ6L2VtGKUDC6Xu7SD53
	 VI7aratTccDk1gTW0gwr9NrwfwIwyBaJMDa8JfFn0Sh9NFtPkodsxAuUd1ws0Zd0lQ
	 r51/uZOAlIqQBsDetwIvAs3ecta9+fXmvRUr48HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Woodhouse <dwmw@amazon.co.uk>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6.1 02/30] mm/mmap: Fix error return in do_vmi_align_munmap()
Date: Thu, 29 Jun 2023 20:43:21 +0200
Message-ID: <20230629184151.758249072@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.651069086@linuxfoundation.org>
References: <20230629184151.651069086@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Woodhouse <dwmw@amazon.co.uk>

commit 6c26bd4384da24841bac4f067741bbca18b0fb74 upstream,

If mas_store_gfp() in the gather loop failed, the 'error' variable that
ultimately gets returned was not being set. In many cases, its original
value of -ENOMEM was still in place, and that was fine. But if VMAs had
been split at the start or end of the range, then 'error' could be zero.

Change to the 'error = foo(); if (error) goto â¦' idiom to fix the bug.

Also clean up a later case which avoided the same bug by *explicitly*
setting error = -ENOMEM right before calling the function that might
return -ENOMEM.

In a final cosmetic change, move the 'Point of no return' comment to
*after* the goto. That's been in the wrong place since the preallocation
was removed, and this new error path was added.

Fixes: 606c812eb1d5 ("mm/mmap: Fix error path in do_vmi_align_munmap()")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2404,7 +2404,8 @@ do_mas_align_munmap(struct ma_state *mas
 			break;
 		}
 		mas_set_range(&mas_detach, next->vm_start, next->vm_end - 1);
-		if (mas_store_gfp(&mas_detach, next, GFP_KERNEL))
+		error = mas_store_gfp(&mas_detach, next, GFP_KERNEL);
+		if (error)
 			goto munmap_gather_failed;
 		if (next->vm_flags & VM_LOCKED)
 			locked_vm += vma_pages(next);
@@ -2456,6 +2457,7 @@ do_mas_align_munmap(struct ma_state *mas
 		mas_set_range(mas, start, end - 1);
 	}
 #endif
+	/* Point of no return */
 	mas_store_prealloc(mas, NULL);
 
 	mm->locked_vm -= locked_vm;


