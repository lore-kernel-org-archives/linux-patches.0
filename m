Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07FA282F04;
	Mon, 23 Mar 2026 15:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279469; cv=none; b=HwBnSx+ShRC87KtB8fssR5ze4vGmfIrRrGCeZK+0rIxN8w7oSLt5RjukvuYtNF/0OiK5gIzeDmmItjDn9+JaaoLm3GuO7BvwBr8TA5Ohv2s1/W5uv+FcypOTHH4btmUO4NN841L0b4D5W/nk+x0wnu1IihkLTzm9YHlHFEDdi5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279469; c=relaxed/simple;
	bh=aeR7JwEy7/o+1VvUNhGqFJ0vthCdaWBEY9zx9JwWmr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iie0LJQS7I0ZsBTMUYUhwCDAzp+PBM+1M30q1Wkb8ClusgF6qN/c8nTliSFBMswUaXGlFCjOit9GwSyrU6m++V7DQW/NB5felDV1SamxjwYpru0buaImud4gFbA2pJTBVPOGBAqFSgXUxOgbpUosW+jIFWVZhLDPJg4gbR926iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eou0lwbC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eou0lwbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CA2C4CEF7;
	Mon, 23 Mar 2026 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279469;
	bh=aeR7JwEy7/o+1VvUNhGqFJ0vthCdaWBEY9zx9JwWmr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eou0lwbC+UnBYsW5DYYoG7RfudFPMz/MA2kFdpO2UuQva///vYAefmOVWrYqn6anm
	 yne+5yBLsn7mVehmmoR6nNSiokdtuk53qr5LLdbVVT0ii+I7NvBA2VglKgzbncXsfi
	 PgmVMM8ayP+49p02e3tZQJ/ItVSJJf9XdH4O234k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/481] KVM: x86: Rename KVM_MSR_RET_INVALID to KVM_MSR_RET_UNSUPPORTED
Date: Mon, 23 Mar 2026 14:40:10 +0100
Message-ID: <20260323134525.926176053@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit aaecae7b6a2b19a874a7df0d474f44f3a5b5a74e ]

Rename the "INVALID" internal MSR error return code to "UNSUPPORTED" to
try and make it more clear that access was denied because the MSR itself
is unsupported/unknown.  "INVALID" is too ambiguous, as it could just as
easily mean the value for WRMSR as invalid.

Avoid UNKNOWN and UNIMPLEMENTED, as the error code is used for MSRs that
_are_ actually implemented by KVM, e.g. if the MSR is unsupported because
an associated feature flag is not present in guest CPUID.

Opportunistically beef up the comments for the internal MSR error codes.

Link: https://lore.kernel.org/r/20240802181935.292540-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Stable-dep-of: 5bb9ac186512 ("KVM: x86: Return "unsupported" instead of "invalid" on access to unsupported PV MSR")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/vmx/vmx.c |  2 +-
 arch/x86/kvm/x86.c     | 12 ++++++------
 arch/x86/kvm/x86.h     | 15 +++++++++++----
 4 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index a885fb39a6559..5d7775b869732 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2735,7 +2735,7 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 		msr->data = kvm_caps.supported_perf_cap;
 		return 0;
 	default:
-		return KVM_MSR_RET_INVALID;
+		return KVM_MSR_RET_UNSUPPORTED;
 	}
 
 	return 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ebdc86030a7a4..e5d162e97f503 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1889,7 +1889,7 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 		msr->data = kvm_caps.supported_perf_cap;
 		return 0;
 	default:
-		return KVM_MSR_RET_INVALID;
+		return KVM_MSR_RET_UNSUPPORTED;
 	}
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 80daa1ef956fa..84e54547ec7d0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1718,7 +1718,7 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	msr.index = index;
 	r = kvm_get_msr_feature(&msr);
 
-	if (r == KVM_MSR_RET_INVALID && kvm_msr_ignored_check(index, 0, false))
+	if (r == KVM_MSR_RET_UNSUPPORTED && kvm_msr_ignored_check(index, 0, false))
 		r = 0;
 
 	*data = msr.data;
@@ -1908,7 +1908,7 @@ static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
 {
 	int ret = __kvm_set_msr(vcpu, index, data, host_initiated);
 
-	if (ret == KVM_MSR_RET_INVALID)
+	if (ret == KVM_MSR_RET_UNSUPPORTED)
 		if (kvm_msr_ignored_check(index, data, true))
 			ret = 0;
 
@@ -1953,7 +1953,7 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
 {
 	int ret = __kvm_get_msr(vcpu, index, data, host_initiated);
 
-	if (ret == KVM_MSR_RET_INVALID) {
+	if (ret == KVM_MSR_RET_UNSUPPORTED) {
 		/* Unconditionally clear *data for simplicity */
 		*data = 0;
 		if (kvm_msr_ignored_check(index, 0, false))
@@ -2022,7 +2022,7 @@ static int complete_fast_rdmsr(struct kvm_vcpu *vcpu)
 static u64 kvm_msr_reason(int r)
 {
 	switch (r) {
-	case KVM_MSR_RET_INVALID:
+	case KVM_MSR_RET_UNSUPPORTED:
 		return KVM_MSR_EXIT_REASON_UNKNOWN;
 	case KVM_MSR_RET_FILTERED:
 		return KVM_MSR_EXIT_REASON_FILTER;
@@ -3915,7 +3915,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    kvm_is_msr_to_save(msr))
 			break;
 
-		return KVM_MSR_RET_INVALID;
+		return KVM_MSR_RET_UNSUPPORTED;
 	}
 	return 0;
 }
@@ -4270,7 +4270,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			break;
 		}
 
-		return KVM_MSR_RET_INVALID;
+		return KVM_MSR_RET_UNSUPPORTED;
 	}
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index f3554bf052016..9bb2f237b0fc0 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -459,11 +459,18 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 
 /*
  * Internal error codes that are used to indicate that MSR emulation encountered
- * an error that should result in #GP in the guest, unless userspace
- * handles it.
+ * an error that should result in #GP in the guest, unless userspace handles it.
+ * Note, '1', '0', and negative numbers are off limits, as they are used by KVM
+ * as part of KVM's lightly documented internal KVM_RUN return codes.
+ *
+ * UNSUPPORTED	- The MSR isn't supported, either because it is completely
+ *		  unknown to KVM, or because the MSR should not exist according
+ *		  to the vCPU model.
+ *
+ * FILTERED	- Access to the MSR is denied by a userspace MSR filter.
  */
-#define  KVM_MSR_RET_INVALID	2	/* in-kernel MSR emulation #GP condition */
-#define  KVM_MSR_RET_FILTERED	3	/* #GP due to userspace MSR filter */
+#define  KVM_MSR_RET_UNSUPPORTED	2
+#define  KVM_MSR_RET_FILTERED		3
 
 #define __cr4_reserved_bits(__cpu_has, __c)             \
 ({                                                      \
-- 
2.51.0



