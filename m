Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF4B22D4C3;
	Mon, 10 Mar 2025 17:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628604; cv=none; b=pVCUJwTvR+eZAzZyEkAbUhIGbVoCI0sxlPYZF8ghj6Y8iRQq2YeQyWuU5oSmaVQdTm1Vw43o+P2zWQYkxzFwRinlWKuIByGoweIPOVlTbLYAthsPjaYcBegPhC/XycwzOaNPhlXOkLO2lktbe3teAS8Zl8lc1brb2H5nzkxPmYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628604; c=relaxed/simple;
	bh=HbCgw1W2YJyKozWZg0yJrp7PrLEti144EFNpO6n+ES4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ku3CZwrUsQfULJSnMpPRGnlABIVGfXSstFymLyB+L1y5cCn66XWED+d1rX5jsAibuxpA7uBB1jZaqQOO94dDwXqylQXuHG1JlH7s6ZKCTk6GyG6NtB8cEnVu48tY54CnQE/a7xUKguKkdcfO57Vn0kpDg2nXlE/15MlxwnmVeaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbNJEDe5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbNJEDe5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2329C4CEE5;
	Mon, 10 Mar 2025 17:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628604;
	bh=HbCgw1W2YJyKozWZg0yJrp7PrLEti144EFNpO6n+ES4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbNJEDe5zO5k9ZfugV8g+RMEM/daLrZ4Q3UOq5OqYdYnoyxL98csxL6EtBfrySo3B
	 PDqm9VhUjn3QD6LXaKAvj6zfKR9hO7VGCZbzpUIn0peYT65cRYcellb4FCbENoh7D8
	 WZhnQKL96AxM3+Caci7l6nJXMnmoTmsz5fVfR+rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 093/109] Revert "KVM: e500: always restore irqs"
Date: Mon, 10 Mar 2025 18:07:17 +0100
Message-ID: <20250310170431.261157300@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit bce6adebc9c5c4d49ea6b4fcaa56ec590b9516a6 which is
commit 87ecfdbc699cc95fac73291b52650283ddcf929d upstream.

It should not have been applied.

Link: https://lore.kernel.org/r/CABgObfb5U9zwTQBPkPB=mKu-vMrRspPCm4wfxoQpB+SyAnb5WQ@mail.gmail.com
Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kvm/e500_mmu_host.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -479,6 +479,7 @@ static inline int kvmppc_e500_shadow_map
 		if (pte_present(pte)) {
 			wimg = (pte_val(pte) >> PTE_WIMGE_SHIFT) &
 				MAS2_WIMGE_MASK;
+			local_irq_restore(flags);
 		} else {
 			local_irq_restore(flags);
 			pr_err_ratelimited("%s: pte not present: gfn %lx,pfn %lx\n",
@@ -487,9 +488,8 @@ static inline int kvmppc_e500_shadow_map
 			goto out;
 		}
 	}
-	local_irq_restore(flags);
-
 	writable = kvmppc_e500_ref_setup(ref, gtlbe, pfn, wimg);
+
 	kvmppc_e500_setup_stlbe(&vcpu_e500->vcpu, gtlbe, tsize,
 				ref, gvaddr, stlbe);
 


