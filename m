Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036694;
	b=JQ2k9y/XsEb1qBxrzKMtQCu20jEKxCPMONKbVyeD/WT+mK2ZNKypfyogkKvjuki793Qk
	 ya8eh7RSB5ZeXRWQ62UJzliASzryrWBzY8sJJvivYqtddi2Athsun/vgHCQp3PyzIkPIG
	 Ry8dr4JDMAHdZd/XHiYoQW9iJ2mFdRVZIPN05Toj6o34zaXeQP1HykW/y+tlSNm0Z8zJ0
	 n5geTxhsbeFhS1L7WeOyagYOlJNuDLSHpjvyn1NcRfjAWpPDU84+0F7tK+TcgwBItppG8
	 sk67EIvFkcix+i5nSvQP5QiZ4ccMRwTEFAh20SVJLNnpCd+rdBEsmcJujujzYLFOcvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7hdvp0Wx8Qy2iBJSe0vVnz5uEmYnCHNW8kCbHFBky9A=;
	b=1BU/mS7lA7D7AZzLWK7XuzRoUNBErGthgHRQFO0frf8h0zD1jNkzgPr4GUxHJ9RQq+vx
	 pXiKQLw4iKpJeeJDW8NrFW1yM6IvH5WIvC5g9zHfQ34v9hzeduoQVHF3p+HEJwdFusrLy
	 kZBy2oRcDiWZBQV7n0ZRp9lzttFiVhyoWtx6mzlXdoAJFjWXcAkvd7SxECvJN5oaVS1nn
	 WPTihKHocf8VrlHfriVdv/JO2E9Me3ZC0vUxpzkb+979XfKxMn2lQ234+egEcji/AvU32
	 yafirnyuUJU5jxSOqL9r+kATYtz3irqHjH0DWhvo9HIZTmGeOxBc1S9RVASx/Gmto6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eag0CvVV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F96F606A320;
	Wed, 18 Nov 2026 21:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eag0CvVV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5D61F000C8;
	Wed, 18 Nov 2026 21:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036694;
	bh=7hdvp0Wx8Qy2iBJSe0vVnz5uEmYnCHNW8kCbHFBky9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eag0CvVVpkK8MfB8kEhRWr27MjX9IpUbzyZ+5JoHQjEZ10GQaNz2T4xfgDseMoNyo
	 6fyVsp0Uym8CJvEAfczou1/zJ8p/79pwTJ0/HTVoC1IJKS53sS5RXwHuziwCrJ1+Jk
	 Tq916csDLTTLlHBmiQjPBAld3kHQogoMJTIOGbOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1149/3318] alpha: fix the local TLB invalidate in flush_tlb_page()
Date: Wed, 18 Nov 2026 15:29:31 +0100
Message-ID: <20261118150354.556310360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9fa165df035dc..be463ed9a3fb0 100644
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



