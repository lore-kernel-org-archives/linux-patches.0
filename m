Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E25442C;
	Wed, 30 Jul 2025 09:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868951; cv=none; b=m9JtPsNCnOoQdtS2okJi0iQihgseq+E6zAi99XTaHmGC2ephPduB3esLTeSAvQKO7MwAVcjXRE8H4x3qUlf8KlpWYfl9vgXq6alCqCqEoQHg1FzUUouV3LrA1R68gYEaPv8jt4hRZjehK98flIDBxtGj0AV6Cm8/I3aC+xwXXLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868951; c=relaxed/simple;
	bh=Mv4FNN+voKJlbmTM6+Be6IjhUmqolSSQHCiVTHJXVTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJ55c4r7knMDPT4XyfZdnVfBs4bpVE70gFepVysg95wgpBW9LtMZeNiccvjlcTt6L8FsG2bqSlGB2uFJkO7ahWUAgEumghDyiHsja4xH4/HL0goKQAz9Y+gZ6d5GHpnZ/36attr5o4NQxWwXGF4wvbZcpiAdjjE+/Hm+4gJb5N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISnsjFAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISnsjFAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCDCC4CEF5;
	Wed, 30 Jul 2025 09:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868950;
	bh=Mv4FNN+voKJlbmTM6+Be6IjhUmqolSSQHCiVTHJXVTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISnsjFAENFof70OJue6VfKCJnEn8/x3h+jN8opOcd3sbrN59xTvr326TJjKY8LkWb
	 9IJhpPrL3W3G2JMHLZjV6PFbg5NtlAhqQ6c3qSQeRINGpwU0KixyN4U+2UK8ViI/YH
	 WDw+cxwRLG5vtPqlWsy70AGMt4cb2HssHtvjI+sI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/117] KVM: x86: Add X86EMUL_F_MSR and X86EMUL_F_DT_LOAD to aid canonical checks
Date: Wed, 30 Jul 2025 11:36:07 +0200
Message-ID: <20250730093237.611864919@linuxfoundation.org>
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

[ Upstream commit c534b37b7584e2abc5d487b4e017f61a61959ca9 ]

Add emulation flags for MSR accesses and Descriptor Tables loads, and pass
the new flags as appropriate to emul_is_noncanonical_address().  The flags
will be used to perform the correct canonical check, as the type of access
affects whether or not CR4.LA57 is consulted when determining the canonical
bit.

No functional change is intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20240906221824.491834-3-mlevitsk@redhat.com
[sean: split to separate patch, massage changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: fa787ac07b3c ("KVM: x86/hyper-v: Skip non-canonical addresses during PV TLB flush")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/emulate.c     |   15 +++++++++------
 arch/x86/kvm/kvm_emulate.h |    5 ++++-
 arch/x86/kvm/x86.c         |    2 +-
 3 files changed, 14 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -651,9 +651,10 @@ static inline u8 ctxt_virt_addr_bits(str
 }
 
 static inline bool emul_is_noncanonical_address(u64 la,
-						struct x86_emulate_ctxt *ctxt)
+						struct x86_emulate_ctxt *ctxt,
+						unsigned int flags)
 {
-	return !ctxt->ops->is_canonical_addr(ctxt, la);
+	return !ctxt->ops->is_canonical_addr(ctxt, la, flags);
 }
 
 /*
@@ -1733,7 +1734,8 @@ static int __load_segment_descriptor(str
 		if (ret != X86EMUL_CONTINUE)
 			return ret;
 		if (emul_is_noncanonical_address(get_desc_base(&seg_desc) |
-						 ((u64)base3 << 32), ctxt))
+						 ((u64)base3 << 32), ctxt,
+						 X86EMUL_F_DT_LOAD))
 			return emulate_gp(ctxt, err_code);
 	}
 
@@ -2516,8 +2518,8 @@ static int em_sysexit(struct x86_emulate
 		ss_sel = cs_sel + 8;
 		cs.d = 0;
 		cs.l = 1;
-		if (emul_is_noncanonical_address(rcx, ctxt) ||
-		    emul_is_noncanonical_address(rdx, ctxt))
+		if (emul_is_noncanonical_address(rcx, ctxt, 0) ||
+		    emul_is_noncanonical_address(rdx, ctxt, 0))
 			return emulate_gp(ctxt, 0);
 		break;
 	}
@@ -3494,7 +3496,8 @@ static int em_lgdt_lidt(struct x86_emula
 	if (rc != X86EMUL_CONTINUE)
 		return rc;
 	if (ctxt->mode == X86EMUL_MODE_PROT64 &&
-	    emul_is_noncanonical_address(desc_ptr.address, ctxt))
+	    emul_is_noncanonical_address(desc_ptr.address, ctxt,
+					 X86EMUL_F_DT_LOAD))
 		return emulate_gp(ctxt, 0);
 	if (lgdt)
 		ctxt->ops->set_gdt(ctxt, &desc_ptr);
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -94,6 +94,8 @@ struct x86_instruction_info {
 #define X86EMUL_F_FETCH			BIT(1)
 #define X86EMUL_F_IMPLICIT		BIT(2)
 #define X86EMUL_F_INVLPG		BIT(3)
+#define X86EMUL_F_MSR			BIT(4)
+#define X86EMUL_F_DT_LOAD		BIT(5)
 
 struct x86_emulate_ops {
 	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
@@ -236,7 +238,8 @@ struct x86_emulate_ops {
 	gva_t (*get_untagged_addr)(struct x86_emulate_ctxt *ctxt, gva_t addr,
 				   unsigned int flags);
 
-	bool (*is_canonical_addr)(struct x86_emulate_ctxt *ctxt, gva_t addr);
+	bool (*is_canonical_addr)(struct x86_emulate_ctxt *ctxt, gva_t addr,
+				  unsigned int flags);
 };
 
 /* Type, address-of, and value of an instruction's operand. */
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8609,7 +8609,7 @@ static gva_t emulator_get_untagged_addr(
 }
 
 static bool emulator_is_canonical_addr(struct x86_emulate_ctxt *ctxt,
-				       gva_t addr)
+				       gva_t addr, unsigned int flags)
 {
 	return !is_noncanonical_address(addr, emul_to_vcpu(ctxt));
 }


