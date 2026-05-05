Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E843732548B;
	Tue,  5 May 2026 09:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974759; cv=none; b=oHcyx0qgXD6tdEAzYvOXt1Jv4Y35ch8QzRwLq7DfPhC7rptfaMiXzdUHolhqBQC2F1go5k76Q0qYWfRwCkrdvM69gbwEwumwvXODB7I0hHX/ydmJ7GUGwVzxHeaULleG55EUpmjYc6vW674pLkp7iduaF6+O8dSyCNkie9v2ojs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974759; c=relaxed/simple;
	bh=a81S8V8xAXX06xMh6+LdpxELBlpViKfnI6svXCZyCUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lvf8E5gAcJdA4IaPaH/WajLag4iMHbXFrJBi6LzwGJR/NJ1zbrcvNuNpZNPdVqm8/nflOmr6Mx7O26pddONJ9gjEo9uYVmBmDujPk+XWe3+6n8t4X1aoJfLc02e2OpnzggVHNEjtbG8KWHd17/l8t45bErq1USaLFOH8eMpLlPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EjX0NgsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EjX0NgsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A317C2BCF4;
	Tue,  5 May 2026 09:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974758;
	bh=a81S8V8xAXX06xMh6+LdpxELBlpViKfnI6svXCZyCUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EjX0NgsGKgSSX3y1EAN9mTypF/U1+B5atgelGigibIiasClbotJhbqSV5+iWB4qzc
	 raMduG74Vtu8iJP2vZ38yCQzB/agy5GRNb/EIBUP5589jOWgnurcETCZGn9m7AtiZB
	 DeVYddHV2l/MHVPMhUspBdxs7GsuXOjHB4X9xyM4sEX/gLi1YXEMT/K35vQ3fsNfiZ
	 9/l/L21Tm+PMTbG7ZSgfHj0D25yB1mMQZp+M7RMLvwG7ZbCDM9RuggGk36fWk6ellF
	 LHKehTNj/w34WDccQ6bccUFEu9wwyKw2gRG489LuVTIabrth85hlCmtrs15HckrBEb
	 KZ/gknO/4GtyA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dylan Wu <fredwudi0305@gmail.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	peter.chen@cixtech.com,
	fugang.duan@cixtech.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] mailbox: cix: Add IRQF_NO_SUSPEND to mailbox interrupt
Date: Tue,  5 May 2026 05:51:31 -0400
Message-ID: <20260505095149.512052-15-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505095149.512052-1-sashal@kernel.org>
References: <20260505095149.512052-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dylan Wu <fredwudi0305@gmail.com>

[ Upstream commit 80784b427970219ebc338a6fb4118cde67a6c317 ]

During the system suspend process, device interrupts are masked in the
noirq phase. However, SCMI often needs to exchange final messages with the
firmware to complete the power-down transition. Without the IRQF_NO_SUSPEND
flag, the mailbox ISR cannot run during this late stage, leading to SCMI
communication timeouts and error messages like "SCMI protocol wait for
resp timeout" during suspend.

Add the IRQF_NO_SUSPEND flag to the interrupt request to ensure the mailbox
can continue to handle responses during the noirq stages of suspend and
resume, thereby ensuring a reliable power state transition.

Signed-off-by: Dylan Wu <fredwudi0305@gmail.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase Walkthrough

### Phase 1: Commit Message Forensics
Step 1.1 Record: subsystem is `mailbox: cix`; action verb is `Add`;
claimed intent is to add `IRQF_NO_SUSPEND` so the CIX mailbox interrupt
can run during suspend/resume noirq phases.

Step 1.2 Record: tags present are `Signed-off-by: Dylan Wu
<fredwudi0305@gmail.com>` and `Signed-off-by: Jassi Brar
<jassisinghbrar@gmail.com>`. No `Fixes:`, `Reported-by:`, `Tested-by:`,
`Reviewed-by:`, `Acked-by:`, `Link:`, or `Cc: stable@vger.kernel.org`
tags were present.

