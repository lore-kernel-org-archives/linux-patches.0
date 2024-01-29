Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E265815CD52;
	Mon, 29 Jan 2024 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548344; cv=none; b=plXZ/D8eqHJuwBPV260CGxN4N9vQPZaUBrg6tb7gr5j8CdJGrPI/GrDXerAiMQQbwQ0zdZ4JMzC8RlVftkbQ1Cd/TgO+ro4rK5tWBPyjGTnEaEMsgU76XRbYQB9tgT2O23S88W4/ivF5+oZz5lK9ilE7asQbBSura6A0wWykZwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548344; c=relaxed/simple;
	bh=BUWRMhhi5WQSR9ht+ooMqiRaMLgjKSbuoJTddl5U9p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nR2QC43bbIsThYbB+i1lv+v8KqBTsR1lKbvU9sTr4aSjmoTTukJEJU4mYQUSjtHx7rO1exYEe45c4d+Jo5cjS8c9SQnsehaq0UA40Pz+WhaeCcEummTTyPC5zz6NOXT7Pi/RR4JKD2vPja/YauUWXihQVeONcjdxGB439lmIOHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lE9HM432; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lE9HM432"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A995FC43390;
	Mon, 29 Jan 2024 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548343;
	bh=BUWRMhhi5WQSR9ht+ooMqiRaMLgjKSbuoJTddl5U9p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lE9HM432okhB9oqpXdJ/8TvUoC8LQUHLpn3fX50oaj7v6crIFVweDN+4ir65n5MAR
	 p+xhPzHOsI38XkpU9vOb2PHKbQdxhzkYEug0OA/S2MvUUy+rBYPOREfYr4uSl7pWHH
	 UzeIah8phpCZWs4U2WyfqFEsGWzOx1iXOOfmpU/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 337/346] MIPS: lantiq: register smp_ops on non-smp platforms
Date: Mon, 29 Jan 2024 09:06:08 -0800
Message-ID: <20240129170026.394816671@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 4bf2a626dc4bb46f0754d8ac02ec8584ff114ad5 ]

Lantiq uses a common kernel config for devices with 24Kc and 34Kc cores.
The changes made previously to add support for interrupts on all cores
work on 24Kc platforms with SMP disabled and 34Kc platforms with SMP
enabled. This patch fixes boot issues on Danube (single core 24Kc) with
SMP enabled.

Fixes: 730320fd770d ("MIPS: lantiq: enable all hardware interrupts on second VPE")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/prom.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/mips/lantiq/prom.c b/arch/mips/lantiq/prom.c
index a3cf29365858..0c45767eacf6 100644
--- a/arch/mips/lantiq/prom.c
+++ b/arch/mips/lantiq/prom.c
@@ -108,10 +108,9 @@ void __init prom_init(void)
 	prom_init_cmdline();
 
 #if defined(CONFIG_MIPS_MT_SMP)
-	if (cpu_has_mipsmt) {
-		lantiq_smp_ops = vsmp_smp_ops;
+	lantiq_smp_ops = vsmp_smp_ops;
+	if (cpu_has_mipsmt)
 		lantiq_smp_ops.init_secondary = lantiq_init_secondary;
-		register_smp_ops(&lantiq_smp_ops);
-	}
+	register_smp_ops(&lantiq_smp_ops);
 #endif
 }
-- 
2.43.0



