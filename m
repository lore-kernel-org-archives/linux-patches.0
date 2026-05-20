Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640CB3FB05D;
	Wed, 20 May 2026 17:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299917; cv=none; b=SAeBejJJrFzRhvRc4fFbhfWZlHChe0/AuNv5EaZ31zFgEHpqscY00XYfv6i4zqKcAjpBeDPldUeOffAnMDYBMlOUCf4xGmnc36iO0rjULBO8kY1nJyRJyYC6tL7VMM62cAsYVw4g/2B1mYSJRlK0yQgbn+VwycywSlzlbMU7frI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299917; c=relaxed/simple;
	bh=qwcc+IUb6amthOQsTONK9TxTGy5WoRCcNV3cI4UEGC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lE+imMT2zJN08ldvtOXk3lTbLAUfawSBz5bQO/Q9jAFRLchSxXnsgSEngfxWzN9Whx1b/k35pWo2QhGJZO1kCvoWWlTysfrMPvCqiq0mcGCCmTlDQO4WL4ycruyxLameYEX9YupMe3hm8/nn6CTP3ZmQuhlHpYUSb8PgfecUcv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7flWz51; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7flWz51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651351F00893;
	Wed, 20 May 2026 17:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299912;
	bh=QppCUaz5LiwWQtufzPZzFN9vWHlfIuvWip30x49TS/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f7flWz5155tZg7ZUUaGVQt+FKueLbMNr1xNEckOnsAwc//KWD4EeT/xamVTkp/hn+
	 jrjbsVmw1t+2DSgv8xuGNVST37AUNY4q4vABBr+DjDf9I7TuIfEsMWP2MOsXcpQtMD
	 0UOVW2Crq28QYay2G8SQPtaTKQcAFrBLoVVZX6SE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Sacks <contact@xchglabs.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 892/957] KVM: Reject wrapped offset in kvm_reset_dirty_gfn()
Date: Wed, 20 May 2026 18:22:55 +0200
Message-ID: <20260520162153.915437037@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Aaron Sacks <contact@xchglabs.com>

commit 577a8d3bae0531f0e5ccfac919cd8192f920a804 upstream.

kvm_reset_dirty_gfn() guards the gfn range with

	if (!memslot || (offset + __fls(mask)) >= memslot->npages)
		return;

but offset is u64 and the addition is unchecked.  The check can be
silently bypassed by a u64 wrap.

The dirty ring backing those entries is MAP_SHARED at
KVM_DIRTY_LOG_PAGE_OFFSET of the vcpu fd, so the VMM can rewrite the
slot and offset fields of any entry between when the kernel pushes
them and when KVM_RESET_DIRTY_RINGS consumes them.  On reset,
kvm_dirty_ring_reset() re-reads the values via READ_ONCE() and feeds
them straight back into this check; only the flags handshake is
treated as the handover, the slot/offset payload is taken on trust.

Crafting two entries

	entry[i].offset   = 0xffffffffffffffc1
	entry[i+1].offset = 0

makes the coalescing loop in kvm_dirty_ring_reset() compute

	delta = (s64)(0 - 0xffffffffffffffc1) = 63

which falls in [0, BITS_PER_LONG), so it folds entry[i+1] into the
existing mask by setting bit 63.  The trailing kvm_reset_dirty_gfn()
call then sees offset = 0xffffffffffffffc1 and __fls(mask) = 63;
the sum is 0 in u64 and the bounds check passes.

That offset propagates into kvm_arch_mmu_enable_log_dirty_pt_masked()
unchanged.  On the legacy MMU path -- kvm_memslots_have_rmaps() ==
true, i.e. shadow paging, any VM that has allocated shadow roots, or
a write-tracked slot -- it reaches gfn_to_rmap(), which indexes
slot->arch.rmap[0][] with a near-U64_MAX gfn.  That is an
out-of-bounds load of a kvm_rmap_head, followed by a conditional
clear of PT_WRITABLE_MASK in whatever the loaded pointer points at.
The path is reachable from any process holding /dev/kvm.

Range-check offset on its own first, so the addition cannot wrap.
memslot->npages is bounded well below U64_MAX, so once offset <
npages holds, offset + __fls(mask) (with __fls(mask) < BITS_PER_LONG)
stays in range.

Fixes: fb04a1eddb1a ("KVM: X86: Implement ring-based dirty memory tracking")
Cc: stable@vger.kernel.org
Signed-off-by: Aaron Sacks <contact@xchglabs.com>
Link: https://patch.msgid.link/20260512060742.1628959-1-contact@xchglabs.com/
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/dirty_ring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -63,7 +63,8 @@ static void kvm_reset_dirty_gfn(struct k
 
 	memslot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
 
-	if (!memslot || (offset + __fls(mask)) >= memslot->npages)
+	if (!memslot || offset >= memslot->npages ||
+	    offset + __fls(mask) >= memslot->npages)
 		return;
 
 	KVM_MMU_LOCK(kvm);


