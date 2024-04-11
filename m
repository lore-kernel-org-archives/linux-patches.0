Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8DF13FD94;
	Thu, 11 Apr 2024 10:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830960; cv=none; b=rsknneE2kawSS36EvzA0OXyRYxTmQGFuVpxsJ5Aj8AkgGNTHOE2Ll7ZihuRTockipsyAqIA6Nz3nDY3fjNO6UQxOZkOa5xWR9qqwpTg35ZnII1Qqcc2i34AIdUMxZtey8tCfgP4Yc/MS6adn8/nnQiNOEW4LF5RQzvxAb8EaEb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830960; c=relaxed/simple;
	bh=mdrLq/5g+CbzAL/b41OKE5lwNRkza0KLGPHusti8wN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsJKu0rp7FqVaFPrstFS3KHdHMQOinyUcKFqgIEb3G6LI6IuOosPkKxoMQTy+NRyXd/Cgicap0lNMD4bFyt+3+KGtKvMvvvdxr2cEzE8YbkVpTkzC3PgohWmBB9hfsilZkK+llzQqp+0cVl6NPoHT/DaFUoP7euANvmcL0xWqTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ifjt8siF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ifjt8siF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10199C433C7;
	Thu, 11 Apr 2024 10:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830959;
	bh=mdrLq/5g+CbzAL/b41OKE5lwNRkza0KLGPHusti8wN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ifjt8siFo442hkPn3CuS+BCY971lETKImiRsXXGup2ebshJzhPPzcpGnRegqFXN0/
	 aQSqgKimpy5LVyEsZT1Nh5QyvxUMmhQCyD0MvAjYkITIcx1HxHCTsMgTd3uiGNy1kk
	 cF3gQ1jKb/GTml8NH0ai/oZXraf/NsvPABAY2Lq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 176/215] panic: Flush kernel log buffer at the end
Date: Thu, 11 Apr 2024 11:56:25 +0200
Message-ID: <20240411095430.161292685@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index cef79466f9417..5559a6e4c4579 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -404,6 +404,14 @@ void panic(const char *fmt, ...)
 
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



