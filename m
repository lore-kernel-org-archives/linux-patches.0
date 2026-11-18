Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045600;
	b=AH122nP0XEUNe7z0VbLDNMH1B02PCPRKNZwo5c2/BA6E67tf8jtSss9139riHfHCELWd
	 olElO6CbfSApge/jIwQ1zjfzw1qiPAu7pnEShcf86YUZxxAUuNAu6t7RqSX5nqrRJ4tbk
	 YPFnFdP5mRmxadgSCiubfarzu8sFbEZH6soZJNVOREFTIcmev1x/38cN5M1pUkUtVwqdi
	 hCYJDXXJUx6NylaCwrPv22trjREbQz3YyTE4LtMfBW8WDldMHQ9Lf+2gyC1B1XFT3SaLe
	 D1Q+fAvWgL3epnN2BFypUqtM4CmnnmNRUs6n4Y6VuuhHpcQ/wAZsRDoc1Jp7QVDBjRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uCOqBPl/PVaSKvzf6v/GTOax9GWC6m9NgT92SSxNh6Q=;
	b=UBUKqBLkykRe4bjmoGt7VavhJRaF+73lN4LCg53tBcYATB3z0qNpu1anE6wRdpiexHxM
	 SYhSDBXQSJzyWjvT7/JKCNcy7WaSi9DabgVml9rXNW1J7QSTEwSbTGGJUC3I+6MKCXEM6
	 HUJiBn+BJl07N2BPGbr/wPz3XvQii2wl469M813eGcmN3eXst0b55ojULkNqgiZNGYjRy
	 Lrn0HXupiUofYHxjpVGvrUVICb5V4+Wduyolbt0vtCrLVQpRpRoFXTfXueGlm5T7ETimU
	 S2gL5Eh77Zo7ZWuktkFmkuzRut8p26skHd8CnxcrEJJf8wLnaAOygkZe9Fx1cgAbBAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IMrlP/PY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA486606A31C;
	Wed, 18 Nov 2026 23:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IMrlP/PY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF631F000C4;
	Wed, 18 Nov 2026 23:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045599;
	bh=uCOqBPl/PVaSKvzf6v/GTOax9GWC6m9NgT92SSxNh6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IMrlP/PYAsg4FPkd7sEIUhi0Fly8ob25xzFZWIzPF46nvbJccPtMtEPGLA76aj0PW
	 aqdyyjA6yjviYk/Ak1h6YdY809kLX7CgE/ES3XT3EAwvOS6kqmWcfy7sydCVZduRSD
	 JvIU1TsuZ2cNnvDrbhFf9FhPw36QXS99cxXfP6UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0980/2857] alpha: fix the local TLB invalidate in flush_tlb_page()
Date: Wed, 18 Nov 2026 15:33:34 +0100
Message-ID: <20261118150236.890224113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4aee15f99b66e..1c2536d5fb9ff 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -688,7 +688,8 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 
 	preempt_disable();
 
-	if (mm == current->active_mm) {
+	/* As in ipi_flush_tlb_page(): a targeted tbi() needs MM current.  */
+	if (mm == current->mm) {
 		flush_tlb_current_page(mm, vma, addr);
 		if (atomic_read(&mm->mm_users) <= 1) {
 			int cpu, this_cpu = smp_processor_id();
-- 
2.53.0



