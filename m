Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026C6227EBD;
	Tue,  8 Apr 2025 11:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112635; cv=none; b=acpCnyAqPfeD/loC0gWvWbMKoB0IJ8j1lH+IMRmgZfgwflOCcBQW7rutYpQlI9bYF6LP6QqiY98HuO08PvceVJR3jiAOJCd4MpC0AdqVHZV/VqFDkrpvee9eccCrZoFUh7MrvtCvPbcSZuWu9wZ9Pck4IFivddfLz8pUZv0LLac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112635; c=relaxed/simple;
	bh=sJoGG+M0mk7Mg1zUewmMYJIchDvWyG44evXUPvaupCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKCUc6eI4eiq1eO2Zf6X5C19NjqONZ7J2eSXXjIjatNozCeHJlepCk5/Xg/+aHB1NU+cUsDk+yoOsLbp/W0AjjBSAAhplGuz1OXuVrX3Em1EG7J4xCNaxBGnjN1jxJvpTLX1LB+6YWUCfY8ShsUG7aMFuE5Tu6lOA+l2lOtD1og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUBJcuX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUBJcuX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E127C4CEE5;
	Tue,  8 Apr 2025 11:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112634;
	bh=sJoGG+M0mk7Mg1zUewmMYJIchDvWyG44evXUPvaupCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUBJcuX4BWqEbw36wmyKsgdEQ0KJUL8Qzx0qfvUdAhG1PP2v5QBxOv3UzmDss/aUC
	 T9YdngoWgvpnHG1Wb47GPun41rImdRhhoyjwhftqw7TTThOco1MCr2Xm6ubHnS0xZx
	 4hoRrhbFI2bCAhCESvyoKQjfvq3YWwMW3dcNc/Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/279] lockdep: Dont disable interrupts on RT in disable_irq_nosync_lockdep.*()
Date: Tue,  8 Apr 2025 12:48:44 +0200
Message-ID: <20250408104830.145727367@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 87886b32d669abc11c7be95ef44099215e4f5788 ]

disable_irq_nosync_lockdep() disables interrupts with lockdep enabled to
avoid false positive reports by lockdep that a certain lock has not been
acquired with disabled interrupts. The user of this macros expects that
a lock can be acquried without disabling interrupts because the IRQ line
triggering the interrupt is disabled.

This triggers a warning on PREEMPT_RT because after
disable_irq_nosync_lockdep.*() the following spinlock_t now is acquired
with disabled interrupts.

On PREEMPT_RT there is no difference between spin_lock() and
spin_lock_irq() so avoiding disabling interrupts in this case works for
the two remaining callers as of today.

Don't disable interrupts on PREEMPT_RT in disable_irq_nosync_lockdep.*().

Closes: https://lore.kernel.org/760e34f9-6034-40e0-82a5-ee9becd24438@roeck-us.net
Fixes: e8106b941ceab ("[PATCH] lockdep: core, add enable/disable_irq_irqsave/irqrestore() APIs")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Suggested-by: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250212103619.2560503-2-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/interrupt.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 1f22a30c09637..976bca44bae0c 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -408,7 +408,7 @@ irq_calc_affinity_vectors(unsigned int minvec, unsigned int maxvec,
 static inline void disable_irq_nosync_lockdep(unsigned int irq)
 {
 	disable_irq_nosync(irq);
-#ifdef CONFIG_LOCKDEP
+#if defined(CONFIG_LOCKDEP) && !defined(CONFIG_PREEMPT_RT)
 	local_irq_disable();
 #endif
 }
@@ -416,7 +416,7 @@ static inline void disable_irq_nosync_lockdep(unsigned int irq)
 static inline void disable_irq_nosync_lockdep_irqsave(unsigned int irq, unsigned long *flags)
 {
 	disable_irq_nosync(irq);
-#ifdef CONFIG_LOCKDEP
+#if defined(CONFIG_LOCKDEP) && !defined(CONFIG_PREEMPT_RT)
 	local_irq_save(*flags);
 #endif
 }
@@ -431,7 +431,7 @@ static inline void disable_irq_lockdep(unsigned int irq)
 
 static inline void enable_irq_lockdep(unsigned int irq)
 {
-#ifdef CONFIG_LOCKDEP
+#if defined(CONFIG_LOCKDEP) && !defined(CONFIG_PREEMPT_RT)
 	local_irq_enable();
 #endif
 	enable_irq(irq);
@@ -439,7 +439,7 @@ static inline void enable_irq_lockdep(unsigned int irq)
 
 static inline void enable_irq_lockdep_irqrestore(unsigned int irq, unsigned long *flags)
 {
-#ifdef CONFIG_LOCKDEP
+#if defined(CONFIG_LOCKDEP) && !defined(CONFIG_PREEMPT_RT)
 	local_irq_restore(*flags);
 #endif
 	enable_irq(irq);
-- 
2.39.5



