Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC6443932A;
	Tue, 21 Jul 2026 21:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668231; cv=none; b=VZsX+Eqjda6KQRYq+u8xjAHt1d8SL1OnstU0Jo2C18+KDIKwgy0/olvzTdirzBcpcponse/wrdnufRoJIpKwoIhtBsIMtwhNrv9k7RnQVCuu55GBPDpbO7oYpzfbB0o2cRjkIefKVfcQ2owUnXB++1Q5oq/D4vu10nf2Z8i3GOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668231; c=relaxed/simple;
	bh=zles75PAh8ZkPQHNMZg0bx8aUF3oZ+02X72knbDcQIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlonqJY+Aa1X5jRGtFaqsC2sGZCY5K8TK5RwJ9uc/ssMFvM9/t+KxJCQrmw/vB0F4uItBeRTyLktHlnXrO3uo7amuRTCwOSB/jCoZg5qgXMch8YCzyLHpLLG/q3ZdMKOYOnYRNJvsM2xqcvpCehe6WX99RsObgZ9nTFft5r0v68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDOTY/af; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDOTY/af"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6CF1F000E9;
	Tue, 21 Jul 2026 21:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668229;
	bh=ULbG4NmlhF94ntRrNLY4fiwZwUZwRHJLPDnqjpYhxSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDOTY/afPmdVrROBNe8A51IXtIsxqd3aMNIgpzwYkQtWXEkXpnhTGCNGdRMpv+K9E
	 RK13eYiNcVzZZEGPIAVFimk+Opw0gowR5/d2hwKNz7vX79LAidYqY0tKbMr9VODVEt
	 kAwjBxVBiPQBg5k31Zak18XukkqonitCR4y5cs3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 0095/1067] mm/damon/ops-common: handle extreme intervals in damon_hot_score()
Date: Tue, 21 Jul 2026 17:11:36 +0200
Message-ID: <20260721152426.711983044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -564,9 +564,13 @@ static inline bool damon_target_has_pid(
 
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
@@ -121,6 +121,7 @@ int damon_hot_score(struct damon_ctx *c,
 	 * Transform it to fit in [0, DAMOS_MAX_SCORE]
 	 */
 	hotness = hotness * DAMOS_MAX_SCORE / DAMON_MAX_SUBSCORE;
+	hotness = max(min(hotness, DAMOS_MAX_SCORE), 0);
 
 	return hotness;
 }


