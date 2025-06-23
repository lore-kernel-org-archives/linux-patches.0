Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA6FB676;
	Mon, 23 Jun 2025 22:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716838; cv=none; b=opXHl7PSK0Bq2dnYz8Px8xKypSjFltxgtIiGgAIndlXlgoOREU7c6wedWsZWe8RsoWyOAdRiPHBZZNMUjoCKE5lygONaK5KjXH2IEGH/7cPiFn4YGqeMCtd5yMKnMYVrh0Gjq+XC84MF2QM/VCxE1K5GxO79lO8r/KiC/1kS33w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716838; c=relaxed/simple;
	bh=IOGfq2LA4wZwFPzRXCvo2Og5awG/v4URlQmv8+jeL84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5A8a/DsCqI5iaRbOndGJUNvSdIE2lrrWtkcu6E5zIpPiox2TfZYp3PRXyqd64/+Waq+Im9L44KJ5zOSPKMNmoY7Eu4LjfW3hdM8XCPaoTDAtkhrsXwU155CmfmiM2OzlBsnDqtD49agNYyUW/6Sxg7113prpLtgW/+LbGNq5WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/DKSrHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/DKSrHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E35C4CEF1;
	Mon, 23 Jun 2025 22:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716837;
	bh=IOGfq2LA4wZwFPzRXCvo2Og5awG/v4URlQmv8+jeL84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/DKSrHpkecrK3dSJOhAv2rED/jlGw57NpUmSmVFXJ7GffIN+V+6mbhrluveAZXzv
	 AWWgxJotCO9f3m0JOVbvZoil4LAkj4FH1B1lAoSawePdiOosks/wQgKNzLwPrtYMVx
	 dXYwQ9stgTbpyVveRWLW18lDbl4AZ5PRnIaf38E8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 397/411] net_sched: sch_sfq: annotate data-races around q->perturb_period
Date: Mon, 23 Jun 2025 15:09:01 +0200
Message-ID: <20250623130643.672026695@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit a17ef9e6c2c1cf0fc6cd6ca6a9ce525c67d1da7f upstream.

sfq_perturbation() reads q->perturb_period locklessly.
Add annotations to fix potential issues.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240430180015.3111398-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
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


