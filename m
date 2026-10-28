Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217326;
	b=ZcJYao9/i7HZAn+Hu97TJbkTRqs1K4HRDDNGZ00TUB8VfSWf38wlFEo5I9Plcj677eR7
	 ANvv/bS1zI+TcQZl32rYKrnhu3FLra3nhEM1lxgVuoGGH8dczUhiIUSVR+r7PDVpxsUHJ
	 pZH92HmdNLhXFB+BOQN4CwQvOhLaMvBNSdy06Yk1rq5E+Ey1AaG7HTuM2N449q+9t27cB
	 V4KY3zGtTFWNMpceI9oMmvyMwZip73SPrs/37N9a9djJvoM6NtlZEbRv9F0rTlOkuw3G4
	 bZnEe1E5bUsXfWys+g6wxhWwkXGFVYCLsDeEfoJl2xQJrd3rOlQYmPP/pNN+GOQ8fuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qbI3JsjYLoGPlQiiZoBRCt+KsdOXzXhRrcb1CVMcnYY=;
	b=3pnrelRLglv1H5uOHxb+YE0ULKffG80vfoxWyK9VHKB6CEvd0oAiqVZKCWM/aOH+tiVy
	 G8IK1EHcbQYxY8KVQLmDe4wVpMMgLKAfoM0KYOLEKRKNYN4SzjF4M4HwdLdRNV6daeu78
	 CPjKJy46Id34vX6b/XFJY2FAKzRHmch3JZ87I/3Hjgdw6tr3mGDMPGRsVi4ji8mgKgzn6
	 rVBxEc1Eogf4WQjHYNGKWIITbHnLxx7foqv13c06RGachCzdnS/9/ZEts8lxFAQvuoolK
	 TPtQM7s4bVXLovtBFoBm781752PBgQJ6JwC4mgazpS+YDkH00OygIng5AdcpMk1Pc3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJWwNyyw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D113606A31A;
	Wed, 28 Oct 2026 19:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qJWwNyyw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440CC1F01825;
	Wed, 28 Oct 2026 19:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217325;
	bh=qbI3JsjYLoGPlQiiZoBRCt+KsdOXzXhRrcb1CVMcnYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qJWwNyyweJU2jIAK6pDv+wZeWXapMaLh7p6SKDXakKCut0ah0PlJDXC4hOvki0NBJ
	 J/R+zVOMGNlSpNLPdAIDntrQQ1QQEDIFAxfXQu7Ot0QfsI7aTfrabh+p0rSLBQHNEV
	 diK0yoo5UcMedWAhLy+4cRSYRMZlTEWbSJ21kZNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1864/1887] alpha: do not clear remote MMU contexts in migrate_flush_tlb_page()
Date: Wed, 28 Oct 2026 18:06:00 +0100
Message-ID: <20261028170541.871105098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

[ Upstream commit 16266d50c51eb5eb98f1c345c5aa9ff359a305aa ]

After the on_each_cpu() rendezvous, migrate_flush_tlb_page() walks the
other CPUs and zeroes their mm->context[cpu] when mm_users is at most one,
described as mimicking flush_tlb_mm()'s mm_users<=1 optimization.

It is not one. flush_tlb_mm() tests mm_users before deciding whether to
send the IPIs; here every CPU has already been visited and waited for, so
nothing is saved. The callback has also just set each CPU's own slot
correctly, so the loop only overwrites it, and does so while that CPU may
still be running in the address space.

Remove it. The shootdown shortcuts in flush_tlb_mm(), flush_tlb_page()
and flush_icache_user_page() clear remote slots too; once the next patch
removes those as well, every runtime update of mm->context[cpu] is made by
CPU cpu itself. That patch relies on the invariant when it reads those
slots to decide whether a shootdown can be skipped, so this one is tagged
for stable as its prerequisite.

Fixes: dd5712f3379c ("alpha: fix user-space corruption during memory compaction")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010144621.974850-2-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/mm/tlbflush.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/arch/alpha/mm/tlbflush.c b/arch/alpha/mm/tlbflush.c
index ccbc317b9a348..239c72b8a7412 100644
--- a/arch/alpha/mm/tlbflush.c
+++ b/arch/alpha/mm/tlbflush.c
@@ -90,22 +90,6 @@ void migrate_flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 	 */
 	preempt_disable();
 	on_each_cpu(ipi_flush_mm_and_page, &d, 1);
-
-	/*
-	 * mimic flush_tlb_mm()'s mm_users<=1 optimization.
-	 */
-	if (atomic_read(&mm->mm_users) <= 1) {
-
-		int cpu, this_cpu;
-		this_cpu = smp_processor_id();
-
-		for (cpu = 0; cpu < NR_CPUS; cpu++) {
-			if (!cpu_online(cpu) || cpu == this_cpu)
-				continue;
-			if (READ_ONCE(mm->context[cpu]))
-				WRITE_ONCE(mm->context[cpu], 0);
-		}
-	}
 	preempt_enable();
 }
 
-- 
2.53.0



