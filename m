Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BC71DFD80;
	Wed, 19 Feb 2025 09:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956826; cv=none; b=U+Z2kldorWV8CLeD9AJJkjFLRmvMERe2DtSNKWq24BURE1iUGQ8O2UZTrs7hZnrLgzUR7tIfObYyZNHK0+08afUPqkg6wNy3JdvzgwJ5r+LBHOcLujGp5LvaioaqV7neJZW41t/5Y+IFKkFO2VBRfjKRQQ5jU+CwDg8YUgA2hH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956826; c=relaxed/simple;
	bh=Tr0pPzbNC6Nk8NbwW9qRdfLqdHhlJASfK52zbW/TOKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7l2/gP5olVR/O/PGx69qdD6l9r2/js28jJdm6cOsdOLTJUTbI/XMn/FFWvnQMkOoQtvUenmptBBbVMyz2EmUB59p7tfJqXrMlCJjxlUpu2jJQdOCznxlljTNhziP4hxattdtSwws7EfDIOvi5Yd/DZMZQ05omMhFIAsY0sY9Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJCWDVbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJCWDVbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A045CC4CED1;
	Wed, 19 Feb 2025 09:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956826;
	bh=Tr0pPzbNC6Nk8NbwW9qRdfLqdHhlJASfK52zbW/TOKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJCWDVbG0UHR2HoqKl2OEq5KMwdT66LG8oqiOZVHwBJLkcwp3Uz7qbgf0lJanbT4i
	 apOkeodM6rRouBPtw/gLfjw/TKNdVNrVCJQT7gFlhNYubvK6JJWlUMeHl27cHvjjaW
	 S3Fo1wPuBqt3JJopTUzdRKqvioDL16ZjcYkkOLOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 312/578] KVM: e500: always restore irqs
Date: Wed, 19 Feb 2025 09:25:16 +0100
Message-ID: <20250219082705.290836835@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 87ecfdbc699cc95fac73291b52650283ddcf929d ]

If find_linux_pte fails, IRQs will not be restored.  This is unlikely
to happen in practice since it would have been reported as hanging
hosts, but it should of course be fixed anyway.

Cc: stable@vger.kernel.org
Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/e500_mmu_host.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 3907922b6a8a2..138fe5eb3801f 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -479,7 +479,6 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 		if (pte_present(pte)) {
 			wimg = (pte_val(pte) >> PTE_WIMGE_SHIFT) &
 				MAS2_WIMGE_MASK;
-			local_irq_restore(flags);
 		} else {
 			local_irq_restore(flags);
 			pr_err_ratelimited("%s: pte not present: gfn %lx,pfn %lx\n",
@@ -488,8 +487,9 @@ static inline int kvmppc_e500_shadow_map(struct kvmppc_vcpu_e500 *vcpu_e500,
 			goto out;
 		}
 	}
-	writable = kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
+	local_irq_restore(flags);
 
+	writable = kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
 
-- 
2.39.5



