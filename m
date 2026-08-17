Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE334315F;
	Mon, 17 Aug 2026 14:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976518; cv=none; b=bUDbMgGagQUyuE9zz+HaprhOT6la+aZhUD2RhXESSH5wjEmKMez7jwY6uN1t0sZat9DKurZ7QME1JYJdUz40yYo9R1JblF/gYTXY4Im6dIz1RFx1fwpBkibIzpxfvN3G7QnnneIKItAH2bVZJm0UdkkC8I2ImEiclsteycqyUvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976518; c=relaxed/simple;
	bh=lbaRUc/KsgLj85pk23hRx0TPtZRwj2rwoVrpiG62tQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXpW5+s/U/MBvQkpT0jKK3CIfmuArw+CI/IEuLic9NjY9OXHrtPLpAO5AFNoqSNJPunf8zMeLDy/DC9jF/rUH1H75UN44Y47ItMFPswTmRa4tMRoX0nJRa1Rgfq6CdleMix8R2yzNShc4Ax3b/qz7vxOWf3TubQ+IvUaD08D3nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZDjS09T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZDjS09T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527E91F000E9;
	Mon, 17 Aug 2026 14:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976516;
	bh=okXA0DxL+jo+LTiHVqMZqOEOh9F5AXrG2nUmUhWDz4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZDjS09TWTqQNbfFR2KUjkDsr+f9pgyZ60So3HKalzlEQcZCcWxRC6SBCIuPY7SIF
	 Et1JnVIEBkIRmyGT83NXlivricA7uova3S3F0p1CHDYJmGXE4T+fY+rssSK+NkrL8Z
	 I78nMYJFtuuo3VfIXvEr6SplKWUqCNjNvXbk/i4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Sean Christopherson <seanjc@google.com>,
	Vivian Wang <dramforever@live.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/456] KVM: VMX: Make vmread_error_trampoline() uncallable from C code
Date: Mon, 17 Aug 2026 15:26:41 +0200
Message-ID: <20260817132540.329225205@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index 9e9ef47e988c12..6d342e4f592082 100644
--- a/arch/x86/kvm/vmx/vmx_ops.h
+++ b/arch/x86/kvm/vmx/vmx_ops.h
@@ -11,14 +11,26 @@
 #include "x86.h"
 
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



