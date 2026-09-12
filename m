Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B6D37E2E7;
	Sat, 12 Sep 2026 12:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217027; cv=none; b=kCSKrZZ+MoEgiK7ecW8AYQIlf8uC1aiQXT/tUoTN5dxPsIia9sAZ0zue44SdGAtLfccOV2v/BmXRJHkSNbY6kzGMk2l0YmAivRtUXwtT2QQ5wWPedxnOrw8PeNY93DyWvJ5OqhB8M9VcGm+XyRew8nphMRCb0NeNiBKMTRAIg60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217027; c=relaxed/simple;
	bh=Z6N0gsnWQT0rHEqkHgJMXdC/1QT7z9gCG9KSC7N9OGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GA7DQyACwF1/ZUt3o0Nvfl/A4IHLBEL1MAVIonBGZ+HFhP/8jn2wKmP7GXA1lL1HLNxbwoVHReWeVE6LpIiz828BVfbkW6eIK3ivbZolFGYO9TuZvjT+D38+96IeLi+8apWbDfzgx3xgiHe/hU3maZTQ7G47cYgtikoUqHjISzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jH2bWi23; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jH2bWi23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0861F000FF;
	Sat, 12 Sep 2026 12:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217025;
	bh=348kf2vtQkBb62QlbV1tvOAiz48mDBAjCyI5yxO7cO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jH2bWi23N8DS2fzA3S8fE91du1YxTGjFRCIokZgm1bR9/X8z9X55QBmhFtSx3q8xH
	 Xa3M5KZm3xi69VIJ4VbC8ndXyl3ZXWmXFK0Kn6uyaQMbAcXCYJ9CUaAhaQPraitgzE
	 AUo1dcgb39TiZA+ba4FeEwKLLN+Y1lviHh25xjLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saket Kumar Bhaskar <skb99@linux.ibm.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0857/1376] powerpc/irq: Fix missing r2 clobber in PCREL inline assembly
Date: Sat, 12 Sep 2026 08:54:43 +0200
Message-ID: <20260912065626.661383793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saket Kumar Bhaskar <skb99@linux.ibm.com>

[ Upstream commit 00be69070d91d2be978e752bb117a0a4db0e1281 ]

In CONFIG_PPC_KERNEL_PCREL mode, r2 is no longer reserved for the TOC
pointer and is available as a caller-saved register [0].

Both call_do_irq() and call_do_softirq() use inline assembly to call
functions with stack switching, but fail to list r2 in their clobber
lists. This causes the compiler to assume r2 is preserved across these
calls, leading to register corruption when the called functions
(__do_irq and __do_softirq) clobber r2.

As a result of this kernel crash during interrupt handling is seen and
the kernel fails to boot:

BUG: Unable to handle kernel data access on write at 0xc000000404697638
Faulting instruction address: 0xc0000000000181ec
Oops: Kernel access of bad area, sig: 11 [#1]
NIP [c0000000000181ec] __do_IRQ+0x6c/0xc0

With older GCC, the compiler would conservatively allocate
callee-saved registers (like r31) for values spanning function calls,
accidentally avoiding the bug:

<__do_IRQ>:
00 00 00 60 	nop
a6 02 08 7c 	mflr    r0
f8 ff e1 fb 	std     r31,-8(r1)
f0 ff c1 fb 	std     r30,-16(r1)
2d 03 10 06 	pla     r31,53297316

...

3d e8 ff 4b 	bl      c0000000000165ac <__do_irq>
00 00 21 e8 	ld      r1,0(r1)
28 00 4d e9 	ld      r10,40(r13)
40 00 21 38 	addi    r1,r1,64
2a f9 aa 7f 	stdx    r29,r10,r31

With newer GCC 14, the compiler uses r2 for such values, exposing the
missing clobber specification:

<__do_IRQ>:
00 00 00 60     nop
a6 02 08 7c     mflr    r0
f0 ff c1 fb     std     r30,-16(r1)
f8 ff e1 fb     std     r31,-8(r1)
29 02 10 06     pla     r2,36252592     # c0000000022aadc0 <__irq_regs>

...

85 dc ff 4b 	bl      c000000000015ee0 <__do_irq>
00 00 21 e8 	ld      r1,0(r1)
28 00 2d e9 	ld      r9,40(r13)
30 00 21 38 	addi    r1,r1,48
2a 11 c9 7f 	stdx    r30,r9,r2

Fix this by adding r2 to the clobber list for both call_do_irq() and
call_do_softirq() when CONFIG_PPC_KERNEL_PCREL is enabled.

[0]: https://www.mail-archive.com/gcc-patches@gcc.gnu.org/msg313226.html

Fixes: 7e3a68be42e1 ("powerpc/64: vmlinux support building with PCREL addresing")
Signed-off-by: Saket Kumar Bhaskar <skb99@linux.ibm.com>
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Reviewed-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/10fc2cda485cd22e209a31d786bed1984bdf3982.1785732393.git.skb99@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/irq.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 2e1600a8bbbbf..7ce69e7d6b11a 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -217,8 +217,12 @@ static __always_inline void call_do_softirq(const void *sp)
 		   [sp] "b" (sp), [offset] "i" (THREAD_SIZE - STACK_FRAME_MIN_SIZE),
 		   [callee] "i" (__do_softirq)
 		 : // Clobbers
-		   "lr", "xer", "ctr", "memory", "cr0", "cr1", "cr5", "cr6",
-		   "cr7", "r0", "r3", "r4", "r5", "r6", "r7", "r8", "r9", "r10",
+		   "lr", "xer", "ctr", "memory", "cr0", "cr1", "cr5", "cr6", "cr7", "r0",
+		  /* r2 may be clobbered by the callee when using PCREL mode in the ELFv2 ABI. */
+#ifdef CONFIG_PPC_KERNEL_PCREL
+		   "r2",
+#endif
+		   "r3", "r4", "r5", "r6", "r7", "r8", "r9", "r10",
 		   "r11", "r12"
 	);
 }
@@ -275,8 +279,12 @@ static __always_inline void call_do_irq(struct pt_regs *regs, void *sp)
 		   [sp] "b" (sp), [offset] "i" (THREAD_SIZE - STACK_FRAME_MIN_SIZE),
 		   [callee] "i" (__do_irq)
 		 : // Clobbers
-		   "lr", "xer", "ctr", "memory", "cr0", "cr1", "cr5", "cr6",
-		   "cr7", "r0", "r4", "r5", "r6", "r7", "r8", "r9", "r10",
+		   "lr", "xer", "ctr", "memory", "cr0", "cr1", "cr5", "cr6", "cr7", "r0",
+		  /* r2 may be clobbered by the callee when using PCREL mode in the ELFv2 ABI. */
+#ifdef CONFIG_PPC_KERNEL_PCREL
+		   "r2",
+#endif
+		   "r4", "r5", "r6", "r7", "r8", "r9", "r10",
 		   "r11", "r12"
 	);
 }
-- 
2.53.0