Step 1.3 Record: the commit describes SCMI response timeouts during
suspend because device IRQs are masked in noirq, preventing the mailbox
ISR from handling firmware responses. Symptom recorded in the message:
`"SCMI protocol wait for resp timeout"` during suspend. Root cause: the
CIX mailbox IRQ was requested with flags `0`, so it is suspended with
ordinary device IRQs.

Step 1.4 Record: yes, this is a hidden bug fix despite the `Add`
wording. It fixes a power-management failure mode on existing CIX SCMI
mailbox users.

### Phase 2: Diff Analysis
Step 2.1 Record: one file changed, `drivers/mailbox/cix-mailbox.c`; 1
insertion, 1 deletion. Modified function: `cix_mbox_startup()`. Scope:
single-file surgical fix.

Step 2.2 Record: before, `cix_mbox_startup()` called
`request_irq(priv->irq, cix_mbox_isr, 0, ...)`. After, it calls the same
ISR with `IRQF_NO_SUSPEND`. This affects mailbox channel startup and
later suspend/resume IRQ handling, not message formatting or normal send
logic.

Step 2.3 Record: bug category is suspend/resume hardware/firmware
communication workaround. The specific mechanism is that SCMI over the
CIX mailbox needs interrupt-driven completion during noirq
suspend/resume, but the IRQ was suspendable.

Step 2.4 Record: fix quality is high: one flag added to an existing IRQ
request, no new API, no data structure change, no refactor. Regression
risk is low. The main theoretical risk of `IRQF_NO_SUSPEND` is keeping
an IRQ active during noirq, but kernel documentation says that is the
intended use for special-purpose interrupts, and this request is not
using `IRQF_SHARED`.

### Phase 3: Git History Investigation
Step 3.1 Record: `git blame` shows the affected `request_irq(..., 0,
...)` line was introduced by `fe2aa2361ddba8f4ccf05123e0e14e9fb70ea701`
(`mailbox: add CIX mailbox driver`). `git describe --contains` places it
in `v6.17-rc1`; `git merge-base` confirmed it is not in `v6.16` and is
in `v6.17`.

Step 3.2 Record: no `Fixes:` tag is present. I still inspected the
introducing commit: it added the whole CIX mailbox driver, including the
suspendable IRQ request. The driver introduction exists in stable-
relevant `v6.17+` history, but not older trees.

Step 3.3 Record: recent file history shows `fe2aa2361ddba` driver
introduction, `dfd997b1e24c` typo fix, and candidate `80784b427970`.
Between `v7.0` and the candidate there is also `89e5d7d61600` removing
an internal header include, but `git apply --check` confirmed the
candidate patch applies to the current 7.0 tree without that being a
functional prerequisite.

Step 3.4 Record: `git log --author='Dylan Wu' -10 -- drivers/mailbox`
found no prior local mailbox commits by Dylan Wu. The patch was
committed and signed off by Jassi Brar, and `MAINTAINERS` verifies Jassi
is the `MAILBOX API` maintainer.

Step 3.5 Record: dependencies found: none for the actual change.
`IRQF_NO_SUSPEND` is available via existing interrupt headers, and the
same `request_irq` line exists in `v6.17` and `v7.0`.

### Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c 80784b427970219ebc338a6fb4118cde67a6c317`
found the original thread at `https://patch.msgid.link/20260209083452.15
4983-1-fredwudi0305@gmail.com`. `b4 dig -a` found only v1. The saved
mbox shows Jassi replied: “Applied to mailbox/for-next”. No NAKs or
concerns were present in the fetched thread.

Step 4.2 Record: `b4 dig -w` shows the original recipients included
Dylan Wu, Peter Chen, Fugang Duan, Jassi Brar, `cix-kernel-
upstream@cixtech.com`, `linux-arm-kernel`, and `linux-kernel`.
`MAINTAINERS` confirms Peter Chen/Fugang Duan as CIX maintainers and
Jassi Brar as mailbox maintainer.

Step 4.3 Record: there were no `Link:` or `Reported-by:` tags. Web
search for the exact timeout plus CIX did not find a separate public bug
report. The only verified bug report source is the commit/thread text
itself.

Step 4.4 Record: b4 found this as a standalone single-patch series, not
a multi-patch dependency.

