Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE3B41BA94;
	Sat, 12 Sep 2026 10:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207786; cv=none; b=KqQs7a+xP6VVeMNcHMGAkv94BU1UqMhoSigKtDKc5bX9U+mXhHf7nhGA1wK5pJNjwqGPdWap233MeaSwZl4qhpKo4CQlWGjrGuj5jXfo8QRwQB9npTPxmJsBaxRsS8Wsnaiuo/3DAJS/GIKovpxWyLswLQZFcilXjMOZXCsN23s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207786; c=relaxed/simple;
	bh=VTOxATjKAi+kQ/UUCR72bNPni9xGtL1BAvlJ5a8vbQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s/BjwTnOyvIol9PH79gG3VGiqEdCtqs9nyCeBEZTzjTlLIM6KiiufKseHpZBh9jbeNrvySTM+9UkvGTBj7yHyDxcWpXy8Y2A1PvfySgnxeVUX2mGsKdQbbyvc0S2ErrYcotGhZAjLZMs+1Xs87ZxHC2MuXHpoy0JYXkwJO+moEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlhV9vrh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlhV9vrh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC62B1F000FF;
	Sat, 12 Sep 2026 10:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207784;
	bh=EbMl/xCpNlWrupJyfmD14R1+9IPm/4f+Ct35pIAbqjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vlhV9vrhdFodPXhp4DqZKH9fu1pgqiW+V6h25Ox57g95Mq9nxFNwZ9cGo15rvMxfs
	 cUg+S9zSoY5PKo+bkRhVdBka6qblMAIa7RT9LjUVDAwnGG8dajIUz/wQlvz08lxWQe
	 XTBtXmymslfJ9BoqEgmsOJ73tyYZABA1HIuLTAjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0484/1518] kcsan: avoid unintended access checking in NMIs
Date: Sat, 12 Sep 2026 08:44:13 +0200
Message-ID: <20260912065634.397155506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



