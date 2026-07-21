Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E18143CEE4;
	Tue, 21 Jul 2026 22:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673555; cv=none; b=DSZ3SjkHGHOk8LpgfyYqVVoxq8J+b2CuFY8Bn5hvkx0xyIuA3Nz8gFzD8nAaSHTTBqOXyRqGyLdRApsjq0NUnRg4ZTlHvBeyURE1w3p908kQZ8HnDEzea5hmKucSN0AsuQjdVgpi9szvqOBeFUxsHEJeLzwjqTBQLkPWbihXse0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673555; c=relaxed/simple;
	bh=f5VI9nnPAmB3BOqV7qymZXTCnQIIMS4BXEtZcd+YM4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0lxL9CKWrhTr65fFqLuq3wuLa5admbi4hp5dVzsCFIoz7/axMO40JljRa1EWcwQEdw4CdDvKQWEdAyyEp4oBxR4j0ky2RPhHqTQ5j+h8IpU//sBJrQtp68sorr2LHTTuFmg/U8WCRxlM4ENgKh7QkkxEif5h01U2Y+pSqNBQgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Guqhe89C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Guqhe89C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A395A1F000E9;
	Tue, 21 Jul 2026 22:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673554;
	bh=a7NH1n6bHSya11NnLIUrJ3oueZ+YeO4Ba8PqkLi09g0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Guqhe89CM/Kg/3J6OeUX7O9Y4KButwWHLSn/4aVYm/i9nphbxpOqDYghH3j9Idfn2
	 G1lJ3PSTluBvGCW3GOQZ5U7Yu74l3LlS7qdTbtkMALcKSy1PPyqYun5X34QYiVzXaX
	 9sYVRmTXLVnIrC9a6Tyl6v9yHPrOih3OKWiY7faY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 205/699] MIPS: DEC: Remove do_IRQ() call indirection
Date: Tue, 21 Jul 2026 17:19:24 +0200
Message-ID: <20260721152400.320547324@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 99b9b29750db3c..ec0aa4ef2778a6 100644
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



