Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AE65172D4;
	Wed, 30 Sep 2026 18:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792543; cv=none; b=hP2DnPlryupZQaj8jN4T1vMrkx5VNgVTlm2mOrPLgJ2Pxrg0TsGTy2H506vgXJYuyl8c/Beqm3oea5bsN1rSFOc2XYScybAvut5hdilIa+JaqUaXb23rewkl75oDO+Er07Yz5LdXT7exhVtIJoHqMVOs4VdcPqs+Wp9HN5igJXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792543; c=relaxed/simple;
	bh=znJwtdFelqUvkSCZ+Pvrk7u1t9KlCvl3rbWgeXa5H/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qvXb5jG7ln25a4fDd12O7k6/4xmuD1nlC8yb4kyWMRLEaZjO2MGt/ZasXP60G7irXZDt5YPGatG+qylPPe3mE7ll3KR8hfDSnZ28Foff1G/+gQb4ekVlC+qxpSuA9BnZzEjc0IKFLXwplAV0gFHlgkMP/DwE3MY1ZAJDP2wTHjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SU/2miYY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SU/2miYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7F01F00898;
	Wed, 30 Sep 2026 18:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792542;
	bh=1ix7u6awCJiZhdEfqyiI0r1fGdOutAFKX0agdKKqCl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SU/2miYYiPzSB4ZAoPtC02TUCDMURpsJLkpaHj4CKIdJXa6Xp69g35XGZ2hYgdUMT
	 6889ayFgWK5k0DqGHWkdO1kX0Ioqp32YAhI1y/jsH/6dt4f4rQgLEAo859nlYzBkNV
	 0K0Ix3PadpAJOULSi5RePhRnHFai1TSye2vnhmoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Kenta Akagi <k@mgml.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 691/752] KVM: x86: Fix shadow paging use-after-free due to unexpected role
Date: Wed, 30 Sep 2026 17:29:21 +0200
Message-ID: <20260930152413.190291155@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 81ccda30b4e83d8f5cc4fd50503c44e3a33abfeb ]

Commit 0cb2af2ea66ad ("KVM: x86: Fix shadow paging use-after-free due
to unexpected GFN") fixed a shadow paging mismatch between stored and
computed GFNs; the bug could be triggered by changing a PDE mapping from
outside the guest, and then deleting a memslot.  The rmap_remove()
call would miss entries created after the PDE change because the GFN
of the leaf SPTE does not match the GFN of the struct kvm_mmu_page.

A similar hole however remains if the modified PDE points to a non-leaf
page.  In this case the gfn can be made to match, but the role does not
match: the original large 2MB page creates a kvm_mmu_page with direct=1,
while the new 4KB needs a kvm_mmu_page with direct=0.  However,
kvm_mmu_get_child_sp() does not compare the role, and therefore reuses
the page.

The next step is installing a leaf (4KB) SPTE on the new path which
records an rmap entry under the gfn resolved by the walk.  But when
that child is zapped its parent kvm_mmu_page has direct=1 and
kvm_mmu_page_get_gfn() computes the gfn for the 4KB page as
sp->gfn + index instead of using sp->shadowed_translation[] (or sp->gfns[]
in older kernels).  It therefore fails to remove the recorded entry.

When the memslot is dropped the shadow page is freed but the rmap
entry survives, as in the scenario that was already fixed.  Code that
later walks that gfn (dirty logging, MMU notifier invalidation, and
so on) dereferences an sptep that lies in the freed page, causing the
use-after-free.

Fixes: 2032a93d66fa ("KVM: MMU: Don't allocate gfns page for direct mmu pages")
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kenta Akagi <k@mgml.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7e2afd0b51806..b2525c38197f3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2180,13 +2180,15 @@ static struct kvm_mmu_page *kvm_mmu_get_child_sp(struct kvm_vcpu *vcpu,
 						 u64 *sptep, gfn_t gfn,
 						 bool direct, unsigned int access)
 {
-	union kvm_mmu_page_role role;
+	union kvm_mmu_page_role role = kvm_mmu_child_role(sptep, direct, access);
 
-	if (is_shadow_present_pte(*sptep) && !is_large_pte(*sptep) &&
-	    spte_to_child_sp(*sptep) && spte_to_child_sp(*sptep)->gfn == gfn)
+	if (is_shadow_present_pte(*sptep) &&
+	    !is_large_pte(*sptep) &&
+	    spte_to_child_sp(*sptep) &&
+	    spte_to_child_sp(*sptep)->gfn == gfn &&
+	    spte_to_child_sp(*sptep)->role.word == role.word)
 		return ERR_PTR(-EEXIST);
 
-	role = kvm_mmu_child_role(sptep, direct, access);
 	return kvm_mmu_get_page(vcpu, gfn, role);
 }
 
-- 
2.53.0



