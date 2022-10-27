Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5594EAD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF303C433C1;
	Thu, 27 Oct 2022 17:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890180;
	bh=KJguYXYtXJS6AaOQtfD1pl1rR1S7vxQuPOk1Lt7/F34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v367ryuMoOOcBEYRC8Ud6M7/BFP3vn5z7txSJeVLmeLAqyJS5SVeWoBDUeku6QqUg
	 J6vuhA6uUrSUiVAAUfPhQIgpQEYBwXDRalYCF+RIKb3QuD3zZIp3WA2Bx1paE2MWs1
	 DoC+D41rh7rJnzz3AC6KdKjmvPN4GLTihMywXSlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Graf <graf@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 25/79] kvm: Add support for arch compat vm ioctls
Date: Thu, 27 Oct 2022 18:55:23 +0200
Message-Id: <20221027165055.794776216@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
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

commit ed51862f2f57cbce6fed2d4278cfe70a490899fd upstream.

We will introduce the first architecture specific compat vm ioctl in the
next patch. Add all necessary boilerplate to allow architectures to
override compat vm ioctls when necessary.

Signed-off-by: Alexander Graf <graf@amazon.com>
Message-Id: <20221017184541.2658-2-graf@amazon.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kvm_host.h |    2 ++
 virt/kvm/kvm_main.c      |   11 +++++++++++
 2 files changed, 13 insertions(+)

--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1124,6 +1124,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *
 			    struct kvm_enable_cap *cap);
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg);
+long kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
+			      unsigned long arg);
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4609,6 +4609,12 @@ struct compat_kvm_clear_dirty_log {
 	};
 };
 
+long __weak kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
+				     unsigned long arg)
+{
+	return -ENOTTY;
+}
+
 static long kvm_vm_compat_ioctl(struct file *filp,
 			   unsigned int ioctl, unsigned long arg)
 {
@@ -4617,6 +4623,11 @@ static long kvm_vm_compat_ioctl(struct f
 
 	if (kvm->mm != current->mm || kvm->vm_bugged)
 		return -EIO;
+
+	r = kvm_arch_vm_compat_ioctl(filp, ioctl, arg);
+	if (r != -ENOTTY)
+		return r;
+
 	switch (ioctl) {
 #ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	case KVM_CLEAR_DIRTY_LOG: {


