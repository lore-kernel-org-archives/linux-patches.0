Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7CB1B3927;
	Mon, 10 Mar 2025 17:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628253; cv=none; b=TkRUMNQt/WrtZl80o80DQk4mxlrAbSn/AkIoF29zYjXeC7g7wnR+IWOvI0MMqbmo2lrw4eVTuwnQTYyQAD7Qpvv4IyojjlGPQEjfPErkuf0iBd7G1cfrBD0IYOoCjeHHom5I8kGsfpdyeqm+JD82R8I0YNn35Bf9XNBTjFYG3UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628253; c=relaxed/simple;
	bh=Y/gHGP/cpJOCeXGKdmpmpzlht57NTNhChzP59BHOn4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1Lb+vZcqCS/p4yREJ43jLu8iGzl9BAD2AlEW6xmlFpCaB4Rab5/Viz361PNhe1LbaHQy/eLZA3OlDnU0SYfmwviIfx+Yiy7h9xndCflvsGfZbxtd/HrcHOzYocREaZIR8tBJIf64iS6adKaJIzqaBI1X/EcW7ghnHnHx/dQfl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxkklIQ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxkklIQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4582DC4CEE5;
	Mon, 10 Mar 2025 17:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628253;
	bh=Y/gHGP/cpJOCeXGKdmpmpzlht57NTNhChzP59BHOn4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxkklIQ1YS+5RrIVWiEIIuBE1Q9SCQXMUxZP1FDu63qnGR/ntXXmQbH1AJEUhEk5+
	 AmmLjM1aJ3EPEfN3U+ZjHvnudNf3duqDLEn/nAr4Y87piSq6Okzzf/wYqCddNe/A3R
	 FqJb8P0jhs0QqmAIHdkTQ9V59OHxHudgOnwmn2aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.6 133/145] Revert "KVM: e500: always restore irqs"
Date: Mon, 10 Mar 2025 18:07:07 +0100
Message-ID: <20250310170440.128564740@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit b9d93eda1214985d1b3d00a0f9d4306282a5b189 which is
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
 


