Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F7C1802AB;
	Fri, 27 Sep 2024 12:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440314; cv=none; b=R3QFJvrzykAhxDrX2jas2NXD9i/TrkCYuMN1PJFXLVD984XMRmJqQFA81T+1zukl/cQ0oAIA7BqY+rEm5a2WTCokxhj2ILwAh9In5mML6UsFmJwf3czzsO7IsViWA3UN4ySiJDhchOy2uebql369hlXVdnUux59mkgI+5GMwBa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440314; c=relaxed/simple;
	bh=thLzb6kuaS2+OuHhD2FEn0w7HPKTQobgcLQy1uiQ6Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADMQctLtvl8caFNDhpUQQnqpAGjS6fJSLpt39cQDbng1/maQCuPGXXI342fo2WemUPXriut/MwB9WQfrL7YvzI544ZQakNY9l2kTS/+BK28WZnOa2S4QSE6r1Ezw0UFaRHwkZF0zOTyi7+8Kq2+MHhT+G6r9pkbZapWe40r3Ii4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leWNWVrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leWNWVrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65513C4CEC4;
	Fri, 27 Sep 2024 12:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440314;
	bh=thLzb6kuaS2+OuHhD2FEn0w7HPKTQobgcLQy1uiQ6Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leWNWVrzyhEFYi8SDQOnyzJ5E8dzOAkV1IIfl0FOaxq4YfXYF/35WOGTVjdpCz4gG
	 IzpjFBGox40UmHSnZCpVbiWZeWlaP0cVv8Y7ykGbO200wCe1vQ2/ow4CxupBsFHd4f
	 zjgJ9k9HLP2jp1uA3Oj0EAHtpE0NZhcigCP0Hsls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Tianyang Zhang <zhangtianyang@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 11/73] LoongArch: Define ARCH_IRQ_INIT_FLAGS as IRQ_NOPROBE
Date: Fri, 27 Sep 2024 14:23:22 +0200
Message-ID: <20240927121720.323285468@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0524bf1169b74..4496649c9e68b 100644
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



