Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F44429B799;
	Sat, 12 Sep 2026 07:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199504; cv=none; b=savCpfQIE+u7OsJRDL08DtF6S4Uleq0B9qNT0AErZKWs5ZnBNEbG8s7SYGq0rDn742ySL4eJjHlLXCOIgDLnOgG3xMZ5lxjJTCepJWku0eTp26G1z8GM5+wg1TpuNUH0aHbkogAljYyzdW93SNi5fU8d+IXzzYlJnVgwJlKGOR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199504; c=relaxed/simple;
	bh=wpDmDFv5dcSbZJyKWsCBBAxgo2iL9tbyogvuYKDWRn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWGexuxwqrcTpxEzKy4+2AUsxRDAG9+rC2KGwjqCXzHb92j682iweQqjgw9pHiLQTvehFc/6UNpV01VCYHOVfYjyqUDiP9wwvWb+JokjJQnDC8aRfqIhiOh8l3fMtdxNZF0TiEWzaMEuMev26kjFGTJ8u9hqpjLcU5wYDXbzGYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vpqTm/6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vpqTm/6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C0F1F000FF;
	Sat, 12 Sep 2026 07:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199503;
	bh=01ThWLQfC0AyZcPnixyvg2Y0mS8fEJ2ziz+DIaFcZbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vpqTm/6S3O+8O479L4EtmLmqsuP16n8pU5PuKzsHtCleytUj+3P+oZHzvmZLWsnDf
	 PtC9LpxKRmX2ndS6nWwUMg/1xhomo/m7p3WQ+0exrlqpHVvd7TXWW2S2BkciyC0z+3
	 RGa1zpN8BU4cC4cwWtoH8vJTh8yr0qLUS1bBluRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0545/1815] kcsan: avoid unintended access checking in NMIs
Date: Sat, 12 Sep 2026 08:38:15 +0200
Message-ID: <20260912065701.678672630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



