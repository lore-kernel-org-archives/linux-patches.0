Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1AF25B099;
	Wed, 30 Sep 2026 15:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782918; cv=none; b=tLUVU9Gxr8KIE5Lpt39hQWtsHQNA4hozyvcNUeNfzKjdh3iKrlB15WTGhrgNThx0H7aITmLvQIe4BHfOmH9+nw1Iv5GUewFS3MdzbEzZGgRPSOc66AsExpm+Le34kpugrfuyMGU+EdrH8LbKfERIddM2OM1ima6XY7bjNr2Jg5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782918; c=relaxed/simple;
	bh=YUQ1rb1cyiODMUny11s4rN1NtKvqn7S48P7PMgLvsDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcOsQwoJHPj2qCRkUFJYGmjWp2+0FOZf1K4szFmfFbYDTVSjU51iFE3yUdUu/FJe3/jjzh4ra22TfD05Hh8+ZdFfLdFxhlvn9Bh98Afy/REvcQA0zn8IfgXh6WBEG4YeIoEud/WRXdrCWHy9rQj+NVzZA5zE1hgv4HnjW3mp+1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFJz9Pab; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFJz9Pab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654BD1F00893;
	Wed, 30 Sep 2026 15:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782910;
	bh=yXDktGdMyxjSTApaz+Y7590fNQxPhl1YuRSokuF49As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bFJz9PabYmkQ2UPkZQsr2tqvUHYHNjsXHBFUd+nG9i9qGCKNLwCNWecCEWOEW1WHq
	 lnIZVTtsWxrtyKwLZcme9EGKA7R7NxLPU07znque2zyD1XeVGrbIlZ6jPruOYlHh0d
	 8zEWYn7/hBAt7BshOisO9VzpOYxxeetSsBShxGuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Hu <hupu@transsion.com>,
	Hongyan Xia <hongyan.xia@transsion.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 168/595] arm64: kprobes: Allow reentering kprobes while single-stepping
Date: Wed, 30 Sep 2026 17:21:01 +0200
Message-ID: <20260930152351.353410564@linuxfoundation.org>
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

From: Pu Hu <hupu@transsion.com>

[ Upstream commit 23f851ac0078a908bf3422d6467ebc1db5828c46 ]

A kprobe can be hit while another kprobe is in KPROBE_HIT_SS state. This
can happen when tracing or perf code runs from the debug exception path
while the first kprobe is preparing or executing its out-of-line
single-step instruction.

Currently arm64 treats a kprobe hit in KPROBE_HIT_SS as unrecoverable,
the same as a hit in KPROBE_REENTER. This is too strict. A hit in
KPROBE_HIT_SS is still a one-level reentry and can be handled by saving
the current kprobe state and setting up single-step for the new probe,
just like reentry from KPROBE_HIT_ACTIVE or KPROBE_HIT_SSDONE.

The truly unrecoverable case is hitting another kprobe while already in
KPROBE_REENTER, because the reentry save area has already been consumed.

Move KPROBE_HIT_SS to the recoverable reentry cases and leave
KPROBE_REENTER as the unrecoverable nested reentry case.

This change also requires saving saved_irqflag in struct prev_kprobe.
When a nested kprobe calls kprobes_save_local_irqflag(), it overwrites
kcb->saved_irqflag with the currently masked DAIF value, losing the
outer kprobe's original DAIF state. Without this fix, when the outer
kprobe's single-step finishes, kprobes_restore_local_irqflag() applies
the wrong DAIF mask and leaves interrupts permanently disabled.

Extend struct prev_kprobe with a saved_irqflag field and save/restore it
alongside kp and status. This ensures the outer kprobe's original
interrupt state is preserved across reentry.

This mirrors the x86 fix in commit 6a5022a56ac3
("kprobes/x86: Allow to handle reentered kprobe on single-stepping").

Signed-off-by: Pu Hu <hupu@transsion.com>
Signed-off-by: Hongyan Xia <hongyan.xia@transsion.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kprobes.h   |  6 ++++++
 arch/arm64/kernel/probes/kprobes.c | 23 ++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kprobes.h b/arch/arm64/include/asm/kprobes.h
index 8699ce30f587e..0a15d23296273 100644
--- a/arch/arm64/include/asm/kprobes.h
+++ b/arch/arm64/include/asm/kprobes.h
@@ -26,6 +26,12 @@
 struct prev_kprobe {
 	struct kprobe *kp;
 	unsigned int status;
+
+	/*
+	 * The original DAIF state of the outer kprobe, saved here before
+	 * a nested kprobe overwrites kcb->saved_irqflag during reentry.
+	 */
+	unsigned long saved_irqflag;
 };
 
 /* Single step context for kprobe */
diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index 798c3e78b84bb..412afe22257d9 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -145,12 +145,27 @@ static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	kcb->prev_kprobe.kp = kprobe_running();
 	kcb->prev_kprobe.status = kcb->kprobe_status;
+
+	/*
+	 * Save the outer kprobe's original DAIF flags before the nested
+	 * kprobe calls kprobes_save_local_irqflag() and overwrites
+	 * kcb->saved_irqflag. Without this, the outer kprobe will restore
+	 * the wrong DAIF state and leave interrupts permanently masked.
+	 */
+	kcb->prev_kprobe.saved_irqflag = kcb->saved_irqflag;
 }
 
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
+
+	/*
+	 * Restore the outer kprobe's saved_irqflag so that when its
+	 * single-step completes, kprobes_restore_local_irqflag() uses
+	 * the correct original DAIF value.
+	 */
+	kcb->saved_irqflag = kcb->prev_kprobe.saved_irqflag;
 }
 
 static void __kprobes set_current_kprobe(struct kprobe *p)
@@ -225,10 +240,16 @@ static int __kprobes reenter_kprobe(struct kprobe *p,
 	switch (kcb->kprobe_status) {
 	case KPROBE_HIT_SSDONE:
 	case KPROBE_HIT_ACTIVE:
+	case KPROBE_HIT_SS:
+		/*
+		 * A probe can be hit while another kprobe is preparing or
+		 * executing its XOL single-step instruction. This is still a
+		 * recoverable one-level reentry, so handle it in the same way as
+		 * reentry from KPROBE_HIT_ACTIVE or KPROBE_HIT_SSDONE.
+		 */
 		kprobes_inc_nmissed_count(p);
 		setup_singlestep(p, regs, kcb, 1);
 		break;
-	case KPROBE_HIT_SS:
 	case KPROBE_REENTER:
 		pr_warn("Unrecoverable kprobe detected.\n");
 		dump_kprobe(p);
-- 
2.53.0



