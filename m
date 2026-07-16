Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04ACE42A7AF;
	Thu, 16 Jul 2026 14:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211967; cv=none; b=UUd995/lqoR+ZOQpkT4hEAffQR3Yj8gol43R+G9fnL9thIhVaRWBt38uUhl2zxKGD9DbT9I7hFCzhRg6z4jJaRKh165VYuUInmGbpNnZfAyO/8cjhO8HEYbAzWrBYcBF+V9bFv588Soz8OhUueFShSpmn7MLqlNLnM++lymori0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211967; c=relaxed/simple;
	bh=qgF7Yga9D2Qeiuc7Ed2k7u3KIzIbSdhH3FkY4NErG8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCeSyxy1MkpQlPzKgMm4duIQXE2x4y+wDrlF3nyMwzsMAgLr6Qin6EYgRvdraFgaQmwa4QsT4+XI9u+WFLTh4HVM+xF9sTrlSfwhSkOTa+Ll3/Q6SvTuJAKKVxhqo2gh4Z5ubRO/rOlF80cqwrxKa5II65v7HatF2jz/QE92G64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ApxEXS8W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ApxEXS8W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699D31F000E9;
	Thu, 16 Jul 2026 14:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211965;
	bh=d8vAnGAduKZX6jkoyu9iEcmn8PUskzf3Tr/uBRnM00A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApxEXS8WHNPvHubldERq8/NogfvQKDMS3VvAGr8KCq8bGwQce9iEctqCITyKnO1H+
	 pWC4gOTnh+CQyGWdS/tQvA/Fzgc5eTgFGAxBImBH9wPJVp4Hi7laKBzrCkg3GfbPqK
	 5J94Bj2FEcy5qPYCw0FSKS5jO5/Mm8ufYy/EHxlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 105/349] mm/damon/ops-common: handle extreme intervals in damon_hot_score()
Date: Thu, 16 Jul 2026 15:30:39 +0200
Message-ID: <20260716133035.666287217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit 35d4a3cf70a855b50e53189ac2f8463e20a02046 upstream.

Fix three issues in damon_hot_score() that comes from wrong handling of
extreme (zero or too high) monitoring intervals user setup.

When the user sets sampling interval zero, damon_max_nr_accesses(), which
is called from damon_hot_score(), causes a divide-by-zero.  Needless to
say, it is a problem.

When the user sets the aggregation interval zero, the function returns
zero.  It is wrong, since the real maximum nr_acceses in the setup should
be one.  Worse yet, it can cause another divide-by-zero from its caller,
damon_hot_score(), since it uses damon_max_nr_accesses() return value as a
denominator.

When the user sets the aggregation interval very high, damon_hot_score()
could return a value out of [0, DAMOS_MAX_SCORE] range.  Since the return
value is used as an index to the regions_score_histogram array, which is
DAMOS_MAX_SCORE+1 size, it causes out of bounds array access.

The issues can be relatively easily reproduced like below.  The sysfs
write permission is required, though.

    # ./damo start --damos_action lru_prio --damos_quota_space 100M \
            --damos_quota_interval 1s
    # cd /sys/kernel/mm/damon/admin/kdamonds/0
    # echo 0 > contexts/0/monitoring_attrs/intervals/sample_us
    # echo 0 > contexts/0/monitoring_attrs/intervals/aggr_us
    # echo commit > state
    # dmesg
    [...]
    [  131.329762] Oops: divide error: 0000 [#1] SMP NOPTI
    [...]
    [  131.336089] RIP: 0010:damon_hot_score+0x27/0xd0
    [...]

Fix the divide-by-zero intervals problems by explicitly handling the zero
intervals in damon_max_nr_accesses().  Fix the out-of-bound array access
by applying [0, DAMOS_MAX_SCORE] bounds before returning from
damon_hot_score().

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260623135834.67189-1-sj@kernel.org
Link: https://lore.kernel.org/20260619202459.145010-1-sj@kernel.org [1]
Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/damon.h |    8 ++++++--
 mm/damon/ops-common.c |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -770,9 +770,13 @@ static inline bool damon_target_has_pid(
 
 static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
 {
-	/* {aggr,sample}_interval are unsigned long, hence could overflow */
-	return min(attrs->aggr_interval / attrs->sample_interval,
+	unsigned long sample_interval;
+	unsigned long max_nr_accesses;
+
+	sample_interval = attrs->sample_interval ? : 1;
+	max_nr_accesses = min(attrs->aggr_interval / sample_interval,
 			(unsigned long)UINT_MAX);
+	return max_nr_accesses ? : 1;
 }
 
 
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -107,6 +107,7 @@ int damon_hot_score(struct damon_ctx *c,
 	 * Transform it to fit in [0, DAMOS_MAX_SCORE]
 	 */
 	hotness = hotness * DAMOS_MAX_SCORE / DAMON_MAX_SUBSCORE;
+	hotness = max(min(hotness, DAMOS_MAX_SCORE), 0);
 
 	return hotness;
 }


