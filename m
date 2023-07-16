Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9C08F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC0BC433C7;
	Sun, 16 Jul 2023 20:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540282;
	bh=RAaRnQrbxD4KQEd99SUWpbHGTAM330DqB2Gt85uMd7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1veqolRYNoEzic/CaadMz6MNV6cplqdMuiLuKRNs0Cp0DJTNjxoAWmmtHzzUqGHyV
	 EaYUNhlcbQJ8lu+fdy7DjI6FirnTOmDEbyk+XHj2xDNJrYUBxwubBYWQMPlarpomJn
	 hzoj8KDRI7BE3qVfVRIQTrZv0isYQuwCxtmHeoo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 307/591] powerpc/interrupt: Dont read MSR from interrupt_exit_kernel_prepare()
Date: Sun, 16 Jul 2023 21:47:26 +0200
Message-ID: <20230716194931.835333542@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 0eb089a72fda3f7969e6277804bde75dc1474a14 ]

A disassembly of interrupt_exit_kernel_prepare() shows a useless read
of MSR register. This is shown by r9 being re-used immediately without
doing anything with the value read.

  c000e0e0:       60 00 00 00     nop
  c000e0e4:       7d 3a c2 a6     mfmd_ap r9
  c000e0e8:       7d 20 00 a6     mfmsr   r9
  c000e0ec:       7c 51 13 a6     mtspr   81,r2
  c000e0f0:       81 3f 00 84     lwz     r9,132(r31)
  c000e0f4:       71 29 80 00     andi.   r9,r9,32768

This is due to the use of local_irq_save(). The flags read by
local_irq_save() are never used, use local_irq_disable() instead.

Fixes: 13799748b957 ("powerpc/64: use interrupt restart table to speed up return from interrupt")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/df36c6205ab64326fb1b991993c82057e92ace2f.1685955214.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/interrupt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/interrupt.c b/arch/powerpc/kernel/interrupt.c
index 0ec1581619db5..cf770d86c03c6 100644
--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -368,7 +368,6 @@ void preempt_schedule_irq(void);
 
 notrace unsigned long interrupt_exit_kernel_prepare(struct pt_regs *regs)
 {
-	unsigned long flags;
 	unsigned long ret = 0;
 	unsigned long kuap;
 	bool stack_store = read_thread_flags() & _TIF_EMULATE_STACK_STORE;
@@ -392,7 +391,7 @@ notrace unsigned long interrupt_exit_kernel_prepare(struct pt_regs *regs)
 
 	kuap = kuap_get_and_assert_locked();
 
-	local_irq_save(flags);
+	local_irq_disable();
 
 	if (!arch_irq_disabled_regs(regs)) {
 		/* Returning to a kernel context with local irqs enabled. */
-- 
2.39.2



