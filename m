Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829205;
	b=ySnQwtDlKKY+YFTfblMz3KcAe9bG0HCiX/s81YZDsmN1jx6JBJAFTD8S10JrzVU2CGnS
	 cHHDhUbcE9Qht26bd9xQ4K+KmMgxGTZIi6DRv2PzkGUlK5M3jQbSD8Aca05I7/JBvU8im
	 Ga5nmu0XVj6JzGoJovq3TZYXIvpTv3C92ENcs4oSNM4v0Fq23zh3HQT1RdpFvifuc3GJE
	 9KTfYKk/L5UV57fbAA3s1HHZJcWfsDIeio4+8IxTIBoFwB/SIgeBOJKti7HLO/A4deWRL
	 YYLD7KB3Aq53Fjpq75OyzM2oN6UUINHGZJoaWksDWaieY4SWgnunbVrOma+bE73xagg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/mHMdmXwqLdmG1RDxDq2bY4lrhmjvoM2tKKyupLxbwg=;
	b=CQ9GQzfh6HYYmC/ngrTX46St5lF+J/ikm5zzs2e1IUhE+LoPPQ8UZdjaY2V1kjjZYLm0
	 oCOXQtU/BngJSpxFx8vsPkhWUzIDxWoyYoNgop+USa8VR1fb/WLFh1vvJ98RJgwes0sbR
	 YrMWQ25bry2KZkqset+lUy/eJbnbgwdsyg1OTjOQVwFH0hv5+yn6ObvkbhNIWM+yNDPlZ
	 cXfoWoXpowmqCnRWM/pFbLEOE8pPPcBpcwRmxngVl+hA3HajKttuNbu29ShXiLVdsqGjl
	 cVozq2gVR1rjMDS7uXXGaDBu/afYb8L4Vvn0/YFb8EU0sinARyNCVnfJjXJBGAGbPTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PbmZ4o0O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E880660A2612;
	Wed,  4 Nov 2026 21:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PbmZ4o0O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C0B1F0093A;
	Wed,  4 Nov 2026 21:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829204;
	bh=/mHMdmXwqLdmG1RDxDq2bY4lrhmjvoM2tKKyupLxbwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PbmZ4o0OD149yGNyeKqJTkGaczB7v0Z3bP4XoH2F87AG1vNLr7cbjKAHbpneEnQEZ
	 9tsclNQMm/tUXwLDtu6VXp5WxYUfoQverk5BMyEFLIIzChBfZ88tPLbiJq44EVURUo
	 TsDsxUyOrrUdU7VgU5x+OQAEhj7b0HnvUamDuGy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 476/547] KVM: TDX: Dont assume exit_reason[31:16] is all-0 in tdx_to_vmx_exit_reason()
Date: Wed,  4 Nov 2026 16:11:00 -0500
Message-ID: <20261104211051.885266011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaoyao Li <xiaoyao.li@intel.com>

commit bc335ce04408750585b4b32f248c543c9493d545 upstream.

When handling the real Exit Reason, don't assume the upper 16 bits as
all-0 in tdx_to_vmx_exit_reason(), in preparation for enabling Bus Lock
VM exit.

When Bus Lock VM exit is enabled, the bit 26 of Exit Reason becomes
valid and it can be 1 with various exit reasons.  Change the logic in
tdx_to_vmx_exit_reason() to check the 'basic' Exit Reason for correctness.
Also preserve bit[31:16] when changing the (basic) Exit Reason, to not
lose the information in bit[31:16].

Change the return type of tdx_to_vmx_exit_reason() to
"union vmx_exit_reason" for the convenience of manipulating the basic
field.

Fixes: c42856af8f70 ("KVM: TDX: Add a place holder for handler of TDX hypercalls (TDG.VP.VMCALL)")
Cc: stable@vger.kernel.org
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://patch.msgid.link/20260819094903.3060020-5-xiaoyao.li@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/tdx.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -935,10 +935,10 @@ static __always_inline bool tdx_is_exit_
 	}
 }
 
-static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
+static __always_inline union vmx_exit_reason tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
-	u32 exit_reason;
+	union vmx_exit_reason exit_reason;
 
 	/*
 	 * Return the synthesized invalid Exit Reason, as the TDX module
@@ -946,22 +946,26 @@ static __always_inline u32 tdx_to_vmx_ex
 	 * but this is NOT a failed VM-Enter.
 	 */
 	if (!tdx_is_exit_reason_valid(tdx->vp_enter_ret))
-		return EXIT_REASON_UNDEFINED;
+		return (union vmx_exit_reason) {
+			.basic = EXIT_REASON_UNDEFINED,
+		};
 
-	exit_reason = tdx->vp_enter_ret;
+	exit_reason.full = (u32)tdx->vp_enter_ret;
 
-	switch (exit_reason) {
+	switch (exit_reason.basic) {
 	case EXIT_REASON_TDCALL:
 		if (tdvmcall_exit_type(vcpu))
-			return EXIT_REASON_VMCALL;
-
-		return tdcall_to_vmx_exit_reason(vcpu);
+			exit_reason.basic = EXIT_REASON_VMCALL;
+		else
+			exit_reason.basic = tdcall_to_vmx_exit_reason(vcpu);
+		break;
 	case EXIT_REASON_EPT_MISCONFIG:
 		/*
 		 * Defer KVM_BUG_ON() until tdx_handle_exit() because this is in
 		 * non-instrumentable code with interrupts disabled.
 		 */
-		return EXIT_REASON_UNDEFINED;
+		exit_reason.basic = EXIT_REASON_UNDEFINED;
+		break;
 	default:
 		break;
 	}
@@ -978,7 +982,7 @@ static noinstr void tdx_vcpu_enter_exit(
 
 	tdx->vp_enter_ret = tdh_vp_enter(&tdx->vp, &tdx->vp_enter_args);
 
-	vt->exit_reason.full = tdx_to_vmx_exit_reason(vcpu);
+	vt->exit_reason = tdx_to_vmx_exit_reason(vcpu);
 
 	vt->exit_qualification = tdx->vp_enter_args.rcx;
 	tdx->ext_exit_qualification = tdx->vp_enter_args.rdx;


