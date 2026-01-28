Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1FA8305E2E;
	Wed, 28 Jan 2026 15:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615743; cv=none; b=EsKYopzoP6o/R++3k99QHILmcelor/9Eeek4KAyCMYdjaQoEfjy7eKOYIJMNKmwh49nIt+Th1WAV77L+3PfEsHUmqaqaKl0mmiJDfXsvXWAp04AICVwUoFfs6DgF3f3w5YiwxDEjc1aQ37UmA2xvg8xRfS6jCb9n8yHFQSh8X8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615743; c=relaxed/simple;
	bh=J4EUFEHzAqw17Hswf5WpdG+CiDfQZIrILVOP9ZiD+3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6gw7D3IoOOMCDgRxQtWXvTydT+S3vwH6o7L+Q5xnrwua6cGzcMAkiySEW6RSMMlJz9WP9f1NACbh2YOiYQXY7qs/m531DITPvvp8pRko2TeCZ2f1xVUH7VQw+7ywFDv7eHs4tmBxTvs7xLR065CZ9gb9fr97RXGf7lVOCzqkVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bl9mOWS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bl9mOWS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60500C4CEF7;
	Wed, 28 Jan 2026 15:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615742;
	bh=J4EUFEHzAqw17Hswf5WpdG+CiDfQZIrILVOP9ZiD+3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bl9mOWS6GAOF/S7h7ockfwQ3iD53jroH/JiuwSd6BdBR7z5C4I/b7wsXP38I6Jb2R
	 UFXk7PWcgf06gWJjoDpKTu8/YBYudiNqqOSoUCHEYONya0mN5AffzCQa5Uysd7roLB
	 IvRq2etw7OGZMIdg6UF+62lV9c1ULCzizzFI6nrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Alexei Starovoitov <ast@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.18 068/227] slab: fix kmalloc_nolock() context check for PREEMPT_RT
Date: Wed, 28 Jan 2026 16:21:53 +0100
Message-ID: <20260128145346.787558310@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>

commit 99a3e3a1cfc93b8fe318c0a3a5cfb01f1d4ad53c upstream.

On PREEMPT_RT kernels, local_lock becomes a sleeping lock. The current
check in kmalloc_nolock() only verifies we're not in NMI or hard IRQ
context, but misses the case where preemption is disabled.

When a BPF program runs from a tracepoint with preemption disabled
(preempt_count > 0), kmalloc_nolock() proceeds to call
local_lock_irqsave() which attempts to acquire a sleeping lock,
triggering:

  BUG: sleeping function called from invalid context
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6128
  preempt_count: 2, expected: 0

Fix this by checking !preemptible() on PREEMPT_RT, which directly
expresses the constraint that we cannot take a sleeping lock when
preemption is disabled. This encompasses the previous checks for NMI
and hard IRQ contexts while also catching cases where preemption is
disabled.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Reported-by: syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b1546ad4a95331b2101e
Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Link: https://patch.msgid.link/20260113150639.48407-1-swarajgaikwad1925@gmail.co
Cc: <stable@vger.kernel.org>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5692,8 +5692,12 @@ void *kmalloc_nolock_noprof(size_t size,
 	if (unlikely(!size))
 		return ZERO_SIZE_PTR;
 
-	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
-		/* kmalloc_nolock() in PREEMPT_RT is not supported from irq */
+	if (IS_ENABLED(CONFIG_PREEMPT_RT) && !preemptible())
+		/*
+		 * kmalloc_nolock() in PREEMPT_RT is not supported from
+		 * non-preemptible context because local_lock becomes a
+		 * sleeping lock on RT.
+		 */
 		return NULL;
 retry:
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))


