Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028A646C4AB;
	Tue, 21 Jul 2026 17:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655334; cv=none; b=leXKfYezUEqjtM2d+CNNWM16hIFTkn1FbbXteu7DelOjpg5y0c3v0+lV0lS7REyaCODCpHHhWr1oPcMG666UTlDZt9u25ZHQcA7Dc+3ppf0TNnX8dch9P4Yv07WwtBSuV2duyb2qLGYf12+fyAR3tdfbUgUyuUxL0krqlMmX7ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655334; c=relaxed/simple;
	bh=Bq1ZPxRlm4eyP0Qmjy6wRNtC36w9bh/lvj9A+8z0Zxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pbfyTv3PacXv0eCYtdy54yILdrU7OQzyealJcjTSkjjQxfK58QnBa8xvzqysLvFumshhe+iIMqpjvEZSYyY59uEJIi8c0cCsxvJQmyizCYQ8tVW9z/U00XrvoOWoV7jEfcZg/AQBoaTBkWidUUHnIdjJps9qc9+JPGWzZ/e5ugQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrosDvM/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrosDvM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0F31F000E9;
	Tue, 21 Jul 2026 17:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655332;
	bh=dc1a17l7ZI1wNHHwpVVDtTeljEhb+G7EvzjlAoTQr68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TrosDvM/kGZQjQvQnIZ5PfWlggXOqM3nIVsqnhNaJILGf+PvZSnRLOkKFMfboawBr
	 av1+fNo3+WSqC+l3RmroIrsbvoIdAvAepgNWWd/k7V/pgwTfumfRjGtaAbTJdAP7G8
	 XvImGpmN+SuuEFW0XGw7VIRRItRVdss6se9ERbgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 2045/2077] mm/damon/core: trace esz at first setup
Date: Tue, 21 Jul 2026 17:28:38 +0200
Message-ID: <20260721152640.931714395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 7e6cc35f5283eab81a14231a64ecd640b690c48c upstream.

DAMON traces effective size quota from the second update, only if a change
has been made by the update.  Tracing only changed updates was an
intentional decision to avoid unnecessary same value tracing.  Always
skipping the first value is just an unintended mistake.

The mistake makes the tracepoint based investigation incomplete, because
the first effective size quota is never traced.  It is not a big issue
when the 'consist' quota tuner is used, because it keeps changing the
quota in the usual setup.

However, when the 'temporal' tuner is used, the quota value is not changed
before the goal achievement status is completely changed.  For example, if
the DAMOS scheme is started with an under-achieved goal, the quota is set
to the maximum value, and kept the same value until the goal is achieved.
Because DAMON skips the first value, the user cannot know what effective
quota the current scheme is using.  Only after the goal is achieved, the
effective quota is changed to zero, and traced.

Unconditionally trace the initial quota value to fix this problem.

Note that the 'temporal' quota tuner was introduced by commit af738a6a00c1
("mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL"), which was
added to 7.1-rc1.  But even with the 'consist' quota tuner, the tracing is
unintentionally incomplete.  Hence this commit marks the introduction of
the trace event as the broken commit.

Link: https://lore.kernel.org/20260520150311.80925-1-sj@kernel.org
Fixes: a86d695193bf ("mm/damon: add trace event for effective size quota")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2492,6 +2492,8 @@ static void damos_adjust_quota(struct da
 	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
 		damos_set_effective_quota(quota, c);
+		if (trace_damos_esz_enabled())
+			damos_trace_esz(c, s, quota);
 	}
 
 	/* New charge window starts */


