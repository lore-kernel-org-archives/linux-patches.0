Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C197226B098;
	Thu, 13 Feb 2025 15:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460247; cv=none; b=KPmDwwpe7dzq5LH2R10PAuKwLqAPcMiW9axK3vjJz+5jA9kHHjyfFTAJlSxWocL1nLsI3HJRkWUiEQOBlpCDs8K0wskpqApFONuVlraFZEYzzzl4sGvLutR8Qc8jWsGNVjQa5NY7si+OA7gh/o+P4z+1jKLOGywfzX9soL3Jr9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460247; c=relaxed/simple;
	bh=xJFYKNgpfCc7zUzfHIzxOR0cGFqL9ful17e+gw21cy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wp6+MB94QGNcZ/3xsHFSija2PB6dcI1/VHGrxUmBRqzs5IzdV3AdQ1JaegM8jD05gZdqIFQcGPpyC5DiA0MjqOFc88Cw4jOwhn0Pu7IX1kzjv9cZpdw1zwH11doJjJZb1hQJczq9wDzXjwgRxSVp6in+ME0BSgl5I5+319UOFCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6cYeCjq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6cYeCjq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31129C4CED1;
	Thu, 13 Feb 2025 15:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460247;
	bh=xJFYKNgpfCc7zUzfHIzxOR0cGFqL9ful17e+gw21cy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6cYeCjqlJ85CAo4x0TC60RYEctEQILyejH4UiprxvXiBK+c4VfoN1L+xZ7+dzxde
	 ObXJz8JNBfwU0dVue10W0KrGa6y3lIzM7soTocAyft/EMcUV9jYLOrm1Y3fg+xfxfy
	 8q4EZ8jryBE+D2LRtJXHyXxpllrX1gSJcgKp0uiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/273] KVM: e500: always restore irqs
Date: Thu, 13 Feb 2025 15:27:09 +0100
Message-ID: <20250213142409.607163765@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1910a48679e52..bd413dafbaf96 100644
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



