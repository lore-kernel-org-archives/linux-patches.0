Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4F246D57D;
	Fri,  7 Aug 2026 15:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117175; cv=none; b=hOsFuUdmnPNCp+ZyL+eRY+mIQtR+klzsYcLlyMyOklW6OtueOSSX3YP8wG2jHMtcktzPDei9mtTVeECSzg9Yjvi5rO8JB6vJ099CScBmB4H9JorahYLMNALOKHJZQk1+aiQcoJrlsk7goxOjPX8XM/GQ5hFmNPnM99fpQPA26uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117175; c=relaxed/simple;
	bh=kmNF+zjAgzThu2oC5bu6fZWamewJnK2qMgI7DGK7jlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2znQ/eGdd79OP0Z5EwarMDdImN5K9WvhnrFO0erEKVU2wMSCsOQttuPXPWLMtX5NTKxq3mjqC2NRWN4u97INwQD6eTHJwmogaGbMeV6+1Zt3OCkjzTVgWZyRQcq46fHxdAsySuDYTppEp8SRPif8i+QpjfdI90uYHCZpe4ztpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wshk0s6q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wshk0s6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0541F000E9;
	Fri,  7 Aug 2026 15:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117174;
	bh=CwyPSW9s1C81KgydrGCB1rvtD8t1TZ9sdEut8UlbN9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wshk0s6qqmlW4Rp1w3wSeN6zzrhLPa2bkI9zWb8hphSKwRtkAY7DQ4eltGS5wrIQt
	 mBoOKQtWMPTB16UhAV2sk20cA2wiUHMv2zMLGkprk9saCDVNLw4IMvQGRin2C4jF9j
	 p6qy9wNdz6LOo/wG4iIIC94lpAulqaWw3rRA6+Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.1 227/438] KVM: VMX: add memory clobber to asm for VMX instructions
Date: Fri,  7 Aug 2026 16:37:03 +0200
Message-ID: <20260807143432.843376744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -145,7 +145,7 @@ do_exception:
 
 		     : ASM_CALL_CONSTRAINT, [output] "=&r" (value)
 		     : [field] "r" (field)
-		     : "cc");
+		     : "cc", "memory");
 	return value;
 
 #endif /* CONFIG_CC_HAS_ASM_GOTO_OUTPUT */
@@ -192,7 +192,7 @@ do {									\
 	asm goto("1: " __stringify(insn) " %0\n\t"			\
 			  "jna %l[error]\n\t"				\
 			  _ASM_EXTABLE(1b, %l[fault])			\
-			  : : op1 : "cc" : error, fault);		\
+			  : : op1 : "cc", "memory" : error, fault);	\
 	return;								\
 error:									\
 	instrumentation_begin();					\
@@ -208,7 +208,7 @@ do {									\
 	asm goto("1: "  __stringify(insn) " %1, %0\n\t"			\
 			  "jna %l[error]\n\t"				\
 			  _ASM_EXTABLE(1b, %l[fault])			\
-			  : : op1, op2 : "cc" : error, fault);		\
+			  : : op1, op2 : "cc", "memory" : error, fault);\
 	return;								\
 error:									\
 	instrumentation_begin();					\