Step 4.5 Record: direct `WebFetch` for lore stable search was blocked by
Anubis. Web search for exact subject plus `stable` found no stable-
specific discussion. This is an unresolved external-history gap, not a
technical blocker.

### Phase 5: Code Semantic Analysis
Step 5.1 Record: modified function is `cix_mbox_startup()`.

Step 5.2 Record: caller chain verified in code: SCMI mailbox transport
calls `mbox_request_channel()`; mailbox core calls
`__mbox_bind_client()`; that calls `chan->mbox->ops->startup(chan)`,
which is `cix_mbox_startup()` for this driver.

Step 5.3 Record: key callees in `cix_mbox_startup()` are
`request_irq()`, `cix_mbox_read()`, and `cix_mbox_write()` to enable
ACK, doorbell, FIFO, or fast-channel interrupts depending on channel
type.

Step 5.4 Record: reachability is verified for CIX SCMI:
`arch/arm64/boot/dts/cix/sky1.dtsi` defines `arm,scmi` with `mboxes =
<&mbox_ap2pm 8>, <&mbox_pm2ap 8>`, and those mailbox nodes use
`compatible = "cix,sky1-mbox"`. This path is used by firmware
communication, including SCMI. Unprivileged triggering was not verified.

Step 5.5 Record: similar patterns exist in mailbox drivers: `tegra-hsp`,
`sprd-mailbox`, `qcom-ipcc`, `qcom-cpucp`, `mailbox-th1520`,
`bcm2835-mailbox`, and `bcm74110-mailbox` use `IRQF_NO_SUSPEND`. Related
commits for `qcom-cpucp` and `bcm2835` fixed SCMI/firmware timeout
failures during suspend/resume with the same flag.

### Phase 6: Stable Tree Analysis
Step 6.1 Record: buggy CIX code exists from `v6.17-rc1` onward. Verified
not in `v6.16`, verified in `v6.17` and `v7.0`, and candidate is
contained in `v7.1-rc2` but not `v7.0`.

Step 6.2 Record: expected backport difficulty is clean or very minor.
`git apply --check` succeeded on the current 7.0 tree, and the exact
buggy request line exists in `v6.17` and `v7.0`.

Step 6.3 Record: no alternate CIX-specific fix was found in local
history or exact-subject stable search. Similar mailbox fixes exist for
other drivers, but not this CIX driver.

### Phase 7: Subsystem And Maintainer Context
Step 7.1 Record: subsystem is `drivers/mailbox`, platform-specific CIX
mailbox used by SCMI firmware communication. Criticality is platform-
specific but important for affected CIX systems because suspend/resume
and firmware messaging are core platform operations.

Step 7.2 Record: CIX mailbox file activity is low: driver introduction,
a typo fix, header cleanup, and this fix. Mailbox subsystem has
established maintainer coverage through Jassi Brar.

### Phase 8: Impact And Risk
Step 8.1 Record: affected users are CIX Sky1/ARCH_CIX systems with
`CONFIG_CIX_MBOX`; `arch/arm64/configs/defconfig` enables
`CONFIG_CIX_MBOX=y`.

Step 8.2 Record: trigger condition is system suspend/resume noirq while
SCMI needs mailbox responses. Commonness depends on affected hardware
and use of suspend/resume. Unprivileged trigger was not verified.

Step 8.3 Record: failure mode is SCMI response timeout during
suspend/resume, causing unreliable power-state transition. Severity:
HIGH for affected systems; not verified as panic/data
corruption/security.

Step 8.4 Record: benefit is high for affected CIX SCMI systems because
it fixes suspend/resume firmware communication. Risk is low: one-line
IRQ flag change, no shared IRQ flag, no ABI/API change.

### Phase 9: Final Synthesis
Step 9.1 Record: evidence for backporting: real suspend/resume timeout
described; code path verified from CIX SCMI DT through SCMI mailbox
transport into mailbox startup; kernel docs verify ordinary device IRQs
are disabled during noirq and `IRQF_NO_SUSPEND` is the intended
mechanism; fix is one line; analogous mailbox fixes exist; applies to
current 7.0 tree; buggy driver exists in `v6.17+`. Evidence against: no
`Fixes`, no reporter/tester tag, no external bug report found, no
hardware test performed here, and relevance is limited to CIX platforms.

