Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053734;
	b=s0vjxJKaeglZ4S2YQR51WXPWJprVYcIJP2UzLrY6N8Wy4105gkZCbV0O1N/NObHcIV9Z
	 aFgw5HZqwGGrULutH8aExY+F0npUlOIGIml4Kue7uA6fyvu2J4+CWBDajvXu0r50mjd6P
	 47FQFvWV2PTTwSgUQ5XOBwzHYRsKhHbgLTFtz4U4LwcFHuxRFlzuEYIkX60zqA22k0n3D
	 PkgBOA7dzxpSkZeOQhoUh9WVp/sP3g4nUKtFhPd6rYufzHqvxRVWFkCTUgLOSgc7fLZcZ
	 gSnHQUHSjZiWb/RW/MGATaJCNKr8UcOnEhV3cKxEm0AVPZVIkWTByQ7dN4O4ahYd6Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O3919Q9Zw+ettDtgwweds9zhu11zjMFlk9YfuExiZJc=;
	b=MNCLvIsRSsvdhKNc5cIMNVJuMIC829mjRjZw51frq7NB7HsPRRH/bYzjEqvCRlfhz2nf
	 i92i4kVAStm4Qoh6I7G4RqYtMl9W9VOEoLQ12ebj4wdG7uSyv225WgknKlgutMRq/e3J/
	 wndrW7bv/99indXE6+xaBgE+oehZo4dl33fDIzz83fTcQtvfkNll80BCnaOYG80LKomDf
	 eQCYN3G0xm7PngO2KS+kwuOeTdG9Q2XoToE8HGSm53UB93njGGmatX1vsi9tgszIGR1no
	 LJm6NETAjhD8husxUl4B7VW/uT7trWYsffsSWFb9cOVWpV6Of+rYmxY1x01QWr1KEhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2uSHV0vq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B91606A325;
	Thu, 19 Nov 2026 02:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2uSHV0vq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA441F000C4;
	Thu, 19 Nov 2026 02:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053734;
	bh=O3919Q9Zw+ettDtgwweds9zhu11zjMFlk9YfuExiZJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2uSHV0vqbunj4uifpKC0PDyfT+115Unzecirp5MxfEkjpP0DlR0c/Z3wNGaEUh2UA
	 fZkTVawghyiDCl8y9oeO+FXhf4RrR6psTKdVtSHkDEitUXV9jxzyzkWo5qwAv/bsvj
	 cqwH1qmgdWOCEA3Om/uVrd27koNKqtenn3kYf5p4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0983/2214] KVM: x86/mmu: Bug the VM if KVM attempts to walk more levels than the MMU has
Date: Wed, 18 Nov 2026 15:44:19 +0100
Message-ID: <20261118150051.563371907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 115f9405a2ed6d78ee7ad8436bdd638743f6d1d4 ]

Extend the "EFER.LMA && !CR4.PAE" check, which exists largely to guard
against KVM configuring a paging32 MMU with more than 2 levels of paging,
with a very explicit check for exactly that: that KVM isn't trying to walk
more levels of paging than the MMU template provides.  I.e. harden KVM
against all bugs that would cause KVM to generates accesses beyond the
bounds of guest_walker's arrays, regardless of how KVM ended up with the
misconfigured MMU.

Note, don't use w->cpu_role.base.level directly as the paging64 template
only provides two levels of page tables for PAE paging on 32-bit hosts, and
handles the third level by manually emulating the PDPTR access.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260902232028.2767071-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index ac139fa59b377..2ffa502aa4d1d 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -391,13 +391,14 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	pte_access = ~0;
 
 	/*
-	 * Queue a page fault for injection if this assertion fails, as callers
-	 * assume that walker.fault contains sane info on a walk failure.  I.e.
-	 * avoid making the situation worse by inducing even worse badness
-	 * between when the assertion fails and when KVM kicks the vCPU out to
-	 * userspace (because the VM is bugged).
+	 * Queue a page fault for injection if any of the below assertions fail,
+	 * as callers assume that walker.fault contains sane info on a walk
+	 * failure.  I.e. avoid making the situation worse by inducing even
+	 * worse badness between when the assertion fails and when KVM kicks
+	 * the vCPU out to userspace (because the VM is bugged).
 	 */
-	if (KVM_BUG_ON(is_long_mode(vcpu) && !is_pae(vcpu), vcpu->kvm))
+	if (KVM_BUG_ON(is_long_mode(vcpu) && !is_pae(vcpu), vcpu->kvm) ||
+	    KVM_BUG_ON(walker->max_level > PT_MAX_FULL_LEVELS, vcpu->kvm))
 		goto error;
 
 	++walker->level;
-- 
2.53.0



