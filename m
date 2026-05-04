Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6283DE434;
	Mon,  4 May 2026 14:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903380; cv=none; b=jo9R5H5NFOK7/s9HpEGBVwAY1KVACC/ws286GNPNlECJ/7BJmonjT+B55625Sse5i1BL13YjeGB1X0FB35umj6LVahvxMYpawp4r1dwpoDHePjQ4YrTXgNJQpvySbPMw5KSPv1/KluUMF20I5cl/YBRVqJod6us1Ib5l2oKFPxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903380; c=relaxed/simple;
	bh=Ub4UDyeAHJuBSrjiDDhmfD08q9QYjXMS/L4Yr44j3dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnerTOmIz7rfIK/naHYajhpLBjK15138ro59xPGmPHMhyCsMQ9rsdzeILh/gZaGWGEHAh/S37CBpvPqRu4HWz498sAKjXMwme+239DXZ8b5G1Xvcfd1O9EumWKN1JqBlrt9P3W/aRUme/8y/RwcvQ/i4XSi2VMsZzBXs7rS46Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7EooWhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7EooWhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBAEC2BCB8;
	Mon,  4 May 2026 14:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903380;
	bh=Ub4UDyeAHJuBSrjiDDhmfD08q9QYjXMS/L4Yr44j3dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7EooWhkGRNt6VWge7JHzuam+e/1QDihv0kozdS3oLmTrZov3hk4RffaQPOejkf9l
	 3rVAlIR6PL6GwUJ1ZWUtpgYbh+F3zm2J/9vP5uNIT7u4w9K8vmLg3+3B91Zqd69G8V
	 t7jZeNeAaZczDsyEIUcY19LTQKt9bZxGxPPCYH94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yosry Ahmed <yosry@kernel.org>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 7.0 204/307] KVM: nSVM: Sync interrupt shadow to cached vmcb12 after VMRUN of L2
Date: Mon,  4 May 2026 15:51:29 +0200
Message-ID: <20260504135150.555218296@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yosry Ahmed <yosry@kernel.org>

commit 03bee264f8ebfd39e0254c98e112d033a7aa9055 upstream.

After VMRUN in guest mode, nested_sync_control_from_vmcb02() syncs
fields written by the CPU from vmcb02 to the cached vmcb12. This is
because the cached vmcb12 is used as the authoritative copy of some of
the controls, and is the payload when saving/restoring nested state.

int_state is also written by the CPU, specifically bit 0 (i.e.
SVM_INTERRUPT_SHADOW_MASK) for nested VMs, but it is not sync'd to
cached vmcb12. This does not cause a problem if KVM_SET_NESTED_STATE
preceeds KVM_SET_VCPU_EVENTS in the restore path, as an interrupt shadow
would be correctly restored to vmcb02 (KVM_SET_VCPU_EVENTS overwrites
what KVM_SET_NESTED_STATE restored in int_state).

However, if KVM_SET_VCPU_EVENTS preceeds KVM_SET_NESTED_STATE, an
interrupt shadow would be restored into vmcb01 instead of vmcb02. This
would mostly be benign for L1 (delays an interrupt), but not for L2. For
L2, the vCPU could hang (e.g. if a wakeup interrupt is delivered before
a HLT that should have been in an interrupt shadow).

Sync int_state to the cached vmcb12 in nested_sync_control_from_vmcb02()
to avoid this problem. With that, KVM_SET_NESTED_STATE restores the
correct interrupt shadow state, and if KVM_SET_VCPU_EVENTS follows it
would overwrite it with the same value.

Fixes: cc440cdad5b7 ("KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE")
CC: stable@vger.kernel.org
Signed-off-by: Yosry Ahmed <yosry@kernel.org>
Link: https://patch.msgid.link/20260225005950.3739782-3-yosry@kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/nested.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -530,6 +530,7 @@ void nested_sync_control_from_vmcb02(str
 	u32 mask;
 	svm->nested.ctl.event_inj      = svm->vmcb->control.event_inj;
 	svm->nested.ctl.event_inj_err  = svm->vmcb->control.event_inj_err;
+	svm->nested.ctl.int_state	= svm->vmcb->control.int_state;
 
 	/* Only a few fields of int_ctl are written by the processor.  */
 	mask = V_IRQ_MASK | V_TPR_MASK;


