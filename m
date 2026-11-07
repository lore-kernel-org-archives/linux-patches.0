Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062443;
	b=pZSbUnrQax/dqWdzEf4EqP3rVvPQ0NeXS2RjvNR585OVmO9kwW9ed6mtbESFnWQEjtW6
	 yrqSLlejomNuVbbpPmSunMC8lKKQfKP8hgPjsLl4R1jAzW9B6T9LiIAxj4A6y8vP7niCZ
	 uK65uLdd73jkD7MQVg7EWin6tySAqU195W68QSzYu8XmFmTL0zHZhQF+DKbE4flIFouvX
	 g4jyEAlwdBGn1/fNMMWtS1+L7F02o79ajiib2gGP15XFOmftu86g3MKf4uWDiKdCJ0ky6
	 r2w7jZ3MNFLGvj9lnRi+s7Rvmux5qv7cMfuLxR5XLkSmCVNOzCV02P9l1rd+Md9Og6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vpHJUFjdk06l9ZiD57oMpBm+DruAU0AzOBIhfobE9dk=;
	b=roxPHaedZGuf03rMQUHeAERbAf7xKEh5XMO1fyjGoDO214war+ywE47gURv82frmMHcl
	 Z/05sdte4MaCb8hKD9qgZQmTyoEH5RDTxqcz0G6sL2g1xb075ZDsKYJCRQK0jhhvZN/AI
	 OMTD7EJliQZuRgiXqLC7jPC3MpZZ1ST/A4nxfllgvehx/FDyvsrlcwlzmQh4uwHu0DaRN
	 QxS4lmNSqWooP51J4/7eBm+s9/Fgoi+0REFUlm0iLolGcSt+nYs44UyZoaeOPZohe9E7U
	 oAqyBHC5P+h2n1D9vzZdmCzMKbgpM/KJ3IFtbvHxFEWrNezvcQUeBHzkhM+rSH6qeUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bF4jEerm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E98606D816;
	Sat,  7 Nov 2026 14:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bF4jEerm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F751F0089F;
	Sat,  7 Nov 2026 14:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062442;
	bh=vpHJUFjdk06l9ZiD57oMpBm+DruAU0AzOBIhfobE9dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bF4jEermE6cR3VD3wBRcWeIkv5xqZvUyxYX31YNi4RhF2cBWkyZrszaW6dIII6zZf
	 bxSGWw7mKavu50/pwRTxNve/sYbUo0CZs+FPQskkVVF4noCwuIUdoEHe9cyJsMKJ8Z
	 WcOEfK13aVsa1eEZv+hUDnVuQoLf3iQWH7NC3UPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1351/1536] alpha: do not clear remote MMU contexts in migrate_flush_tlb_page()
Date: Sat,  7 Nov 2026 08:56:07 -0500
Message-ID: <20261107135035.772842852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



