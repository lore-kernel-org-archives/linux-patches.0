Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D499E21A43D;
	Tue, 29 Apr 2025 17:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946043; cv=none; b=fAfSV4f7OCGC19xHQiL8jqBdGyMb5MdXPYaD1aHpGRW0kQX09WFHWeR7XuE3sC8SkfLJ5RiYDuDN7p9DFPh/kuJePWdHa6EuE+TiCYcX2nWCv+8biEcK0A52OlC+Ei+2CAOyWi5iPIEHzKRQpHmPQZejgbTZI4z6scpKnOMI4mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946043; c=relaxed/simple;
	bh=/cRymtbJ2UbgLeUVwtaLrpJSo7Eagwkf0fUVL76/NvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+hWcI4/5sD82n4pib5iT5IkmhQ7lHRGPiiEpZ8PM69TEOPWo+9ustJ5WuT3u3KdDN3FDSVOkqfsrAxtFifvPZAlSSVkRnflbZWe3eNcpGTF1rP0PfnvSlLiGNXWv0d+vHd1MFMfohHbaTF/VlcHpMP/WAap8F7MTAAMNhUTCxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SXzvUJ92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SXzvUJ92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DC9C4CEE3;
	Tue, 29 Apr 2025 17:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946043;
	bh=/cRymtbJ2UbgLeUVwtaLrpJSo7Eagwkf0fUVL76/NvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXzvUJ922LYhEQPQEcgZ56uma0Vj47FW/PNQimC/WMfK5rHvB9oNTq7FHCBNWRw99
	 OX/bJCYR7XsImrOQs09CTD0NPKIiMMTpsgeC/shzLpskOEYl1pk2gkOXJEGIdDOc6a
	 97oMxooC4IxKXKHcmVNdOgDmxcqprP8XTm1qsp9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.14 135/311] KVM: SVM: Allocate IR data using atomic allocation
Date: Tue, 29 Apr 2025 18:39:32 +0200
Message-ID: <20250429161126.570906009@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


