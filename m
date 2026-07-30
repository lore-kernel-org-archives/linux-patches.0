Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B29443E4E;
	Thu, 30 Jul 2026 14:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421222; cv=none; b=IybMsKjsLADNA2/Cv8V+YEmocC+WcDmLGsb/A2N/z5i7CwdZcvWgJZdpUAtZwtmqwfvRXeI90lJ3pul282yQIGZ6Hd8L0mhOo1fgbkLAXPRFQEULvzg3Nh9yfVgkd3xjEbJdkQVevq1feFTxUcq8xkfz2BWXngW5YOV2GoWQQmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421222; c=relaxed/simple;
	bh=nocx1J3dKh2Wb2GUzrunRFTHLZboQfqbNWa2emcWSHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iltuZWitz1wtpd1dY1uTNKdkKeCMJ/0V1hqNdUTGLsxE2S4boL2Lp08UKTEZ5wV1bpK5b+sWwKK7po7zNUcpbmHr7A1xAvJFRdjmNnGfaNlJjLgkRmZi+nwLNPbNC+jSM+gwyeXzsBpBx8Pt0ifi8zlKY28+HogS+YHdk2w8Mno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Orpz35Zq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Orpz35Zq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9761F00A3A;
	Thu, 30 Jul 2026 14:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421221;
	bh=64esbvuohDqFskuf5mjiGc1nVkyWjfsr+W3rhOulTno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Orpz35Zqx5q4xShLKcylbL3nVd5AKhLKrPp4ECw/JpvJvCiZ59vWSsakfjpg6Apy9
	 lb/U4ZQZR9DVKvPIYLWX2Frez7KEVvYtxdSPNPilMK/j16Fb9n6OKhCTJ6Eij0FRe4
	 FSneK0HFdUe3MmNc85/v7dFfUDbW+PLuphxBtewM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7.1 007/744] KVM: nVMX: Hide shadow VMCS right after VMCLEAR
Date: Thu, 30 Jul 2026 16:04:40 +0200
Message-ID: <20260730141444.436542458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -336,6 +336,7 @@ static void nested_put_vmcs12_pages(stru
 static void free_nested(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vmcs *shadow_vmcs;
 
 	if (WARN_ON_ONCE(vmx->loaded_vmcs != &vmx->vmcs01))
 		vmx_switch_vmcs(vcpu, &vmx->vmcs01);
@@ -353,9 +354,15 @@ static void free_nested(struct kvm_vcpu
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


