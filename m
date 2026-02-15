Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EB01474CC;
	Sun, 15 Feb 2026 17:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771177282; cv=none; b=a7Licdae/2j8e3vcgOGsW61TaG5CSJJ5JqY81pmwqxQzOvl7/gBanoUwdXg7ct3Y8/DR6wvAYNARs4brF7H21gMnTTTAoKCUYXJbq1Iew2C8OgROnsZUxbn+JDJR1aVTVC8Z6zn7GIyaIaYvJFttiLp6I2UWbq9q3I5BwJiobNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771177282; c=relaxed/simple;
	bh=E2nT5cOjhtNCy8Ca/IKa1cEk9Sll2tDIBkAmpJKLaX4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gBwOQMe+3tH0P6Qm6CMhaAcFWth5VZLKnsaVXS1SfT6xDsXUPx4vl7gh3FoMAbssqJ0vrS37xfR70Y8ndj4wYef1sylx0PqoYYTRWTD2TVOlwuzrjikaoTohrTORYZQPDf9/SUHMcgRmrsIv9422CpIo4Uk8Cg/SLV8XR2n8/6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RLkV2ZuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RLkV2ZuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEA7C4CEF7;
	Sun, 15 Feb 2026 17:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771177282;
	bh=E2nT5cOjhtNCy8Ca/IKa1cEk9Sll2tDIBkAmpJKLaX4=;
	h=From:To:Cc:Subject:Date:From;
	b=RLkV2ZuZpPfGcHiTeYa2mqUF+epx+4gu7Jp/QT/cTgBPzKET3Kb30VWOhlwlc+jB5
	 TwOOMT0NVU2xjNZPcauhlblM3RqodKdD37sYeBcDmx5J8lKE0QiMvsk68527XyE1FI
	 ot3SenH29fTvmZett9gghgb7sYJuolIYTgkOLakqsRRg+kep9xEChEoyNYnI4J0m9N
	 wLJ1Y8PvEhOKbiaixEjFTVN0/DbYscVyNRtQfI3Zg8TelqLSVuvmEY5+bdHDx/1bXU
	 rmNoWRrRN0X8OTDegOw16yuz9N1s594dhkXky6XeIZWFqSf+zRC+65IQ/6FXSApbi8
	 GYG1cUfjSVhzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.19-5.10] mailbox: bcm-ferxrm-mailbox: Use default primary handler
Date: Sun, 15 Feb 2026 12:41:09 -0500
Message-ID: <20260215174120.2390402-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit fa84883d44422208b45869a67c0265234fdce1f0 ]

request_threaded_irq() is invoked with a primary and a secondary handler
and no flags are passed. The primary handler is the same as
irq_default_primary_handler() so there is no need to have an identical
copy.
The lack of the IRQF_ONESHOT can be dangerous because the interrupt
source is not masked while the threaded handler is active. This means,
especially on LEVEL typed interrupt lines, the interrupt can fire again
before the threaded handler had a chance to run.

Use the default primary interrupt handler by specifying NULL and set
IRQF_ONESHOT so the interrupt source is masked until the secondary
handler is done.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Both commits are the same patch. The one being evaluated (fa84883d44422,
signed by Jassi Brar) is the one from the mailbox tree.

## Summary of Analysis

### What the commit fixes

The commit fixes a missing `IRQF_ONESHOT` flag in
`request_threaded_irq()` for the BCM FlexRM mailbox driver. The existing
code had a custom primary handler (`flexrm_irq_event`) that was
functionally identical to the kernel's `irq_default_primary_handler()` —
it simply returned `IRQ_WAKE_THREAD`. However, because the code didn't
set `IRQF_ONESHOT`, the interrupt line is not masked while the threaded
handler runs. On level-triggered interrupt lines, this can cause an
interrupt storm (the interrupt fires repeatedly before the threaded
handler gets to run).

### Why it matters

1. **Correctness**: Without `IRQF_ONESHOT`, if the interrupt is level-
   triggered (or chained through a level-triggered parent), the
   interrupt will continuously fire between the primary handler
   returning and the threaded handler completing. This is a potential
   interrupt storm / soft lockup.

2. **Author credibility**: Sebastian Siewior is the PREEMPT_RT
   maintainer and a leading expert on interrupt handling in Linux.
   Thomas Gleixner, the IRQ subsystem maintainer, also signed off on
   this patch via the tip tree.

3. **Pattern**: This is part of a systematic series fixing the same
   pattern across multiple drivers (efct, btintel_pcie, fsl-mc, etc.),
   all from the same author.

### Stable kernel criteria

