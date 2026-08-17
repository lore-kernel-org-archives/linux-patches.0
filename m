Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D0B3D8132;
	Mon, 17 Aug 2026 14:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975425; cv=none; b=rmAqyTTOVi2GZYYlPmrG3Fw1EoX6Ma4yYFAPpzb9SaOjnDz9EelEmxfzcuCRZSYRx/hCWMViS+9XN3BULxuwQ7apvAxQzBEKiu4gKXYe7bbxC19sNLHe4YmeudH7hJxguA3+nJ5MmKXnPXRMvF7wUeNpbrqKhWWDhWCqKdHKTV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975425; c=relaxed/simple;
	bh=YxrI69VwHnNhNWXxa12xzsoA53P/yEd3jPhQdCp2fao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIjGSA8kK+1USxVjz15R/p1RDm8bpzFuSgQW2s3sYfN/SkNSEuRCnIWt2RlgSQROo9va+HNigZ2Oj7n6pGMOPHvED7OVqvScQeWn67vJ5c+9piS7p3txvW3xm/nJN2a9RRkAm8FkMPCT4u7bCQqwgHLHyJ563vQRQMd71q5dDxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uK8Q0GP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uK8Q0GP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF7E1F000E9;
	Mon, 17 Aug 2026 14:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975424;
	bh=lAQ4YxnNOh5TvkBjdTdlVA//I6EIyEglKlxjpKkgAvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uK8Q0GP6GUnr57c7hw/xrbNBG5EFQaEnmeMOOXhzBjNcZcTert1+KRPjZSyKfLwf
	 rBnYY8Y9z84XaSE1F8JBxw1bDIdwWESKb3iQwqXZUiywAaUdfABYQ0drdREZgI19GE
	 JY+6u94JrXnXS9tQqX9bR2nlhx09AmyKgzAXOZso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 004/389] KVM: nVMX: Hide shadow VMCS right after VMCLEAR
Date: Mon, 17 Aug 2026 15:27:23 +0200
Message-ID: <20260817132538.994394006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -279,6 +279,7 @@ static void vmx_switch_vmcs(struct kvm_v
 static void free_nested(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vmcs *shadow_vmcs;
 
 	if (WARN_ON_ONCE(vmx->loaded_vmcs != &vmx->vmcs01))
 		vmx_switch_vmcs(vcpu, &vmx->vmcs01);
@@ -295,9 +296,15 @@ static void free_nested(struct kvm_vcpu
 	vmx->nested.current_vmptr = -1ull;
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


