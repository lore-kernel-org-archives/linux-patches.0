Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F781779BD;
	Fri, 27 Sep 2024 12:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439892; cv=none; b=o2Q1tw8MSZuPhy7wuml19bGf/6XwoRVZE8gHFPbzbvNaQEtVXAv9sIJeMPfqydbihc/m+lNyfFdRNZashS4U0enU8imRjHFckyBjYClCStq6B+wL/Rq1EyyLZk3eeYGOaAp8awkaR84pzEJrEcO3i9DVhJ4sT5noGJ7uWkop4cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439892; c=relaxed/simple;
	bh=7asTXdZQTnmY3uG77tR9Altm7ZV97hGWLnUpuRQpNKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUY737v/TqsLSQy/lA0UNjzND2iBhHnrrAm/KE0xs+CSIB7fdah1U0xM4561xWSOhh8K0LJ1Yt4jcqSRRgFrSj3uRkz6B/nlw734qQ2Bk0u3Aoq/IQaht+zYdyb+va/ExvRuUnXt/7y1BU1G4g0Chx2DCDCxvlu6QFN6zIwmE2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxxYP9YM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxxYP9YM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368ACC4CEC4;
	Fri, 27 Sep 2024 12:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439891;
	bh=7asTXdZQTnmY3uG77tR9Altm7ZV97hGWLnUpuRQpNKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxxYP9YMGqq8yBHKq5jl3j/gENaRHmSP7b54e4maWCwkFxZ64ZZ0aUMRhf2L3KfYe
	 YiYa9kg+8QKUI6dgjms/9gFvLRtKTUj1w6LqPFLMxcGOp6Fnf4FwscOd6sS1avlsLC
	 raonnCeJxNYtHL1FXEgsPsPNP25Z5Oapr4TeuQF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 13/54] LoongArch: Define ARCH_IRQ_INIT_FLAGS as IRQ_NOPROBE
Date: Fri, 27 Sep 2024 14:23:05 +0200
Message-ID: <20240927121720.243238986@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 274ea3563e5ab9f468c15bfb9d2492803a66d9be ]

Currently we call irq_set_noprobe() in a loop for all IRQs, but indeed
it only works for IRQs below NR_IRQS_LEGACY because at init_IRQ() only
legacy interrupts have been allocated.

Instead, we can define ARCH_IRQ_INIT_FLAGS as IRQ_NOPROBE in asm/hwirq.h
and the core will automatically set the flag for all interrupts.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Tianyang Zhang <zhangtianyang@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/hw_irq.h | 2 ++
 arch/loongarch/kernel/irq.c         | 3 ---
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/include/asm/hw_irq.h b/arch/loongarch/include/asm/hw_irq.h
index af4f4e8fbd858..8156ffb674159 100644
--- a/arch/loongarch/include/asm/hw_irq.h
+++ b/arch/loongarch/include/asm/hw_irq.h
@@ -9,6 +9,8 @@
 
 extern atomic_t irq_err_count;
 
+#define ARCH_IRQ_INIT_FLAGS	IRQ_NOPROBE
+
 /*
  * interrupt-retrigger: NOP for now. This may not be appropriate for all
  * machines, we'll see ...
diff --git a/arch/loongarch/kernel/irq.c b/arch/loongarch/kernel/irq.c
index 883e5066ae445..df42c063f6c43 100644
--- a/arch/loongarch/kernel/irq.c
+++ b/arch/loongarch/kernel/irq.c
@@ -122,9 +122,6 @@ void __init init_IRQ(void)
 		panic("IPI IRQ request failed\n");
 #endif
 
-	for (i = 0; i < NR_IRQS; i++)
-		irq_set_noprobe(i);
-
 	for_each_possible_cpu(i) {
 		page = alloc_pages_node(cpu_to_node(i), GFP_KERNEL, order);
 
-- 
2.43.0



