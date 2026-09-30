Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B95151B181;
	Wed, 30 Sep 2026 17:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789605; cv=none; b=kUVdiS9lgupuJywESO6WRnwA+2OoxlAIklD/5gUmWf9A0RCejUXZmKAEQT4BSoNMWUOFCcr8CVpH8qEFPrWp8G9G1peiN+w7c22FC9TUjljGVwqCFQ3z5fN3o5zFbMyBMWt4GsWimaIj0VgrzN4w12eCWNYSnrEwWy+ufBJdCN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789605; c=relaxed/simple;
	bh=qYhN1QGJ6bmPkbqxIpjqHkv3dWvtk4Tqy8PcbZagtCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJTsrZluTI+uB61dgOAuzUr8xzvuc4ARzDeoP2O+hHtjOUDrYQNbJMD7XYWm5ey2O3hIYurzrc9PPKsUYvDjHZmEO/Bd9iWc7DMpiI3gGSUg8NGaAhcWSGIqlo4W4Etl6DfWFKPbSte9/tfigai7O1nK3DcDyc4Q6I8m8Gh0zUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8qNxPDw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8qNxPDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73BA1F000FF;
	Wed, 30 Sep 2026 17:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789604;
	bh=nzJ57rSh6kmo6P5JnkM+Ypjok9trb2140a1wpQ+niHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8qNxPDwn1krTXciRBf18jFVTuUVzB202+P+ARs+rb7QZj8UHlpCJPOJgDFLiGRFf
	 zXInx0eerta/TWMjOa77pV49eIVWhA+5BwDaOFvN+BVQ32D1I2ZVFPWdj/2A+MRvHW
	 8NqzhBwNGke0bieor7/PaCm0yRRKceNzpDNfTK+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Marc Zyngier <maz@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 6.12 534/877] KVM: arm64: Fix spurious warning for benign stage 2 teardown race
Date: Wed, 30 Sep 2026 17:24:05 +0200
Message-ID: <20260930152426.166268262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Lorenzo Stoakes (ARM) <ljs@kernel.org>

commit 38b70fc453c3112f1a62583b89903ae41116cc27 upstream.

kvmtool was used to establish an L1 guest with 8 CPUs and 8 GiB of RAM, an
L2 guest with 4 CPUs and 4 GiB of RAM and an L3 guest with 2 CPUs and 2 GiB
of RAM, all of which was then exited.

Under memory pressure in the L0 host warnings were observed due to
migration triggered by compaction:

WARNING: arch/arm64/kvm/mmu.c:336 at __unmap_stage2_range+0x64/0x80,
CPU#5: kcompactd0/66

Which was, in turn, triggered by an MMU notifier for the host invalidation:

mmu_notifier_invalidate_range_start()
  -> ... -> kvm_mmu_notifier_invalidate_range_start()
    -> kvm_mmu_unmap_gfn_range()
      -> kvm_unmap_gfn_range()
        -> kvm_nested_s2_unmap()
          -> kvm_stage2_unmap_range()
            -> __unmap_stage2_range()
               -> stage2_apply_range()
       	       <- -EINVAL, triggering a WARN_ON()

Racing with L0's teardown of stage 2 page tables:

exit_mm()
  -> mmput()
    -> __mmput()
      -> exit_mmap()
        -> mmu_notifier_release()
	  -> ... -> kvm_mmu_notifier_release()
            -> kvm_flush_shadow_all()
              -> kvm_arch_flush_shadow_all()
	        -> kvm_free_stage2_pgd()
		  -> [ acquire kvm->mmu_lock for write ]
		  -> mmu->pgt = NULL [ among other tasks ]
		  -> [ release kvm->mmu_lock for write ]

It turns out there is a benign race resulting in a spurious warning:

	Thread A - notify: migration   | Thread B - notify: release
	-------------------------------|---------------------------------
	< kvm->mmu_lock held >         |
	stage2_apply_range()           |
	  get mmu->pgt, check !NULL    |
	  ...                          | kvm_arch_flush_shadow_all()
	  cond_resched_rwlock_write(); |   < contend, sleep kvm->mmu_lock >
	< drop kvm->mmu_lock >         |   < acquire kvm->mmu_lock>
                                       |   ...
				       |   kvm_free_stage2_pgd()
                                       |     mmu->pgt = NULL
				       |   < invalidate MMU >
				       |   ...
				       |   < release kvm->mmu_lock >
	[ scheduled ]		       |
	stage2_apply_range()           |
	  < loop to next >             |
	  get, mmu->pgt, check !NULL   |
	  is NULL, return -EINVAL      |
        __unmap_stage2_range()         |
	  WARN_ON(-EINVAL) <--- entirely spurious - the race was handled
                                 correctly.

Fix the spurious warning by updating stage2_apply_range() to no longer
treat concurrent PGT teardown on lock release as an error - whether the
walker is tearing down page tables or doing something else this is a
legitimate reason to abort the operation without error.

This keeps the warning in place for all other circumstances.

In practice only __unmap_stage2_range() actually does anything with the
error so this only impacts that.

Fixes: ec14c272408a ("KVM: arm64: nv: Unmap/flush shadow stage 2 page tables")
Cc: stable@vger.kernel.org
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Link: https://patch.msgid.link/20260901-kvm-arm-nested-virt-fix-v3-1-b154676f7e4c@kernel.org
Signed-off-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/mmu.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -53,27 +53,36 @@ static phys_addr_t stage2_range_addr_end
  * long will also starve other vCPUs. We have to also make sure that the page
  * tables are not freed while we released the lock.
  */
-static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t addr,
+static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
 			      phys_addr_t end,
 			      int (*fn)(struct kvm_pgtable *, u64, u64),
 			      bool resched)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+	bool lock_dropped = false;
+	phys_addr_t addr = start;
 	int ret;
 	u64 next;
 
 	do {
 		struct kvm_pgtable *pgt = mmu->pgt;
+		/*
+		 * We may be raced on PGT teardown when we release the
+		 * kvm->mmu_lock. That's fine as the PGT is legitimately no
+		 * longer present.
+		 */
 		if (!pgt)
-			return -EINVAL;
+			return lock_dropped ? 0 : -EINVAL;
 
 		next = stage2_range_addr_end(addr, end);
 		ret = fn(pgt, addr, next - addr);
 		if (ret)
 			break;
 
-		if (resched && next != end)
+		if (resched && next != end) {
 			cond_resched_rwlock_write(&kvm->mmu_lock);
+			lock_dropped = true;
+		}
 	} while (addr = next, addr != end);
 
 	return ret;


