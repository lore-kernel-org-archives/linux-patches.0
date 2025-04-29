Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A8A25333E;
	Tue, 29 Apr 2025 17:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947820; cv=none; b=iNskPiDxk1EGlZFBF3qXngBhnzpJUXrq3B14uHmZZzzWvrY2La3memz/yM/eDYB1CkScA2f3wuB1BYe6OQ3daH+bONsMxjoQJe28C+93ZNjDI3196ednOFIyzBHFJ75enP9BJQoxoWizKt+LFJkNH///VF74FT08VS4atH+lfmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947820; c=relaxed/simple;
	bh=yV4MBJuZEv6b/iWmGUhwC2+YoHxFrrdIgZlPdU0Nsjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGEvnKDHZQkimWbnEdogiSi1c+MFmlmDWAqga7zdthpzh0ykSfkv5UM0XdxvC/+UnaUb1kMxOQbFvF3lHcfiCMPwT086lJCtlOxvrmsAxv2kydvojDH4K2VZnnryYBnUylC/0wz2cCGSuKtm7uyETl93VFXYJsDKO5ubUWQM4rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DD7nupf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DD7nupf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B84BFC4CEEF;
	Tue, 29 Apr 2025 17:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947820;
	bh=yV4MBJuZEv6b/iWmGUhwC2+YoHxFrrdIgZlPdU0Nsjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DD7nupf8Z+jAmj/rt6FNuJqIvlDd8L5KeECuiSGY7OB0h37IozfLG5mvIEtSqZ00r
	 xaN6aQbB8eOJZ3vdEHeedDV0g3ah/8B9PyxQRCRNGrRz/N6hCOL3XoXgHC1Y7kXpka
	 7GXMTQLXG7S+/XSQtUBiqEN3XnQq4d5aFzvauSfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 113/280] KVM: SVM: Allocate IR data using atomic allocation
Date: Tue, 29 Apr 2025 18:40:54 +0200
Message-ID: <20250429161119.737672403@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 7537deda36521fa8fff9133b39c46e31893606f2 upstream.

Allocate SVM's interrupt remapping metadata using GFP_ATOMIC as
svm_ir_list_add() is called with IRQs are disabled and irqfs.lock held
when kvm_irq_routing_update() reacts to GSI routing changes.

Fixes: 411b44ba80ab ("svm: Implements update_pi_irte hook to setup posted interrupt")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20250404193923.1413163-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/avic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -820,7 +820,7 @@ static int svm_ir_list_add(struct vcpu_s
 	 * Allocating new amd_iommu_pi_data, which will get
 	 * add to the per-vcpu ir_list.
 	 */
-	ir = kzalloc(sizeof(struct amd_svm_iommu_ir), GFP_KERNEL_ACCOUNT);
+	ir = kzalloc(sizeof(struct amd_svm_iommu_ir), GFP_ATOMIC | __GFP_ACCOUNT);
 	if (!ir) {
 		ret = -ENOMEM;
 		goto out;


