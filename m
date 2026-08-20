Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F58247F77E;
	Thu, 20 Aug 2026 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247022; cv=none; b=DadMsR9QrSl4w7eX6CSp1GdbRqubRWzroWJ7+3s4SQlE6zBHXaLK9ppfr1CLZWQPNkZoV14ABa37iZPL5rmBHmffFtxt3zkb0A/kj2u6oGHtKHvZxAbAvvpBSkK7uGKt84qaxkp34Kqbglz7fFHgm0xjIbDYWX4bn2V3KxqzRE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247022; c=relaxed/simple;
	bh=BRzOJUPgATAoMXBe2QLrL6LUdo7g4lMPkslgFA9Ni8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nusV14LwPXNgLpIktKV4F8QPLonaU0rVRsWp6IgxfeEqVnLAt+SyBUG8I3rh4zn3Q4xTQzWx4Mwz5OxlG7i0TLlurV/L+yquBh3FwtwZmtQqKPFi8vLLoS1cgbbHdC8RLZdU3kPRY+Rs9qArghpNYDMlPCNKlPIAoIGgYtG6r1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jHb7zhW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jHb7zhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635CF1F000E9;
	Thu, 20 Aug 2026 17:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247021;
	bh=dFnDXDP0KRJ3vzZQ69jqAo82S4XEp7mUXz91k4u98QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1jHb7zhW7SuPz2BjYUPMfmtGm7V+FnsN2FoK2W7ehTabcuukX9614gfvqjkLBOzt9
	 pHyrwlRh8dCB71mGYDScLqnmcOn0k50cbSCX0wAWqLmskRE9RGUu5PdtyoFfxq2Uxa
	 4e2mVmOcJMEDDhuoNz81r7xRMKfLFIhpcElRxISc=
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
Subject: [PATCH 6.12 121/220] userfaultfd: prevent registration of special VMAs
Date: Thu, 20 Aug 2026 16:55:11 +0200
Message-ID: <20260820145227.112276886@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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
 include/linux/userfaultfd_k.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -216,6 +216,12 @@ static inline bool vma_can_userfault(str
 				     unsigned long vm_flags,
 				     bool wp_async)
 {
+	if (vma->vm_flags & VM_SHADOW_STACK)
+		return false;
+
+	if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
+		return false;
+
 	vm_flags &= __VM_UFFD_FLAGS;
 
 	if (vm_flags & VM_DROPPABLE)


