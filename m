Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D4D47D463;
	Thu, 20 Aug 2026 16:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243745; cv=none; b=V/FBwwB9iqHZlT9sKotzr18yQnIqNbVAcnlS58jZQrYQ0ixQ0Tk89mXyiOR+prZThR51ccBao5b3wqTk9GD77CA6VxoJuebzqnHpQP4Wu8s6Nyp0u7tpkXL283XriN4ss0PImUaXgh7YfFlid1t3rfi98leokeNmT2xPKAKUA5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243745; c=relaxed/simple;
	bh=8yGrgUkMOO0y9lNXOx5Tq3L5XMr31fjfmkRnZqv6cro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B59bw4utm9Bwkoow2UZWmT9at60cpkQiGloKidB+9qxKWrx0tMTPGj4FKAnjl7O9aAIDZuaZBHkqxi4UrKMQKj5u5mdXOzxVDrV5ZEXnI7LjdhX2io1l/ojyPbdTIPf9npfsfsI0gnVvUau+QicL8RPPS/LLNq125OR+2yhUpho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5ELVQpT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5ELVQpT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30B11F00A3A;
	Thu, 20 Aug 2026 16:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243744;
	bh=qz0c6n+7gn56TgNnem3I0KkUDylKn6eTtDGoIXOWrl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g5ELVQpTuMWFTMpHCBJ0IvTUHPiFPJL1PMtseIIdkqCW+9+7HVEr7d9lRLkcxxvKu
	 Ye4DdGY3fg1hNy42G8CRUxDF5LlxoepQEtSlokYPs+rCTqjzotyRbpCGNugFkCuGFu
	 qr/9U94Hq0YfXJ9rrgTg/QQU8uvWEZxBscItrSDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 162/272] KVM: x86/mmu: Directly "destroy" PTE list when recycling rmaps
Date: Thu, 20 Aug 2026 16:55:46 +0200
Message-ID: <20260820145236.192193503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit a42989e7fbb0186d9fee05b29e0ea9cb639d0bd3 ]

Use pte_list_destroy() directly when recycling rmaps instead of bouncing
through kvm_unmap_rmapp() and kvm_zap_rmapp().  Calling kvm_unmap_rmapp()
is unnecessary and odd as it requires passing dummy parameters; passing
NULL for @slot when __rmap_add() already has a valid slot is especially
weird and confusing.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220715224226.3749507-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 2abd5287f083 ("KVM: x86: Check for invalid/obsolete root *after* making MMU pages available")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1639,7 +1639,7 @@ static void rmap_add(struct kvm_vcpu *vc
 	rmap_count = pte_list_add(vcpu, spte, rmap_head);
 
 	if (rmap_count > RMAP_RECYCLE_THRESHOLD) {
-		kvm_unmap_rmapp(vcpu->kvm, rmap_head, NULL, gfn, sp->role.level, __pte(0));
+		pte_list_destroy(vcpu->kvm, rmap_head);
 		kvm_flush_remote_tlbs_with_address(
 				vcpu->kvm, sp->gfn, KVM_PAGES_PER_HPAGE(sp->role.level));
 	}


