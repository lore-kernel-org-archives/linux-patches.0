Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76B346D092;
	Fri,  7 Aug 2026 15:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115167; cv=none; b=XWfibBQtDCVAdQoN8fce92YJuR26heNNzu3ABm58OJyBgBjBJi6KvAhf2K2MmZfPYQCCdf7x3NqrZfmPvLEJKjPuNgg3Fyc9jSWPiVNbgaKbrtXZFGRg7780hsADaBNd4ezCzTkKFWnbpnrA42sfqXnUuUNUnJAs1K6NgAaROO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115167; c=relaxed/simple;
	bh=LjV9doUnPGqRRtrB6xYHE/lpcBB9kOdGlh6PGp2JBV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojwMHPDpA4rT5y5f2r7jo/gib9pB2yvxTJj7zjKVsg2MXZqJ5Jbw3KUdroqBJWj8tzUFQY432kYztmwEoxSg/n4tnYbceFvHnl7HCIOVBvxIe9O9oTVxerttQPyUeSNvNH2l5XpJzEiYZ8y60PXO9LsGhaCKYZtxvKjk9Fj20Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wu89PeLP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wu89PeLP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01D01F00A3E;
	Fri,  7 Aug 2026 15:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115161;
	bh=HLtjgnPpCFe5X0UWTcIk1PwcGAEcdNQhygW83w4ce+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wu89PeLPHzWn0m4YG0rhM+6owJqlJyXuKFN+EBo+frcVIRQFDkkC5R+WuTv8zAPjT
	 4Eu9DVlx2WBY0ZddnWRENl3SxQh5/hg5fjeg9xRqCLyYmEjC/TaIDYQGUT9vB2fRu7
	 cJFKQbT1blvf54lMyzWCuX2tWq2AFfXGhVUiREWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.18 178/396] KVM: VMX: add memory clobber to asm for VMX instructions
Date: Fri,  7 Aug 2026 16:35:38 +0200
Message-ID: <20260807143428.135458557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit 0e65cd9e5d41c34f86b7c347967bedac54926041 upstream.

VMCLEAR/VMREAD/VMWRITE/VMPTRLD access the internal VMCS cache, which
is not visible to the compiler; without a memory clobber, the compiler
can reorder them in troublesome ways because "asm volatile" and "asm goto"
only protect against removal of the asm.  For example, placing a VMWRITE
before the corresponding VMCS pointer is loaded can lead to corruption.
While none of this has been observed, it is better to prevent than cure.

Likewise, INVEPT and INVVPID access the TLB and, even though in their
case the effect is only visible to the next VMLAUNCH/VMRESUME, it is
technically correct to add the clobber there too.  So avoid any urge to
special case them, and simply hardcode "memory" into the clobber list
of vmx_asm1() and vmx_asm2().  __vmcs_readl() open-codes its own asm,
so add the clobber there as well.

Link: https://lore.kernel.org/kvm/CABgObfbL3t21yVeSwiLSjjOUER+rTYDPHYAH9YU4TWGRjx6XHg@mail.gmail.com/
Cc: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/vmx_ops.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -101,7 +101,7 @@ static __always_inline unsigned long __v
 
 			  : [output] "=r" (value)
 			  : [field] "r" (field)
-			  : "cc"
+			  : "cc", "memory"
 			  : do_fail, do_exception);
 
 	return value;
@@ -146,7 +146,7 @@ do_exception:
 
 		     : ASM_CALL_CONSTRAINT, [output] "=&r" (value)
 		     : [field] "r" (field)
-		     : "cc");
+		     : "cc", "memory");
 	return value;
 
 #endif /* CONFIG_CC_HAS_ASM_GOTO_OUTPUT */
@@ -194,7 +194,7 @@ do {									\
 			  ".byte 0x2e\n\t" /* branch not taken hint */	\
 			  "jna %l[error]\n\t"				\
 			  _ASM_EXTABLE(1b, %l[fault])			\
-			  : : op1 : "cc" : error, fault);		\
+			  : : op1 : "cc", "memory" : error, fault);	\
 	return;								\
 error:									\
 	instrumentation_begin();					\
@@ -211,7 +211,7 @@ do {									\
 			  ".byte 0x2e\n\t" /* branch not taken hint */	\
 			  "jna %l[error]\n\t"				\
 			  _ASM_EXTABLE(1b, %l[fault])			\
-			  : : op1, op2 : "cc" : error, fault);		\
+			  : : op1, op2 : "cc", "memory" : error, fault);\
 	return;								\
 error:									\
 	instrumentation_begin();					\


