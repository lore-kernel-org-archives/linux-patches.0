Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18F9215060;
	Tue, 29 Apr 2025 17:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949385; cv=none; b=igKy3a9Uft7MWg5FraAb3/Y/Btyq01LSlGrPCQwxWpRGna4EpWxydB530GSTkdU3dTbdsGxZi/tH9e0OEOuv8jISY64E073U4IU7NRoICHgu7oOBhaPGo6m91xpQhjxi7f2iQB1di0JzQXp7asQzzuOd1GKbZ15/oFfQWfHhkJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949385; c=relaxed/simple;
	bh=magYQQ8SfuoVWMBNX7HtLl7CIjPMPjbUlWnKTOkV2rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rigk4kbKyyedpgCEYYtUAdGAo/JqRAVNr985feX1TcS5YtI79LdxyUWUOAPGJ2v5888HuzRR0dYKuIXgOFl+DILrrF6glQUhD1T6By5cHkcx7PuWVZHhQVKWVcGl1XMKVgH5c9wXvO8eVEPn7fJ3lVN0ewu+UrjJbdpqGjFoHyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0W4lXXow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0W4lXXow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D583C4CEE3;
	Tue, 29 Apr 2025 17:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949384;
	bh=magYQQ8SfuoVWMBNX7HtLl7CIjPMPjbUlWnKTOkV2rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0W4lXXowBQx4AdveJ3KDh1f7LMxkcCAiroTJEgD1Fp8jAP4ix6E8cfqEgdb3d5pWb
	 ADYTdpY9d7kMXkUA/9p2bGH7SGX0mI4lBHbXLuovL+gNDQ6InxUPW34xZiUVOWTr6j
	 kVSovlPLOGBCh4tqtAUXcvJKeAhWAth9YZsngoY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 301/373] KVM: SVM: Allocate IR data using atomic allocation
Date: Tue, 29 Apr 2025 18:42:58 +0200
Message-ID: <20250429161135.496255609@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -737,7 +737,7 @@ static int svm_ir_list_add(struct vcpu_s
 	 * Allocating new amd_iommu_pi_data, which will get
 	 * add to the per-vcpu ir_list.
 	 */
-	ir = kzalloc(sizeof(struct amd_svm_iommu_ir), GFP_KERNEL_ACCOUNT);
+	ir = kzalloc(sizeof(struct amd_svm_iommu_ir), GFP_ATOMIC | __GFP_ACCOUNT);
 	if (!ir) {
 		ret = -ENOMEM;
 		goto out;


