Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D9B2F39
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421C4C433D2;
	Tue,  7 Feb 2023 13:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775285;
	bh=9GJdinjANYFCzCmhoC+afbNe+2RjdAv0oZ3PI/E+JV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9BHXzlofoQRly432gjj04s1i9XfQ4gF2dpahQj6IHQUgQtaCyi1exMkQSdDQzFk8
	 MJFvo1A+0BJ+sdaRblI2vPspOkbjCrTHQwHBBeEjmobmJolSHGR/9EPXTP3aF+IJHg
	 x4oURyCKAQD5TktYJ0vfWQb8oohYJ2xLdWvsosrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 198/208] powerpc/64s: Fix local irq disable when PMIs are disabled
Date: Tue,  7 Feb 2023 13:57:32 +0100
Message-Id: <20230207125643.463143801@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicholas Piggin <npiggin@gmail.com>

commit bc88ef663265676419555df2dc469a471c0add31 upstream.

When PMI interrupts are soft-masked, local_irq_save() will clear the PMI
mask bit, allowing PMIs in and causing a race condition. This causes a
deadlock in native_hpte_insert via hash_preload, which depends on PMIs
being disabled since commit 8b91cee5eadd ("powerpc/64s/hash: Make hash
faults work in NMI context"). native_hpte_insert calls local_irq_save().
It's possible the lpar hash code is also affected when tracing is
enabled because __trace_hcall_entry() calls local_irq_save().

Fix this by making arch_local_irq_save() _or_ the IRQS_DISABLED bit into
the mask.

This was found with the stress_hpt option with a kbuild workload running
together with `perf record -g`.

Fixes: f442d004806e ("powerpc/64s: Add support to mask perf interrupts and replay them")
Fixes: 8b91cee5eadd ("powerpc/64s/hash: Make hash faults work in NMI context")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
[mpe: Just take the fix without the new warning]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230121095352.2823517-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/hw_irq.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index 77fa88c2aed0..0b7d01d408ac 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -192,7 +192,7 @@ static inline void arch_local_irq_enable(void)
 
 static inline unsigned long arch_local_irq_save(void)
 {
-	return irq_soft_mask_set_return(IRQS_DISABLED);
+	return irq_soft_mask_or_return(IRQS_DISABLED);
 }
 
 static inline bool arch_irqs_disabled_flags(unsigned long flags)
-- 
2.39.1



