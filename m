Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779CA2288F4;
	Mon,  2 Jun 2025 15:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877182; cv=none; b=PrySRHhszRUkNoJVDXwUOdqv35fH+v/4GUP23IG8yiK8l6aqGvXxQsdliaGs5Rmnev5g3qZkLnbQ9IM9mGmEuEx2wFiwouoJTPS3fMqrG/QlnCsj3uDL7+MbImtFTC6OTuZtPgtsCIORMJpCCNP78sdwrA+58hFkWfaDW1obCi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877182; c=relaxed/simple;
	bh=dJ/w6kb3DcTvVB4l+ThnfttYzqiQmdfTO2i6nIe97BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9Qr1TP8E7jcR1sWyuvfFO2PqygMWLxOTXEF0RpZlASbHqg5OBvjyoRMuvelTf1urctCnxWKiRTIlllnq/5IDDo0DWDeazlNpj45QSclTF86skEI0d/7A/vY2+OgGfLWjffuhzT9UsCxCOp+1OjtD0O9tIzkYbkgTqm+ihUXJrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w4EOX1of; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w4EOX1of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93ABC4CEEB;
	Mon,  2 Jun 2025 15:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877182;
	bh=dJ/w6kb3DcTvVB4l+ThnfttYzqiQmdfTO2i6nIe97BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w4EOX1ofxjiiA0ecfV2wvC8qQjxd5sn6i98Qt4ZwMHA+w+xcs+/yveUaqQuzbiRII
	 rf4BTKR3itb+r6jyCdHQHeeR4rueV8wDjvOpM3szvphT35amzhejlBIR83X1UQ4F6Z
	 RBZ6e2OyIKsvqoFR+URpVmxwZezRVeTUfdPFJIe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 197/325] rcu: handle quiescent states for PREEMPT_RCU=n, PREEMPT_COUNT=y
Date: Mon,  2 Jun 2025 15:47:53 +0200
Message-ID: <20250602134327.802753083@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ankur Arora <ankur.a.arora@oracle.com>

[ Upstream commit 83b28cfe796464ebbde1cf7916c126da6d572685 ]

With PREEMPT_RCU=n, cond_resched() provides urgently needed quiescent
states for read-side critical sections via rcu_all_qs().
One reason why this was needed: lacking preempt-count, the tick
handler has no way of knowing whether it is executing in a
read-side critical section or not.

With (PREEMPT_LAZY=y, PREEMPT_DYNAMIC=n), we get (PREEMPT_COUNT=y,
PREEMPT_RCU=n). In this configuration cond_resched() is a stub and
does not provide quiescent states via rcu_all_qs().
(PREEMPT_RCU=y provides this information via rcu_read_unlock() and
its nesting counter.)

So, use the availability of preempt_count() to report quiescent states
in rcu_flavor_sched_clock_irq().

Suggested-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_plugin.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 044026abfdd7f..4f45562be7b54 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -963,13 +963,16 @@ static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp)
  */
 static void rcu_flavor_sched_clock_irq(int user)
 {
-	if (user || rcu_is_cpu_rrupt_from_idle()) {
+	if (user || rcu_is_cpu_rrupt_from_idle() ||
+	     (IS_ENABLED(CONFIG_PREEMPT_COUNT) &&
+	      (preempt_count() == HARDIRQ_OFFSET))) {
 
 		/*
 		 * Get here if this CPU took its interrupt from user
-		 * mode or from the idle loop, and if this is not a
-		 * nested interrupt.  In this case, the CPU is in
-		 * a quiescent state, so note it.
+		 * mode, from the idle loop without this being a nested
+		 * interrupt, or while not holding the task preempt count
+		 * (with PREEMPT_COUNT=y). In this case, the CPU is in a
+		 * quiescent state, so note it.
 		 *
 		 * No memory barrier is required here because rcu_qs()
 		 * references only CPU-local variables that other CPUs
-- 
2.39.5



