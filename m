Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986E739C658;
	Mon, 23 Mar 2026 14:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277570; cv=none; b=FJJGlKM2aKpFW0cbrJkMATGiP8WSkQgjR4GCdK6LL20iA6uVhghhMI8AywowtnhITX+vBtjh623AwfVBNp8UeC+DsaA7dJ9Pgi9eWGVv1VN3AQ4qELHyfs2egEV3DmAEPveauj1pwabNfiQk8I/tA/+OLOcbWGZzMyszIB6bmZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277570; c=relaxed/simple;
	bh=tfgzQSk6pldBaSKifOsg8z6h+Nakxc98TX//qUSTZbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=up2NVyffrg7+jfekmksAe5ebmJNpPGyM6DL48CgvtMB19No/XiHejyuePMo7CZpc/+nX3Yj5RKouFZBPJ0Axh0X39yMNT4gLWywmh5zu56ngNySSbBAYr3LyssYmgR+VkB6BJGcYBuq8r9UPu+Ie4zBbev93hRc/Sxxy9gnblrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YmHrmELd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YmHrmELd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1326DC4CEF7;
	Mon, 23 Mar 2026 14:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277570;
	bh=tfgzQSk6pldBaSKifOsg8z6h+Nakxc98TX//qUSTZbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmHrmELdfKU64zxdhrHk73EV1VpVq1aKzbiUF721OC15BZ7YjH/RssfDlksomAut8
	 1YcQ+hAyoyap9xFSjCSI0cIwh/OPvX/1NHyx/kplmkkx2C/TbQmETKZ+uEvas5Zhn1
	 +yFOXySFxC1X2+sh571H1InFAWSw0LxsfaHKKYSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/567] KVM: x86: Rename KVM_MSR_RET_INVALID to KVM_MSR_RET_UNSUPPORTED
Date: Mon, 23 Mar 2026 14:39:15 +0100
Message-ID: <20260323134534.660473114@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9ddd1ee5f3123..a48616242affe 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2848,7 +2848,7 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
 			msr->data |= MSR_AMD64_DE_CFG_LFENCE_SERIALIZE;
 		break;
 	default:
-		return KVM_MSR_RET_INVALID;
+		return KVM_MSR_RET_UNSUPPORTED;
 	}
 
 	return 0;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4dd3f64a1a8c7..b68fb5329a13e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1981,7 +1981,7 @@ static int vmx_get_msr_feature(struct kvm_msr_entry *msr)
 			return 1;
 		return vmx_get_vmx_msr(&vmcs_config.nested, msr->index, &msr->data);
 	default:
-		return KVM_MSR_RET_INVALID;
+		return KVM_MSR_RET_UNSUPPORTED;
 	}
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 275dd7dc1d68b..3e16513a4d9fd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1724,7 +1724,7 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 	msr.index = index;
 	r = kvm_get_msr_feature(&msr);
 
-	if (r == KVM_MSR_RET_INVALID && kvm_msr_ignored_check(index, 0, false))
+	if (r == KVM_MSR_RET_UNSUPPORTED && kvm_msr_ignored_check(index, 0, false))
 		r = 0;
 
 	*data = msr.data;
@@ -1917,7 +1917,7 @@ static int kvm_set_msr_ignored_check(struct kvm_vcpu *vcpu,
 {
 	int ret = __kvm_set_msr(vcpu, index, data, host_initiated);
 
-	if (ret == KVM_MSR_RET_INVALID)
+	if (ret == KVM_MSR_RET_UNSUPPORTED)
 		if (kvm_msr_ignored_check(index, data, true))
 			ret = 0;
 
@@ -1962,7 +1962,7 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
 {
 	int ret = __kvm_get_msr(vcpu, index, data, host_initiated);
 
-	if (ret == KVM_MSR_RET_INVALID) {
+	if (ret == KVM_MSR_RET_UNSUPPORTED) {
 		/* Unconditionally clear *data for simplicity */
 		*data = 0;
 		if (kvm_msr_ignored_check(index, 0, false))
@@ -2031,7 +2031,7 @@ static int complete_fast_rdmsr(struct kvm_vcpu *vcpu)
 static u64 kvm_msr_reason(int r)
 {
 	switch (r) {
-	case KVM_MSR_RET_INVALID:
+	case KVM_MSR_RET_UNSUPPORTED:
 		return KVM_MSR_EXIT_REASON_UNKNOWN;
 	case KVM_MSR_RET_FILTERED:
 		return KVM_MSR_EXIT_REASON_FILTER;
@@ -3997,7 +3997,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    kvm_is_msr_to_save(msr))
 			break;
 
-		return KVM_MSR_RET_INVALID;
+		return KVM_MSR_RET_UNSUPPORTED;
 	}
 	return 0;
 }
@@ -4356,7 +4356,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			break;
 		}
 
-		return KVM_MSR_RET_INVALID;
+		return KVM_MSR_RET_UNSUPPORTED;
 	}
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1e7be1f6ab299..1222e5b3d5580 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -501,11 +501,18 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 
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



