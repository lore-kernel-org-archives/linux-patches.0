Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2077A2BE7D7;
	Wed, 23 Apr 2025 15:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421738; cv=none; b=ezhsg5BGeR23ZefgowI8Td2NUCBtOE7FiJpsyYYthS4A0MDWylE6htxr+pNPBbnlDKsa3yD/u7L47c95Fay3Z3ZH+s8JZULdJamAREQSW6G+wZdS9zEjsi9TkuX3lYeWKnaTiVipwokeZEAedU822GejqQ8e+zduvhQjGhj+oII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421738; c=relaxed/simple;
	bh=824HpfQIYoeZW3MS/F3San1U5wcoc2wt+WWhPsgyQTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaOCL+HhAjBNZcM02ABmjWZl89Ldoru/l/Ay0/3pDLh0KsFQElGIWu5NyJrAFdcgjDN1Q55IYm35LCcQDSuohSzAPnadv53a01/OfESMq2kBQHY3INBWdx5f+7ikHupJMzfHUpU1J08nGA7o7tYaXqx+wthWWskESOvdyNMhRYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eaUNYgxw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eaUNYgxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFC5C4CEE2;
	Wed, 23 Apr 2025 15:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421736;
	bh=824HpfQIYoeZW3MS/F3San1U5wcoc2wt+WWhPsgyQTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eaUNYgxwHmFSnTlv0ULaWfFyh0BEREC9MDE7S7iBlyad+NvIYXQFUt/uj4XwjC30X
	 Cka8V8BlWMmGCd+mKe7rJliASe0jXPDgb8IIYJAeubYIhModfLtqesag0S2pKwaFLc
	 uPpDf2dnX5w0s2UoI17u5ujvwRHWfpYQuh9ldQ20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Jim Mattson <jmattson@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 218/393] KVM: x86: Explicitly zero-initialize on-stack CPUID unions
Date: Wed, 23 Apr 2025 16:41:54 +0200
Message-ID: <20250423142652.388239785@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit bc52ae0a708cb6fa3926d11c88e3c55e1171b4a1 upstream.

Explicitly zero/empty-initialize the unions used for PMU related CPUID
entries, instead of manually zeroing all fields (hopefully), or in the
case of 0x80000022, relying on the compiler to clobber the uninitialized
bitfields.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Message-ID: <20250315024102.2361628-1-seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1011,8 +1011,8 @@ static inline int __do_cpuid_func(struct
 		}
 		break;
 	case 0xa: { /* Architectural Performance Monitoring */
-		union cpuid10_eax eax;
-		union cpuid10_edx edx;
+		union cpuid10_eax eax = { };
+		union cpuid10_edx edx = { };
 
 		if (!enable_pmu || !static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
@@ -1028,8 +1028,6 @@ static inline int __do_cpuid_func(struct
 
 		if (kvm_pmu_cap.version)
 			edx.split.anythread_deprecated = 1;
-		edx.split.reserved1 = 0;
-		edx.split.reserved2 = 0;
 
 		entry->eax = eax.full;
 		entry->ebx = kvm_pmu_cap.events_mask;
@@ -1303,7 +1301,7 @@ static inline int __do_cpuid_func(struct
 		break;
 	/* AMD Extended Performance Monitoring and Debug */
 	case 0x80000022: {
-		union cpuid_0x80000022_ebx ebx;
+		union cpuid_0x80000022_ebx ebx = { };
 
 		entry->ecx = entry->edx = 0;
 		if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2)) {


