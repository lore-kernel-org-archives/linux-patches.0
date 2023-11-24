Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B0828E32;
	Fri, 24 Nov 2023 18:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5Y61zuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF38AC433C8;
	Fri, 24 Nov 2023 18:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850694;
	bh=jrUWZM3IiqF/b5F6Cj0aH6vLmHmQUzL6JUJSOtuI8e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5Y61zuCZImJCGS4NmO3sjX/zWiIYoW9rHKHxvyGwJbXd79KwN7PVP12GJJGIXjfI
	 GTfAfI1kVZv9OpjJ9lTStEZpRQtkqPPDkIKVrCyZk8WZIGhgVRuxBxJ/NQsgWlQRdf
	 Y1xd2W8hudNMd6o1CrH+Q+JXh3H4vM4+iamKVpj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Finn Thain <fthain@linux-m68k.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 152/491] sched/core: Optimize in_task() and in_interrupt() a bit
Date: Fri, 24 Nov 2023 17:46:28 +0000
Message-ID: <20231124172029.047583404@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit 87c3a5893e865739ce78aa7192d36011022e0af7 ]

Except on x86, preempt_count is always accessed with READ_ONCE().
Repeated invocations in macros like irq_count() produce repeated loads.
These redundant instructions appear in various fast paths. In the one
shown below, for example, irq_count() is evaluated during kernel entry
if !tick_nohz_full_cpu(smp_processor_id()).

0001ed0a <irq_enter_rcu>:
   1ed0a:       4e56 0000       linkw %fp,#0
   1ed0e:       200f            movel %sp,%d0
   1ed10:       0280 ffff e000  andil #-8192,%d0
   1ed16:       2040            moveal %d0,%a0
   1ed18:       2028 0008       movel %a0@(8),%d0
   1ed1c:       0680 0001 0000  addil #65536,%d0
   1ed22:       2140 0008       movel %d0,%a0@(8)
   1ed26:       082a 0001 000f  btst #1,%a2@(15)
   1ed2c:       670c            beqs 1ed3a <irq_enter_rcu+0x30>
   1ed2e:       2028 0008       movel %a0@(8),%d0
   1ed32:       2028 0008       movel %a0@(8),%d0
   1ed36:       2028 0008       movel %a0@(8),%d0
   1ed3a:       4e5e            unlk %fp
   1ed3c:       4e75            rts

This patch doesn't prevent the pointless btst and beqs instructions
above, but it does eliminate 2 of the 3 pointless move instructions
here and elsewhere.

On x86, preempt_count is per-cpu data and the problem does not arise
presumably because the compiler is free to optimize more effectively.

This patch was tested on m68k and x86. I was expecting no changes
to object code for x86 and mostly that's what I saw. However, there
were a few places where code generation was perturbed for some reason.

The performance issue addressed here is minor on uniprocessor m68k. I
got a 0.01% improvement from this patch for a simple "find /sys -false"
benchmark. For architectures and workloads susceptible to cache line bounce
the improvement is expected to be larger. The only SMP architecture I have
is x86, and as x86 unaffected I have not done any further measurements.

Fixes: 15115830c887 ("preempt: Cleanup the macro maze a bit")
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/0a403120a682a525e6db2d81d1a3ffcc137c3742.1694756831.git.fthain@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/preempt.h | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 1424670df161d..9aa6358a1a16b 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -99,14 +99,21 @@ static __always_inline unsigned char interrupt_context_level(void)
 	return level;
 }
 
+/*
+ * These macro definitions avoid redundant invocations of preempt_count()
+ * because such invocations would result in redundant loads given that
+ * preempt_count() is commonly implemented with READ_ONCE().
+ */
+
 #define nmi_count()	(preempt_count() & NMI_MASK)
 #define hardirq_count()	(preempt_count() & HARDIRQ_MASK)
 #ifdef CONFIG_PREEMPT_RT
 # define softirq_count()	(current->softirq_disable_cnt & SOFTIRQ_MASK)
+# define irq_count()		((preempt_count() & (NMI_MASK | HARDIRQ_MASK)) | softirq_count())
 #else
 # define softirq_count()	(preempt_count() & SOFTIRQ_MASK)
+# define irq_count()		(preempt_count() & (NMI_MASK | HARDIRQ_MASK | SOFTIRQ_MASK))
 #endif
-#define irq_count()	(nmi_count() | hardirq_count() | softirq_count())
 
 /*
  * Macros to retrieve the current execution context:
@@ -119,7 +126,11 @@ static __always_inline unsigned char interrupt_context_level(void)
 #define in_nmi()		(nmi_count())
 #define in_hardirq()		(hardirq_count())
 #define in_serving_softirq()	(softirq_count() & SOFTIRQ_OFFSET)
-#define in_task()		(!(in_nmi() | in_hardirq() | in_serving_softirq()))
+#ifdef CONFIG_PREEMPT_RT
+# define in_task()		(!((preempt_count() & (NMI_MASK | HARDIRQ_MASK)) | in_serving_softirq()))
+#else
+# define in_task()		(!(preempt_count() & (NMI_MASK | HARDIRQ_MASK | SOFTIRQ_OFFSET)))
+#endif
 
 /*
  * The following macros are deprecated and should not be used in new code:
-- 
2.42.0



