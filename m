Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585576;
	b=RJq4pWPQcG4LjhD53zFMQP/iN3Xa8OGt77Qe5CCVPOgN5PV3xvckh2uyM99uluPjVAu3
	 vDhfFDOhbvdgIuQ6UkIUO9nV2bH2VjaGXibOcfvogct3cBb+jynnaTxwYtbGNYtsW8oyp
	 dMof+4BbesHFxYLBu4UTzuGHRebx2CtM1JwJGJl2IMlciGTpwOjNbFAH7HUTmphASEgg0
	 +JqpE30RE/FwguCg5Gndvgspiag8KSdVzcEV8Eqx/MTf/bA1htDyxsFhD48DBFLAcjhPp
	 P3XZxf/MGJC86ZtIRv5i1xeGlQQRSf84OnTjnL9gl8ZFiGBTOUiYhz8PuzASANGPmGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aypRjXr/7LMdFSrQi6xWnvqthrQ9s8P4tKi3dlFivzo=;
	b=whcWW2xqlWCOvDcuLxsexxuNhHtf9P5ZsG/PONIaY+6a1FrPHPjNslF8egt82oGQdZmr
	 YlZJIzLcfxSNHdOy1DjPYcRGG87HfdewUJMHybdcV3e9Okln7cgKZ8RQtXgHLAaMcFy9O
	 bhC/cjHYgCvs8ntzUXhk5alIUVHJVoks+B/banPvFbacRfr0lC+H30ceHYboWQCPtiW+Z
	 +JwX4gegFIA7rK2Jnw/9UN5RFWsnGaK5Wu+/2lIXpfAdHPyDBU6tcfw+qm/hKidEaXuL5
	 P+zuxnh0gtYm7ur8y2C6ydDBtOQ+7ZQK8qEubK5OqB3x3QAtNl/CF6a8/5wYjYNTgMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Ils5ms7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7092606BAB8;
	Fri, 13 Nov 2026 15:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Ils5ms7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5461F000C5;
	Fri, 13 Nov 2026 15:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585576;
	bh=aypRjXr/7LMdFSrQi6xWnvqthrQ9s8P4tKi3dlFivzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Ils5ms7vF7BNG4tsizpXXM//ju4qRTtONtu6Wrr344FaPqvh7Ud8GrGd3Y/Lvgkv
	 ZGl6DkewHPqc/Zfb3JRwL5Jpm0C+P54prPWAuq9UPi5l4RClZIptZKXBqyHC8XgEnv
	 geKKSL7FJ67tyMGLq6jllnl53HlvOGuqznp62GCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	James Houghton <jthoughton@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Stefan Teodorescu <fane@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 209/507] KVM: x86/mmu: Cap number of parent PTEs per SP at 1000 (the arbitrary rmap limit)
Date: Fri, 13 Nov 2026 10:48:33 -0500
Message-ID: <20261113153801.565068359@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit e4558c3d7198ed9a0adc3304681f561f4e4d80e1 ]

When potentially reusing a shadow page, zap the shadow page if its number
of parent PTEs exceeds KVM's (mostly) arbitrary rmap recycling threshold.
Letting the guest create a (mostly) unbounded number of parent PTEs allows
the guest to coerce KVM into creating lists containing millions of PTEs,
effectively bounded only by the maximum number of shadow pages.

Because PTE lists are simple singly linked lists, removal is O(n).  Even
worse, if a list is constructed just so, teardown can be O(n^2), e.g. if
SPTEs are built such that zapping child SPTEs always zaps the last entry
in the list.  To cap things off, all paths that walk PTE lists do so
while holding mmu_lock, without conditionally rescheduling.

Using a doubly linked list would not address the issue, as removal would
remain O(n) since KVM still wouldn't know where in the list to remove from.
Removal could be made O(1) by storing a per-SPTE pointer, but that would
largely defeat the purpose of reusing SPs, and would penalize well-behaved
guests, especially for nested TDP where aliasing page tables is uncommon.

So, cap the maximum number of parent PTEs at the rmap limit.  In practice,
well-behaved guests will likely never run afoul of the limit.  E.g. when
running Linux as L1 with TDP, the number of parent PTEs for a single SP
tops out at under 200 (though undoubtedly obscure workloads can push it
higher).  Deliberately use a "greater than or equal" as opposed to rmap's
strictly "greater than", as the rmap code checks the threshold immediately
*after* inserting into the list, i.e. the limit is 1000 for rmaps, KVM just
very briefly blows past it.

Apply the check to both indirect and direct SPs, because while a fully
direct MMU naturally limits the number of parent PTEs to '1', direct SPs in
indirect MMUs have no such constraint.  E.g. if the guest maps a huge PTE
into many locations in its page tables, and KVM is backing the hugepage
with a direct SP, i.e. with a series of smaller pages, then KVM could end
up with a direct SP with many parents.

Note, shadow_mmu_try_split_huge_pages() always restarts the rmap walk or
bails entirely if it gets to the point where it tries to grab a SP, i.e.
there is *no* pre-existing bug that would be tripped by zapping a SP and
thus rmaps when getting a SP.

Cc: Jim Mattson <jmattson@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: stable@vger.kernel.org
Reported-by: Stefan Teodorescu <fane@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20261027171518.1432557-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e56497089b599..2c2ff20f8ad0f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2310,6 +2310,16 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
 			continue;
 		}
 
+		/*
+		 * Note!  Unlike fully direct MMUs, direct SPs in indirect MMUs
+		 * can have an arbitrary number of parents, e.g if the guest is
+		 * mapping a huge PTE at many points in its page tables.
+		 */
+		if (pte_list_count(&sp->parent_ptes) >= RMAP_RECYCLE_THRESHOLD) {
+			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
+			break;
+		}
+
 		/* unsync and write-flooding only apply to indirect SPs. */
 		if (sp->role.direct)
 			goto out;
-- 
2.53.0



