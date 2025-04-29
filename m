Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D02E24A07D;
	Tue, 29 Apr 2025 17:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947302; cv=none; b=MxMa2b/7G/SuYbMAmsd/WYyDtq+QRqqpeSKNub3w3HjwmTlqXkjR2HftjtKW0rVga30hcVk57x5dUsxpBdVLS3HhoDM+13mdGpVcCKodz9Y+P2IKrA9y9KVdSFwapRH9MOBvd+EvWmV651wo3Dkse9U3MtHho+HrsSbJolPdc4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947302; c=relaxed/simple;
	bh=aClPNfefnA2MDJ9z+o2XfzsGSRNEkYSw+JxB3c0pMV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzFa0g473Nl1G7hI1yDYB62DtsIgp36BH716knqBEt0YczJWVgP+G7PTYdQdw8Vxmqxn3tr28Bb1IMtoyXaHPKz6FG3GNCLTwltDKGuWEULSR03azUJ20W9KYsQJ730eP+K1KC5dmArU0/IeG2yVm3JiIqFACMw2VUE6YS+Un+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCy/6c8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCy/6c8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A133AC4CEEA;
	Tue, 29 Apr 2025 17:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947302;
	bh=aClPNfefnA2MDJ9z+o2XfzsGSRNEkYSw+JxB3c0pMV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCy/6c8BJP2QFRmb/nS1mnX1oV5W3ChIzRDmXL7wV1l1ekiGnNLpsarYnf0KlhRsT
	 3yGi4k3rEqweJKE7esG71igaxKc3fmj55w0vfIdCSf2LfdTEWdSpaVCSnnhfG84Gn2
	 bqK0ZYTtJ/CfhwE2ZiPGXjonhrIioCyVAzdn/hr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 238/286] KVM: SVM: Allocate IR data using atomic allocation
Date: Tue, 29 Apr 2025 18:42:22 +0200
Message-ID: <20250429161117.717734488@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -742,7 +742,7 @@ static int svm_ir_list_add(struct vcpu_s
 	 * Allocating new amd_iommu_pi_data, which will get
 	 * add to the per-vcpu ir_list.
 	 */
-	ir = kzalloc(sizeof(struct amd_svm_iommu_ir), GFP_KERNEL_ACCOUNT);
+	ir = kzalloc(sizeof(struct amd_svm_iommu_ir), GFP_ATOMIC | __GFP_ACCOUNT);
 	if (!ir) {
 		ret = -ENOMEM;
 		goto out;


