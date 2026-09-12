Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799FF4BEE38;
	Sat, 12 Sep 2026 16:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229837; cv=none; b=gXIBmB/7wYkJbsMVfCbWO95bVokZdzEeotR5spdadfUM3aZZzkWW22KreeRf4jDhYOKBnNXgMyqmB5o8u5GdaIFXpmRwsCUZn3TMvBgVJyG+OrI1Xo6QoIj8JxaTnuLilhiRKIZkUcbkN06BcOPq/e2QdHXmLuMBtpnW3XSYnvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229837; c=relaxed/simple;
	bh=CSsVp6MxaTJ5g1BzfpbHQdwr8bh7szCD1nUy/vtB4Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I3cD4wxYwa1P9qvKLiYmVqFxGV/gYd5NfpaFnS9/Wkhm+mcoKQtMP/fan/qTjHHyYbj6RuS5Rg1bqw+LrjwRrpZMH1yrK7v/CyNMf451qhqCL+y0cb2AxYf4Jq/s/X/4MJ5oqHt8OMRQYW/VJJPqhPVIv+hO31/9vwqIowFnoOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXwdJ8kh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXwdJ8kh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179081F000FF;
	Sat, 12 Sep 2026 16:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229835;
	bh=UIuwLazoyW5cLe5osVjD/lM6J93h/XiQZE4qxeiblKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tXwdJ8kh+w9lP46nDZJJ2gMjqtN131+P9P/j2SC8lbv1zEurdCA9nWsoH+o1eKMOp
	 /MLUaXIbC9b+6Kl6Pm8KCJNycYzOimqJsw/PfQr4UqIPr/Gh5DEFMsetVOqNqGq7wT
	 3FaJ0JTehIttLCGTnPRIMs+f3DQOPwEbKH0biBhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0671/1191] kcsan: avoid unintended access checking in NMIs
Date: Sat, 12 Sep 2026 08:56:39 +0200
Message-ID: <20260912065603.328851940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Elver <elver@google.com>

[ Upstream commit a8488ecbd7ba44d65b912dfe88a73f438eba2447 ]

If a watcher deliberately disables interrupts (either by user choice, or
because we're dealing with a scoped reordered access) to avoid detecting
any data races in interrupts, NMIs are still able to fire.

When we set up a watchpoint on a scoped reordered access, we disabled
interrupts because the same CPU cannot observe reordering of its own
accesses. To ensure we observe no false positives from NMIs, disable
access checking for interrupt contexts as well.

Fixes: 69562e4983d9 ("kcsan: Add core support for a subset of weak memory modeling")
Signed-off-by: Marco Elver <elver@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kcsan/core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
index 8a7baf4e332e3..2db82661cd60a 100644
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -585,8 +585,14 @@ kcsan_setup_watchpoint(const volatile void *ptr, size_t size, int type, unsigned
 	 * information is lost if dirtied by KCSAN.
 	 */
 	kcsan_save_irqtrace(current);
-	if (!interrupt_watcher)
+	if (!interrupt_watcher) {
 		local_irq_save(irq_flags);
+		/*
+		 * NMIs can still fire, disable checking for all interrupt
+		 * contexts.
+		 */
+		raw_cpu_ptr(&kcsan_cpu_ctx)->disable_count++;
+	}
 
 	watchpoint = insert_watchpoint((unsigned long)ptr, size, is_write);
 	if (watchpoint == NULL) {
@@ -699,8 +705,10 @@ kcsan_setup_watchpoint(const volatile void *ptr, size_t size, int type, unsigned
 	atomic_long_dec(&kcsan_counters[KCSAN_COUNTER_USED_WATCHPOINTS]);
 
 out_unlock:
-	if (!interrupt_watcher)
+	if (!interrupt_watcher) {
+		raw_cpu_ptr(&kcsan_cpu_ctx)->disable_count--;
 		local_irq_restore(irq_flags);
+	}
 	kcsan_restore_irqtrace(current);
 	ctx->disable_scoped--;
 
-- 
2.53.0



