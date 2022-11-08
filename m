Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DC415CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02465C433C1;
	Tue,  8 Nov 2022 14:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916017;
	bh=togohQUVmm6tlWrpD6V03F1kQv5B4NxAZ01SWhS50Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUc9S5XA4HlvTzKDI94bamIm9aNhD1E1Rayf7USjZzJJCMnDHsa1YtfUPFp7AAj5W
	 G02VtqEy1xWREVffdnfSp/8Cb+d4gM8xJstyLG9voCmKHlQPMshv+8uHVgO9Y5cpxz
	 27+wP5ucz64lb405eCtMIxtuA8SfdvceLBC95yQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Graf <graf@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/144] KVM: x86: Copy filter arg outside kvm_vm_ioctl_set_msr_filter()
Date: Tue,  8 Nov 2022 14:38:08 +0100
Message-Id: <20221108133345.798890596@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Graf <graf@amazon.com>

[ Upstream commit 2e3272bc1790825c43d2c39690bf2836b81c6d36 ]

In the next patch we want to introduce a second caller to
set_msr_filter() which constructs its own filter list on the stack.
Refactor the original function so it takes it as argument instead of
reading it through copy_from_user().

Signed-off-by: Alexander Graf <graf@amazon.com>
Message-Id: <20221017184541.2658-3-graf@amazon.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 59c9eb55e6d1..5d165f793f44 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5895,26 +5895,22 @@ static int kvm_add_msr_filter(struct kvm_x86_msr_filter *msr_filter,
 	return 0;
 }
 
-static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
+static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm,
+				       struct kvm_msr_filter *filter)
 {
-	struct kvm_msr_filter __user *user_msr_filter = argp;
 	struct kvm_x86_msr_filter *new_filter, *old_filter;
-	struct kvm_msr_filter filter;
 	bool default_allow;
 	bool empty = true;
 	int r = 0;
 	u32 i;
 
-	if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
-		return -EFAULT;
-
-	if (filter.flags & ~KVM_MSR_FILTER_DEFAULT_DENY)
+	if (filter->flags & ~KVM_MSR_FILTER_DEFAULT_DENY)
 		return -EINVAL;
 
-	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++)
-		empty &= !filter.ranges[i].nmsrs;
+	for (i = 0; i < ARRAY_SIZE(filter->ranges); i++)
+		empty &= !filter->ranges[i].nmsrs;
 
-	default_allow = !(filter.flags & KVM_MSR_FILTER_DEFAULT_DENY);
+	default_allow = !(filter->flags & KVM_MSR_FILTER_DEFAULT_DENY);
 	if (empty && !default_allow)
 		return -EINVAL;
 
@@ -5922,8 +5918,8 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 	if (!new_filter)
 		return -ENOMEM;
 
-	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++) {
-		r = kvm_add_msr_filter(new_filter, &filter.ranges[i]);
+	for (i = 0; i < ARRAY_SIZE(filter->ranges); i++) {
+		r = kvm_add_msr_filter(new_filter, &filter->ranges[i]);
 		if (r) {
 			kvm_free_msr_filter(new_filter);
 			return r;
@@ -6320,9 +6316,16 @@ long kvm_arch_vm_ioctl(struct file *filp,
 	case KVM_SET_PMU_EVENT_FILTER:
 		r = kvm_vm_ioctl_set_pmu_event_filter(kvm, argp);
 		break;
-	case KVM_X86_SET_MSR_FILTER:
-		r = kvm_vm_ioctl_set_msr_filter(kvm, argp);
+	case KVM_X86_SET_MSR_FILTER: {
+		struct kvm_msr_filter __user *user_msr_filter = argp;
+		struct kvm_msr_filter filter;
+
+		if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
+			return -EFAULT;
+
+		r = kvm_vm_ioctl_set_msr_filter(kvm, &filter);
 		break;
+	}
 	default:
 		r = -ENOTTY;
 	}
-- 
2.35.1



