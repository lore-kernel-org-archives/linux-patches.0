Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 824DD2DEA74;
	Tue, 21 Jul 2026 19:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660496; cv=none; b=kbFvucbTjJNExLwmhqbEpvofsrryNnhzs6wUFdaRTtUwcs+AZKz36dPjH0F+TXytDpAybv7++IbhbMYuEAvwS5mQ8SNc+F6hUDvO5SmDNB06DlI4z5+rJCdOivqIAp2DSxe6YN0iIdYVpunVyJu5TdQYDlEFyxRLemsvLMR0JME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660496; c=relaxed/simple;
	bh=e+XcJfipoQiLz8VUM1A3kSvXNtcQB5tTRIFRbZLH6AU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R8MKFCpZ/SoOoOvd3j8XHMTz7h3nf+eYaLr77HATeSmuT7czHYLfS25lS/qdo0nyWv0UWVNMsMFyNrQ6WW4YAqGFQFmMkF4xI3AC8DtDBwaVQIbQSrbOygMZI9lmfr/zVCbM08zrGw8qllPlF+joJIszYtkEXVuhPUVJYgb0bHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vlbx58HC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vlbx58HC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78581F0155D;
	Tue, 21 Jul 2026 19:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660454;
	bh=ispYcrCURyHE72BeNa2gYJSjoCQFeO/v04lwDh3+1cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vlbx58HCjFwPRnqccALmSy4xbJCFkIx2cu8jE7XfDxB+cILPgKfhl54OUwugfXrL6
	 zIu89onNLqS48QLJBzw7zr9GIB1Q1khO+DlOwlGxqKLt3FMFTW0ugNsUC6tMOFEl4X
	 I9AiO/lkKfdkfmfDg1gTpQykAw3A0AvSXyjFhmIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Yang Jihong <yangjihong@bytedance.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0986/2077] perf sched: Bounds-check prio before test_bit() in timehist
Date: Tue, 21 Jul 2026 17:10:59 +0200
Message-ID: <20260721152616.072253068@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 4477dc01fcfc7f404772a67e0c1e056541ceb61d ]

timehist_skip_sample() reads prio from untrusted tracepoint data via
perf_sample__intval(sample, "prev_prio") without bounds validation.
A crafted perf.data with prev_prio >= MAX_PRIO (140) causes test_bit()
to read past the end of the prio_bitmap, which is only MAX_PRIO bits.

Add a prio >= 0 guard before the test_bit() call and skip out-of-range
values (>= MAX_PRIO) that can never match the user's filter set.

The original prio != -1 already let all negatives other than -1 through
(after an undefined-behavior bitmap read); the new prio >= 0 guard
preserves that pass-through behavior — negative means "no priority
info", so the event is shown unfiltered — while fixing the OOB.
Values >= MAX_PRIO are skipped because they cannot be represented in
the filter bitmap.

Fixes: 9b3a48bbe20d9692 ("perf sched timehist: Add --prio option")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Yang Jihong <yangjihong@bytedance.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index defbf8dc26073c..6cf034f60c6667 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2647,7 +2647,9 @@ static bool timehist_skip_sample(struct perf_sched *sched,
 		else if (evsel__name_is(evsel, "sched:sched_switch"))
 			prio = evsel__intval(evsel, sample, "prev_prio");
 
-		if (prio != -1 && !test_bit(prio, sched->prio_bitmap)) {
+		/* negative prio means no info; out-of-range prio can't match the filter */
+		if (prio >= 0 &&
+		    (prio >= MAX_PRIO || !test_bit(prio, sched->prio_bitmap))) {
 			rc = true;
 			sched->skipped_samples++;
 		}
-- 
2.53.0



