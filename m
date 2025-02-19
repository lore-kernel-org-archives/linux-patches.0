Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECE41C3F0A;
	Wed, 19 Feb 2025 09:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956115; cv=none; b=uVGkZ9kRh3CvHjuD36bJAyJmj9mVjmTfjuugaaXDaplab3ov51EHK7zv6ZqQjR6WkRWxSeaSRGkro2JcX7Gjl+ydx3KGagnExEY/8YP7VpHWa1WQvt7dnX1qwXWcuhjrT2L8SSzFQw2osSHHuxObLckfx/wXaQWPYN2sbU/lBGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956115; c=relaxed/simple;
	bh=nLZ9OVDLn2vCkWgPhlP8aKpZxXVuP2TbrJY7ifDDxn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtiwrM8/DK/Ctyhq5Wav+CAczUjqXrTVh8ZGK5EOuUjW1NFTH+YZfY0uvhCs3yknIyTN/KDmsWSVITQbPxuR+gp4hW3wIzPc9ZroRK589TBKC7IoHU5t2AgdJCCzZq7O69GlYktpmTPzcbOHAjg9ESFme6rdNVzrCtBbR4Lk+9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOOz+Y8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOOz+Y8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8884C4CED1;
	Wed, 19 Feb 2025 09:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956115;
	bh=nLZ9OVDLn2vCkWgPhlP8aKpZxXVuP2TbrJY7ifDDxn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vOOz+Y8sK4Kq2W5nlZrSuZvu7d0FKHkZJ2sTqcbd2+86EgkEUO8n6qkWtuiKmvDhj
	 dtC82N2gQ5uwfbb19TeyCqQIWQ0EsW7FBDFGEhmIGoi9p95qnY2sZ8A8To4RYl3cHk
	 h1vWVTG6Px/wd87BNrYFt1cFo2go/0hjCS+29Zfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/578] net_sched: sch_sfq: annotate data-races around q->perturb_period
Date: Wed, 19 Feb 2025 09:20:46 +0100
Message-ID: <20250219082654.549020382@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a17ef9e6c2c1cf0fc6cd6ca6a9ce525c67d1da7f ]

sfq_perturbation() reads q->perturb_period locklessly.
Add annotations to fix potential issues.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240430180015.3111398-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 10685681bafc ("net_sched: sch_sfq: don't allow 1 packet limit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_sfq.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 66dcb18638fea..ed362eefeea9a 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -608,6 +608,7 @@ static void sfq_perturbation(struct timer_list *t)
 	struct Qdisc *sch = q->sch;
 	spinlock_t *root_lock;
 	siphash_key_t nkey;
+	int period;
 
 	get_random_bytes(&nkey, sizeof(nkey));
 	rcu_read_lock();
@@ -618,8 +619,12 @@ static void sfq_perturbation(struct timer_list *t)
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
 	rcu_read_unlock();
 }
 
@@ -662,7 +667,7 @@ static int sfq_change(struct Qdisc *sch, struct nlattr *opt)
 		q->quantum = ctl->quantum;
 		q->scaled_quantum = SFQ_ALLOT_SIZE(q->quantum);
 	}
-	q->perturb_period = ctl->perturb_period * HZ;
+	WRITE_ONCE(q->perturb_period, ctl->perturb_period * HZ);
 	if (ctl->flows)
 		q->maxflows = min_t(u32, ctl->flows, SFQ_MAX_FLOWS);
 	if (ctl->divisor) {
@@ -724,7 +729,7 @@ static void sfq_destroy(struct Qdisc *sch)
 	struct sfq_sched_data *q = qdisc_priv(sch);
 
 	tcf_block_put(q->block);
-	q->perturb_period = 0;
+	WRITE_ONCE(q->perturb_period, 0);
 	del_timer_sync(&q->perturb_timer);
 	sfq_free(q->ht);
 	sfq_free(q->slots);
-- 
2.39.5



