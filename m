Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF40647988D;
	Sat, 12 Sep 2026 12:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214483; cv=none; b=T9v2tbJf4DouBg6s38oyHvhppqo4tHBkhGqJXr4+QQ7iJ8/7eAKSeD7lRT2bG6plyQtRT4t8bWmbZhLvw8SpNc45ETqfMKw1FUcp7qrggutAcnRuC1jJExLrqCOrVm6wmQeSj0Lxaqr3hg4AaAAMFaG3lMiP63pTBzPZhucarKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214483; c=relaxed/simple;
	bh=TyDQJ63aomE/2ImtyO7sZ7wKlprED7XNFbo7c5VkPKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmqwiCeDgeIiNE1RF52W2E39vyZnRemp533Y7R2oaf/lv8QGXiD/FeBt1Mx+6HEjAu7SoBImOeCF5aNlmpJ7Ydeuw4Id8LIEeMuxC2ewjALuZumfhQB0cPVE4+YS5TNVIosz4wzMEbZmIgtV/XVWP7An5CSVBFUT9YblPbjPY6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tb8mVQ1p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tb8mVQ1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB381F000FF;
	Sat, 12 Sep 2026 12:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214481;
	bh=/Xv13xqBYv6SlFmClYmeU8TPyrCd0OlhetXb3ruo+U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tb8mVQ1p9kWWhWywe5BKz8ouEx8qFpeh3n1Daf70Y34lFNbh3ui0NefvRhESttzfE
	 caVQgxOnMR5TBh83y+ft8ybxbarQ9MrzU4gL45E5VWMVKnp7jyQx4/SMAtmQhjr0+U
	 d47QKGyda39X9ySN4KRe2Y5ih6WEkeSYPsPn+ggo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0292/1376] mm/damon/ops-common: use nr_accesses moving sum for quota score
Date: Sat, 12 Sep 2026 08:45:18 +0200
Message-ID: <20260912065614.054991835@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit 6c25083f7ae7e2660d766169e5b4d3e96010503f ]

Since commit 42f994b71404 ("mm/damon/core: implement scheme-specific apply
interval"), DAMOS scheme can be applied at any time.  At that time,
nr_accesses may not be fully aggregated.  But the quota prioritization
score is calculated using the not fully aggregated count.  As a result,
the performance of DAMOS could be degraded.  Fix by using
damon_nr_accesses_mvsum() instead.

The user impact of the issue is suboptimum DAMOS performance under certain
setups.  Nonetheless, the bug was there from the beginning of the setup
availability.  In other words, the suboptimum performance is the baseline
of the setup and hence it didn't cause regression.  Also the extent of the
suboptimality was not big enough to be found from users and testers.
Still, this is a clear bug that is better to be fixed, and can be easily
fixed.

Link: https://lore.kernel.org/20260719161136.90191-1-sj@kernel.org
Fixes: 42f994b71404 ("mm/damon/core: implement scheme-specific apply interval")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.7.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/ops-common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 4b5638bbe0614..dea662a6747ce 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -80,8 +80,9 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 	unsigned int age_weight = s->quota.weight_age;
 	int hotness;
 
-	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE /
-		damon_max_nr_accesses(&c->attrs);
+	freq_subscore = mult_frac(r->nr_accesses_bp / 10000,
+			DAMON_MAX_SUBSCORE,
+			damon_max_nr_accesses(&c->attrs));
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
 	for (age_in_log = 0; age_in_log < DAMON_MAX_AGE_IN_LOG && age_in_sec;
-- 
2.53.0



