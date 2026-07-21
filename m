Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638373E49CF;
	Tue, 21 Jul 2026 18:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657251; cv=none; b=OVVC5YGcKcCanhLoxeUjn7rA2NdUDE5nG4f1ELzx+EswzhP8us6B7D8Rnn8O99IR/c3SgO2ByatyQg77+BssY/RqN0i9C1SdPkKe0sxjSlBQUhvTlR5Qpn2LENUsrYd9vijO2hlYnENlCUJVvX1V1keSJRwmkB8+CTIcwh20DH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657251; c=relaxed/simple;
	bh=rnZvEv7RgELuRWdU3USQKSAgtSXhkup7LDJti/uskA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LlXs8WfSNSpGlQ3l6PHjw4bcoxWgH0uuoPYbt15aTp2BvdAFZVjG4i8K8/5ip+MTNATmOZ832TYUCR14K/aPRC/tuFuGfqpAeRT91wX6p8xaVisMeljgMc2vxGkjUr5DhQFT51jSUflwhpsp2iYLv0C6AyC2xTWvhr+TT/TEx/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFZD4WiW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFZD4WiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35371F000E9;
	Tue, 21 Jul 2026 18:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657250;
	bh=zYOW9Qae81djpuz0mSch9x87qsy+7Yazh4N9c7YAPfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GFZD4WiWfL6hwe6ENpOL8Ub4jUC6tbsuJb51xw+MAVpV/dMOJ9XEBcd2levUcLD+f
	 XP0TBiiYm5y4EIE6z+cYD7QB+lnzkxmUAl25jcJUOowFD1EWsEx1r3HDG8t4WPJW5K
	 0l82zpYd1ofdP7mySG5sosU+ZVPsbOcxbI0AlSWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Yang Jihong <yangjihong@bytedance.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0692/1611] perf sched: Bounds-check prio before test_bit() in timehist
Date: Tue, 21 Jul 2026 17:13:28 +0200
Message-ID: <20260721152530.945752458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 36c8a018a830f1..074de58c8675b7 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2631,7 +2631,9 @@ static bool timehist_skip_sample(struct perf_sched *sched,
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



