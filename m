Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C2322425B;
	Tue, 12 Aug 2025 19:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025224; cv=none; b=ZA6LVCMHI+m6i1XJYBpWHGI+AUlvpSmEoTs7O9DbyBB7Nid+ArY+bUpOPTeCXhU5XzKdBWSRmjBGATeJpptFTeYXUCC5bWb01Wtgiqb8Dp7BlBvDA/9IvSpWqLjm98rkzRjWg0dxoMDuOxUsDmXbIh9vewjmqd9Ze7x6ymD6XAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025224; c=relaxed/simple;
	bh=6tIJGCAbBb1H8Oo6ewLNUE+xQJ6yWwVScBtdSfvVLdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5be+kMDrcR8kV11YO5g0UvnRBqX0HMb+yN1XzNBihcmrpFj7ceI5PyrBZcTh9zsqsa3xP5bHwy810kFm5ElI+PpbZ/jMsCDwBmfXAuIJ1tqK9M86yIFT05ZBpE8DVcKU8IdCHmrGcZDEsWW/0qpkr8loJYt8QxvK0dWLDnrWvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIyp7k9a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIyp7k9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173F1C4CEF0;
	Tue, 12 Aug 2025 19:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025224;
	bh=6tIJGCAbBb1H8Oo6ewLNUE+xQJ6yWwVScBtdSfvVLdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIyp7k9aQVhKa6fw9MDBX6aLbJKbRf9XCN7QfWzzn8jHNpBDOXJDkYtrJMp4peUVt
	 3JZ0321vphtQCNI5NYhkOYzhyyHYQdVHIodDc6P4KF6KA8JFtYCiaBDTaosoHn4wJk
	 dVm7hxQGvp0KrdMCXQJZk8ASj0xMjFb4RlM2CS/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.16 606/627] KVM: VMX: Allow guest to set DEBUGCTL.RTM_DEBUG if RTM is supported
Date: Tue, 12 Aug 2025 19:35:01 +0200
Message-ID: <20250812173454.927064516@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 17ec2f965344ee3fd6620bef7ef68792f4ac3af0 upstream.

Let the guest set DEBUGCTL.RTM_DEBUG if RTM is supported according to the
guest CPUID model, as debug support is supposed to be available if RTM is
supported, and there are no known downsides to letting the guest debug RTM
aborts.

Note, there are no known bug reports related to RTM_DEBUG, the primary
motivation is to reduce the probability of breaking existing guests when a
future change adds a missing consistency check on vmcs12.GUEST_DEBUGCTL
(KVM currently lets L2 run with whatever hardware supports; whoops).

Note #2, KVM already emulates DR6.RTM, and doesn't restrict access to
DR7.RTM.

Fixes: 83c529151ab0 ("KVM: x86: expose Intel cpu new features (HLE, RTM) to guest")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250610232010.162191-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/msr-index.h |    1 +
 arch/x86/kvm/vmx/vmx.c           |    4 ++++
 2 files changed, 5 insertions(+)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -419,6 +419,7 @@
 #define DEBUGCTLMSR_FREEZE_PERFMON_ON_PMI	(1UL << 12)
 #define DEBUGCTLMSR_FREEZE_IN_SMM_BIT	14
 #define DEBUGCTLMSR_FREEZE_IN_SMM	(1UL << DEBUGCTLMSR_FREEZE_IN_SMM_BIT)
+#define DEBUGCTLMSR_RTM_DEBUG		BIT(15)
 
 #define MSR_PEBS_FRONTEND		0x000003f7
 
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2186,6 +2186,10 @@ static u64 vmx_get_supported_debugctl(st
 	    (host_initiated || intel_pmu_lbr_is_enabled(vcpu)))
 		debugctl |= DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
 
+	if (boot_cpu_has(X86_FEATURE_RTM) &&
+	    (host_initiated || guest_cpu_cap_has(vcpu, X86_FEATURE_RTM)))
+		debugctl |= DEBUGCTLMSR_RTM_DEBUG;
+
 	return debugctl;
 }
 


