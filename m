Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABE65013C9;
	Wed, 30 Sep 2026 16:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784900; cv=none; b=UkFJ9NpWprjE6YG3PZzcbYu+flLPAQCgPjzxFrc8cxb5YnFvUAnHm/O3WXQh9pKpqQri0GwXtFetyshbh9vkWY/7LKkTNv5md8/Bu32OgMdVIwOBxrgBkbopAL16PKRXZdU2KTcu5TrilK22zZnsUmeP1rKmrj2/clPL48XY4dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784900; c=relaxed/simple;
	bh=YujFX69cc7PGMxq6RCj9Ydk9lUAEhr+mvblS31Zc02A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5BRFPmidPCgQG+BcZCXTZ4lSafZl7Gzh2fG1REypz89wQpghRTdxkyP/X3RcWqS+o37QAHPgFsoFf9c/yANaArwFkbO5Q7x4v87FPtIj8RWuvEoP6ipWQm+YVPw/mMmBYytaJJWQBzcmQgE2/uXFm1i1G48c6s4sOHpm9Vgw1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwSP3WaS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwSP3WaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B891F0089B;
	Wed, 30 Sep 2026 16:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784895;
	bh=zaSbaNlA5L0bT4EQLyEMcJuJo61fNRl94O42tcgOrFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rwSP3WaSYi9eYEumIacBxCop3pX936/yTnQ7n+jD/QYPIRhyAD858hAlsGjT3313M
	 AsJuAPXNN5NuA/OGQDVfgxAj3BnMsm2rRLjiSgmx5HYck2FvHo+UcUe6u7UQVYIc0a
	 ZX+r63i4geDMJuy2CQ6s99xA7VXMTTFLFYL6vxfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Linus Walleij <linusw@kernel.org>,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 318/982] ARM: 9484/1: enable interrupts when unhandled user faults are triggered
Date: Wed, 30 Sep 2026 17:17:34 +0200
Message-ID: <20260930152423.650583744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 29a995c6d7c6b..1010e808e2308 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -583,6 +583,9 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (!inf->fn(addr, fsr & ~FSR_LNX_PF, regs))
 		return;
 
+	if (likely(user_mode(regs)))
+		local_irq_enable();
+
 	pr_alert("8<--- cut here ---\n");
 	pr_alert("Unhandled fault: %s (0x%03x) at 0x%08lx\n",
 		inf->name, fsr, addr);
@@ -621,6 +624,9 @@ do_PrefetchAbort(unsigned long addr, unsigned int ifsr, struct pt_regs *regs)
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



