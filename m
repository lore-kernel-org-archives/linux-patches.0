Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A4679EE;
	Sat, 30 Dec 2023 12:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LqSuhSgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3922C433C8;
	Sat, 30 Dec 2023 12:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938334;
	bh=+5DKgrj94PTqCO+0BUUfulRBdth9QywqYi0/MPThc/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LqSuhSgBf3mku8ZYLTsEFuq/fn0faCISZ9lnyVK6AZ03jS9ubSzSzwlw4hnjcWR5n
	 ulKKqf6pf1El9S3QlwalZ+8gqMhDSrtB89d4w1Zk4bC/9sLIqTAVz4H/6yOrdKiiFs
	 qQvEQrl2iLq5RIG0rXUvt0Doq0U804qo881QOhpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.1 106/112] KVM: arm64: vgic: Add a non-locking primitive for kvm_vgic_vcpu_destroy()
Date: Sat, 30 Dec 2023 12:00:19 +0000
Message-ID: <20231230115810.161957895@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115806.714618407@linuxfoundation.org>
References: <20231230115806.714618407@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marc Zyngier <maz@kernel.org>

commit d26b9cb33c2d1ba68d1f26bb06c40300f16a3799 upstream.

As we are going to need to call into kvm_vgic_vcpu_destroy() without
prior holding of the slots_lock, introduce __kvm_vgic_vcpu_destroy()
as a non-locking primitive of kvm_vgic_vcpu_destroy().

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20231207151201.3028710-3-maz@kernel.org
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/vgic/vgic-init.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -368,7 +368,7 @@ static void kvm_vgic_dist_destroy(struct
 		vgic_v4_teardown(kvm);
 }
 
-void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
+static void __kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 
@@ -382,6 +382,15 @@ void kvm_vgic_vcpu_destroy(struct kvm_vc
 	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
 }
 
+void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	mutex_lock(&kvm->slots_lock);
+	__kvm_vgic_vcpu_destroy(vcpu);
+	mutex_unlock(&kvm->slots_lock);
+}
+
 void kvm_vgic_destroy(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
@@ -392,7 +401,7 @@ void kvm_vgic_destroy(struct kvm *kvm)
 	vgic_debug_destroy(kvm);
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_vgic_vcpu_destroy(vcpu);
+		__kvm_vgic_vcpu_destroy(vcpu);
 
 	mutex_lock(&kvm->arch.config_lock);
 


