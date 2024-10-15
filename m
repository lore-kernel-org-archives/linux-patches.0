Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6851E8832;
	Tue, 15 Oct 2024 13:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997892; cv=none; b=eqgi2QGWwysnjnzAHxIH1cDwkUudrRb6khJTxEM6d89Q7eG2B4ohT9tUco9ww9IVAgPh6gQFdVhrNYOLvoh5M229Ht/Y2I9LNMhdF15lsxfIIUDiNiXaSMy+awrrxCY6E/cki2Bj9bWr4Z3+FC4C3cdxW4sBdxVS88VTExn71/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997892; c=relaxed/simple;
	bh=sWmBG/eogVZMewWpDQ/8N92UqT+f8J3zEEzpl/9iCYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szsHRtSpMgOcNh0BgJnvLJU6Ltii2A/bB1Hfcndv3tTWwawMKzLtGrM7Fo+stW1H/X9kAT4K7NTSq4VuflcPNSjKXFwzZuUX9tCn6aIrQzoRQYsS1NyWB293ESPaVIXiAtjjp7Y/CbzXUlpPuUa7dMJQqsT8Ee74X/+2qi20Tjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRaNFBRB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRaNFBRB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE85C4CECF;
	Tue, 15 Oct 2024 13:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997892;
	bh=sWmBG/eogVZMewWpDQ/8N92UqT+f8J3zEEzpl/9iCYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRaNFBRBoIf2KhgKaxUi6jttB8jMazCiRuAh8civrEGs07ofRmgqkDceEoz8UyjNo
	 dm7kIbqPxlek11zX+niriAfHz/LskvVZZejrqgLFfaoA4W8bT0SW7gFCkC9qHGCn3o
	 YSVFSJt2x5gaCNYzAfqqhu/hUC4p0xIBKvAPQGNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 319/518] signal: Replace BUG_ON()s
Date: Tue, 15 Oct 2024 14:43:43 +0200
Message-ID: <20241015123929.293214664@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 7f8af7bac5380f2d95a63a6f19964e22437166e1 ]

These really can be handled gracefully without killing the machine.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index bfc1da526ebbe..7a9af6d4f2b01 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1817,10 +1817,11 @@ struct sigqueue *sigqueue_alloc(void)
 
 void sigqueue_free(struct sigqueue *q)
 {
-	unsigned long flags;
 	spinlock_t *lock = &current->sighand->siglock;
+	unsigned long flags;
 
-	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
+	if (WARN_ON_ONCE(!(q->flags & SIGQUEUE_PREALLOC)))
+		return;
 	/*
 	 * We must hold ->siglock while testing q->list
 	 * to serialize with collect_signal() or with
@@ -1848,7 +1849,10 @@ int send_sigqueue(struct sigqueue *q, struct pid *pid, enum pid_type type)
 	unsigned long flags;
 	int ret, result;
 
-	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
+	if (WARN_ON_ONCE(!(q->flags & SIGQUEUE_PREALLOC)))
+		return 0;
+	if (WARN_ON_ONCE(q->info.si_code != SI_TIMER))
+		return 0;
 
 	ret = -1;
 	rcu_read_lock();
@@ -1867,7 +1871,6 @@ int send_sigqueue(struct sigqueue *q, struct pid *pid, enum pid_type type)
 		 * If an SI_TIMER entry is already queue just increment
 		 * the overrun count.
 		 */
-		BUG_ON(q->info.si_code != SI_TIMER);
 		q->info.si_overrun++;
 		result = TRACE_SIGNAL_ALREADY_PENDING;
 		goto out;
-- 
2.43.0



