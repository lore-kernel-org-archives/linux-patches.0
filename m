Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12BD9549387;
	Wed,  9 Sep 2026 13:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961873; cv=none; b=a6TKbs2PA8piZMt1Ssn/XM9ekWlu2xjHLq4+XmCHFaxnMaV8Gfe1dP0A/0eHt4CiTqi4nDxQg3LsmM4FK6GyfaLc3EXVGZSyKWrwyay3/7k4LKsuD8fbMaymrmj1cMCECQQWWKMbrIvlK6ttFi+DsABjiTjbkFWesCdsNQUaReU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961873; c=relaxed/simple;
	bh=nC827+trVOzHGWitRmh5aXQoKwkrUjNxInw05AuqCz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOWaF/QOShJTWZVJs1xZx5u4KEjAXjfvA1sZ0bTaL3ULGABFLZhNBFS/33xvQKum6beja6t9PPt7L+/O98PyUHBa5JfjdBFRROd4FCYa7LOCVJt2696TtXBUGtPnHJ6tYgC9YeVJrrBgjeKgoF6pe5QRUTCa9mXWpGo1QjByMyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Icmb8qgf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Icmb8qgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525321F00A3A;
	Wed,  9 Sep 2026 13:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961870;
	bh=BT2kdmrNSV1TgQuAueqNywMfg9frSL+0OCo+hTmC/Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Icmb8qgfuiyLW+d6u9sQzQRs01wL5hdhxBjzzY012MFeavCuNrZsw+sazp52YVAuQ
	 Yb8QF9v0SsJkkeCMNiE3KaNT0QjkdePs/BjH/NRjyBI+WA1TeRiViHAYhjnrMPlPtc
	 ZxR5vVPlBeq/c/ajszHSYRi+9/XtqVWLf38/D/CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 096/556] mm/damon/core: initialize damos->last_applied
Date: Wed,  9 Sep 2026 15:36:16 +0200
Message-ID: <20260909134233.879954681@linuxfoundation.org>
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

commit af5f76aeb9c9aa9c77d5e1d94e0ee4618c805239 upstream.

Patch series "mm/damon: fix uninitialized DAMOS field and kunit exec
expectation bugs".

Fix a few Sashiko-found unurgent bugs.  Patch 1 fixes use of uninitialized
damos->last_applied field.  Patches 2-7 fix DAMON kunit tests that do
invalid memory access under test failures.

The bugs are better to be fixed and eventually merged into stable@ kernel.
That said, the fixes are arguably not urgent.  Patch 1 only introduces
negligible DAMOS efficiency degradation in occasional cases.  Kunit fixes
could introduce quite bad consequences but those are test code that affect
only test run setups.


This patch (of 7):

Multiple DAMON regions could exist across a folio.  If they fulfill the
condition to apply a DAMOS scheme, the scheme could be applied multiple
times to the folio.  To avoid this, each DAMOS scheme stores the folio
that the scheme was applied to last time in the damos->last_applied field
and skips repeatedly applying the same scheme to the same folio.

The field is being used without initialization, though.  Hence, the
mechanism could wrongly skip applying a scheme to a folio at the very
first time of DAMOS run.

The user impact is trivial.  DAMON might unexpectedly skip applying DAMOS
action for one folio for the first time per scheme.  In the DAMON's
best-effort world, this is never a real problem.  No critical consequences
such as kernel panic or memory corruption happen.

It is a clear bug, though, and the fix is straightforward.  Fix the issue
by initializing the field in DAMOS scheme creation function,
damon_new_scheme().

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-1-sj@kernel.org
Link: https://lore.kernel.org/20260718001442.87129-2-sj@kernel.org
Link: https://lore.kernel.org/20260714055436.120034-1-sj@kernel.org [1]
Fixes: 94ba17adaba0 ("mm/damon: avoid applying DAMOS action to same entity multiple times")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -579,6 +579,7 @@ struct damos *damon_new_scheme(struct da
 	INIT_LIST_HEAD(&scheme->ops_filters);
 	scheme->stat = (struct damos_stat){};
 	scheme->max_nr_snapshots = 0;
+	scheme->last_applied = NULL;
 	INIT_LIST_HEAD(&scheme->list);
 
 	scheme->quota = *(damos_quota_init(quota));


