Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48B446C4D9;
	Tue, 21 Jul 2026 19:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661689; cv=none; b=TiJ215X9HRCBPkliqPMBAeagWJxXpdLvRysWWpDqbaNd4pFJcpd5pO3O8xDhHdzyCSwyoFotuso3DxpKALLmexzO1cw0UwPQTCj62N11SSLw5igoR+JTGVY5VnT0biY3GRxqkef8dhS8eAIRNywyYr7FQdt8i1TK617LOYGnt+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661689; c=relaxed/simple;
	bh=/VMPnKq3QlePvxgbUNT3ipUGCSLcavTeqezZozvJufM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLO6RXXbOROndJm+tvCXslxKhRNOlQ1or7xF58PSm0vUROAYMvk2SQWceIRoIAQ69Q9aeyMzXt1Tf9iDvQQIuER6MN6rByw60sFS/5nHLtC1BM5W2JRarhiamC0kksRJl9fo5DiVzu5ZW7eC33DtQd3l/lMC3U/Yk9RMZq08aCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N6nkFpuc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N6nkFpuc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DB11F000E9;
	Tue, 21 Jul 2026 19:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661688;
	bh=pAp1eJIC8s44VKbKW9HA2XNh8Pikj3Ijy7mB5ZGmVIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N6nkFpucsNHIyZLQLUMkscigHBO+t5k0BexcW7iva/PvHADwoviVMbRvuY4LpPq37
	 AzYM2hGQN9PIDeMYBRODleG7mB3hPEgYXEXZgxNC3rbbYbbe/hS4lSTeMjSwXs+vYQ
	 j+1nDxDGkLVY5J4rnYVG9BUp9PiDAzUaSkcc3+wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0161/1276] MIPS: DEC: Remove do_IRQ() call indirection
Date: Tue, 21 Jul 2026 17:10:04 +0200
Message-ID: <20260721152449.703236707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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



