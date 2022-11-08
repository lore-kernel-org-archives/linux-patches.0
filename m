Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A12415CB2
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AED7C433D7;
	Tue,  8 Nov 2022 14:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916949;
	bh=3uU64uPCncAqLNdao3wwKcUs4r2F7gxrQtrMrvHJbKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRa7icFXTGBCP+5MYL9oJ9J3jVqTdpbSFczqbYK5oLq2oCFiRJ3oBcyLe0KYKZUAp
	 JaPz+kRaoIeWhomhsrfZyoLjmLOqKQ0t2+DZveAibaD7HPafIKBfDPskAmaOQ1X4wC
	 L9iJnJIDW6udEZw0n6gQdceSiG9S2h9dNXbIchkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Steven Price <steven.price@arm.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.0 181/197] KVM: arm64: Fix bad dereference on MTE-enabled systems
Date: Tue,  8 Nov 2022 14:40:19 +0100
Message-Id: <20221108133403.135299554@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ryan Roberts <ryan.roberts@arm.com>

commit b6bcdc9f6b8321e4471ff45413b6410e16762a8d upstream.

enter_exception64() performs an MTE check, which involves dereferencing
vcpu->kvm. While vcpu has already been fixed up to be a HYP VA pointer,
kvm is still a pointer in the kernel VA space.

This only affects nVHE configurations with MTE enabled, as in other
cases, the pointer is either valid (VHE) or not dereferenced (!MTE).

Fix this by first converting kvm to a HYP VA pointer.

Fixes: ea7fc1bb1cd1 ("KVM: arm64: Introduce MTE VM feature")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
[maz: commit message tidy-up]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221027120945.29679-1-ryan.roberts@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/hyp/exception.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -13,6 +13,7 @@
 #include <hyp/adjust_pc.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
 
 #if !defined (__KVM_NVHE_HYPERVISOR__) && !defined (__KVM_VHE_HYPERVISOR__)
 #error Hypervisor code only!
@@ -115,7 +116,7 @@ static void enter_exception64(struct kvm
 	new |= (old & PSR_C_BIT);
 	new |= (old & PSR_V_BIT);
 
-	if (kvm_has_mte(vcpu->kvm))
+	if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))
 		new |= PSR_TCO_BIT;
 
 	new |= (old & PSR_DIT_BIT);


