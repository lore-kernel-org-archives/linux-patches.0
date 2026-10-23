Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774820;
	b=2a1q9E2hAkNlEYjs/3MbBGZPtFdJT83NucP6X6vkB2oQXOhrXpP+JhcOC8Zir85xr1tj
	 JCCw25J2hDklLi0spyWRAgnHZ7WNy4XHNQ4kwhT9ee6tXLIPAEesDJ5MhEZxkAcVQkqHU
	 J4u1ylX5/haav3i6d7JNpPOl+poWgQUVdZRP7gHJ8IvNP0t5lijQlLhqiqsQvEw68QT7x
	 T0494qG53wYMRb0uGNZSH+k0HLZuLWn0mJ+hi2RkncRJnD43AH4hNPJBScXu/FQaYF32r
	 oBHmEX8lH1utYkTW0ehWeHJRZ2/suHXGByH9mJ5YnEacbm5gxEe1GZMxy5BqOVb+THA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cdJ2rz4BqCRKvz2w0p5d+T9TXcXXpYiOuAMhPpjsm8U=;
	b=IV8OW0eGI70Bc4PbTMw8URzdZZ3R/DSaMvRCy9h16AcfyGM1hPA5ZsmkWxJgpWIQFvKW
	 WJLDUp3aP9J6so8C+0mpQoGgmqpVNbXHJqL/zsvoR55m9kgPGup4RcFtc5VWasxLN52w/
	 qs7ye0XhC2PRGcYgQ9AMzVa2i70oHXc6vQGkrMqXj/cYDndTcfotO7PJLXJGWkYYeH7Mb
	 eO7xfEGGkyHlcft+MjSeY+IbmDUAhFoshIHrmLEHvCa04L6ZRU1n+dPAfg6gtfb3fVK3E
	 FWFwguwdllpVU7DRYBuXiVDVuRZqfgtKyw7cfergczW7lmpk46qvEY12swPhW7RX8Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YiQEzJzO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CC0606A31A;
	Fri, 23 Oct 2026 17:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YiQEzJzO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7251F01825;
	Fri, 23 Oct 2026 17:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774819;
	bh=cdJ2rz4BqCRKvz2w0p5d+T9TXcXXpYiOuAMhPpjsm8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YiQEzJzO1aYC5+9j6tKx6bH1MJDBv65SMlnt/xzmtVJkPdD6isrWPvydWZG2v7AtS
	 pvUVJ23c4X3T9PC8G+WzF7in5t5TjNE76GnfrMOyLlFpl4g1oabwnJjk9ZxGz6S0SW
	 L7X+JjhEXLI1aUaIV3/O85Dhgj6ehCS44PXod+8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>
Subject: [PATCH 7.2 167/242] sched_ext: Propagate every bypass depth change to the descendants
Date: Fri, 23 Oct 2026 18:40:09 +0200
Message-ID: <20261023163717.734465552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit dcf7f650a24897d59b071f7f9a454d8b0b188b27 upstream.

scx_bypass() propagates a depth change to the descendants only when the
scheduler's own depth crosses zero, so an own bypass that starts under an
ancestor's never reaches them. When the ancestor's bypass ends first, the
descendants leave bypass while the scheduler is still bypassing: a
sub-scheduler disabled under a PM suspend has its children re-queue their
tasks through their own BPF schedulers at resume, mid-teardown. If the own
bypass then ends, every descendant is decremented once more than incremented
and dec_bypass_depth() warns, though no current caller gets there.

Propagate on every call so that a descendant's depth is the sum of its own
bypasses and its ancestors'. The early return follows the walk, as a
descendant's depth is at least the scheduler's and nothing changes bypass
state unless the scheduler's own does.

Fixes: c7f0e467a27a ("sched_ext: Prepare bypass mode for hierarchical operation")
Cc: stable@vger.kernel.org # v7.1+
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext/ext.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -5793,22 +5793,23 @@ static void scx_bypass(struct scx_sched
 	struct scx_sched *pos;
 	unsigned long flags;
 	int cpu;
+	bool changed;
 
 	raw_spin_lock_irqsave(&scx_bypass_lock, flags);
 
 	if (bypass) {
-		if (!inc_bypass_depth(sch))
-			goto unlock;
-
-		enable_bypass_dsp(sch);
+		changed = inc_bypass_depth(sch);
+		if (changed)
+			enable_bypass_dsp(sch);
 	} else {
-		if (!dec_bypass_depth(sch))
-			goto unlock;
+		changed = dec_bypass_depth(sch);
 	}
 
 	/*
 	 * Bypass state is propagated to all descendants - an scx_sched bypasses
-	 * if itself or any of its ancestors are in bypass mode.
+	 * if itself or any of its ancestors are in bypass mode. A descendant's
+	 * depth is the sum of its own bypasses and its ancestors', so every
+	 * call propagates whether or not @sch changed state.
 	 */
 	raw_spin_lock(&scx_sched_lock);
 	scx_for_each_descendant_pre(pos, sch) {
@@ -5822,6 +5823,13 @@ static void scx_bypass(struct scx_sched
 	raw_spin_unlock(&scx_sched_lock);
 
 	/*
+	 * A descendant's depth is at least @sch's, so no bypass state changed
+	 * unless @sch's did.
+	 */
+	if (!changed)
+		goto unlock;
+
+	/*
 	 * No task property is changing. We just need to make sure all currently
 	 * queued tasks are re-queued according to the new scx_bypassing()
 	 * state. As an optimization, walk each rq's runnable_list instead of


