Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA16433BC0;
	Tue, 21 Jul 2026 19:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662593; cv=none; b=Z6RLNwsSy+jQSscpI1RgflaCKGwdIzvOLuzNl6iB5RRCcxnQDTalIZ9NzEeOsMuPPcMZqktATaYnI7J4C6w6D8t/tk/6UHdcYaBkpJqLFlhJ+MQx7Lm0xbAT0H0sD2i+jnw67CXGOg4Ybiv6hoZ/jVgdlPDaPBHbAz8+mKkNi90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662593; c=relaxed/simple;
	bh=sc6mYILdUB59gVQl+x2tyP/5OMbLdlt+0bXUXmZPwGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I3sLAwEEwfpB7TT0c0SrsTq9cj6jQ6KWxfpSR5owfB3o3cTYH3fjuWH/lRx+uR/3mw7zpiQCl16swXFXG/rFi7J6lD+yTlFM9v7br7OuU/6D3X4YI1ZlXk2vXjVftN1fcXYGkho0xh+5ETItRhCQ2wdJgSt7eUnzO0a8POcwuP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyMOUhgu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyMOUhgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A291F000E9;
	Tue, 21 Jul 2026 19:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662591;
	bh=NT3GizsijI0rKihSuNqJ2UBsm1FMektDTuHPvpoaXw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyMOUhgu9tO2T+3ZZmwhJnCUxZHs9mG4MQkUq/Gue6cOT9ECO32dnbkfxklOOXJgk
	 BK9kxKT+sWsrJ7f/85/U6tCzgEGdzryMr+b4JsxBSlHuhexrD4ouh4PO9QIB4WHwQV
	 v/sPfO3FQh61ImEqu6TkUjlYMh7nmmvI2vRJ7Lj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Yang Jihong <yangjihong@bytedance.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0501/1276] perf sched: Bounds-check prio before test_bit() in timehist
Date: Tue, 21 Jul 2026 17:15:44 +0200
Message-ID: <20260721152457.316941741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d599ad421df108..7cf56e271a993a 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2646,7 +2646,9 @@ static bool timehist_skip_sample(struct perf_sched *sched,
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



