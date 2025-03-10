Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE4222FF40;
	Mon, 10 Mar 2025 17:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627821; cv=none; b=MrMAbw0c20GyeW3M3yit5hVapVwOKMhAx2IFXw4ayi1jUDYUi0LSC4FrToVdZh49RxcgIpQqoxccVpx4tIPun3vn2uqJJWYXtOeIrmXgq7bhC3vSDOn6/tFEJa8fZuBDwOSH26C5b5PzhcKGwDaYdwqb6MU/xhqgRSf0wXxB0YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627821; c=relaxed/simple;
	bh=brZ+4QDxui++X6yM7GlxtHUXhuJ84zIsTDiePF58LOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZieyNylw8fw6XfGJesKdCT6xoNHlosRglRH8FNcHYtcUaWg3RxZodUkJHmgYTmRmDPHlAWl/eNg1nPPiiIq4ZfJykdle+/RpoCYWBCdANXbTgEoKhhcHX0Tr5YhjzfvhiV4OvKUT10VL1fNKocciijb2mANRVWyjOYHo2aX12LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1uwODsTG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1uwODsTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE87C4CEE5;
	Mon, 10 Mar 2025 17:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627821;
	bh=brZ+4QDxui++X6yM7GlxtHUXhuJ84zIsTDiePF58LOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1uwODsTGZVFwvVWt9OwXwkIEeQvyDuOTG6atA34oQArh/KkcfstjdNE072HcdWtmz
	 N4zI+dVFfCHLgkIjn3tJkiAmV8wEotLFsQnqIsbzASSQTygPl4oAZ66C1kh364GvYH
	 VDWk4r4QfvzcY5b9IF3WtIOAHjJPXqkxkKGCgkJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 262/269] Revert "KVM: e500: always restore irqs"
Date: Mon, 10 Mar 2025 18:06:55 +0100
Message-ID: <20250310170508.233002474@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 48fe216d7db6b651972c1c1d8e3180cd699971b0 which is
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
 


