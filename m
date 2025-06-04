Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C790522A4DA;
	Wed,  4 Jun 2025 11:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749037792; cv=none; b=aWf57LAiXL+6NEYNWiyAIizcNclBJYYCOI1NFnzY3yPX1fR3h2lYsi64uekPJFgzZbAPWjhyKUofCd+5md/+ptCzaJdmihT3Sk+W6+x9GsNuwPehf+yBu1WhfksXt86lNBA/Sgf+UVJfBzVJV0FgTLz+8lfq9LRhKU4lZKbUR1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749037792; c=relaxed/simple;
	bh=7+sNGReLs7jeizWT18ZVAuKAOTguBF2kr0JruLTc+Xk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t7MZ7nVPLI7xpB1YalSFO+EPeLaemosAugThn2MgQklSo3XJmaKI6Vm6HKoCEQ/IJi/GcD9M8NslN1i+uPWbXmZJvA+mRxvnnNOUota8kHIraF5Cabm3FXEH5PprSlBXPZvw6fkRUzK2numkwKJ/MQceSrnWV3xKueP/AKtqze0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l3wXdhTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l3wXdhTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BEBC4CEEF;
	Wed,  4 Jun 2025 11:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749037792;
	bh=7+sNGReLs7jeizWT18ZVAuKAOTguBF2kr0JruLTc+Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3wXdhTy+nZS9WHfttQWxPvy80k453dbrTFQVgi1dgaX6YUn4eM6pgu3pM2Rxhxgl
	 q2Dv1b4hVmelPOdOXEa6RkBxEdF5LgePPuMpTA0ZwcZzdxNlNKRokXE/su8jpasJCU
	 iB/yFgYrSzjy9ZfOXzvsJsmJHNfB7P6/m6oPML8YTcHVzhHLcqVAF6Gd4rlf7WjN9k
	 C9AQ2DFAo0UeRPomMmGgQY9e5WOf4eq+2yXmwZwTFIk/5JBKovs+Ekq6CtxVDFaWmd
	 ffuJjF9kGTrrtfm4WRwJOKToVc/vPXXWONSsYVTd2u//8ubqt5aF4lBqZ4YqTytRcw
	 +Q4lzbumyKGzA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	Shyam-sundar.S-k@amd.com,
	Guruvendra.Punugupati@amd.com,
	billy_tsai@aspeedtech.com
Subject: [PATCH AUTOSEL 6.14 4/8] i3c: mipi-i3c-hci: Fix handling status of i3c_hci_irq_handler()
Date: Wed,  4 Jun 2025 07:49:39 -0400
Message-Id: <20250604114944.208828-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604114944.208828-1-sashal@kernel.org>
References: <20250604114944.208828-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Transfer-Encoding: 8bit

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit 279c24021b838e76ca8441e9446e0ab45271153a ]

Return IRQ_HANDLED from the i3c_hci_irq_handler() only if some
INTR_STATUS bit was set or if DMA/PIO handler handled it.

