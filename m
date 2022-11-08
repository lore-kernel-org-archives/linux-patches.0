Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8472115CAC
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D3DC433D6;
	Tue,  8 Nov 2022 13:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915515;
	bh=FTLELSZacEIFvtaKyRilsJ2hfyQuJXB6jn6YycAor8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bp9sv6ocJKBRup60i+eCawizuifi6CydmrGjJJxiakmOFdvJbY/J679pKSzwa4nIG
	 77Qfz4Pqjpw/9D3wK9Ie7rLpnVNNhClp6UMe+HnT40z2wEQ1rhn74/StCy23X4P9dn
	 ljFgi8eYrLiAUHKtImxmqbNsNvLr81c5RzMkXEEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Randrianasulu <randrianasulu@gmail.com>,
	Alexander Graf <graf@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/118] KVM: x86: Add compat handler for KVM_X86_SET_MSR_FILTER
Date: Tue,  8 Nov 2022 14:38:10 +0100
Message-Id: <20221108133341.237515955@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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

[ Upstream commit 1739c7017fb1d759965dcbab925ff5980a5318cb ]

The KVM_X86_SET_MSR_FILTER ioctls contains a pointer in the passed in
struct which means it has a different struct size depending on whether
it gets called from 32bit or 64bit code.

This patch introduces compat code that converts from the 32bit struct to
its 64bit counterpart which then gets used going forward internally.
With this applied, 32bit QEMU can successfully set MSR bitmaps when
running on 64bit kernels.

Reported-by: Andrew Randrianasulu <randrianasulu@gmail.com>
Fixes: 1a155254ff937 ("KVM: x86: Introduce MSR filtering")
Signed-off-by: Alexander Graf <graf@amazon.com>
Message-Id: <20221017184541.2658-4-graf@amazon.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index be4326b143e1..0ac80b3ff0f5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5493,6 +5493,62 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm,
 	return 0;
 }
 
+#ifdef CONFIG_KVM_COMPAT
+/* for KVM_X86_SET_MSR_FILTER */
+struct kvm_msr_filter_range_compat {
+	__u32 flags;
+	__u32 nmsrs;
+	__u32 base;
+	__u32 bitmap;
+};
+
+struct kvm_msr_filter_compat {
+	__u32 flags;
+	struct kvm_msr_filter_range_compat ranges[KVM_MSR_FILTER_MAX_RANGES];
+};
+
+#define KVM_X86_SET_MSR_FILTER_COMPAT _IOW(KVMIO, 0xc6, struct kvm_msr_filter_compat)
+
+long kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
+			      unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct kvm *kvm = filp->private_data;
+	long r = -ENOTTY;
+
+	switch (ioctl) {
+	case KVM_X86_SET_MSR_FILTER_COMPAT: {
+		struct kvm_msr_filter __user *user_msr_filter = argp;
+		struct kvm_msr_filter_compat filter_compat;
+		struct kvm_msr_filter filter;
+		int i;
+
+		if (copy_from_user(&filter_compat, user_msr_filter,
+				   sizeof(filter_compat)))
+			return -EFAULT;
+
+		filter.flags = filter_compat.flags;
+		for (i = 0; i < ARRAY_SIZE(filter.ranges); i++) {
+			struct kvm_msr_filter_range_compat *cr;
+
+			cr = &filter_compat.ranges[i];
+			filter.ranges[i] = (struct kvm_msr_filter_range) {
+				.flags = cr->flags,
+				.nmsrs = cr->nmsrs,
+				.base = cr->base,
+				.bitmap = (__u8 *)(ulong)cr->bitmap,
+			};
+		}
+
+		r = kvm_vm_ioctl_set_msr_filter(kvm, &filter);
+		break;
+	}
+	}
+
+	return r;
+}
+#endif
+
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg)
 {
-- 
2.35.1



