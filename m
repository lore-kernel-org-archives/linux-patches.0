Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F017642BC42;
	Fri,  7 Aug 2026 15:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115714; cv=none; b=syNVx+Kztip8PS5eXZ5DOM0XVf4Qm8P4h8NwGlpTzM9wiynCg/hBueBES09Hs87s2SOVYNmtZcF5G9weZkjgB4CvFmPqdceJex7W2zfH9Gyp1wZBu+ICmKLkv6+lOsWFccdUy1KzhR/fC4XRof5BfAsMRgMm6AQ9zcja2i2M/wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115714; c=relaxed/simple;
	bh=zDRb8T6CefX0vwxBwM2goC5xV4heM3DoD89uKVThBRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ah9z7fcX7sHLkXJVskynDVdttFrlD6WOEVvGFCJB0BkKAa6mRgoxnHvcptBEvGCusjjG+dURWDmykYYAWrrTpMGaCoKFCh8nY3+RfJn7sIeu58FBm1bGDGP/U/uo2y4Vsu1Ew/b3oQXZDXRkS5h6t+BhFdrg041IjpCeAORmKwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LO+jLRjZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LO+jLRjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5DD1F000E9;
	Fri,  7 Aug 2026 15:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115712;
	bh=Vgi5dRwSdqt8reOsZ7THRi6CiAXXaTcaRq4Ejmm8HRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LO+jLRjZOodZUs4ch2159xKziud46botQ0+lisEGbkGrYmc82M06sy/XWicItNYxq
	 o7n/wq4ex/ZP/1tdzHhySK4a0g32StQ1U0qSk4Ew2rf8ns5+lv7ObboRPpmKWGw+ml
	 Snzhwok8Iz6YmFYWeo6TJRlC74vKhFl1/ONtZRHo=
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
Subject: [PATCH 6.18 371/396] userfaultfd: prevent registration of special VMAs
Date: Fri,  7 Aug 2026 16:38:51 +0200
Message-ID: <20260807143432.284246423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 include/linux/userfaultfd_k.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -214,7 +214,10 @@ static inline bool vma_can_userfault(str
 {
 	vm_flags &= __VM_UFFD_FLAGS;
 
-	if (vma->vm_flags & VM_DROPPABLE)
+	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
+		return false;
+
+	if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
 		return false;
 
 	if ((vm_flags & VM_UFFD_MINOR) &&


