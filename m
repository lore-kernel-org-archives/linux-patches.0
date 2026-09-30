Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2103451B16A;
	Wed, 30 Sep 2026 17:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789963; cv=none; b=OfkaJDYcqZ3dptFtkB25p3gn0yireyUulPtUCA8RRixh9VMpOGUXepLg4frp1z2Pa9dsaC6W/NGceEFOB80l+UgrT/1cCktfS9Vs4v5Nx+wao1HyiadXGy1evx3kAhEtApWcclkbkVWllcLdr9ugbaGoYAsLoZHW8bFrTNvw8Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789963; c=relaxed/simple;
	bh=lRvLG7HOiw593ONtYr6oCVcXFATA7HvhaehEEpn0oFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dR+TVPrrVwsPqcNW5/1C9MnTa9SfgGvEsWrdC/yoqWZ9CW38Fh91GhWiLnMsA4wrRJBeFaB+dEgHsZCA8zIMGy2KDRR7aiUlmP0BUR97n4NJKTLHFx4LNH8PskhU8KhkDrjlIYb4gmPrw9gHSrx8k5b6PLvZOnLsgtn0NkWlkkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ccjqx101; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ccjqx101"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802A51F000FF;
	Wed, 30 Sep 2026 17:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789962;
	bh=T4fjgrFLpwrNASu3Jv1jhjPuQxf/VLCs1S6Lzkw7uGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ccjqx101PSySvi6lcYbiIkaRD+fQOj/hfOxbHdsAbcDLCAsfnZSkXV5ZfsBnQu76H
	 SvAm/GCabb/AoJvo+7LQCuM00+UdQU9IfW7F5aMLerhwEK5YpPfCqIm6oelDFsuFrp
	 C/65psEQfyOjP+OlTElVP7e5tpUuD/81PYbSfKJo=
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
Subject: [PATCH 6.12 662/877] KVM: x86: Extract REGS and SREGS runtime sync code to helpers
Date: Wed, 30 Sep 2026 17:26:13 +0200
Message-ID: <20260930152428.949186316@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -12310,7 +12310,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct k
 	return 0;
 }
 
-static void store_regs(struct kvm_vcpu *vcpu)
+static void kvm_run_sync_regs_to_user(struct kvm_vcpu *vcpu)
 {
 	BUILD_BUG_ON(sizeof(struct kvm_sync_regs) > SYNC_REGS_SIZE_BYTES);
 
@@ -12319,13 +12319,18 @@ static void store_regs(struct kvm_vcpu *
 
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
@@ -12341,6 +12346,14 @@ static int sync_regs(struct kvm_vcpu *vc
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
 


