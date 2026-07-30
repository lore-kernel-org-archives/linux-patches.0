Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817F14477F9;
	Thu, 30 Jul 2026 15:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425283; cv=none; b=KYomm1czdlFYlLC7H3aI6lCPAVxAs0R9dL38YcsPB+KmJdZV+b7hiW9P2HVY7s0SLo06KETl2aBT9AGVGldeJaCbqlXNoexUz39L5VhlNvNWqBSxVdpwH/HmMitaqVsz1PgKZrUOi4WIfMvY8StYxGeYa04LQm/QRcDlctQdGGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425283; c=relaxed/simple;
	bh=eTplWNRm6Z/4p3z5WIY9La/eMQDATpnZbDXK67wA58E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuoJ8fMaY2ERTmsTAqnjhfQt839Z1eZr62KdN0yNIJ8c30Ab2WA6OJUOkZ8AqrIsdcbSa6GmxOArWQURsGxNCaI4KAeMDxWMubHWMJys4BCaUuFgkGxwOL+oWIfxg29tJZgT0ZeQza1MLM0kUOKSIZ9LR7uVMreQvDtTNyM5+4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJPfxNd6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJPfxNd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0A11F000E9;
	Thu, 30 Jul 2026 15:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425282;
	bh=rc5DJuyQHbeUHSt8JLzuinDNMYXMxC+5KBDX6pOBU3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJPfxNd6ta0Jio/feQWC+73avAVrQjM9BVQFBl/CYwxSaQAiUsqoSUwajbJuBhrWr
	 8dbVC3kQfUm4DXpsLbSC0Cxy1l3LTXDvfwTVajRIdRxIfsI5rX8UrrlCGMsK5VyNoI
	 CNzi3OWbZ3J9DqTQXf2kGOypSZC45Yvk/YVJ+TCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 016/602] KVM: nVMX: Hide shadow VMCS right after VMCLEAR
Date: Thu, 30 Jul 2026 16:06:48 +0200
Message-ID: <20260730141436.342257227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

commit 622ebfac01ba4f9c0060cebd41257fe46fc4a0b3 upstream.

free_nested() frees the shadow VMCS while vmcs01 still points to it. But
because it is asynchronous with respect to loaded_vmcs_clear(), the vCPU
might migrate before the pointer is cleared and __loaded_vmcs_clear()
may then execute VMCLEAR.

The VMCS needs to stay attached until its explicit VMCLEAR completes, but
then it can be hidden and the page safely freed.

Fixes: 355f4fb1405e ("kvm: nVMX: VMCLEAR an active shadow VMCS after last use")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -325,6 +325,7 @@ static void vmx_switch_vmcs(struct kvm_v
 static void free_nested(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vmcs *shadow_vmcs;
 
 	if (WARN_ON_ONCE(vmx->loaded_vmcs != &vmx->vmcs01))
 		vmx_switch_vmcs(vcpu, &vmx->vmcs01);
@@ -342,9 +343,15 @@ static void free_nested(struct kvm_vcpu
 	vmx->nested.current_vmptr = INVALID_GPA;
 	if (enable_shadow_vmcs) {
 		vmx_disable_shadow_vmcs(vmx);
-		vmcs_clear(vmx->vmcs01.shadow_vmcs);
-		free_vmcs(vmx->vmcs01.shadow_vmcs);
+
+		/*
+		 * Keep the pointer visible until after VMCLEAR, so migration
+		 * can clear an active shadow VMCS on the old CPU.
+		 */
+		shadow_vmcs = vmx->vmcs01.shadow_vmcs;
+		vmcs_clear(shadow_vmcs);
 		vmx->vmcs01.shadow_vmcs = NULL;
+		free_vmcs(shadow_vmcs);
 	}
 	kfree(vmx->nested.cached_vmcs12);
 	vmx->nested.cached_vmcs12 = NULL;


