Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBAA340A57;
	Wed, 20 May 2026 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301605; cv=none; b=XM/rvfedt0wqXTjGes+NJ6iUbgzLnT9WKbk7tXIbOM7HxW/qo8MMnIfRCML6CrUGa0hoO02tKt3mSM/Wq5BOAvqFXygzUkIbrMpbbXJKNbsxnF1XAnXucRsuPnSDuMblukHKNSB72FbzhRCH25Cj0oCntNVUtSATdv7C7dWMuoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301605; c=relaxed/simple;
	bh=fCEb2gV5i1bDRHtZb73YCsaRrtqpN79NQl0TdFUHLrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEfYeF4RKvvowzEQkd0YyCOBaymWaTLTO5rqsSAgc7787kuK3OWruQJ0Lhcnfz0dsLQ4KEZNIYrGwPpkRKU9qnbIXQ3uPln2Qu/l8ZykyBR1tT582FXn0E6jlW49l1lr4a+EfqExUErZazFxgZkdswuPN3RPQevSBReJjD3g9vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZKjEnnF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZKjEnnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAE61F000E9;
	Wed, 20 May 2026 18:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301604;
	bh=ECW/y++QxW6heRhTAaQElyqZ1ROLHN73KHAmutOKd9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SZKjEnnF2TU1KMOwcUq0qfKfwpyQC7Qhq8+6KL2l0IW9CGac3wPFp5buYCm0U5aQk
	 aIM58jlemOYYkuAiPJsfazhqNQh62JRr8MKaEJ3Utt4LGGvclWM+vCiACFp/jPElRd
	 DOgluiKrY8m/bm8wYHeBHyi5UGLFewh/Cehl/f8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Sacks <contact@xchglabs.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 619/666] KVM: Reject wrapped offset in kvm_reset_dirty_gfn()
Date: Wed, 20 May 2026 18:23:50 +0200
Message-ID: <20260520162124.688902418@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
@@ -66,7 +66,8 @@ static void kvm_reset_dirty_gfn(struct k
 
 	memslot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
 
-	if (!memslot || (offset + __fls(mask)) >= memslot->npages)
+	if (!memslot || offset >= memslot->npages ||
+	    offset + __fls(mask) >= memslot->npages)
 		return;
 
 	KVM_MMU_LOCK(kvm);


