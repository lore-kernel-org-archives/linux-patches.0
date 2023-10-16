Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BA128E01
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYm9ooVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5749CC433C9;
	Mon, 16 Oct 2023 14:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697468187;
	bh=X+NSZ6BDVkYsFYBh6oyNxQSAGdMYv8jaUj4VHriCXhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYm9ooVSo4fCdaOGETeGpQNR6599Te/PYpInSXuItaAUJQiio/IPYUoa3UsMiMTxK
	 pQ5PdUMApAbdr3L86ZAgSRl6i0xknpQvuZC8EzdEhYocXKzRl3CJP3BgusQhAqaTLj
	 EZC0wCeNLIXgN1w95BsDRm6QrUs8qgpsMCJVOMQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Jiexun Wang <wangjiexun@tinylab.org>,
	Samuel Holland <samuel@sholland.org>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.5 172/191] RISC-V: Fix wrong use of CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK
Date: Mon, 16 Oct 2023 10:42:37 +0200
Message-ID: <20231016084019.390188715@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiexun Wang <wangjiexun@tinylab.org>

commit 07a27665754bf649b5de8e55c655e4d6837406be upstream.

If configuration options SOFTIRQ_ON_OWN_STACK and PREEMPT_RT
are enabled simultaneously under RISC-V architecture,
it will result in a compilation failure:

arch/riscv/kernel/irq.c:64:6: error: redefinition of 'do_softirq_own_stack'
   64 | void do_softirq_own_stack(void)
      |      ^~~~~~~~~~~~~~~~~~~~
In file included from ./arch/riscv/include/generated/asm/softirq_stack.h:1,
                 from arch/riscv/kernel/irq.c:15:
./include/asm-generic/softirq_stack.h:8:20: note: previous definition of 'do_softirq_own_stack' was here
    8 | static inline void do_softirq_own_stack(void)
      |                    ^~~~~~~~~~~~~~~~~~~~

After changing CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK to CONFIG_SOFTIRQ_ON_OWN_STACK,
compilation can be successful.

Fixes: dd69d07a5a6c ("riscv: stack: Support HAVE_SOFTIRQ_ON_OWN_STACK")
Reviewed-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Jiexun Wang <wangjiexun@tinylab.org>
Reviewed-by: Samuel Holland <samuel@sholland.org>
Link: https://lore.kernel.org/r/20230913052940.374686-1-wangjiexun@tinylab.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/irq.c b/arch/riscv/kernel/irq.c
index a8efa053c4a5..9cc0a7669271 100644
--- a/arch/riscv/kernel/irq.c
+++ b/arch/riscv/kernel/irq.c
@@ -60,7 +60,7 @@ static void init_irq_stacks(void)
 }
 #endif /* CONFIG_VMAP_STACK */
 
-#ifdef CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK
+#ifdef CONFIG_SOFTIRQ_ON_OWN_STACK
 void do_softirq_own_stack(void)
 {
 #ifdef CONFIG_IRQ_STACKS
@@ -92,7 +92,7 @@ void do_softirq_own_stack(void)
 #endif
 		__do_softirq();
 }
-#endif /* CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK */
+#endif /* CONFIG_SOFTIRQ_ON_OWN_STACK */
 
 #else
 static void init_irq_stacks(void) {}
-- 
2.42.0



