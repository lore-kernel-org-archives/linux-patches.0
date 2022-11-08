Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7BB15CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DBEC433C1;
	Tue,  8 Nov 2022 13:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915979;
	bh=0z0w+ocXjP6J97oYW7wDq51o9+MIFMuPNfxY2/dh04U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yP1VfNQxLjlfiyjUR/kbWHUDlKw7PH4qIN3GmNjnoeEvpX/ZKmOpbB23uUYIn1e9K
	 9/Gztic/kCOErZG8+UuS5Oj2HDRnjeMIhYnSYDGZJ6ApvS0kIrB85SMJ6Jln4j+E4k
	 IkdYPMW/O0y6VJXGYlVx7zWoOklMkm62KqzMSlZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Lewis <aaronlewis@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 010/144] KVM: x86: Protect the unused bits in MSR exiting flags
Date: Tue,  8 Nov 2022 14:38:07 +0100
Message-Id: <20221108133345.768115061@linuxfoundation.org>
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

From: Aaron Lewis <aaronlewis@google.com>

[ Upstream commit cf5029d5dd7cb0aaa53250fa9e389abd231606b3 ]

The flags for KVM_CAP_X86_USER_SPACE_MSR and KVM_X86_SET_MSR_FILTER
have no protection for their unused bits.  Without protection, future
development for these features will be difficult.  Add the protection
needed to make it possible to extend these features in the future.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Message-Id: <20220714161314.1715227-1-aaronlewis@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 2e3272bc1790 ("KVM: x86: Copy filter arg outside kvm_vm_ioctl_set_msr_filter()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cd22557e2645..59c9eb55e6d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5770,6 +5770,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = 0;
 		break;
 	case KVM_CAP_X86_USER_SPACE_MSR:
+		r = -EINVAL;
+		if (cap->args[0] & ~(KVM_MSR_EXIT_REASON_INVAL |
+				     KVM_MSR_EXIT_REASON_UNKNOWN |
+				     KVM_MSR_EXIT_REASON_FILTER))
+			break;
 		kvm->arch.user_space_msr_mask = cap->args[0];
 		r = 0;
 		break;
@@ -5903,6 +5908,9 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 	if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
 		return -EFAULT;
 
+	if (filter.flags & ~KVM_MSR_FILTER_DEFAULT_DENY)
+		return -EINVAL;
+
 	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++)
 		empty &= !filter.ranges[i].nmsrs;
 
-- 
2.35.1