Step 9.2 Record: stable rules checklist: obviously correct and tested by
maintainer acceptance, but hardware testing is unverified; fixes a real
user-visible bug per commit and verified code path; important issue
because suspend/resume firmware communication can time out; small and
contained at 1 line; no new feature/API; can apply to at least current
7.0 tree and likely `v6.17+`.

Step 9.3 Record: exception category: hardware/platform workaround for
suspend/resume mailbox/firmware communication, analogous to accepted
mailbox `IRQF_NO_SUSPEND` fixes.

Step 9.4 Record: decision is YES. This is a small, targeted platform
power-management fix for a real suspend/resume failure mode, with low
regression risk and verified applicability to stable trees that contain
the CIX mailbox driver.

## Verification
- [Phase 1] `git show --format=fuller --stat --patch
  80784b427970219ebc338a6fb4118cde67a6c317`: verified subject, body,
  tags, author/committer, and one-line diff.
- [Phase 2] Same `git show`: verified `drivers/mailbox/cix-mailbox.c`
  changes only `request_irq()` flags in `cix_mbox_startup()`.
- [Phase 3] `git blame -L 401,410 -- drivers/mailbox/cix-mailbox.c`:
  verified buggy line introduced by `fe2aa2361ddba`.
- [Phase 3] `git show --no-patch --format=fuller fe2aa2361ddba`:
  verified CIX mailbox driver introduction and maintainer/reviewer tags.
- [Phase 3] `git describe --contains` and `git merge-base --is-
  ancestor`: verified driver starts in `v6.17-rc1`, not `v6.16`;
  candidate is in `v7.1-rc2`, not `v7.0`.
- [Phase 3] `git apply --check`: verified candidate patch applies to
  current 7.0 tree.
- [Phase 4] `b4 dig -c`, `-a`, `-w`, and saved mbox: verified lore
  thread, single v1 series, recipients, and maintainer “Applied to
  mailbox/for-next” reply.
- [Phase 5] `ReadFile`/`rg` on `drivers/mailbox/mailbox.c`, SCMI mailbox
  transport, and CIX DTS: verified call path and CIX SCMI mailbox use.
- [Phase 5] `rg IRQF_NO_SUSPEND drivers/mailbox`: verified similar
  mailbox drivers use this flag.
- [Phase 6] `git show v6.17:drivers/mailbox/cix-mailbox.c` and
  `v7.0:...`: verified the same suspendable `request_irq(..., 0, ...)`
  line exists.
- [Phase 7] `MAINTAINERS`: verified CIX and mailbox maintainers.
- [Phase 8] `Documentation/power/suspend-and-interrupts.rst` and
  `kernel/irq/pm.c`: verified noirq IRQ masking and `IRQF_NO_SUSPEND`
  semantics.
- UNVERIFIED: real CIX hardware test result.
- UNVERIFIED: direct apply check on every stable branch/tag, though code
  presence and current-tree apply were verified.
- UNVERIFIED: separate public bug report beyond commit message/thread;
  lore WebFetch stable search was blocked by Anubis.

**YES**

 drivers/mailbox/cix-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/cix-mailbox.c b/drivers/mailbox/cix-mailbox.c
index 443620e8ae37f..933820b12772d 100644
--- a/drivers/mailbox/cix-mailbox.c
+++ b/drivers/mailbox/cix-mailbox.c
@@ -405,7 +405,7 @@ static int cix_mbox_startup(struct mbox_chan *chan)
 	int index = cp->index, ret;
 	u32 val;
 
-	ret = request_irq(priv->irq, cix_mbox_isr, 0,
+	ret = request_irq(priv->irq, cix_mbox_isr, IRQF_NO_SUSPEND,
 			  dev_name(priv->dev), chan);
 	if (ret) {
 		dev_err(priv->dev, "Unable to acquire IRQ %d\n", priv->irq);
-- 
2.53.0

