Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036844;
	b=472AKFpcMQoro9Ky87tYRgwCZ3sVTq2365/U1Atq8LIP2adDmMYd91zDECq4G+LoemRR
	 X44eIykbEecdR85DVsAShLGjdCkZz/s+1yDTq69fmNcygTCjLGTHE7pcSyYqldwhNvxbW
	 esZyCriGrJGcfkXZ+vK8OieiBqXWCli7fh24mx/GVIAYj4zcZ9der4hyAbjkG9jY9w6rf
	 78eaqn/ikSn+xJ4hJQCLZ7vKcfsiTtZ4OHh5PfRGZG2GTlG+2GOaLS6gu6N9cz5zgMzbY
	 xlbHI/TgOvZs6ZLwloZI32WMTH++imYI32Z8AkRw7er4kry61LNbyYmlH38BaKWu6uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N7qd2ICcC4xiyUUQxy/Uawi0LCBr+VvFHLjdGj7rgr0=;
	b=k6EWScNiDlejJUHyB9Zc048MncQzQMEFRzyrNtchpBW4TvNwavavfAKY8hwy1a4th/Sp
	 /9LCcN6vlUlmTXZhA4Hqj6lZYG7/Iyrs7bFN/uBUOPHuzJtEmAGAIrvuVIoCSVDUe/tpd
	 GfSaP7Ge2C/tOzdQBsyj4eFR9YnAMl0ie/tv+BFBrbPW4hDdNACzi1FoP54GhjU0Sdgze
	 2EfUAtunRfJ1Vy5EEhLDh5u6eVI/nd6Eu5BBl9kouctL9Ag02YdkoFB792yH//A66JP/6
	 k9+jqyaVZ8Ib7X+/MpewgfpMPyzlj8M6P0Jz1jNsPtA21Z41dPvfklOciZQBxAo3X8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uya56Gbb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE335606A31C;
	Wed, 18 Nov 2026 21:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uya56Gbb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4FF1F000C4;
	Wed, 18 Nov 2026 21:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036844;
	bh=N7qd2ICcC4xiyUUQxy/Uawi0LCBr+VvFHLjdGj7rgr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uya56Gbb2ELkR/kHEuXTQgPRvgpbLsriPsxsmH1odqhoI9HU8Yv7T6U5mcl/V2e6c
	 //qtQWXH/plOGpWtlSBHqeJvCvBbB7+JgtGfRjD71P0S62wArRJ6BJqR6i7AkjS6wc
	 +J3p/ZXCAf6GiUcxFbY7GyPRxNliG15j+d9tcU/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1153/3318] alpha: do not clear remote MMU contexts in migrate_flush_tlb_page()
Date: Wed, 18 Nov 2026 15:29:35 +0100
Message-ID: <20261118150354.685402832@linuxfoundation.org>
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



