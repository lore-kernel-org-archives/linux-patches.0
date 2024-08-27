Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455191C6F6D;
	Tue, 27 Aug 2024 15:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772311; cv=none; b=s4SVW4DdB0StLohXLUORmZmgwM+vrl0230zTVh24ZVHiHkeCrUtDtTojU2QZqwSMhIkYtkR665JiELxl2uxtkF6q+NaYdXtHtmguG6T/3ivOekM7VNDPoEQ+d3ScBFUkKvopuG2gCl8WHZtu3reZuMUyvX/9Nd6KsrQUyJAV0pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772311; c=relaxed/simple;
	bh=c4+G6oH8A3zwPnVDZrKk9HBbV6dkwnGmy5+nu7ICHnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aW7bAytewIHK/UfM0XuSmzav05niIaUMNOSwNVfPoX+zm5exvziljPrVWZ2gk362DvPm1qCN5TrTiHp1QJSW/jKtDW8hWU9gXDttlzENZY1zwrq6Yd2g4AXuMl4H9tMRCed2d/FyO8BopUs38FxwuLux+IAwfaKuKGg7I3lL5dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUq2k9vt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUq2k9vt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83ADC61071;
	Tue, 27 Aug 2024 15:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772311;
	bh=c4+G6oH8A3zwPnVDZrKk9HBbV6dkwnGmy5+nu7ICHnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUq2k9vtJqFD2oMKyr/4owfuudC0WPnQ04NeHXO6RFxSkLGeWjta/+XUZNSCkIMv/
	 p5wu+S9jZXOJLlfxSghiPDv3FWX5k6NMIMeqyj3JF1FU71fbPyhmG834h8CsM7PWgQ
	 9r5LnRHRj/4vsHEYla6HXzQMsEUg/9J+txpMj7LU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/321] parisc: Use irq_enter_rcu() to fix warning at kernel/context_tracking.c:367
Date: Tue, 27 Aug 2024 16:38:05 +0200
Message-ID: <20240827143844.967754733@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit 73cb4a2d8d7e0259f94046116727084f21e4599f ]

Use irq*_rcu() functions to fix this kernel warning:

 WARNING: CPU: 0 PID: 0 at kernel/context_tracking.c:367 ct_irq_enter+0xa0/0xd0
 Modules linked in:
 CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.7.0-rc3-64bit+ #1037
 Hardware name: 9000/785/C3700

 IASQ: 0000000000000000 0000000000000000 IAOQ: 00000000412cd758 00000000412cd75c
  IIR: 03ffe01f    ISR: 0000000000000000  IOR: 0000000043c20c20
  CPU:        0   CR30: 0000000041caa000 CR31: 0000000000000000
  ORIG_R28: 0000000000000005
  IAOQ[0]: ct_irq_enter+0xa0/0xd0
  IAOQ[1]: ct_irq_enter+0xa4/0xd0
  RP(r2): irq_enter+0x34/0x68
 Backtrace:
  [<000000004034a3ec>] irq_enter+0x34/0x68
  [<000000004030dc48>] do_cpu_irq_mask+0xc0/0x450
  [<0000000040303070>] intr_return+0x0/0xc

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 9ddb2e3970589..b481cde6bfb62 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -501,7 +501,7 @@ void do_cpu_irq_mask(struct pt_regs *regs)
 
 	old_regs = set_irq_regs(regs);
 	local_irq_disable();
-	irq_enter();
+	irq_enter_rcu();
 
 	eirr_val = mfctl(23) & cpu_eiem & per_cpu(local_ack_eiem, cpu);
 	if (!eirr_val)
@@ -536,7 +536,7 @@ void do_cpu_irq_mask(struct pt_regs *regs)
 #endif /* CONFIG_IRQSTACKS */
 
  out:
-	irq_exit();
+	irq_exit_rcu();
 	set_irq_regs(old_regs);
 	return;
 
-- 
2.43.0



