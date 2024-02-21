Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B81E7B3F2;
	Wed, 21 Feb 2024 13:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523727; cv=none; b=K8UxY+breWWXAAQKEl6vU6tkoxHcDDPO9LFrbbnWup04w5nJl5WtCkPE/HdPYOLIBPhVh27zAOnMm6kSXGZoI2WGkA24VPbd8XrhzuDpOQY/rRNwdPPmlItnJ2mvSz+sBJoUUbhLstgZDxIgD9LGwvOdjx0MDtiBr5Xjw2hIvkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523727; c=relaxed/simple;
	bh=K1tGlxw11V84qbdk8J6n27Xb7oytJ+AZSzda1EsG+Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itBKzajP4G4siodXlegalI3cJvmmqyTK+VZOvUSjajG/dcwVgaRqLu/kT74JiRnVPYSqxKt3gQUCf9G4OygX0C23ocPbdDjGSYKCfmUT7sKPfQR6rZkpr+iZsEUPHz0OuOewolUqDIGIeLbIlDPGI7WjgaNzXnRw1lscEQfWU6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WKtOtxPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WKtOtxPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEA3C433C7;
	Wed, 21 Feb 2024 13:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523727;
	bh=K1tGlxw11V84qbdk8J6n27Xb7oytJ+AZSzda1EsG+Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKtOtxPnhWBURGF6r46FDS1RpvvF1ve2OZoOrfO6mIjKRocDShMa5g2d22dAizdRg
	 Yz7UEkZ8DtjC8wfT5k8c95r26WRJMfnLoAApOgx0Iv0NVnfcDZnonKSHuI10V8Gu4V
	 D0/c/xbiwh/AkmjVY7ShJxzJFXQIQ1QEvRsQ7F44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Ofitserov <oficerovas@altlinux.org>
Subject: [PATCH 5.10 041/379] KVM: use __vcalloc for very large allocations
Date: Wed, 21 Feb 2024 14:03:40 +0100
Message-ID: <20240221125956.132558957@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 37b2a6510a48ca361ced679f92682b7b7d7d0330 upstream.

Allocations whose size is related to the memslot size can be arbitrarily
large.  Do not use kvzalloc/kvcalloc, as those are limited to "not crazy"
sizes that fit in 32 bits.

Cc: stable@vger.kernel.org
Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Alexander Ofitserov <oficerovas@altlinux.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/book3s_hv_uvmem.c |    2 +-
 arch/x86/kvm/mmu/page_track.c      |    2 +-
 arch/x86/kvm/x86.c                 |    4 ++--
 virt/kvm/kvm_main.c                |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -250,7 +250,7 @@ int kvmppc_uvmem_slot_init(struct kvm *k
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
-	p->pfns = vzalloc(array_size(slot->npages, sizeof(*p->pfns)));
+	p->pfns = vcalloc(slot->npages, sizeof(*p->pfns));
 	if (!p->pfns) {
 		kfree(p);
 		return -ENOMEM;
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -35,7 +35,7 @@ int kvm_page_track_create_memslot(struct
 
 	for (i = 0; i < KVM_PAGE_TRACK_MAX; i++) {
 		slot->arch.gfn_track[i] =
-			kvcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
+			__vcalloc(npages, sizeof(*slot->arch.gfn_track[i]),
 				 GFP_KERNEL_ACCOUNT);
 		if (!slot->arch.gfn_track[i])
 			goto track_free;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10826,14 +10826,14 @@ static int kvm_alloc_memslot_metadata(st
 				      slot->base_gfn, level) + 1;
 
 		slot->arch.rmap[i] =
-			kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
+			__vcalloc(lpages, sizeof(*slot->arch.rmap[i]),
 				 GFP_KERNEL_ACCOUNT);
 		if (!slot->arch.rmap[i])
 			goto out_free;
 		if (i == 0)
 			continue;
 
-		linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
+		linfo = __vcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
 		if (!linfo)
 			goto out_free;
 
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1008,9 +1008,9 @@ static int kvm_vm_release(struct inode *
  */
 static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
 {
-	unsigned long dirty_bytes = 2 * kvm_dirty_bitmap_bytes(memslot);
+	unsigned long dirty_bytes = kvm_dirty_bitmap_bytes(memslot);
 
-	memslot->dirty_bitmap = kvzalloc(dirty_bytes, GFP_KERNEL_ACCOUNT);
+	memslot->dirty_bitmap = __vcalloc(2, dirty_bytes, GFP_KERNEL_ACCOUNT);
 	if (!memslot->dirty_bitmap)
 		return -ENOMEM;
 


