Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371DF2C21F7;
	Tue, 12 Aug 2025 19:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026868; cv=none; b=AEoqc9R4gCPtHuudOsLdIiVVp4DnxQTfKildW5iDhcaaF9igtbfpinoeo/vmnevi7LuBMYoPI36d9T8FzlZl97+HEv2RqYyb5/XB1BTLL0W+QExBFC8kJJAXtdSuHwt6gS47GQqqhI+5yDaeqANvbujYL5h8vqxzrtI+HuwEhJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026868; c=relaxed/simple;
	bh=fwQfzrsZ+f5FGRdjZ7OgaRvjWhERUHfLchUcpdREjXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gr1jFcQecacuJFcTFiK+CbqQ6I4KvSje9c4yUkfin8SQ7Oycbiy9EeCKk8YyLld5igmJPFF2Z4d0QBk6+RYLyOciLqoh6rTSUGLWEezs7czPWNl/w4TXwUsMyBDZd69iYB7Vve+ix8nxLLyfHPM7CXM5lso7xzxFguEyZtKs7Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcs8SbZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcs8SbZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD60C4CEF0;
	Tue, 12 Aug 2025 19:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026868;
	bh=fwQfzrsZ+f5FGRdjZ7OgaRvjWhERUHfLchUcpdREjXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcs8SbZSMchsK5dlefF9YmkVzM30BLfa1rGyqzfJytmnlsVDsVZ+FOZcXxLwhK5sM
	 K9ey1/inX3Z5k4RUTASnvjfNYbRvCKjIdSYrHbqymiWduQnckW8JvzAMUV8euEM92L
	 5RerHxStX6B5KVNzFVv7pPlO4xQNZD1PxErPJAuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.15 464/480] KVM: VMX: Allow guest to set DEBUGCTL.RTM_DEBUG if RTM is supported
Date: Tue, 12 Aug 2025 19:51:12 +0200
Message-ID: <20250812174416.530544704@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2192,6 +2192,10 @@ static u64 vmx_get_supported_debugctl(st
 	    (host_initiated || intel_pmu_lbr_is_enabled(vcpu)))
 		debugctl |= DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
 
+	if (boot_cpu_has(X86_FEATURE_RTM) &&
+	    (host_initiated || guest_cpu_cap_has(vcpu, X86_FEATURE_RTM)))
+		debugctl |= DEBUGCTLMSR_RTM_DEBUG;
+
 	return debugctl;
 }
 


