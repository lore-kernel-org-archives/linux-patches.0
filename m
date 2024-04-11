Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C331487C1;
	Thu, 11 Apr 2024 10:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832154; cv=none; b=dZOUemKGymol7BqvJrQd74AvNiXnvJQFvaUuypJg65+fFSTME3bwomsEXqeBo5G15fMvEm4DXv7g4mP7+5vlbjY+Y7AC7xFGEZsqVQZRTadYQp5l1eXnxmm+EGnzchxN74aYt6eJaAZBUdyC9Q5mI3LoTj+xNlGRCX7Yj1C/gE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832154; c=relaxed/simple;
	bh=0SCHghE8voAfYrYlRauv/8U6pV+drh1bpy/ZNiS+H6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3RKMpw91hqiJv/8qHvfv0c6rpxLG+RIF4vtM9fyDR8quq1pyIRXstBoTJOOSfUMYzzVVvZ1/Bl80X/+bnSPOwIxbddPE4qNrCN+AEeb4+om0fZjGVpiChGi3ma1hw7WumFErK9g5viFW87xNZJOJbM/gPj1RIJ3N7bnODv7EF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGuW3fxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGuW3fxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C002C433F1;
	Thu, 11 Apr 2024 10:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832153;
	bh=0SCHghE8voAfYrYlRauv/8U6pV+drh1bpy/ZNiS+H6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGuW3fxg4hCsfqH4WPH/xIvmQLKoOgij1Y00qKApdgaC/YtNmQQCgJNamxb+RQpWh
	 AcLu4Yc7coVJpiRZ8cvKiihA1906Xb28R6qTU9MVo9fMZoxoY4v26UWkaGtdcNRCG3
	 Te9gpauyPT45V7YvZQ3TOyDXusKOt4nA9y3T5hKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 247/294] panic: Flush kernel log buffer at the end
Date: Thu, 11 Apr 2024 11:56:50 +0200
Message-ID: <20240411095443.003646780@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bc39e2b27d315..30d8da0d43d8f 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -427,6 +427,14 @@ void panic(const char *fmt, ...)
 
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



