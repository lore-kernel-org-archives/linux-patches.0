Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF15292B5F;
	Wed, 30 Jul 2025 09:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868897; cv=none; b=dk9nYEuQYuhqzP2Q6+sz6/Z51VJJVFaRcFtX+sTlpUL0isDfMpswppo+2WTliHLrGieQOvdUDfVbLBV5a8DmioenzZI9JgY9Ty90LCU+a5OFq40AFULwfurgiJUAtFtNlwJhg5li/P1SBXFsfxj6vkAOuP2d73lfI0X4ndFoN8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868897; c=relaxed/simple;
	bh=Fpk9DlX4wpoXHZcYLD9bBuoM9WQn6GPWejjV/I1OT3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGzcW1XdRpE3W4CRNvb6/4OrGLOYLVDh+XmdXMOAZ5Qt0pklpd084ONQZSQnvhYdko3c1xwwyKT6VOocYEropxhLKYBVYzDeH4hlGUSv551mhWo8NEOtwNXrZkL19QVsXMMGcaJsAbDolf7EWYa6dEmpwSNRtj8lag0vPSnyO70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x2kEBE22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x2kEBE22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D50C4CEF5;
	Wed, 30 Jul 2025 09:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868896;
	bh=Fpk9DlX4wpoXHZcYLD9bBuoM9WQn6GPWejjV/I1OT3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x2kEBE22mMIhPiekpwaX3eXVBO3Pyxganv5WTMKI+T4P5OEhvqUe6mK6wGYnrTRL/
	 yJd23vvG4khQ0gcuYDTX/LIO+aPrD5dLZxjQ/ue/nrz2AmJlGAU0fOh2fRs9B66yg2
	 GjqiqZb8GZq7luPvzaWHEfESk8qNfGlxzc+n2nAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 097/117] KVM: x86: Route non-canonical checks in emulator through emulate_ops
Date: Wed, 30 Jul 2025 11:36:06 +0200
Message-ID: <20250730093237.570184114@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 16ccadefa295af434ca296e566f078223ecd79ca ]

Add emulate_ops.is_canonical_addr() to perform (non-)canonical checks in
the emulator, which will allow extending is_noncanonical_address() to
support different flavors of canonical checks, e.g. for descriptor table
bases vs. MSRs, without needing duplicate logic in the emulator.

No functional change is intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20240906221824.491834-3-mlevitsk@redhat.com
[sean: separate from additional of flags, massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: fa787ac07b3c ("KVM: x86/hyper-v: Skip non-canonical addresses during PV TLB flush")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c     |    2 +-
 arch/x86/kvm/kvm_emulate.h |    2 ++
 arch/x86/kvm/x86.c         |    7 +++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -653,7 +653,7 @@ static inline u8 ctxt_virt_addr_bits(str
 static inline bool emul_is_noncanonical_address(u64 la,
 						struct x86_emulate_ctxt *ctxt)
 {
-	return !__is_canonical_address(la, ctxt_virt_addr_bits(ctxt));
+	return !ctxt->ops->is_canonical_addr(ctxt, la);
 }
 
 /*
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -235,6 +235,8 @@ struct x86_emulate_ops {
 
 	gva_t (*get_untagged_addr)(struct x86_emulate_ctxt *ctxt, gva_t addr,
 				   unsigned int flags);
+
+	bool (*is_canonical_addr)(struct x86_emulate_ctxt *ctxt, gva_t addr);
 };
 
 /* Type, address-of, and value of an instruction's operand. */
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8608,6 +8608,12 @@ static gva_t emulator_get_untagged_addr(
 					       addr, flags);
 }
 
+static bool emulator_is_canonical_addr(struct x86_emulate_ctxt *ctxt,
+				       gva_t addr)
+{
+	return !is_noncanonical_address(addr, emul_to_vcpu(ctxt));
+}
+
 static const struct x86_emulate_ops emulate_ops = {
 	.vm_bugged           = emulator_vm_bugged,
 	.read_gpr            = emulator_read_gpr,
@@ -8654,6 +8660,7 @@ static const struct x86_emulate_ops emul
 	.triple_fault        = emulator_triple_fault,
 	.set_xcr             = emulator_set_xcr,
 	.get_untagged_addr   = emulator_get_untagged_addr,
+	.is_canonical_addr   = emulator_is_canonical_addr,
 };
 
 static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)


