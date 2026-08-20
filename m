Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0756B37E5E5;
	Thu, 20 Aug 2026 17:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247650; cv=none; b=Ti82FI0OtTIXMnICkAlfpXHGNe9fujHmlRriT2CURa0xxGOb4PCmg23mAP6UsCBQ2BpuIagQr4OfjCn9Ap+A6MDb0irbII6T3J9NGcSKpMBlCpiPr7AnnGRSRmP+Aw79bR8CwgVg5DSJVP0fUpRZVHHB+Fk1IxNhtuvQPNHiLG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247650; c=relaxed/simple;
	bh=lHTxhU1dUXdmsGkadsCocS/gD99dCUz28ZKR8io6Mag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwFxeD3QMjjTKpl9w89gB/cLlhNZc+sn5iq4GnoG0fcbRqa+zJGbAPEJc9FWZpGyKata2AimsJsULYM1816k7SUyo8r2p0C41LEEqmP/UVE0Y85b/hvxAwpFQUgSxyEWXK2Z49o5ru0qATQOuLa4W7g3TC/O/EaZl5c6YGzkHG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvsAxJ1V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvsAxJ1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C30C1F000E9;
	Thu, 20 Aug 2026 17:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247648;
	bh=gmmlTtIeT4Mbkyd3RUWbameyh4vjy4BnavKRSt7z5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZvsAxJ1V1iS74Bt1wYCumJ5VmG9jtutqkPB9Citcx6A8nABukCALHN4OunhC0FQCx
	 O+Su+87M+3ajhiNepNNOYXzqm1qgVFUvfgc5Y552deLbhPbsrkNOtSgrcBjeL5aeUr
	 BkMj5hpcgZGu4MJI0ZLxgeQiGwhpXZYGurPUCvQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	vova tokarev <vladimirelitokarev@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/166] userfaultfd: prevent registration of special VMAs
Date: Thu, 20 Aug 2026 16:55:40 +0200
Message-ID: <20260820145213.589040780@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

[ Upstream commit 3c58f641e813c3c71039f8fd4d4e2a3aab713288 ]

Vova Tokarev says:

  userfaultfd allows registration on shadow stack VMAs.  With userfaultfd
  access, you can register on the shadow stack, discard a page ... and
  inject a page with chosen return addresses via UFFDIO_COPY.

Update vma_can_userfault() to reject VM_SHADOW_STACK.

While on it, also reject VM_SPECIAL so that if a driver would implement
vm_uffd_ops, it wouldn't be possible to register special VMAs with
userfaultfd.

Since VM_SPECIAL includes VM_DONTEXPAND which is set but hugetlb, exclude
hugetlb VMAs from the check for VM_SPECIAL.

Link: https://lore.kernel.org/20260618095017.2553004-1-rppt@kernel.org
Fixes: 54007f818206 ("mm: Introduce VM_SHADOW_STACK for shadow stack memory")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reported-by: vova tokarev <vladimirelitokarev@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -894,6 +894,12 @@ out_unlock:
 
 bool vma_can_userfault(struct vm_area_struct *vma, unsigned long vm_flags)
 {
+	if (vma->vm_flags & VM_SHADOW_STACK)
+		return false;
+
+	if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
+		return false;
+
 	if ((vm_flags & VM_UFFD_MINOR) &&
 	    (!is_vm_hugetlb_page(vma) && !vma_is_shmem(vma)))
 		return false;


