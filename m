Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D71509F0B;
	Wed, 30 Sep 2026 15:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782851; cv=none; b=ouzxtpt2N87nveLGB+D+X3LzuCx6ybeN1WMb4W5t44bPbpaH2j9CK4Lnf/5ZuniF2i4zMB2bX72YKZIaraYfFfMH8GiBhicfzjUFOK20pfVheoh0ew9l/LJ3fPgRh62akHz97C7KBnrEMwfFoZ4fgM6PaOJ6cfEpDuABe+sC0Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782851; c=relaxed/simple;
	bh=2F6wL1kMiWfVsD0Zxv5XMIu7onMXw6SDnRFuMophoxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnpVGxQvhwu8R6R4nCJq1M0Q+TTBr4oxgY6CWrcVwj1PnXI3leL0hqzC8RANcjryaA3JYFM7kdR/qZF2AJN58SBXPzsGDPccexzVv4ZA86VqHL/WyuC1eZGJvdVKZ1ou+pM2YUvqkBT4APDe39IWfTVwyDRUIyTDT6KKMJNp/GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eM9L/wmD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eM9L/wmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB1A1F00898;
	Wed, 30 Sep 2026 15:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782845;
	bh=iVrDlOgSMVAJ7HxCYlFRR0Mw/5GztM8cVN9oj/R5gvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eM9L/wmDjSBai+TyXPW/QxDTsaSgqU9vUvbD8zpfzqprBTRLc/8ifVQTkQPaNNyQY
	 pktkUff986fXYnSJVkjcnF76DHv44DfGiJb3EK7UXnKCuLqUrIFdUqstq82EQAirZc
	 ANBpYryuT3S4kpHRIZEFsbO3SO2/GKgkVREkCFFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Linus Walleij <linusw@kernel.org>,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/595] ARM: 9484/1: enable interrupts when unhandled user faults are triggered
Date: Wed, 30 Sep 2026 17:21:22 +0200
Message-ID: <20260930152351.807223310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index c16d6a293b97c..622fa99e138f6 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -533,6 +533,9 @@ do_DataAbort(unsigned long addr, unsigned int fsr, struct pt_regs *regs)
 	if (!inf->fn(addr, fsr & ~FSR_LNX_PF, regs))
 		return;
 
+	if (likely(user_mode(regs)))
+		local_irq_enable();
+
 	pr_alert("8<--- cut here ---\n");
 	pr_alert("Unhandled fault: %s (0x%03x) at 0x%08lx\n",
 		inf->name, fsr, addr);
@@ -571,6 +574,9 @@ do_PrefetchAbort(unsigned long addr, unsigned int ifsr, struct pt_regs *regs)
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



