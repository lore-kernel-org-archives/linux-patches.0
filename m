Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0512E350820;
	Tue, 26 Aug 2025 14:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218610; cv=none; b=Gvk4L94j3i9SNXbPEy6lTw6lkwUEFf65lpChHuzfx54+WIUDGxMS4OkEdIG3QBHWVmrjaas/1CYdxIFaR1qiNBRygH9gKqtGUytQVswFCeaTbzmFWKVhHrSVx088Pj2IZZDpSa9p/wT5GFOzLd2i+IFVGfp5ouyFBww7H4i7s3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218610; c=relaxed/simple;
	bh=tYEIdt20QfEiiGiAFhU/BLBT2FTDct3BccqREfKJUMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZtZ5Jrb9+YCWyGl+qDvoB3LevizJYrVTHDXnoOL3ZyqfV+nxPM3FpTGDS34H4zl5q+Z9jKXoRm9egyxoJ85jtFBOp2SZFyLU0zOLO4PUHA8536YkFF/fZjfL2cOMh1vQXIej+ccThzx1T+QECd5yIbMeQaw1aJNutqEZsqXKA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezHCna2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezHCna2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE96C4CEF1;
	Tue, 26 Aug 2025 14:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218609;
	bh=tYEIdt20QfEiiGiAFhU/BLBT2FTDct3BccqREfKJUMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezHCna2QFW//tsh+/Vdbzx4ar3jfPMVHGwpu1tuZOeIM6AqKbSNoXGGkC1fdWKbnO
	 QMmu+XPhXki47wTdbeuZB+uOox0ByjVsnWBv2HfJWNvO40UmQvQBCYN0jTmmqdYdVI
	 Jdk29GvO3JxnMRvJgK4OQbu+T5Q+pDi8Cm12p640=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.4 048/403] net_sched: sch_sfq: annotate data-races around q->perturb_period
Date: Tue, 26 Aug 2025 13:06:14 +0200
Message-ID: <20250826110907.168969231@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a17ef9e6c2c1cf0fc6cd6ca6a9ce525c67d1da7f ]

sfq_perturbation() reads q->perturb_period locklessly.
Add annotations to fix potential issues.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240430180015.3111398-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Harshit: Backport to 5.4.y, conflicts resolved due to missing commit:
  d636fc5dd692 ("net: sched: add rcu annotations around
  qdisc->qdisc_sleeping")in 5.4.y ]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_sfq.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -611,6 +611,7 @@ static void sfq_perturbation(struct time
 	struct Qdisc *sch = q->sch;
 	spinlock_t *root_lock = qdisc_lock(qdisc_root_sleeping(sch));
 	siphash_key_t nkey;
+	int period;
 
 	get_random_bytes(&nkey, sizeof(nkey));
 	spin_lock(root_lock);
@@ -619,8 +620,12 @@ static void sfq_perturbation(struct time
 		sfq_rehash(sch);
 	spin_unlock(root_lock);
 
-	if (q->perturb_period)
-		mod_timer(&q->perturb_timer, jiffies + q->perturb_period);
+	/* q->perturb_period can change under us from
+	 * sfq_change() and sfq_destroy().
+	 */
+	period = READ_ONCE(q->perturb_period);
+	if (period)
+		mod_timer(&q->perturb_timer, jiffies + period);
 }
 
 static int sfq_change(struct Qdisc *sch, struct nlattr *opt)
@@ -662,7 +667,7 @@ static int sfq_change(struct Qdisc *sch,
 		q->quantum = ctl->quantum;
 		q->scaled_quantum = SFQ_ALLOT_SIZE(q->quantum);
 	}
-	q->perturb_period = ctl->perturb_period * HZ;
+	WRITE_ONCE(q->perturb_period, ctl->perturb_period * HZ);
 	if (ctl->flows)
 		q->maxflows = min_t(u32, ctl->flows, SFQ_MAX_FLOWS);
 	if (ctl->divisor) {
@@ -724,7 +729,7 @@ static void sfq_destroy(struct Qdisc *sc
 	struct sfq_sched_data *q = qdisc_priv(sch);
 
 	tcf_block_put(q->block);
-	q->perturb_period = 0;
+	WRITE_ONCE(q->perturb_period, 0);
 	del_timer_sync(&q->perturb_timer);
 	sfq_free(q->ht);
 	sfq_free(q->slots);


