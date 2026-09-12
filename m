Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47B0366052;
	Sat, 12 Sep 2026 12:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216029; cv=none; b=rPuUVx6wOj0sVyYEL692p9yWOdVg3VhMlDA4CK9HjvDk37IgZFdECxPxVkqrCPAxqM/7VVDfDEhCJHUIwyNlTG+Ej4yzhAuiqWlewQ27QkFqW2b6PMcc0eGdNYdfxtoK5SRYd/3wGJMdcJ9dQKks6yZFqk3a1FWe6W9Ol2PTwmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216029; c=relaxed/simple;
	bh=ZF4GhyC77xdMO03Y1iYV/aPBoWreVJtxbrD6KKpQk5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaAYDZT9bTAgpUn+Pgt5YV+1iOzhSFjsy69Ew0Q3Yjb0QkO9IGHw8tzZvi4vbWQSJR/kmLDy0Qxca5S1KRZC1WYGYgMbMA+TK+l3k5pdH1wHxCZgfBr0jt6WQaeLaxq7sgi79or4pwdECVkbO49xp8lV0Jp7i/FIL49c9KQYEKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeVGMLlW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeVGMLlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F73B1F000FF;
	Sat, 12 Sep 2026 12:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216028;
	bh=/dBs/VBqCz26ykXTkqO8713/W7jJPUw47vveaoMtpUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LeVGMLlWXciH+QLfnsPpZODNTuCrlpqDa7gk/HoB1/Y8fkLU7mmE/BFdsKlU3/8Ky
	 vxG+LrSeyDq9R2gmxQz08apul2sikt9ThqKKytuxlFNMHrFZEC2x3KjG6q7TrnvIg8
	 inygNQ7DayU9/ySG5stm97e5XfqtaBWhTz/f9Ems=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0610/1376] kcsan: avoid unintended access checking in NMIs
Date: Sat, 12 Sep 2026 08:50:36 +0200
Message-ID: <20260912065621.136184253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



