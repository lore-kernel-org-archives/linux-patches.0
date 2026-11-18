Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046681;
	b=TbOctGyZMcjIyo1DJgGv/fEboadLlPJv8W4cLkUSQ7SqeaxL2JB3X+Vuzf0Ij+MmV9rw
	 ws21mBBk4HN1cXcyjGdJW8n5fKw3dHfiiXNmGLldrMhErvlboduSu0mCruXT8vw5CFX2j
	 CwPyQCNduWUSwdcH0ME+sw4aJhe83XRmrPUOyohO4I1JNNcFMubFHZUWTKfauyJWgMQea
	 xUgrJ3SybAwuk+/YVIl43xwbHpdejGIwQThlUq3U/MGszCDLlwd9ou254FexLJd8fb6GA
	 45SV2bBWqanX6x8mnBs0XV9yBjcPC1wkeinz9PSNimHu16dFlRm0NePVDO2c72/ksLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JUXSk7eDH8ol4U8k9FC33+UodiZ/XmofCzKFuKzwJT4=;
	b=t15Tt038CgQSu2EHapogr95+Sxo3F0kyw31T5epGmhkLnBGWVzA/AJ1C+8jBmdj5LEo+
	 OeiP21D27YMDLCxrNv2IS9NDfmgSuJeNba+s5xsMYm0qtq5PMJ7xQMA9M8qiHhNhHkEw9
	 b19hsOF3rjz2P3vr1C03SZoNX4/luk4grYnozNMzkusePH4TsPm0t+jl11B7J0PhGjNDz
	 mQrSu91hWh4PElurMogTsPFiPCDmGhfYjLxI1mDIPZyd2q+yfVl6zLoaPQnrt/qCoVCpg
	 5Jn62IU2Mka08ORVUbDl5u52TFL7/Dl85fYtQdCHYP5qZG+7kZ5+dM3zbvZ0Kp+FfAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T9CFDKoJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51CD606A325;
	Thu, 19 Nov 2026 00:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T9CFDKoJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EC01F000C4;
	Thu, 19 Nov 2026 00:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046681;
	bh=JUXSk7eDH8ol4U8k9FC33+UodiZ/XmofCzKFuKzwJT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T9CFDKoJEExI8Htc/r82E4868pC59Lv/SkI7XLpU7Q2zsnrQ4jC4n0EsvIKy+BndP
	 vS6TxSoQdkrDuh8ZB5UkU+zq116HQkV6OSgQIaQJMu690GYTsAyUVEq5Vve4KJHRAc
	 270Tr8B6fob9zJB7uhxVVlOcvTj4WStdl1ewcWqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1367/2857] KVM: x86/mmu: Bug the VM if KVM attempts to walk more levels than the MMU has
Date: Wed, 18 Nov 2026 15:40:01 +0100
Message-ID: <20261118150250.616130129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 42d459370f781..4ff63e273687c 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -356,13 +356,14 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
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



