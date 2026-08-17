Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECC32DC331;
	Mon, 17 Aug 2026 15:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978862; cv=none; b=qWG5n4os17s3+3c0ZBPOFTgCY+YRtQa5ScFpEBnhUg+7h6Ano5eq3e6g8ru9WSqjTxeul9R0hXJMHF8uR28htzhRktNFIEvZmjvB+9Am8etMfs9lMzb2Mq9NtvgGGOfutIbRpTcB10815l4DqsyUCMFDYXgakbCbVXh1Df+95EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978862; c=relaxed/simple;
	bh=H9f1By+hVrHMnC3QaB/tsSvx3IwmENcxw20uUUlJ+pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhKO/DgLpzG5lnEbMJlRKiyWXqJ+ziRER0lOda25L1kXdRdSY7s+ne3+Ung63rCz/qNBKhOgsWwxXMZZRkKfPIjhqZv3cc0kz2likjK8H91uYiVoUP4d686u669sS8xZM+ZxAZdU4jqJ1Z6X/nPjnFQKI2uC17YtCXzMUjjOnAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T99i68cW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T99i68cW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40021F000E9;
	Mon, 17 Aug 2026 15:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978861;
	bh=T+7xCoHAZCsVexeovnjbWKep4sAaCYd65wbSWLe40oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T99i68cWaxzjND2QbDf7cHh3TOp2BcE7Ew9I6fHn4f4RE+xbIwykibu7DOaoGdPj6
	 w53lymur/mDTiNgAFHhHEYvTcVpanr36YTBpzLcW8chcFMmvXHHFoTKDUCvMdI171A
	 tk2AkAvW3yu5YgZzuAFqNuDuFJmQpcvvQLjvmENw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 007/609] KVM: nVMX: Hide shadow VMCS right after VMCLEAR
Date: Mon, 17 Aug 2026 15:25:03 +0200
Message-ID: <20260817132543.387227913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -287,6 +287,7 @@ static void vmx_switch_vmcs(struct kvm_v
 static void free_nested(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vmcs *shadow_vmcs;
 
 	if (WARN_ON_ONCE(vmx->loaded_vmcs != &vmx->vmcs01))
 		vmx_switch_vmcs(vcpu, &vmx->vmcs01);
@@ -304,9 +305,15 @@ static void free_nested(struct kvm_vcpu
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


