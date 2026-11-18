Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059361;
	b=YgpOFdBJllCnObhAtlUB7LaYXEUizjNxI4YYQR8Itudgz6cNAnZA7i7Sd8K/4CkzDS+o
	 aNMjmEdkYpCStGMSWmZQTx+vxSkWksJMvTg+wRERYIxuwpgSMOVkSBx+0zePl9NA97b5I
	 StVQnP6SwZY7vbj5FzEZfj5Qfm28ajxa/a5rZFoQMMWdziWq5his13oCnq/zIKT8CUE4/
	 C3KrMccl36idDShM2pF2Y56aNe+1bAWPXHZMCEnG6Rc77mkWdTCfuQj2RpRbsmdiL6mL1
	 wPYKDbS/GvHmltGUIrDxRSTuUoncurnHTxrvp08U2XPb2q5cZ5DnxRw0l/vqyXj+uNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FGvg6aBhqPCEz9UDcqteV0MuqJlJbbIRFIBmJ/LAYtQ=;
	b=UPsMaKn16O+ZxS0OAGLvm2jiOPP740OtvlP6N+xmVniigJSt5mJlGfKoUbLpDZFXOCdd
	 1Eks/ADvDd+bp2eZ+5YmFulJsHpufLdYbBNxreJTY6g+p6UUwc6ta+1cymuKHWiZHdmPM
	 CpSkirMOMkxEPSQM++godUBu76BvlmqamSNMF17VBcZ+AIMBZniUZMwauuNIW97hSX3Zi
	 zFmZmr84vTSxUi+H3G4oVm97NYte362vLUJ52yLcgrFfVuQioTLz8FtzjdGJWxur5HQzp
	 Lp7CPI/E+n/NZtn6eVTVoc0VbefHcStbAjQ+duFq3ogk6TSJ/miA0aLh5Wykm/mCBAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pw0U1SNh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2935606A31C;
	Thu, 19 Nov 2026 03:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pw0U1SNh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3434B1F000C5;
	Thu, 19 Nov 2026 03:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059361;
	bh=FGvg6aBhqPCEz9UDcqteV0MuqJlJbbIRFIBmJ/LAYtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pw0U1SNhh+dmUdHw2TGgLcA6Zl1qWRE3aVh+5XKYS4a+hrszJwNMH67eJKHMizmaV
	 13gzpzz6/GkQ8clKLBj8wFByT4OaKCL7nxBaaDdQo3jYD3uRkJZQMcnu61ucL5IqrP
	 3C1gbytr07/i1vc2Dz1BWu3M3GHVKvN2g+niaIfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0815/1848] KVM: x86/mmu: Bug the VM if KVM attempts to walk more levels than the MMU has
Date: Wed, 18 Nov 2026 15:47:33 +0100
Message-ID: <20261118145950.482877066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0db6414300d2d..37fa59aa0a3ec 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -362,13 +362,14 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
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



