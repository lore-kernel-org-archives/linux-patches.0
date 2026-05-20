Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D0D3F660B;
	Wed, 20 May 2026 18:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302750; cv=none; b=fQpNrqegsKd4EATGgd8DhowXTGGES7vj+iWNListthRcVplA7ohiTvPM6mCG9tc1+FYlr4adClK5aaf3ZYmIJxQylT5K8Zo7wEmS5CKtqzNHXYLtiyQgjvST+6lki/3Gzn7ur8XSybG/fcs8/nTjzMFYInUvxsBP5HZOWcDGTiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302750; c=relaxed/simple;
	bh=iCV1Pwba3lLQq2qS4f7Ispyn99KFMrL0rxg3LjFFVTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5d3dOCYmi1gH4/tDfRRj4iA7ZCy0qcuyIyVe3a5IjLsEpTquk11K9ZfMa3cp7RXjHUhcdoAECSdNvKOsedKDlgyBSqN6y11m0ePzFTBTgwKcyCOdy1g86uAGXmlGdc/IiVrw0HHmSxCgEl5jnt7G1pMUZ4TAZJ82PnkZRwgn/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPJ+xlNh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPJ+xlNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435541F000E9;
	Wed, 20 May 2026 18:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302748;
	bh=KQ2NX+2/Ty7mRUOTyuIpitjjagJ21E45Rvcu5ihrfnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KPJ+xlNheKU/LV6XARVO8edAKwgbztKVA4Q4p4NbVImYHcGKAZfGkl3vQKYzNZa2i
	 ebrWB3l9dCxXTIAv6VI410NuJUtqURasNaN6KoJzlPKJMpYCIgHAKtL4bgYtl5BGnQ
	 n08IWocdyDEdEapGKd99egxK0NgQCxqxdzusVHfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Hemminger <stephen@networkplumber.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 383/508] net/sched: netem: only reseed PRNG when seed is explicitly provided
Date: Wed, 20 May 2026 18:23:26 +0200
Message-ID: <20260520162106.920006301@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Hemminger <stephen@networkplumber.org>

[ Upstream commit 986afaf809940577224a99c3a08d97a15eb37e93 ]

netem_change() unconditionally reseeds the PRNG on every tc change
command. If TCA_NETEM_PRNG_SEED is not specified, a new random seed
is generated, destroying reproducibility for users who set a
deterministic seed on a previous change.

Move the initial random seed generation to netem_init() and only
reseed in netem_change() when TCA_NETEM_PRNG_SEED is explicitly
provided by the user.

Fixes: 4072d97ddc44 ("netem: add prng attribute to netem_sched_data")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260418032027.900913-4-stephen@networkplumber.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_netem.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index b3af6a50b43be..e778eb1d1a510 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -1110,11 +1110,10 @@ static int netem_change(struct Qdisc *sch, struct nlattr *opt,
 	/* capping jitter to the range acceptable by tabledist() */
 	q->jitter = min_t(s64, abs(q->jitter), INT_MAX);
 
-	if (tb[TCA_NETEM_PRNG_SEED])
+	if (tb[TCA_NETEM_PRNG_SEED]) {
 		q->prng.seed = nla_get_u64(tb[TCA_NETEM_PRNG_SEED]);
-	else
-		q->prng.seed = get_random_u64();
-	prandom_seed_state(&q->prng.prng_state, q->prng.seed);
+		prandom_seed_state(&q->prng.prng_state, q->prng.seed);
+	}
 
 unlock:
 	sch_tree_unlock(sch);
@@ -1137,6 +1136,9 @@ static int netem_init(struct Qdisc *sch, struct nlattr *opt,
 		return -EINVAL;
 
 	q->loss_model = CLG_RANDOM;
+	q->prng.seed = get_random_u64();
+	prandom_seed_state(&q->prng.prng_state, q->prng.seed);
+
 	ret = netem_change(sch, opt, extack);
 	if (ret)
 		pr_info("netem: change failed\n");
-- 
2.53.0



