Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A080563FA1;
	Wed,  9 Sep 2026 14:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963199; cv=none; b=DXlJhwEeNBLQsC4Ib6dGRZdLlYaALOSYvvlFrmGBm97V1/Kz6js7VTnI1r3PTvf23ZjMi+mj0zzrmE7bXfFwt3TjlgX7Fl0w611W/3C42j1D7O3AVwc1nx/rjOofytj6FSJzUufDpZdyz4d+ygABH/ESkxiosooMLUpyF5nRbPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963199; c=relaxed/simple;
	bh=NgTmbkCT0jZLp7n9OsRJfqGXibUNiHeMW36uXGSHO0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRrb3xVwpB2bFf8PK/3RVoMOxqvMTiU4+TjhQp9ElgGR1/M8aKfjHWB/Cq9DAa4W8bd2pbeFdE6RGOxNUNMkudsurcRUzywMcScbMM/JH+crTwk+CiZEDBTc7ZSlQz6/HlsOM00ctlSuoRQ/R0reTGbLz2/I8aPUCBDsjxcW5sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2b9zfjw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2b9zfjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D211F00A3A;
	Wed,  9 Sep 2026 14:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963198;
	bh=fHVN9Ii6RfoEWQ6FbrdDHf1Dme3c5rPf2yK9xwNBMzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V2b9zfjwL0MKNb1tJljdIsaCTIXRTXOQL75qd5o7e08/rySMtyfuYc1d05EQuGL3c
	 eackZ4d0xiIptD5EKLgPGokPDK4PCaIEqg8FDkXxWXd/IgMX2TdBrl1XmsIOxjxv2q
	 N5zpu1IDGCo52zDhaHzSYJwtQHbMpnmmfuE/wxKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 552/556] mm/damon/ops-common: use nr_accesses moving sum for quota score
Date: Wed,  9 Sep 2026 15:43:52 +0200
Message-ID: <20260909134249.802300662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

commit 6c25083f7ae7e2660d766169e5b4d3e96010503f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/ops-common.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -111,8 +111,9 @@ int damon_hot_score(struct damon_ctx *c,
 	unsigned int age_weight = s->quota.weight_age;
 	int hotness;
 
-	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE /
-		damon_max_nr_accesses(&c->attrs);
+	freq_subscore = mult_frac(r->nr_accesses_bp / 10000,
+			DAMON_MAX_SUBSCORE,
+			damon_max_nr_accesses(&c->attrs));
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
 	if (age_in_sec)


