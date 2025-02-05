Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3374C126C18;
	Wed,  5 Feb 2025 13:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763389; cv=none; b=eqz+dSaHv2PHiMMdl2V1K/f5Vv0dhWm6/2hURV4Wnj7C9Bbs230vjoN1if1j/R+gwBfaSFaog7fJRenf7s0tXVgVX/EXcw/9PrZIO2w6GmwAHFTsblEXvh0PjdOp9Jso71Kr2jzUFJxBERrNmeYiov4xMXiOux5/QQd43qrlrjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763389; c=relaxed/simple;
	bh=f14kOU0TC3R4YhiiS8L0f9BG0lpuWBxxLfYLmhBYJhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7UqVH0BEnKGB99e1G9UYrtSKbfDx63nae1FBwSUdNrUSfaAkWFXqGUrURBaxzg/P5d1Xgbpj5MfeUhLl9r5qfJT5JQ6uEXm93QO2WkuMSqSxgkN3u/9c47Dqc0rjS8eq0zE7559h2n3mxMkvGM6zpt4I0Yq8lmFxneXkeM41JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlucOcIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlucOcIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9402BC4CED1;
	Wed,  5 Feb 2025 13:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763389;
	bh=f14kOU0TC3R4YhiiS8L0f9BG0lpuWBxxLfYLmhBYJhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlucOcIsSX1cRXugULq1NJcsfTWG8rdTOntSDokeRSyIAixf2peBSsB335BcpIJu4
	 IVFE9GkGP9+7xSUieyIGHQa35sVGt+7UFmye4sLDGkYeU2rehWvtNHgNKN/kP7DU4b
	 5tAKR5QD/V2gCjL1kbbTosOikITKJOsnd+D+T5bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/393] net_sched: sch_sfq: annotate data-races around q->perturb_period
Date: Wed,  5 Feb 2025 14:39:34 +0100
Message-ID: <20250205134422.402596389@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



