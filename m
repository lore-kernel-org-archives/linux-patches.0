Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BC37469
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E645DC433C8;
	Sun, 17 Sep 2023 20:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982342;
	bh=d8zjwdspyugbZiYsFMrIJMIQIZDOXQnFrwJb3OrIXCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+aiDqcJ57C/yFRHqdB67iOydbN7HwmPaLr1lpogWIsuWo1/fhm41luKgsGqY47GO
	 c4p4rDK920M1gKqndhJ8+AkiFdaZ0Ul2hpjVtEMfW3ozzChedFeUHNZIMaeZicwCF3
	 nMOn/dvsni4d+76AmmGGJboLkoLwnDRiuvhBGHdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 223/511] powerpc: Dont include lppaca.h in paca.h
Date: Sun, 17 Sep 2023 21:10:50 +0200
Message-ID: <20230917191119.195361299@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 1aa000667669fa855853decbb1c69e974d8ff716 ]

By adding a forward declaration for struct lppaca we can untangle paca.h
and lppaca.h. Also move get_lppaca() into lppaca.h for consistency.

Add includes of lppaca.h to some files that need it.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230823055317.751786-3-mpe@ellerman.id.au
Stable-dep-of: eac030b22ea1 ("powerpc/pseries: Rework lppaca_shared_proc() to avoid DEBUG_PREEMPT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/lppaca.h         | 4 ++++
 arch/powerpc/include/asm/paca.h           | 6 +-----
 arch/powerpc/include/asm/paravirt.h       | 1 +
 arch/powerpc/include/asm/plpar_wrappers.h | 1 +
 arch/powerpc/kvm/book3s_hv_ras.c          | 1 +
 arch/powerpc/mm/book3s64/slb.c            | 1 +
 arch/powerpc/xmon/xmon.c                  | 1 +
 7 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/lppaca.h b/arch/powerpc/include/asm/lppaca.h
index c390ec377baed..5d509ba0550b5 100644
--- a/arch/powerpc/include/asm/lppaca.h
+++ b/arch/powerpc/include/asm/lppaca.h
@@ -130,6 +130,10 @@ static inline bool lppaca_shared_proc(struct lppaca *l)
 	return !!(l->__old_status & LPPACA_OLD_SHARED_PROC);
 }
 
+#ifdef CONFIG_PPC_PSERIES
+#define get_lppaca()	(get_paca()->lppaca_ptr)
+#endif
+
 /*
  * SLB shadow buffer structure as defined in the PAPR.  The save_area
  * contains adjacent ESID and VSID pairs for each shadowed SLB.  The
diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index c5c9e25153152..02c089c5493ad 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -14,7 +14,6 @@
 
 #include <linux/string.h>
 #include <asm/types.h>
-#include <asm/lppaca.h>
 #include <asm/mmu.h>
 #include <asm/page.h>
 #ifdef CONFIG_PPC_BOOK3E
@@ -46,14 +45,11 @@ extern unsigned int debug_smp_processor_id(void); /* from linux/smp.h */
 #define get_paca()	local_paca
 #endif
 
-#ifdef CONFIG_PPC_PSERIES
-#define get_lppaca()	(get_paca()->lppaca_ptr)
-#endif
-
 #define get_slb_shadow()	(get_paca()->slb_shadow_ptr)
 
 struct task_struct;
 struct rtas_args;
+struct lppaca;
 
 /*
  * Defines the layout of the paca.
diff --git a/arch/powerpc/include/asm/paravirt.h b/arch/powerpc/include/asm/paravirt.h
index b325022ffa2b0..0a333ac716e0b 100644
--- a/arch/powerpc/include/asm/paravirt.h
+++ b/arch/powerpc/include/asm/paravirt.h
@@ -6,6 +6,7 @@
 #include <asm/smp.h>
 #ifdef CONFIG_PPC64
 #include <asm/paca.h>
+#include <asm/lppaca.h>
 #include <asm/hvcall.h>
 #endif
 
diff --git a/arch/powerpc/include/asm/plpar_wrappers.h b/arch/powerpc/include/asm/plpar_wrappers.h
index 83e0f701ebc67..217d8fb246354 100644
--- a/arch/powerpc/include/asm/plpar_wrappers.h
+++ b/arch/powerpc/include/asm/plpar_wrappers.h
@@ -9,6 +9,7 @@
 
 #include <asm/hvcall.h>
 #include <asm/paca.h>
+#include <asm/lppaca.h>
 #include <asm/page.h>
 
 static inline long poll_pending(void)
diff --git a/arch/powerpc/kvm/book3s_hv_ras.c b/arch/powerpc/kvm/book3s_hv_ras.c
index d4bca93b79f6d..6fa634599bc90 100644
--- a/arch/powerpc/kvm/book3s_hv_ras.c
+++ b/arch/powerpc/kvm/book3s_hv_ras.c
@@ -9,6 +9,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/kernel.h>
+#include <asm/lppaca.h>
 #include <asm/opal.h>
 #include <asm/mce.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/mm/book3s64/slb.c b/arch/powerpc/mm/book3s64/slb.c
index f0037bcc47a0e..a4fd2901189c5 100644
--- a/arch/powerpc/mm/book3s64/slb.c
+++ b/arch/powerpc/mm/book3s64/slb.c
@@ -14,6 +14,7 @@
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
 #include <asm/paca.h>
+#include <asm/lppaca.h>
 #include <asm/ppc-opcode.h>
 #include <asm/cputable.h>
 #include <asm/cacheflush.h>
diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 3c085e1e5232e..8b5277c3b1476 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -59,6 +59,7 @@
 #ifdef CONFIG_PPC64
 #include <asm/hvcall.h>
 #include <asm/paca.h>
+#include <asm/lppaca.h>
 #endif
 
 #include "nonstdio.h"
-- 
2.40.1



