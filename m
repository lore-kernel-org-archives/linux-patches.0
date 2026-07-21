Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06DE4071E3;
	Tue, 21 Jul 2026 17:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656000; cv=none; b=ufhN9EMd3y6NWCn9LSmhr7w7gZJ1uXWNxfh9JKpScbmAkXYugEX3JI8LyaXiFY+HRRz/svVpi76F2/rNXtJotBqBOlnubh597yMBk3oZcPp9KVG2aIyIVBDT9sXqe/CzV0A/7Zki1QQ48eDMTcHl60bCOGGlwu+6Xs5tiEag+To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656000; c=relaxed/simple;
	bh=Fhr96y49DeMjF4wbElAds8c0YTdG2knAgk/5fVC4L8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hav1dnkbRr9aTagygSZn42kyC4uNZ1BfxspBbt82o2phJDKVhTYKfL70hPMyHxUVMBokalo2hI1C74rK5J0IJ2BGgie8Ha1bdqwz5AiCavgAPhaxXV88DdlkpuDT8tQ50+sD0bWqsg+EMnjLm83BCilWBwk9UNpzbkA+MQw3N8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgzTf6Vl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgzTf6Vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9651F000E9;
	Tue, 21 Jul 2026 17:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655998;
	bh=loQTnE3l/ZuVp8bKfJVDzZTp8K6RDR+jRHQG7Pm1XN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WgzTf6VltHIMxTkj4bH6IoQfK0jeXsv1TagKvZkUk1rRWrYnyKLB/+oFroLI9yeKF
	 dgscxXsDpL7m3Jcjyp9bv3XXmz06RPs/Ck6d45WGKKAa5/39WMx3ETYrFozUBx8uJS
	 Ynl9AzwdTIr5Ob3g8Az0v+UJTvk5Lj1geLB75KQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0220/1611] MIPS: DEC: Remove do_IRQ() call indirection
Date: Tue, 21 Jul 2026 17:05:36 +0200
Message-ID: <20260721152519.947523436@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit 35554eadc1b127bb5294504a4ac8f3a5dd9e299d ]

As from commit 8f99a1626535 ("MIPS: Tracing: Add IRQENTRY_EXIT section
for MIPS") do_IRQ() is not a macro anymore and can be invoked directly
from assembly code, as a tail call.  Remove the dec_irq_dispatch() stub
then and the indirection previously introduced with commit 187933f23679
("[MIPS] do_IRQ cleanup"), improving performance by reducing the number
of control flow changes and the overall instruction count, while fixing
a compiler's complaint about a missing prototype for said stub:

arch/mips/dec/setup.c:780:25: warning: no previous prototype for 'dec_irq_dispatch' [-Wmissing-prototypes]
  780 | asmlinkage unsigned int dec_irq_dispatch(unsigned int irq)
      |                         ^~~~~~~~~~~~~~~~

(which gets promoted to a compilation error with CONFIG_WERROR).

Fixes: 8f99a1626535 ("MIPS: Tracing: Add IRQENTRY_EXIT section for MIPS")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/dec/int-handler.S | 2 +-
 arch/mips/dec/setup.c       | 6 ------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/mips/dec/int-handler.S b/arch/mips/dec/int-handler.S
index 011d1d678840aa..a0b439c90488fc 100644
--- a/arch/mips/dec/int-handler.S
+++ b/arch/mips/dec/int-handler.S
@@ -277,7 +277,7 @@
 		 srlv	t3,t1,t2
 
 handle_it:
-		j	dec_irq_dispatch
+		j	do_IRQ
 		 nop
 
 #if defined(CONFIG_32BIT) && defined(CONFIG_MIPS_FP_SUPPORT)
diff --git a/arch/mips/dec/setup.c b/arch/mips/dec/setup.c
index 87f0a1436bf9cc..abe42616498db9 100644
--- a/arch/mips/dec/setup.c
+++ b/arch/mips/dec/setup.c
@@ -776,9 +776,3 @@ void __init arch_init_irq(void)
 			pr_err("Failed to register halt interrupt\n");
 	}
 }
-
-asmlinkage unsigned int dec_irq_dispatch(unsigned int irq)
-{
-	do_IRQ(irq);
-	return 0;
-}
-- 
2.53.0



