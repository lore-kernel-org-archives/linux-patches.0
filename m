Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC2A624;
	Thu, 11 Apr 2024 10:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832407; cv=none; b=hpG5sQHiwInRuqTiBlHAfy09gP8p4asOwZpAlRSeCcrRv5WLUgA4Y4RKFcJxlsK8n+bWwh8k/inxoJrSU/pj/QCJPiN9fCZLhRy2+ZF7TRGPHWgHgE8Wbm0tVRbtmF9NpjpBgCAifOiXu2EVTTKPbYBgqoDOTbJR61RTtw+KnYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832407; c=relaxed/simple;
	bh=6CAHplaGkG1lVaENfvyv+lPpw8mQbdaeCuAIy6mr/aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGXydSm+euEZWrcsEoCAbmlhiPcHgYZ0kUFOSEdNfJNbk9D+QzHRJ7cXx1w3U8N7soo5WhmmXMmf69ptlX/cqQp2ihlcFyVQeci3HQBJ9RB/zG33oDOn0JXIXENiLDwnMQqvol9Pz9RveFYei6XpWtieCgnCyadfgXZhuxKbhb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQpRKGXY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQpRKGXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC54C43390;
	Thu, 11 Apr 2024 10:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832407;
	bh=6CAHplaGkG1lVaENfvyv+lPpw8mQbdaeCuAIy6mr/aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQpRKGXYhraN66+KaxVgbvjA8ry9RbpVCYLLXGMxtpbXrzOQu7MbIC37pDYFdf0mv
	 CaJeLNeg5h3yM7wqZuVsVxKPAuQC6rIAgJXSzcyOqrMXA/N63QiTfspbX55NxWC4yA
	 HMFn5v6en5cMG9Ts7ejUjBMvaSrslYeAflEHFv+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 08/83] panic: Flush kernel log buffer at the end
Date: Thu, 11 Apr 2024 11:56:40 +0200
Message-ID: <20240411095412.928088353@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit d988d9a9b9d180bfd5c1d353b3b176cb90d6861b ]

If the kernel crashes in a context where printk() calls always
defer printing (such as in NMI or inside a printk_safe section)
then the final panic messages will be deferred to irq_work. But
if irq_work is not available, the messages will not get printed
unless explicitly flushed. The result is that the final
"end Kernel panic" banner does not get printed.

Add one final flush after the last printk() call to make sure
the final panic messages make it out as well.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20240207134103.1357162-14-john.ogness@linutronix.de
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/panic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/panic.c b/kernel/panic.c
index 63e94f3bd8dcd..e6c2bf04a32c0 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -441,6 +441,14 @@ void panic(const char *fmt, ...)
 
 	/* Do not scroll important messages printed above */
 	suppress_printk = 1;
+
+	/*
+	 * The final messages may not have been printed if in a context that
+	 * defers printing (such as NMI) and irq_work is not available.
+	 * Explicitly flush the kernel log buffer one last time.
+	 */
+	console_flush_on_panic(CONSOLE_FLUSH_PENDING);
+
 	local_irq_enable();
 	for (i = 0; ; i += PANIC_TIMER_STEP) {
 		touch_softlockup_watchdog();
-- 
2.43.0



