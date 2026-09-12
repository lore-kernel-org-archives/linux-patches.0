Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D6C3A961A;
	Sat, 12 Sep 2026 07:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196751; cv=none; b=UBH3qPuKb2U1LBt31NdKB8d6w0xdeUuSRTT1HeB47SLVl3oDzvaU0MmoYu4GGlp29lYtQDs5LepqrpVhTGLjyJtOxyGqOcJ/PEjbbBQg1DYvJJZN1WCbnY82deZVCGPf/rgQcE5ad8QGTueeqn6Tbeyr5xAuWuUhAWLpnI0Fvtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196751; c=relaxed/simple;
	bh=4FxlG9IwqpLnB6QN3zo9XgcqVogBoEicMk6XXhOkhns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fya/jpKYm6sAsWewqeCs43sQX0iUUXEqG32R3pZJnptbQS9oGavKBxYxBrpSIkXtXMD+V3GWuAvJqu5P0fp+4/HwzakDDsQkzytjPQR9rr/XEGGrxGJVagMOtuS8qQeuoDOxVkCZNkFPJISE2XE4RqXo5Ya2kPzoLAp3zlCFRYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHJWZ8tj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHJWZ8tj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C854C1F00893;
	Sat, 12 Sep 2026 07:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196747;
	bh=G4a3Zov16AHHKNeukWXC3YtenDw+3DQY/Xk/uGru32g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aHJWZ8tj7jQyWMkXGwkFUYEu01oGVwHNaf7D74LYOkNYezi4om/MxP+jntrUhDyf4
	 MNKV9/bYgg6VEIKohjq5xm6tENuZbMetXsxLTa8Gn0Xj3DP+JJHEZXisiuh2R30Xxm
	 2jvVPbM5fXyvMu7SVlzNbcdJ4PPotTAEjSmg6iQc=
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
Subject: [PATCH 7.2 0029/1815] KVM: x86: Extract REGS and SREGS runtime sync code to helpers
Date: Sat, 12 Sep 2026 08:29:39 +0200
Message-ID: <20260912065649.692599267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -12696,7 +12696,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct k
 	return 0;
 }
 
-static void store_regs(struct kvm_vcpu *vcpu)
+static void kvm_run_sync_regs_to_user(struct kvm_vcpu *vcpu)
 {
 	BUILD_BUG_ON(sizeof(struct kvm_sync_regs) > SYNC_REGS_SIZE_BYTES);
 
@@ -12705,13 +12705,18 @@ static void store_regs(struct kvm_vcpu *
 
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
@@ -12727,6 +12732,14 @@ static int sync_regs(struct kvm_vcpu *vc
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
 


