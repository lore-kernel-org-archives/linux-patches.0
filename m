Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA4923A3
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 12:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141F1C433C1;
	Fri, 28 Oct 2022 12:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666958744;
	bh=yQF+60/nRttu+4F813ug7tbSCcUnkXqAAubIk4piuKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/E0U0/x2ELnFX41Uat7UIUa/r3WkEZDTbse+GkT+6WDnNspXphs6MZ5D9bTAttLZ
	 73bP0b+qVqkAccZq/tp95COn8d3/GTniYl/GXv4fRusiUdyCUQpiyVdhTDHc5kxL2E
	 bfJJwitz4LLsThj4aQ/0Ck9MCI14sM8Ls1kFpuz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Graf <graf@amazon.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 11/73] kvm: Add support for arch compat vm ioctls
Date: Fri, 28 Oct 2022 14:03:08 +0200
Message-Id: <20221028120232.838761674@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>
References: <20221028120232.344548477@linuxfoundation.org>
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
@@ -911,6 +911,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *
 			    struct kvm_enable_cap *cap);
 long kvm_arch_vm_ioctl(struct file *filp,
 		       unsigned int ioctl, unsigned long arg);
+long kvm_arch_vm_compat_ioctl(struct file *filp, unsigned int ioctl,
+			      unsigned long arg);
 
 int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
 int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu);
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3966,6 +3966,12 @@ struct compat_kvm_clear_dirty_log {
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
@@ -3974,6 +3980,11 @@ static long kvm_vm_compat_ioctl(struct f
 
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


