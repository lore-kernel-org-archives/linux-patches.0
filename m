Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01253C9EF3;
	Thu, 17 Sep 2026 17:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665128; cv=none; b=b9nbLVStUsoQPg4QmHgEwDW1kHSSiCDxchBFneL8GmG2QkGDjP0qCrRojFKk6mginhnLegNwmJ8t7saXMqlkOIqE3FFU5hfR1Q3wbt/JCNPVhbRboo+BhU6rHO4Ol2X1i62tfhbrr4cznUXxDSjGKHOVRqeh+bYafXhvUGecM6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665128; c=relaxed/simple;
	bh=TtO//GxhnfuHPQr1LHoBpCi2p01KP2bmLPQIycCt/68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7uTQK4tQviE2X5cH/S22xy6VL1hPTMhz8fTsJ1f7ttQA3CcdkI2Xt7zEg3WDD/toB9qCdX4FFrj5F8tGPLQ1kOWR0B4lQQSK1D1uOLg/xZfd/EtT3EQJsEeA/w84FKIjH7dlKMIZUlOlN6Y/cqv9ol4N1AMzsb9UCRjgIFUcpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FqhBFb2s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FqhBFb2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0372B1F000FF;
	Thu, 17 Sep 2026 17:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665126;
	bh=df7Nu1kb0lsXUaI+ZEtOOkdXzfrmJqniLom5ri38l4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FqhBFb2sgJ8ME0JO7e53WlDiDHj5q0hIfs+bKwNEujFulCsHfDTlc0jwiF5gRxX25
	 AGM5uIkLVTM/fU7RD+aW3AxtIuLRwdy+EFO82iQIdEu+GxST3WC7BEJ7Y48hqP4dhN
	 HOzk+i7mlc+ET3cHiJzrsXw1L3pgtvyjHt5n6T5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Linus Walleij <linusw@kernel.org>,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0599/1250] ARM: 9484/1: enable interrupts when unhandled user faults are triggered
Date: Thu, 17 Sep 2026 16:06:34 +0100
Message-ID: <20260917151608.116809083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Xie Yuanbin <xieyuanbin1@huawei.com>

[ Upstream commit e79ca91165d4fd18549c536abdb86101e889052f ]

PREEMPT_RT requires interrupts to be enabled when sending signals.

When do_DataAbort()/do_PrefetchAbort() triggers unhandled user faults,
that is `inf->fn()` return a non-zero value, and the interrupts are not
enabled within the hook function, force_sig_fault() will be called
with interrupts disabled.

This can be triggered by user programs executing the bkpt instruction,
with kernel config CONFIG_PERF_EVENTS=n.

Enable interrupts in do_DataAbort()/do_PrefetchAbort() when unhandled
user faults are triggered to fix the issue.

Fixes: c6e61c06d606 ("ARM: 9463/1: Allow to enable RT")
Link: https://lore.kernel.org/20260629123349.134224-1-xieyuanbin1@huawei.com
Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/fault.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index 65b652b4dec3d..5c6135b3931d2 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -649,6 +649,9 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (!inf->fn(addr, fsr & ~FSR_LNX_PF, regs))
 		return;
 
+	if (likely(user_mode(regs)))
+		local_irq_enable();
+
 	pr_alert("8<--- cut here ---\n");
 	pr_alert("Unhandled fault: %s (0x%03x) at 0x%08lx\n",
 		inf->name, fsr, addr);
@@ -687,6 +690,9 @@ do_PrefetchAbort(unsigned long addr, unsigned int ifsr, struct pt_regs *regs)
 	if (!inf->fn(addr, ifsr | FSR_LNX_PF, regs))
 		return;
 
+	if (likely(user_mode(regs)))
+		local_irq_enable();
+
 	pr_alert("8<--- cut here ---\n");
 	pr_alert("Unhandled prefetch abort: %s (0x%03x) at 0x%08lx\n",
 		inf->name, ifsr, addr);
-- 
2.53.0



