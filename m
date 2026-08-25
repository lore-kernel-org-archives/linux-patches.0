Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBAE448D11;
	Tue, 25 Aug 2026 13:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666239; cv=none; b=rF2JdHvp0F3fgMuEbu85aHzzCIFN43n3su22Mn8OfW6g05mUgzYEfg74HY1h1AmQESzMxAKo9cZGL8sD8uvN20v7+BKT0qgbEL9Q5JNlcLzYaUxvy/lSqNh+4e42tsCkpyNdFCCtJcQH6zSibVON08Q5YhB2Wk6twCMtibb0Eas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666239; c=relaxed/simple;
	bh=Y6qBy1RmeAz/uQeb7X85th7pPbjkeIiRQyfvnSi/+DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqZaq5ZOXReGnVk6Jf6uOKz8ieG+uA3Kegf3AMG+/1QpH4mEM2K4G8o+EeUXnrZbahKh7EaqCcGEUebXwlElbFGWcg37LoNWHBjmOHUUTs07ymN/CgwhxsaEDq4QrIFst1FpAf4BgTVVwXX5Jph+uHt4X3fS1X4y5CakezwV7Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1mQb9q5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1mQb9q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAB21F000E9;
	Tue, 25 Aug 2026 13:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666238;
	bh=sWZ2wt8MHfA4HVzpTX7vUbWOWmZszNkM4ll84ajgN6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H1mQb9q5Z/7jUi74SmrKx+gzIfj4RhxMesXPuhdkORFuvlgwilwuBe2F4sXmJhshd
	 Ci9ypbv53EhPhVRq5h8jop0eKoruA0KJeT6zl8s7HYzihZeMfTDaoIX9VBEFQuiAed
	 WXklp3kyCv3X26JfKRnf6oJy5flPSkStjq0Wsx6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Kenta Akagi <k@mgml.me>
Subject: [PATCH 5.15 52/76] KVM: x86/mmu: Directly "destroy" PTE list when recycling rmaps
Date: Tue, 25 Aug 2026 15:26:45 +0200
Message-ID: <20260825132543.616425198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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
Signed-off-by: Kenta Akagi <k@mgml.me>
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


