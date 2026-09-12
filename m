Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF08355803;
	Sat, 12 Sep 2026 09:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205871; cv=none; b=a2OgZMy3V6sZ8f/46XYdWSLP3Y+4C6wC1+tzwUe8CpGueUMSToGSe5jqKhk51hrkZcPoZaLGJqqC9CxSHZR1ZAN0BOwsgFsvQZO0uGJkKey1qwMPVqfPrIUH3t4Laqxv78A33shqhQueAylpE9iDgV4T9vLm7+DzPUcBWa9BHtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205871; c=relaxed/simple;
	bh=NZejzJPha3y8MnEToLMDCP7tuj5n2zgCeDpEx4BDmYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQvcJ5bgR2Z8fTJW5/WuoNrwJTBdTWBtatkwJArcFlmkUBvjfcD50PMzxj/XIYnaOCZ6svv2T1ryc8cJoX7SoLvG7sXWExiOX95y5GClPm8faSnIe5CfVlB1QC9SPxi/3Im+dtKQqpVtl341mM3oNcrsTgwLB7p1By2i4lVaAek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U9WeI3y8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U9WeI3y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C71A1F000FF;
	Sat, 12 Sep 2026 09:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205870;
	bh=6rDvqMWYGCqKfShMzPTTA2QbrSLHm/OrOgjqWO12WiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U9WeI3y8zj/dZtEvAVeV0WCwXTRWo5qOH9imOS7nVYR7PvoRLxRK20PoS3ZIYRbSY
	 Uk1x7XqLnBetgLOwCue0u3pgtew6Fjl36GMICLZtQH8eY30NG9cQZDluwgwrh0/rE9
	 o5Kc/UrLcFfvh3qlLDgn6YBKsJm5kXck5jS9fW2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0088/1518] KVM: x86: Extract REGS and SREGS runtime sync code to helpers
Date: Sat, 12 Sep 2026 08:37:37 +0200
Message-ID: <20260912065625.455485518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 6a8a98aa9c147eb63f5a360f157f207bf46c05ee ]

Extract the REGS and SREGS portions of {store,sync}_regs() into separate
helpers in anticipation of moving the register specific code out of x86.c
and into regs.c.

No functional change intended.

Cc: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Message-ID: <20260613000329.732085-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 184bd464bdb6 ("KVM: x86: Check EFER validity on KVM_SET_SREGS*")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12627,7 +12627,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct k
 	return 0;
 }
 
-static void store_regs(struct kvm_vcpu *vcpu)
+static void kvm_run_sync_regs_to_user(struct kvm_vcpu *vcpu)
 {
 	BUILD_BUG_ON(sizeof(struct kvm_sync_regs) > SYNC_REGS_SIZE_BYTES);
 
@@ -12636,13 +12636,18 @@ static void store_regs(struct kvm_vcpu *
 
 	if (vcpu->run->kvm_valid_regs & KVM_SYNC_X86_SREGS)
 		__get_sregs(vcpu, &vcpu->run->s.regs.sregs);
+}
+
+static void store_regs(struct kvm_vcpu *vcpu)
+{
+	kvm_run_sync_regs_to_user(vcpu);
 
 	if (vcpu->run->kvm_valid_regs & KVM_SYNC_X86_EVENTS)
 		kvm_vcpu_ioctl_x86_get_vcpu_events(
 				vcpu, &vcpu->run->s.regs.events);
 }
 
-static int sync_regs(struct kvm_vcpu *vcpu)
+static int kvm_run_sync_regs_from_user(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->run->kvm_dirty_regs & KVM_SYNC_X86_REGS) {
 		__set_regs(vcpu, &vcpu->run->s.regs.regs);
@@ -12658,6 +12663,14 @@ static int sync_regs(struct kvm_vcpu *vc
 		vcpu->run->kvm_dirty_regs &= ~KVM_SYNC_X86_SREGS;
 	}
 
+	return 0;
+}
+
+static int sync_regs(struct kvm_vcpu *vcpu)
+{
+	if (kvm_run_sync_regs_from_user(vcpu))
+		return -EINVAL;
+
 	if (vcpu->run->kvm_dirty_regs & KVM_SYNC_X86_EVENTS) {
 		struct kvm_vcpu_events events = vcpu->run->s.regs.events;
 


