Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063482;
	b=z3EAHcFQ3He2XVtvavvjoLKNms47P8DSUILtN+FZa9g/7B9v9WPw4qbmA1Nr+lbACLdP
	 ftUNS1npXigqfbY5+ZwVzsAmPefG+wDrm/ato7hsti+pMSYZSPXZr4P07ZLRmKVo0BC73
	 KclG1QP9TjCkuNqom3wcmrKSSDb1rwUfxaRZ2WA9dV3eHPs/qVYzBCQdHQX5R+97UBxY7
	 wFqIR4Y4RhXIjTKT4u9nmJ/B6F1myLYv+CaCbbgAcGVbo/vIRQCsMTXHnJn9edZQtelqr
	 QtmRfqTw1PMb+EoUxiCd+mmyvhxTtFUjX8lP/IztFkJE0IhKhzD3RTttq9+seO0Esjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PNTtMMQYUgZJOrR3WcvU2YKfht0cQN3vKF+3x/Ys3Ds=;
	b=BJzKLx36SyDl5AJbmpBixDCFNtda5ZwCfisaA/kzw+PY1Gy9oOXlfCsqi3iDW4NZYoxx
	 DBMJ3CP3G7FhmcEeTsfVp1U5QFuRGEnz/t6c0HG7fCuTkSff7Rb6s6oxzzPs6LmIuwY9s
	 ci25TQBb9xr4vFdjgU/NqPWMymCbNl4FQMLeVpBekubAPJxxvw6kPlDDR3kFGx7hPnFlR
	 5eQHsZgWOJ4OZ1WU19CqrpnYXCX8sxXdQ7Nmb0nz5afbvkUEyycUhAa82L46aIRrLTQl6
	 psuWJT2aUchr0UoysoDVD7ncDEqj1HZpKzUCOBzf5QtYZM0+Ot2ihcEjevNh8lFLpog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="a07/g0pF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442DA606A9DA;
	Sat,  7 Nov 2026 14:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a07/g0pF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50371F008A5;
	Sat,  7 Nov 2026 14:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063481;
	bh=PNTtMMQYUgZJOrR3WcvU2YKfht0cQN3vKF+3x/Ys3Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a07/g0pFQwhxMKEz8CMwtewAYO4ANnSBTr0AO2Y0rHVujzhcql8BkMZoG+wkRTuAU
	 YNacsicO2+leY8qrlKFLvb+2MWJzWQb11VbfqEA3A1ms+IScDmTmI9OP7Pc/K9Qh2f
	 N1AqZJnNSg/H1F6aOQ9kNWcDstYNeJnnMAqmwM1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 629/869] alpha: fix the local TLB invalidate in flush_tlb_page()
Date: Sat,  7 Nov 2026 08:55:11 -0500
Message-ID: <20261107134914.314353170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit 32f4dd420d626f96128fcfeea2ab24760b4f21a6 ]

flush_tlb_page() invalidates the calling CPU itself before asking the
others, and gates that on current->active_mm. For a non-executable vma
that means a targeted tbi(2, addr), which acts on the context currently
loaded and is only guaranteed to invalidate the intended translations
when the target mm's context is the loaded one. A lazy active_mm does
not establish that, so as in ipi_flush_tlb_page() the target mm's stale
translations can survive, and nothing forces the old ASN to be retired
afterwards.

Test current->mm instead. A lazy caller then takes the flush_tlb_other()
branch added by the previous patch, retiring its local context. Adding
that branch first preserves the local invalidate at every step, including
on EV7 where a targeted tbi() against a foreign ASN appeared to work.

Which callers reach here with a foreign mm depends on the configuration.
folio_mkclean(), from the writeback flusher kworker that has no mm of its
own, accounted for about half the calls during writeback of a shared
mapping and none at all on anonymous memory. Those counts were measured
with CONFIG_COMPACTION=n: with COMPACTION=y, asm/pgtable.h overrides
ptep_clear_flush() to call migrate_flush_tlb_page(), which rendezvouses
with every CPU and handles the context itself, so folio_mkclean() does
not reach this function.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-6-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index e4ba0aab8a669..a5a42ae4a7d80 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -684,7 +684,8 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 
 	preempt_disable();
 
-	if (mm == current->active_mm) {
+	/* As in ipi_flush_tlb_page(): a targeted tbi() needs MM current.  */
+	if (mm == current->mm) {
 		flush_tlb_current_page(mm, vma, addr);
 		if (atomic_read(&mm->mm_users) <= 1) {
 			int cpu, this_cpu = smp_processor_id();
-- 
2.53.0



