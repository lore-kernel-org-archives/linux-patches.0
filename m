Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AFF15198D;
	Wed,  5 Feb 2025 14:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764197; cv=none; b=T/sywCDKdRsSr5tSER5L6d2PtZs1oGIFv6s0AEF3oPrgnxQQK58SjmKjQ9AW3yk1PxvxArLmSujHGk4Thwr2eY4CcQVHZ1AFKDG2+OiooVB/5W9gLH/sc8IUMdlQMn0Lqv826NYkEwSXYvbYrjkHS7iGgiWpjH1vkXfha7ruigo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764197; c=relaxed/simple;
	bh=CMeZxRgzpjGg/xvlbJkqq4SQEiiHR0K3dAd9u9atmuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsQ34MrvS5aiAwlh9/EkiRDqSZvj5bND1WXWH0p3Q0kz5efwnJ2htEKy/YCLabmHWoHNA7sEnmAxMm8hLvK7imUQ8fFk9CfO1gPQueThcJnQbL+YKTG0EvY12yhW7151x9qNuVZtsCU9AUoiYRs8LTJ2fG+3M4KpjNrm/IWibgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OoD9GENp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OoD9GENp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49DD9C4CED6;
	Wed,  5 Feb 2025 14:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764196;
	bh=CMeZxRgzpjGg/xvlbJkqq4SQEiiHR0K3dAd9u9atmuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OoD9GENpmldk/zd4QF0XgJjUdM5xdauaYqNaGWYbZL8dtEmT1uNkRFxoOl1DgKT1M
	 I0odUwuC8GOcS03yoyqbix7h43IStvFAxP+KQWIEbjkjpxqduHsJbJbE0HB4HB/X3+
	 tqZbHxrJgzgVt1L54P9o3LogzJ+OfP9tXSqCMEw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 056/623] printk: Defer legacy printing when holding printk_cpu_sync
Date: Wed,  5 Feb 2025 14:36:38 +0100
Message-ID: <20250205134458.372188486@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 0161e2d6950fe66cf6ac1c10d945bae971f33667 ]

The documentation of printk_cpu_sync_get() clearly states
that the owner must never perform any activities where it waits
for a CPU. For legacy printing there can be spinning on the
console_lock and on the port lock. Therefore legacy printing
must be deferred when holding the printk_cpu_sync.

Note that in the case of emergency states, atomic consoles
are not prevented from printing when printk is deferred. This
is appropriate because they do not spin-wait indefinitely for
other CPUs.

Reported-by: Rik van Riel <riel@surriel.com>
Closes: https://lore.kernel.org/r/20240715232052.73eb7fb1@imladris.surriel.com
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Fixes: 55d6af1d6688 ("lib/nmi_backtrace: explicitly serialize banner and regs")
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20241209111746.192559-3-john.ogness@linutronix.de
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/internal.h    | 6 ++++++
 kernel/printk/printk.c      | 5 +++++
 kernel/printk/printk_safe.c | 7 ++++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/kernel/printk/internal.h b/kernel/printk/internal.h
index c6bb47666aef6..a91bdf8029671 100644
--- a/kernel/printk/internal.h
+++ b/kernel/printk/internal.h
@@ -338,3 +338,9 @@ bool printk_get_next_message(struct printk_message *pmsg, u64 seq,
 void console_prepend_dropped(struct printk_message *pmsg, unsigned long dropped);
 void console_prepend_replay(struct printk_message *pmsg);
 #endif
+
+#ifdef CONFIG_SMP
+bool is_printk_cpu_sync_owner(void);
+#else
+static inline bool is_printk_cpu_sync_owner(void) { return false; }
+#endif
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 80910bc3470c2..f446a06b4da8c 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -4922,6 +4922,11 @@ void console_try_replay_all(void)
 static atomic_t printk_cpu_sync_owner = ATOMIC_INIT(-1);
 static atomic_t printk_cpu_sync_nested = ATOMIC_INIT(0);
 
+bool is_printk_cpu_sync_owner(void)
+{
+	return (atomic_read(&printk_cpu_sync_owner) == raw_smp_processor_id());
+}
+
 /**
  * __printk_cpu_sync_wait() - Busy wait until the printk cpu-reentrant
  *                            spinning lock is not owned by any CPU.
diff --git a/kernel/printk/printk_safe.c b/kernel/printk/printk_safe.c
index 6f94418d53ffb..6bc40ac8847b5 100644
--- a/kernel/printk/printk_safe.c
+++ b/kernel/printk/printk_safe.c
@@ -61,10 +61,15 @@ bool is_printk_legacy_deferred(void)
 	/*
 	 * The per-CPU variable @printk_context can be read safely in any
 	 * context. CPU migration is always disabled when set.
+	 *
+	 * A context holding the printk_cpu_sync must not spin waiting for
+	 * another CPU. For legacy printing, it could be the console_lock
+	 * or the port lock.
 	 */
 	return (force_legacy_kthread() ||
 		this_cpu_read(printk_context) ||
-		in_nmi());
+		in_nmi() ||
+		is_printk_cpu_sync_owner());
 }
 
 asmlinkage int vprintk(const char *fmt, va_list args)
-- 
2.39.5



