Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD55D1D416E;
	Wed,  6 Nov 2024 12:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895276; cv=none; b=V59atm6rh+klvm9UozUhhfudCzz+cmub8SLCJBE1Bgje5QdD1AuUbHca+YK3NZSQT08FkWm9Buc201Y0EZezZFkacxJyIg4RXTwu8q/OtfiRyFNwPGPJj7w2ZAB7ZehjH6OH5EdcZeT1AwpYw/EiwZ850eX4/DzcAg5ciQaVFsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895276; c=relaxed/simple;
	bh=rXpVa3NE21MDyWLhWo2aI7Zo0fUsoA2gCbFoWT/Aww0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUIYhvyWqhokQQ+/w7bKVWIuY6PdnjxlgaSls1qUylIN/rcHv14b17VuO76OMqAhlTrl42xDIUpG65TR3iA9CqY3YOEOQcDI01U5UBJmlJlOroMTjipcy0GJTZJzJJ2C+i8QxC7r9tMekNgl+s9Bwfc87cZ5/VTQQv4r7ugeNpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sT35f0K2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sT35f0K2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31850C4CECD;
	Wed,  6 Nov 2024 12:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895276;
	bh=rXpVa3NE21MDyWLhWo2aI7Zo0fUsoA2gCbFoWT/Aww0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sT35f0K2NFonnrzEyBrbCJ68AqxjUUVcuDcnpwzpR0vRO7c0gnXZkm4SO5urvxm1a
	 8IXTVcEvUu1WFr+HYrgAelyiR/EZ8CYlc2Og4Ai72wMADEeyXUFMHKnyrPk/Iy1VBg
	 dh6KO+FkokjxBs25UAk9qb53WgskhwwWTUetIj6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 162/350] signal: Replace BUG_ON()s
Date: Wed,  6 Nov 2024 13:01:30 +0100
Message-ID: <20241106120324.920858735@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index c79b87ac10416..356bdf5c45e61 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1739,10 +1739,11 @@ struct sigqueue *sigqueue_alloc(void)
 
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
@@ -1770,7 +1771,10 @@ int send_sigqueue(struct sigqueue *q, struct pid *pid, enum pid_type type)
 	unsigned long flags;
 	int ret, result;
 
-	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
+	if (WARN_ON_ONCE(!(q->flags & SIGQUEUE_PREALLOC)))
+		return 0;
+	if (WARN_ON_ONCE(q->info.si_code != SI_TIMER))
+		return 0;
 
 	ret = -1;
 	rcu_read_lock();
@@ -1789,7 +1793,6 @@ int send_sigqueue(struct sigqueue *q, struct pid *pid, enum pid_type type)
 		 * If an SI_TIMER entry is already queue just increment
 		 * the overrun count.
 		 */
-		BUG_ON(q->info.si_code != SI_TIMER);
 		q->info.si_overrun++;
 		result = TRACE_SIGNAL_ALREADY_PENDING;
 		goto out;
-- 
2.43.0



