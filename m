Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D9051FCC2;
	Wed, 30 Sep 2026 18:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791242; cv=none; b=arH6p1HXDaXMrqjwmahH41HyIW8HOyppdmKw7LeuaUF4HmAao3nSN+FFNyGWPr+6t+7/0HmoUykRaymvRxMz09pajMiP3zo8mT4vMwd+fnmDQxJOh+HVwIOsSzqRNG41+N9QedEfCHDS44ofVpNVQ+2pNo3u4xjsxReq+KqzAYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791242; c=relaxed/simple;
	bh=FJe5aluaPmILJfT44/tkfaPPBu+GQPj0dJux4jYFcKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mrr7bvqtRz2QbJecs0VAgpg2qB47l09Mv1aeCryS2tnkgBINPuhS9wlo7XwkJCxOxjjf03xzxltPZE/NS72LFaFp5bj48zauIob2rg0y8/OasVz+gT657cLPfkvyTpufcCT2W/pZZJaLveeSca+ZJ5AVBffB0ojcp1MjABaYBds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHBBMV8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHBBMV8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5531F000FF;
	Wed, 30 Sep 2026 18:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791241;
	bh=IMSWRC8ynk1rXqD/vGULsbCKbnZw9PC+hw5mc/JZLPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHBBMV8YCht2vF/akhCS4hGci/JhFFhEl3jSBFBUr56RUouRYEpJUxAJ7tWSykPGq
	 dmpXAxRVBNGbEIK43wNa2T6oj/8t9mQmtMHm633U81b31vhPYfxZ1qduQDEh0bxC6e
	 CEwqH69PU8Btry182AUpnaU2sWNpIam+nwY7LFEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Linus Walleij <linusw@kernel.org>,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 234/752] ARM: 9484/1: enable interrupts when unhandled user faults are triggered
Date: Wed, 30 Sep 2026 17:21:44 +0200
Message-ID: <20260930152403.328349258@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