- **Obviously correct**: Yes - removes an exact duplicate of
  `irq_default_primary_handler()` and adds the missing `IRQF_ONESHOT`
  flag. This is the canonical pattern for threaded IRQs.
- **Fixes a real bug**: Yes - missing `IRQF_ONESHOT` can cause interrupt
  storms on level-triggered lines.
- **Small and contained**: Yes - 1 file changed, 2 insertions, 12
  deletions. The change is strictly self-contained.
- **No new features**: Correct - this is purely a bug fix.
- **Risk**: Very low. The behavior is identical except that the
  interrupt line is now properly masked during threaded handler
  execution, which prevents the storm.

### Nuance: MSI vs Level-Triggered

The driver uses platform MSI interrupts for completions (the comment
says "We only have MSI for completions"). MSI interrupts are typically
edge-triggered and may not suffer from the re-assertion problem.
However:
1. Platform MSIs may be chained through parent controllers that ARE
   level-triggered.
2. The underlying IRQ chip may not have `IRQCHIP_ONESHOT_SAFE` set (only
   PCI MSI explicitly sets this).
3. Even if the risk is lower for MSI, adding `IRQF_ONESHOT` is the
   correct defensive practice and has zero downside.
4. The kernel enforcement check (`__setup_irq`) would actually reject
   the new code (handler=NULL without IRQF_ONESHOT) if the chip lacks
   `IRQCHIP_ONESHOT_SAFE`, so `IRQF_ONESHOT` is needed for the code to
   even work.

### Verification

- **Verified** `flexrm_irq_event()` returns only `IRQ_WAKE_THREAD` at
  line 1176-1182 of bcm-flexrm-mailbox.c, identical to
  `irq_default_primary_handler()` at kernel/irq/manage.c:976-979.
- **Verified** `request_threaded_irq()` with handler=NULL uses
  `irq_default_primary_handler` (kernel/irq/manage.c:2128-2132).
- **Verified** `__setup_irq()` requires IRQF_ONESHOT when
  handler==irq_default_primary_handler and chip lacks
  IRQCHIP_ONESHOT_SAFE (kernel/irq/manage.c:1664-1685).
- **Verified** platform MSI irq chips do NOT automatically set
  `IRQCHIP_ONESHOT_SAFE` - only PCI MSI does
  (drivers/pci/msi/irqdomain.c:133,187). No irqchip drivers set it
  either.
- **Verified** the driver has existed since v4.12 (commit
  dbc049eee7300), present in all active stable trees.
- **Verified** the fix is self-contained: only touches 1 file, no
  dependencies on other commits.
- **Verified** author Sebastian Siewior is the PREEMPT_RT maintainer
  with deep IRQ expertise, and this is part of a systematic series.
- **Verified** the commit also went through Thomas Gleixner's tip tree
  (commit 03843d95a4a4e) with his Signed-off-by, confirming IRQ
  subsystem maintainer review.

This is a small, safe, well-understood bug fix from a domain expert that
prevents a potential interrupt storm. It meets all stable kernel
criteria.

**YES**

 drivers/mailbox/bcm-flexrm-mailbox.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/mailbox/bcm-flexrm-mailbox.c b/drivers/mailbox/bcm-flexrm-mailbox.c
index 41f79e51d9e5a..4255fefc3a5a0 100644
--- a/drivers/mailbox/bcm-flexrm-mailbox.c
+++ b/drivers/mailbox/bcm-flexrm-mailbox.c
@@ -1173,14 +1173,6 @@ static int flexrm_debugfs_stats_show(struct seq_file *file, void *offset)
 
 /* ====== FlexRM interrupt handler ===== */
 
-static irqreturn_t flexrm_irq_event(int irq, void *dev_id)
-{
-	/* We only have MSI for completions so just wakeup IRQ thread */
-	/* Ring related errors will be informed via completion descriptors */
-
-	return IRQ_WAKE_THREAD;
-}
-
 static irqreturn_t flexrm_irq_thread(int irq, void *dev_id)
 {
 	flexrm_process_completions(dev_id);
@@ -1271,10 +1263,8 @@ static int flexrm_startup(struct mbox_chan *chan)
 		ret = -ENODEV;
 		goto fail_free_cmpl_memory;
 	}
-	ret = request_threaded_irq(ring->irq,
-				   flexrm_irq_event,
-				   flexrm_irq_thread,
-				   0, dev_name(ring->mbox->dev), ring);
+	ret = request_threaded_irq(ring->irq, NULL, flexrm_irq_thread,
+				   IRQF_ONESHOT, dev_name(ring->mbox->dev), ring);
 	if (ret) {
 		dev_err(ring->mbox->dev,
 			"failed to request ring%d IRQ\n", ring->num);
-- 
2.51.0

