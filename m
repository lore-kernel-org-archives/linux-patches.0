Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA992EC0B0;
	Mon, 17 Aug 2026 14:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975384; cv=none; b=Otl4xB2t1ebyY7+N/4UNWTdOWMvPsjxbj+LNzZYfj/KlVL32P0D9LNZ7ok4RuDuFsYH3xrnRnDuVhP+Q6z3pmnpTEuQhH1lKznvzPWrbZWcgNxPbOkr9QUwLZFmMadoAjg1aF+AoaFGwarQE9CZLzOI/MjfodFEkgYELVYq6u6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975384; c=relaxed/simple;
	bh=Jd8zqbCRfcZ6L2LNa5g1MEyxUS0sVdJYGuN41TONfU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4lX+d9TOiTMUoxv5Mb6q3gSsy48NtYRRwFdFvD84PaOaBuXNmt7Y+YIYaCGkyWThSBXB2gF8Z20x20mYiy5fHsHbb45hF1T42b3EtAUfOi1i7oOwEeZNhh8JPyiprXi0Ns9gtkfPd/TazROWZHBf85ds2jHBo6fWbjL1CTWF/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q11Fi/WS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q11Fi/WS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B6B1F000E9;
	Mon, 17 Aug 2026 14:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975383;
	bh=0AUi/1Bs4L3qEMB2ONX07ZLX9BmHLjZSXieOGKTPDwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q11Fi/WSNat9ZyhFuH54j80xcJrzur0ICLHtksLVwgi728lzqHDHBUTg6KjqupNhp
	 Of4cm9g7AZlbN2R5CddDSFsy9RWWtsW1iZIDYO3bTMBsiEFKNZYQzmRmCJbxImDLcZ
	 rZhbY9aqyqa/z7cyC8aRLn2bRhw35HwILju4+0zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Vivian Wang <dramforever@live.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 010/389] KVM: VMX: Make vmread_error_trampoline() uncallable from C code
Date: Mon, 17 Aug 2026 15:27:29 +0200
Message-ID: <20260817132539.244504792@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 0b5e7a16a0a79a3742f0df9e45bca46f01b40e6a ]

Declare vmread_error_trampoline() as an opaque symbol so that it cannot
be called from C code, at least not without some serious fudging.  The
trampoline always passes parameters on the stack so that the inline
VMREAD sequence doesn't need to clobber registers.  regparm(0) was
originally added to document the stack behavior, but it ended up being
confusing because regparm(0) is a nop for 64-bit targets.

Opportunustically wrap the trampoline and its declaration in #ifdeffery
to make it even harder to invoke incorrectly, to document why it exists,
and so that it's not left behind if/when CONFIG_CC_HAS_ASM_GOTO_OUTPUT
is true for all supported toolchains.

No functional change intended.

Cc: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20220928232015.745948-1-seanjc@google.com
[ Vivian: Adjust context. Remove check for CONFIG_CC_HAS_ASM_GOTO_OUTPUT
  which does not apply for old kernel. ]
Signed-off-by: Vivian Wang <dramforever@live.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx_ops.h | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx_ops.h b/arch/x86/kvm/vmx/vmx_ops.h
index 692b0c31c9c82d..b80902686c1e41 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -13,14 +13,26 @@
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
 asmlinkage void vmread_error(unsigned long field, bool fault);
-__attribute__((regparm(0))) void vmread_error_trampoline(unsigned long field,
-							 bool fault);
 void vmwrite_error(unsigned long field, unsigned long value);
 void vmclear_error(struct vmcs *vmcs, u64 phys_addr);
 void vmptrld_error(struct vmcs *vmcs, u64 phys_addr);
 void invvpid_error(unsigned long ext, u16 vpid, gva_t gva);
 void invept_error(unsigned long ext, u64 eptp, gpa_t gpa);
 
+/*
+ * The VMREAD error trampoline _always_ uses the stack to pass parameters, even
+ * for 64-bit targets.  Preserving all registers allows the VMREAD inline asm
+ * blob to avoid clobbering GPRs, which in turn allows the compiler to better
+ * optimize sequences of VMREADs.
+ *
+ * Declare the trampoline as an opaque label as it's not safe to call from C
+ * code; there is no way to tell the compiler to pass params on the stack for
+ * 64-bit targets.
+ *
+ * void vmread_error_trampoline(unsigned long field, bool fault);
+ */
+extern unsigned long vmread_error_trampoline;
+
 static __always_inline void vmcs_check16(unsigned long field)
 {
 	BUILD_BUG_ON_MSG(__builtin_constant_p(field) && ((field) & 0x6001) == 0x2000,
-- 
2.53.0



