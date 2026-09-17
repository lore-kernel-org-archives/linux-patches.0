Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3698E4F93C4;
	Thu, 17 Sep 2026 18:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668663; cv=none; b=ZohA75oSjn4EW+dh6UzjnweGK4ZnQBVD2tvQP72j/lc0Yz98j0hfj5wuKGVnSVcNwTZtNRyQGvhw8cOE4SY5dQ8VL7uCWZqhAoZaLkeoPzXfciYelVpMCZXFCFuTOlBG0P5hgOPXt3ToTiYbKvtF2GD6xtLnSlDYqjVGjS2gbKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668663; c=relaxed/simple;
	bh=kXiCY9oiV/HA2/3pHWfZm95Gpq8UVyf0HTu9PdmXzVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/v2gw6JKbItC4eOf3XuMzegSEbfxaZZkGzJka8ejYHVOWsk475wlWYNyca+sNe9XcLclUmVi/NC/KkfK7LyQ1YamVaUd31hjpx9oM5aFKhXxibQq70Mv8QLplL6eprErdB5+6I+qTncNjWeyoFawIea4ed1X5nMKnYvJc3i8dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQ6Q3eNw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQ6Q3eNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96D71F00893;
	Thu, 17 Sep 2026 18:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668660;
	bh=tKsUYY+yObxfL2n0RPodZvIm2iEQMEXms6BJeLcZxng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQ6Q3eNw1jzCSa+8+dqu5WFcxvGsfGM1M77+mDMCWlAoudXtJjRY5X2mZDMY1cxKC
	 HUaw/lhqSNDkv+Tnr7X8N7pp8O2T5+jHq3pdtnRMxqqrx+fJMAxYl9yF07EkC3Ibfi
	 +vP/m0Brtv1kf5VXq1/T/lr4vN9+tVm0Xm/JNExM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Linus Walleij <linusw@kernel.org>,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0498/1102] ARM: 9484/1: enable interrupts when unhandled user faults are triggered
Date: Thu, 17 Sep 2026 16:07:21 +0100
Message-ID: <20260917151552.230411041@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 6763a7c660780..233452584e1ee 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -650,6 +650,9 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (!inf->fn(addr, fsr & ~FSR_LNX_PF, regs))
 		return;
 
+	if (likely(user_mode(regs)))
+		local_irq_enable();
+
 	pr_alert("8<--- cut here ---\n");
 	pr_alert("Unhandled fault: %s (0x%03x) at 0x%08lx\n",
 		inf->name, fsr, addr);
@@ -688,6 +691,9 @@ do_PrefetchAbort(unsigned long addr, unsigned int ifsr, struct pt_regs *regs)
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



