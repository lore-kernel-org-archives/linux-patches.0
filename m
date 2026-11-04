Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829217;
	b=5eNqJ4XLz7RbRdMrLh8C4ishutFmx9JZGquv/EQbHOdsnuEbuh/nGftqA1/Wpbbfj1/a
	 GuGWo1FtnYr0AIjyj6XtUWAxBHzy6ObIfl3KP898+IE+1fpemvFgLIMPyjntTLNk2vDW1
	 trGg2NGiaCU+29FTY2oqoNfqoH+naohnL3xa2jXLwkPcTvp81F7PJhCEvSk3/DARJ9kAQ
	 7hxkDu2P3P62qfZIdIUOAiwlN+qIsgh8YvddLJtd8I1UQN0PZLoz9Y41ZlpE8tUZ9atGo
	 3TNvoPJJn7cy6YDIcsMHhEssacNdpLApAqqwlJ2NmHPdZUcamMD6EoDa7GoH+W3IvmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829217;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3SjW8i7DbpuKjwBT3AAm+F6S0Q5Cbol3X/Cy6s4EgwY=;
	b=NdpDiN88nqlOv7ONIZNdKg/j2IlDLKlIcakBBoW06NuoNGfYHrm6112G1uF5MCW3BfX9
	 oHcRVA5vAMixiliuIXNgZ37NVQegsvv2bq13PYvo/Ca35lymSZz1pm+4LRYwK2C9oYdbE
	 xH2Uh1zW8FyfYYQUF+rV0pN5VzdxhvoQRrVPPv2u8sqmnUCP+84ZzLuOhZabFJ6unFeyb
	 2o2WW6IW6E0Y+IjcOKdQ1o2dlm20VtbaDZn5PUuiTAuTwLEWXFajZuVgh4YFaGoSTr3qT
	 FJ7PaLC+ymCypTMNVr4Y+ssy/BfQq68PMKnSPrtmxCJaDBZuSw1xekWbiqUvEg66nJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rrZyZhox;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2326C6070323;
	Wed,  4 Nov 2026 21:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rrZyZhox
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89521F000C1;
	Wed,  4 Nov 2026 21:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829217;
	bh=3SjW8i7DbpuKjwBT3AAm+F6S0Q5Cbol3X/Cy6s4EgwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrZyZhoxDz2J4O44eO5QR8lhU1qi+kVgcbEN/6WIJG1vcnW20A1jkJIGWZSGYjpkm
	 GMrp6cBJ31m4K+HSZA0oi4XyIjcjZEGzaxQa7ZXkVXN6pAV5W6L7CFxCcS+xY3sqNa
	 OxgwX8IppH2MVLDxll3HVa2492tbnCD8IzKN9wb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH 7.3 472/547] KVM: TDX: Check if there is valid exit infos based on vp_enter_ret
Date: Wed,  4 Nov 2026 16:10:56 -0500
Message-ID: <20261104211051.776126872@linuxfoundation.org>
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

commit 0966c881ea13be5ec89820c185de4d55568e80ed upstream.

Check if there is valid exit info based on vp_enter_ret instead of relying
on the clobbered Exit Reason, in tdx_get_exit_info().

Current KVM uses "Exit Reason is not equal to the synthesized invalid
Exit Reason, -1u," as the condition to identify there is a real TD Exit
and valid exit infos.  However, there is one issue with this approach:
KVM updates the Exit Reason to the synthesized invalid Exit Reason for
real EPT MISCONFIG as well.  This is a false positive for real EPT
MISCONFIG, which has valid exit infos.

Though the issue can be addressed by changing the handling for real EPT
MISCONFIG to not update the Exit Reason to the synthesized one, relying
on the clobbered Exit Reason itself is brittle.  Instead, check
vp_enter_ret directly to identify if it is a valid Exit Reason.

Fixes: da407fe45908 ("KVM: TDX: Handle EPT violation/misconfig exit")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Link: https://patch.msgid.link/20260819094903.3060020-3-xiaoyao.li@intel.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/tdx.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -921,21 +921,27 @@ static __always_inline u32 tdcall_to_vmx
 	return EXIT_REASON_TDCALL;
 }
 
-static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
+static __always_inline bool tdx_is_exit_reason_valid(u64 vp_enter_ret)
 {
-	struct vcpu_tdx *tdx = to_tdx(vcpu);
-	u32 exit_reason;
-
-	switch (tdx->vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) {
+	switch (vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) {
 	case TDX_SUCCESS:
 	case TDX_NON_RECOVERABLE_VCPU:
 	case TDX_NON_RECOVERABLE_TD:
 	case TDX_NON_RECOVERABLE_TD_NON_ACCESSIBLE:
 	case TDX_NON_RECOVERABLE_TD_WRONG_APIC_MODE:
-		break;
+		return true;
 	default:
-		return -1u;
+		return false;
 	}
+}
+
+static __always_inline u32 tdx_to_vmx_exit_reason(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	u32 exit_reason;
+
+	if (!tdx_is_exit_reason_valid(tdx->vp_enter_ret))
+		return -1u;
 
 	exit_reason = tdx->vp_enter_ret;
 
@@ -2141,7 +2147,7 @@ void tdx_get_exit_info(struct kvm_vcpu *
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
 	*reason = tdx->vt.exit_reason.full;
-	if (*reason != -1u) {
+	if (tdx_is_exit_reason_valid(tdx->vp_enter_ret)) {
 		*info1 = vmx_get_exit_qual(vcpu);
 		*info2 = tdx->ext_exit_qualification;
 		*intr_info = vmx_get_intr_info(vcpu);


