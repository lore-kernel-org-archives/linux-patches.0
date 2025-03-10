Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FB3232786;
	Mon, 10 Mar 2025 17:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627832; cv=none; b=bqfNPwxrQQKmIr3yoze9LekjG8774DXnra7R6uc9gkbRcUkTeacpxJ6O1EArQCNAfsm2IvmaHx6CFKzFQYlPtZmZ/XC8ZTIFn7BaTi8QuVDSJ6SWZztAUTROj00A6hQ+2+tHKILNulqbdWtAs2IY+28vpVFomMrl+21lYb2d6lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627832; c=relaxed/simple;
	bh=UiiLWJnaAq/JaffZ0Db3lhw07iFOYna8FdQcn74a5CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzKGECTjt2NGOkuh0nnTG6rU+erouTtzljCy+bHJDmKxaflUyA0xf9jzm39h68Tw/0aZCCDXDIbSNmPjKErR8V8u1v44qXrKrRFHZirqzYANfCUpONQihHoeWWBFfqdxS+/Byb8d4QeUx1K0vzJ5d53AXCb7LspHdnZeiSlJHJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rL5BbHFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rL5BbHFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5103FC4CEE5;
	Mon, 10 Mar 2025 17:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627832;
	bh=UiiLWJnaAq/JaffZ0Db3lhw07iFOYna8FdQcn74a5CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rL5BbHFz1iItTTsiAYYgGIqKGpZUr6BXSIZBX+Rr5CKc2L+DOUxd06PbY03+XGktN
	 19fmFbnlIHxKPPDn6mnm0dv7bQARCb+r5yTTncTPDvnYTl/I7pcF+9Ds8T6AHAxScS
	 ujI3+hDJSxOwjmk7/LDq1VSPc3+8pJzwuhF+CF/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 266/269] KVM: e500: always restore irqs
Date: Mon, 10 Mar 2025 18:06:59 +0100
Message-ID: <20250310170508.390540199@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

commit 87ecfdbc699cc95fac73291b52650283ddcf929d upstream.

If find_linux_pte fails, IRQs will not be restored.  This is unlikely
to happen in practice since it would have been reported as hanging
hosts, but it should of course be fixed anyway.

Cc: stable@vger.kernel.org
Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/e500_mmu_host.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -481,7 +481,6 @@ static inline int kvmppc_e500_shadow_map
 		if (pte_present(pte)) {
 			wimg = (pte_val(pte) >> PTE_WIMGE_SHIFT) &
 				MAS2_WIMGE_MASK;
-			local_irq_restore(flags);
 		} else {
 			local_irq_restore(flags);
 			pr_err_ratelimited("%s: pte not present: gfn %lx,pfn %lx\n",
@@ -490,8 +489,9 @@ static inline int kvmppc_e500_shadow_map
 			goto out;
 		}
 	}
-	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
+	local_irq_restore(flags);
 
+	kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
 


