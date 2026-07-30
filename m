Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8154E36493F;
	Thu, 30 Jul 2026 14:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422950; cv=none; b=eAMjOEc5z+WK+REmS4+U8jRs9OF2eXpb4JuGyQZotrSQLmH/Ft2Q3ViJObTGESywLiXML3/6CncU+4fFiJ9XL5GYq+iYrcJGbkRFS/Z/qCCQsd4aIURGZO9vaUHt9TAEyNZQSjWYjfi3dEAo6AD27vufajy/U6omqRhVf59aJNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422950; c=relaxed/simple;
	bh=6DjunSJoIOUUtMPWNR+K92X825Zr88tsNodQzpWZGuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loIQx3YwQ7w3SK4XOTw0MzoaaouOQO7ioLKENzZ8eNaWJzTO4vhv+SMVneee8VQQvoEp0gbSVFJ5Qke+j+lyw770U22DxyK8Lw4vWBdENBwvvVPvIIYlrX7ziEHh11ca8W8Z13DU4TvGxrvvWsoApZmsRrySXhoSCixbwfUdbPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qev0+Gih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qev0+Gih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DA71F000E9;
	Thu, 30 Jul 2026 14:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422949;
	bh=obCkS6+nJOT7P8oXio4ZC4v656m42iiEbTExuX1FPQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qev0+Gihq79k1qyIr+Tiejutn59ivtRBMKDwkublg8xNXGalFjIXqGqfuf4L16IBF
	 VwTR2X6ZdKrJyoNZVLtxVCx0eaMnNQga2X0njr7Z40qDaFTiexwGut8XL7kYOQ2O6G
	 WFnVKKNRlUilxGUNv9w4+ZFelZExpuvt4ppHnMuE=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 614/744] userfaultfd: prevent registration of special VMAs
Date: Thu, 30 Jul 2026 16:14:47 +0200
Message-ID: <20260730141457.323555269@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

commit 3c58f641e813c3c71039f8fd4d4e2a3aab713288 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2095,7 +2095,10 @@ bool vma_can_userfault(struct vm_area_st
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
 
-	if (vma->vm_flags & VM_DROPPABLE)
+	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
+		return false;
+
+	if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
 		return false;
 
 	vm_flags &= __VM_UFFD_FLAGS;


