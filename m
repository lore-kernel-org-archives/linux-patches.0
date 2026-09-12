Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C6E2EC09B;
	Sat, 12 Sep 2026 11:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211833; cv=none; b=Rqtdi4KufPLMVMHCioGigCPzBPYF/u9mu5wSRGlUF6M4/Rw6QdzNCQHg6F2P7aJXLqnYGnL9IFr01PrBwnPY8rSudpSp/g+Kn8L6NLmnsqUGjSj/bE1Eb7cozXFcsKET7JTxHX9VDjXOr1/TaExJHMXBlDjUxGK0m5+qY2p39Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211833; c=relaxed/simple;
	bh=liiEIbPnmcWWPIw+qwXCXGEsG4EgU+1xzOgISEJ1Vvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/cITQ4vg0iRVdDckUTGJZGYbth2tba8KWk7Qw0uWy6c8oZtUDJqiPQgW+ETSV4TdwLbj/sETcxNY0bayCinBrjH6Dl6etC4MRG4AlcHrAljdQ6GsGsNay0KdjqcEfWitygTw/CliPuh8+DhVEYoyeZX0QVWjB2182DHcmBKvKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aa8UsCEC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aa8UsCEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE131F000FF;
	Sat, 12 Sep 2026 11:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211831;
	bh=GlnXTcVn+DQvx2oGQ7TcCLgCz1cuwRLktWyoVCAiIOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aa8UsCECw8Ru1CuFQCcTr09nblQzAB4wMfCO24WF/Vlxgp2CFN4+PgG7ieCpsfcBb
	 IPAq7G8xu7+57MjAeIwfvSqsNI8TJUPTIDAENw86xnQrHKxVb24ZPIYhXnjCjcZHsJ
	 KBFW2jBvgylQD6LcJCXJQd/2QhDfw2vsLZ5MeS68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1312/1518] irqchip/gic-v5: Synchronize CPU interface disable
Date: Sat, 12 Sep 2026 08:58:01 +0200
Message-ID: <20260912065653.205901526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Sascha Bischoff <Sascha.Bischoff@arm.com>

[ Upstream commit ac6db0e0bee18cd4385418c752a007e1aba4ec14 ]

The write disabling the GICv5 CPU interface is only guaranteed to take
effect after a context synchronization event. Without one, execution can
return from gicv5_cpu_disable_interrupts() while an interrupt is still
able to be taken.

Add an ISB after the ICC_CR0_EL1 write to ensure interrupts are
disabled before the function returns. No corresponding ISB is added
when enabling the interface, as interrupt delivery is asynchronous and
there is no obvious benefit to waiting for it.

Fixes: 7ec80fb3f025 ("irqchip/gic-v5: Add GICv5 PPI support")
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Link: https://sashiko.dev/#/patchset/20260724104819.1296803-1-sascha.bischoff@arm.com?part=6
Link: https://patch.msgid.link/20260811152630.942023-3-sascha.bischoff@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index fa86dd03e307c..a04dd56652027 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -925,6 +925,7 @@ static void gicv5_cpu_disable_interrupts(void)
 
 	cr0 = FIELD_PREP(ICC_CR0_EL1_EN, 0);
 	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
+	isb();
 }
 
 static void gicv5_cpu_enable_interrupts(void)
-- 
2.53.0



