Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829172;
	b=UVQ1YknIB56oqj3oWZHjptCiOI1SwgoSLILnwgChkGM5WRuJyl1JoTWb+hmGQhIC4oNu
	 0htcsJri/+ey+OMbYz0oS26fBOOjXsEaH1ESa8y3mpgU3apc90L9V3LIOUgmxrj05pepU
	 pYPKP0idJbgHWHxSz/g8wlT3KWF4dwTa1OYOdPQelHL0zljJWsYded/uq5Be1E6+1L0xz
	 ShpLvAPKDtfmwewaBVV8oPT4rN7gS490qylb8fOozhDPJnIq5p5hcz+P3N6EeLphA+3lz
	 yB08hXZLnF8KDLkO5SOV4QUL+jvYH+1kAuS72UR2EJUwpy9XY/TbXZV6nFMLQsaIUig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dbyp4TTOIPyswYajPraSOxHd13bpG48uw5H1biiZ9T8=;
	b=pMUg41rJHRrtQJPkriNzfrfW4gsyoPGdpMM7nK/v48Id5f3+pojC4vdHjGvHMx29PGkI
	 5tnlSGidpCoqeCNlC260psM6S9t/7hkSV768bRjlfnjrHdPHKl4yaHrnfm/jOZ7JvzEUC
	 /Z26Hk7icBmQKe7iCXjDLxLJLMRCVEVGN6bDhxrXJayEMLncnskkUJibjvfvC/U2FXIva
	 TTUVaIZotmEyTvs3HQQuCXYPA13JNclgNPmHx3mWDW5AvL+a6ih72vzytGSZVNogzna3Q
	 1xRrFGgTLHtzz7hiNUEWMg10rUk5obuBhwZcumK9UIb/8OSjE6PHrpcAPe1F4y75HEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FzljXSFj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B7C60709B0;
	Wed,  4 Nov 2026 21:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FzljXSFj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49A01F000C1;
	Wed,  4 Nov 2026 21:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829171;
	bh=dbyp4TTOIPyswYajPraSOxHd13bpG48uw5H1biiZ9T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FzljXSFjaghJSoZ1enFTRGK30q7TM/dafDhNzByjooGxj3OY7gON1b40XYBr4FZ7V
	 rVFXnK3iT/xmOLldn9lFoM4rxcu/fNwOKEhDPJdUKjxUX+WuOme/2rSQf9nIIHY/1z
	 kl38500piu0yxW0nCmeT9nuLKXagdxs7kapUbYV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.3 474/547] KVM: TDX: Set bits 31:16 to 0 and use UNDEFINED when synthesizing exit reason
Date: Wed,  4 Nov 2026 16:10:58 -0500
Message-ID: <20261104211051.828832373@linuxfoundation.org>
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

commit b43c520b198ab70868307a489ef2117ed6d6c4cc upstream.

Set bits 31:16 to 0 instead of all-1s when synthesizing an exit reason,
e.g. if the TDX Module never attempted VM-Enter, or when stuffing the exit
reason due to an unexpected "real" EPT Misconfig.  Opportunistically use
VMX's KVM-defined EXIT_REASON_UNDEFINED (0xdead) instead of -1u.

KVM is going to support Bus Lock VM exit for TDX, after which bit 26 of
the Exit Reason becomes meaningful and indicates that a bus lock happened.
The existing synthesized Exit Reason, -1u, will cause a false positive in
that case.  Change the synthesized Exit Reason from -1u to U16_MAX, so that
bits 31:16 are set to 0.  This also avoids the potential issues when other
bits in 31:16 become valid in the future.

As a bonus, the check for synthesized Exit Reason in tdx_failed_vmentry()
becomes unnecessary.  Just drop it.

Cc: stable@vger.kernel.org
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Link: https://patch.msgid.link/20260819094903.3060020-4-xiaoyao.li@intel.com
[sean: use EXIT_REASON_UNDEFINED instead of another magic value]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/tdx.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -940,8 +940,13 @@ static __always_inline u32 tdx_to_vmx_ex
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	u32 exit_reason;
 
+	/*
+	 * Return the synthesized invalid Exit Reason, as the TDX module
+	 * never attempted to run the vCPU, i.e. the Exit Reason is undefined,
+	 * but this is NOT a failed VM-Enter.
+	 */
 	if (!tdx_is_exit_reason_valid(tdx->vp_enter_ret))
-		return -1u;
+		return EXIT_REASON_UNDEFINED;
 
 	exit_reason = tdx->vp_enter_ret;
 
@@ -956,7 +961,7 @@ static __always_inline u32 tdx_to_vmx_ex
 		 * Defer KVM_BUG_ON() until tdx_handle_exit() because this is in
 		 * non-instrumentable code with interrupts disabled.
 		 */
-		return -1u;
+		return EXIT_REASON_UNDEFINED;
 	default:
 		break;
 	}
@@ -987,8 +992,7 @@ static noinstr void tdx_vcpu_enter_exit(
 
 static bool tdx_failed_vmentry(struct kvm_vcpu *vcpu)
 {
-	return vmx_get_exit_reason(vcpu).failed_vmentry &&
-	       vmx_get_exit_reason(vcpu).full != -1u;
+	return vmx_get_exit_reason(vcpu).failed_vmentry;
 }
 
 static fastpath_t tdx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)


