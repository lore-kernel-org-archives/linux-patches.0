Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E0F2609EE;
	Fri, 15 May 2026 16:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862217; cv=none; b=Aln6rk3UHYnlELli+yaA0b0XKLTIhxyIY5asi59XPMFhFVTDI1RDJVwnha90TW7uZIGKDPfMLR7+tsenGfZYzJ/i0ESZ6XkgYhvfaddDQXybIchR7Shjo4ZVuPXeOxzai1UQ5VGQazTkNuC+QSh3RGt6pR7UHW2erfdXB3GlQ1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862217; c=relaxed/simple;
	bh=wIVNI7UdeZ57oALjmUgqk7OkytDb/eFHn2egEDpiwq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bs/392iXFzeGjQk4BhkSh1rUg7xgX+61lkPUvnEUyFBPgfpUhSAcansIttKVzHeKvkABdoohOvXXzOy555YN/tMcJpvnwRHrjsH7yWkmleoO3P/deiu9oBQ7fFFN1G+CisoixkeOq1KfZMPp82gEy08BLLKHafnCll8wWZ5l38M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nazpVwHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nazpVwHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32D4C2BCB0;
	Fri, 15 May 2026 16:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862217;
	bh=wIVNI7UdeZ57oALjmUgqk7OkytDb/eFHn2egEDpiwq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nazpVwHB0rVbvtc1Ya2GygPmSCFhMOpDnmC/eisGYdjUHb5318Tb4c4S6AbW/R0wY
	 RaeaVvrG3gyvQF6umoC9sa9QUJqPtVzzl9zpRUxwbnqfzSstaRIKEEl3fnyEkI7AUo
	 zNHJJiek8IhJYHA7vM7uNaHapEmFB8FDDt95zwq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 151/188] mm/damon/core: disallow time-quota setting zero esz
Date: Fri, 15 May 2026 17:49:28 +0200
Message-ID: <20260515154700.599905717@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 8bbde987c2b84f80da0853f739f0a920386f8b99 upstream.

When the throughput of a DAMOS scheme is very slow, DAMOS time quota can
make the effective size quota smaller than damon_ctx->min_region_sz.  In
the case, damos_apply_scheme() will skip applying the action, because the
action is tried at region level, which requires >=min_region_sz size.
That is, the quota is effectively exceeded for the quota charge window.

Because no action will be applied, the total_charged_sz and
total_charged_ns are also not updated.  damos_set_effective_quota() will
try to update the effective size quota before starting the next charge
window.  However, because the total_charged_sz and total_charged_ns have
not updated, the throughput and effective size quota are also not changed.
Since effective size quota can only be decreased, other effective size
quota update factors including DAMOS quota goals and size quota cannot
make any change, either.

As a result, the scheme is unexpectedly deactivated until the user notices
and mitigates the situation.  The users can mitigate this situation by
changing the time quota online or re-install the scheme.  While the
mitigation is somewhat straightforward, finding the situation would be
challenging, because DAMON is not providing good observabilities for that.
Even if such observability is provided, doing the additional monitoring
and the mitigation is somewhat cumbersome and not aligned to the intention
of the time quota.  The time quota was intended to help reduce the user's
administration overhead.

Fix the problem by setting time quota-modified effective size quota be at
least min_region_sz always.

The issue was discovered [1] by sashiko.

Link: https://lore.kernel.org/20260407003153.79589-1-sj@kernel.org
Link: https://lore.kernel.org/20260405192504.110014-1-sj@kernel.org [1]
Fixes: 1cd243030059 ("mm/damon/schemes: implement time quota")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2135,7 +2135,8 @@ static unsigned long damos_quota_score(s
 /*
  * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
-static void damos_set_effective_quota(struct damos_quota *quota)
+static void damos_set_effective_quota(struct damos_quota *quota,
+		struct damon_ctx *ctx)
 {
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
@@ -2161,6 +2162,7 @@ static void damos_set_effective_quota(st
 		else
 			throughput = PAGE_SIZE * 1024;
 		esz = min(throughput * quota->ms, esz);
+		esz = max(ctx->min_sz_region, esz);
 	}
 
 	if (quota->sz && quota->sz < esz)
@@ -2197,7 +2199,7 @@ static void damos_adjust_quota(struct da
 	/* First charge window */
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(quota, c);
 	}
 
 	/* New charge window starts */
@@ -2211,7 +2213,7 @@ static void damos_adjust_quota(struct da
 		quota->charged_sz = 0;
 		if (trace_damos_esz_enabled())
 			cached_esz = quota->esz;
-		damos_set_effective_quota(quota);
+		damos_set_effective_quota(quota, c);
 		if (trace_damos_esz_enabled() && quota->esz != cached_esz)
 			damos_trace_esz(c, s, quota);
 	}