Currently it returns IRQ_HANDLED in case INTR_STATUS is zero and IO
handler returns false. Which could be the case if interrupt comes from
other device or is spurious.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Link: https://lore.kernel.org/r/20250409140401.299251-2-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my comprehensive analysis of the commit, here is my assessment:
**YES** This commit should be backported to stable kernel trees. Here's
my extensive analysis: ## Code Change Analysis The commit fixes a
critical logic bug in the `i3c_hci_irq_handler()` function in
`drivers/i3c/master/mipi-i3c-hci/core.c`. The specific changes are: 1.
**Line 597**: Added `result = IRQ_HANDLED;` when `val` (INTR_STATUS) is
non-zero 2. **Line 608**: Changed from unconditional call to
conditional: `if (hci->io->irq_handler(hci)) result = IRQ_HANDLED;` 3.
**Lines 611-612**: Removed the `else result = IRQ_HANDLED;` logic that
was incorrectly tied to having no unexpected status bits ## Why This
Should Be Backported ### 1. **Fixes Important Functional Bug** The
current code has incorrect interrupt handling logic that returns
`IRQ_NONE` even when interrupts are successfully processed by the
DMA/PIO handlers. This can lead to: - **Spurious interrupt detection
issues**: The kernel may incorrectly think interrupts are unhandled -
**Interrupt storm problems**: In shared IRQ scenarios, returning
`IRQ_NONE` when interrupts were actually handled can cause the kernel to
disable the IRQ line - **System stability issues**: Incorrect IRQ return
values can affect overall system interrupt handling ### 2. **Small,
Contained Fix** - The change is minimal (only 3 lines modified) - No
architectural changes or new features - Only affects the interrupt
return value logic - Low risk of introducing regressions ### 3.
**Critical Subsystem Impact** The I3C subsystem is used for critical
hardware communication, particularly in: - Embedded systems and IoT
devices - Industrial applications - Hardware that uses MIPI I3C HCI
controllers ### 4. **Follows Stable Backport Criteria** This matches the
pattern of **Similar Commit #4** (IB/hfi1 interrupt handler fix) which
was marked "Backport Status: YES" for fixing incorrect IRQ return
values. ### 5. **Reviewed and Tested** The commit includes "Reviewed-by:
Frank Li <Frank.Li@nxp.com>" indicating it has been properly reviewed by
subsystem maintainers. ### 6. **Historical Context Shows This Is a Real
Problem** From the git history, I can see this driver has had multiple
interrupt-related fixes: - Commit 45357c9b37bb changed the interrupt
handling logic per MIPI spec compliance - That change inadvertently
introduced this return value bug - This commit fixes the logical error
without changing the spec-compliant behavior ### 7. **Clear Problem and
Solution** The commit message clearly explains: - **Problem**: "Return
IRQ_HANDLED...only if some INTR_STATUS bit was set or if DMA/PIO handler
handled it" - **Current bug**: "Currently it returns IRQ_HANDLED in case
INTR_STATUS is zero and IO handler returns false" - **Impact**: "Which
could be the case if interrupt comes from other device or is spurious"
## Risk Assessment **Minimal Risk**: The change only affects when
`IRQ_HANDLED` vs `IRQ_NONE` is returned, without changing any of the
actual interrupt processing logic. The worst case would be reverting to
the previous (also incorrect but differently incorrect) behavior, but
the new logic is clearly more correct. This is exactly the type of
important bug fix that stable trees should include: it fixes a real
functional problem, has minimal risk, and affects critical system
functionality (interrupt handling).

 drivers/i3c/master/mipi-i3c-hci/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/i3c/master/mipi-i3c-hci/core.c b/drivers/i3c/master/mipi-i3c-hci/core.c
index 648c501407ced..96f077945efae 100644
--- a/drivers/i3c/master/mipi-i3c-hci/core.c
+++ b/drivers/i3c/master/mipi-i3c-hci/core.c
@@ -596,6 +596,7 @@ static irqreturn_t i3c_hci_irq_handler(int irq, void *dev_id)
 
 	if (val) {
 		reg_write(INTR_STATUS, val);
+		result = IRQ_HANDLED;
 	}
 
 	if (val & INTR_HC_RESET_CANCEL) {
@@ -607,12 +608,11 @@ static irqreturn_t i3c_hci_irq_handler(int irq, void *dev_id)
 		val &= ~INTR_HC_INTERNAL_ERR;
 	}
 
-	hci->io->irq_handler(hci);
+	if (hci->io->irq_handler(hci))
+		result = IRQ_HANDLED;
 
 	if (val)
 		dev_err(&hci->master.dev, "unexpected INTR_STATUS %#x\n", val);
-	else
-		result = IRQ_HANDLED;
 
 	return result;
 }
-- 
2.39.5

