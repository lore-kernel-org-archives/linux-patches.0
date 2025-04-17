Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2031DF756;
	Thu, 17 Apr 2025 18:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913527; cv=none; b=fVCksHW5ZuwQhU+82rAl0qcNOkK8HgQ42433ykQKREXVD7ItMzHtw/nPvFzkIG7y+68DnrgTIJ+8jpI8IGMOQFtvm+iM74aNtzkTqYNXtZXxEzkKN79Vkh/Ow0ywUptVNBFHDbNE4/m4YMqCU6l5ppOMctkVBfdZ8HiwoRkHUk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913527; c=relaxed/simple;
	bh=M/mfVAQJz3DqD/6B+Odmr+Y8lbLFhmWNyml9t4m3IUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EE8AcwqB1L4VcF4YHH2hj6HEOzI1JJNz/ixjWPoWhv9ktXgDCj2aJJd2EGPGVkAcvFv+FR3cCIVPjrFoFPTTMrq0Z6Dq7q3L3axHSyRNLnokjPlxqUDsG4dtU+c1iztvsm38zeAKn9Th1KzX8h52CxjC8Jw6bNXnLc5lPsyX/fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrwgON73; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrwgON73"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F99C4CEE4;
	Thu, 17 Apr 2025 18:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913526;
	bh=M/mfVAQJz3DqD/6B+Odmr+Y8lbLFhmWNyml9t4m3IUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrwgON73CAS7clve21tZtzmLMRE+s64K6PVEuMlC2XytiBfe1sMSzbAJKYHJ+jIJJ
	 0GbD8NOZDTkv8fTV2+JFw9tw4W9MoQ4/FGExmu0gbMOVGiSePtdOR+9YzXAL2H4g1R
	 zj2oNMpAl8wfaLVO0oBnwx6EZqx6SUetz2hGijzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sebastian Siewior <bigeasy@linutronix.de>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	stable@kernel.org
Subject: [PATCH 6.14 369/449] uprobes: Avoid false-positive lockdep splat on CONFIG_PREEMPT_RT=y in the ri_timer() uprobe timer callback, use raw_write_seqcount_*()
Date: Thu, 17 Apr 2025 19:50:57 +0200
Message-ID: <20250417175133.093780322@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

commit 0cd575cab10e114e95921321f069a08d45bc412e upstream.

Avoid a false-positive lockdep warning in the CONFIG_PREEMPT_RT=y
configuration when using write_seqcount_begin() in the uprobe timer
callback by using raw_write_* APIs.

Uprobe's use of timer callback is guaranteed to not race with itself
for a given uprobe_task, and as such seqcount's insistence on having
preemption disabled on the writer side is irrelevant. So switch to
raw_ variants of seqcount API instead of disabling preemption unnecessarily.

Also, point out in the comments more explicitly why we use seqcount
despite our reader side being rather simple and never retrying. We favor
well-maintained kernel primitive in favor of open-coding our own memory
barriers.

Fixes: 8622e45b5da1 ("uprobes: Reuse return_instances between multiple uretprobes within task")
Reported-by: Alexei Starovoitov <ast@kernel.org>
Suggested-by: Sebastian Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20250404194848.2109539-1-andrii@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/uprobes.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1955,6 +1955,9 @@ static void free_ret_instance(struct upr
 	 * to-be-reused return instances for future uretprobes. If ri_timer()
 	 * happens to be running right now, though, we fallback to safety and
 	 * just perform RCU-delated freeing of ri.
+	 * Admittedly, this is a rather simple use of seqcount, but it nicely
+	 * abstracts away all the necessary memory barriers, so we use
+	 * a well-supported kernel primitive here.
 	 */
 	if (raw_seqcount_try_begin(&utask->ri_seqcount, seq)) {
 		/* immediate reuse of ri without RCU GP is OK */
@@ -2015,12 +2018,20 @@ static void ri_timer(struct timer_list *
 	/* RCU protects return_instance from freeing. */
 	guard(rcu)();
 
-	write_seqcount_begin(&utask->ri_seqcount);
+	/*
+	 * See free_ret_instance() for notes on seqcount use.
+	 * We also employ raw API variants to avoid lockdep false-positive
+	 * warning complaining about enabled preemption. The timer can only be
+	 * invoked once for a uprobe_task. Therefore there can only be one
+	 * writer. The reader does not require an even sequence count to make
+	 * progress, so it is OK to remain preemptible on PREEMPT_RT.
+	 */
+	raw_write_seqcount_begin(&utask->ri_seqcount);
 
 	for_each_ret_instance_rcu(ri, utask->return_instances)
 		hprobe_expire(&ri->hprobe, false);
 
-	write_seqcount_end(&utask->ri_seqcount);
+	raw_write_seqcount_end(&utask->ri_seqcount);
 }
 
 static struct uprobe_task *alloc_utask(void)


