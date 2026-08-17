Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6293AAF6D;
	Mon, 17 Aug 2026 15:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979643; cv=none; b=SJdUZ93JgGVkV9p7EVATC+DoWWoqD4yis5U4D2EUlowdnSPa2fguzw5u8PzIP/XB7tFclHcIuI/Ij0Jez6vksOeQLdkPoT6joj0lxKnvApUJBR14SZYPkepiXs+81JBxhcVVGVZeuXnP8XqaMRTT7XC7Fkdg1o+/I0AWiaQ7xuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979643; c=relaxed/simple;
	bh=pTp32Vl5nut2nTnjiI4BER6pEjgdUv0MTEVDsKWgwX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mO0VKrv41IjsGbV6Tn4mBBqKGcXhKp/0h75KC6ruSgBUdUGy2LKkRRqvgrr2Dp2E1SK2VWTgTbTCvB8XnB/G4BxbSC7ojC3j7dLnxTJli64GoGzZ54F4PL+DzBs1uLHIiIaXXnttrIB0hYkXPPuBvPIw2YD/53syZ20UbpMnD4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0RJARq3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0RJARq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FE01F000E9;
	Mon, 17 Aug 2026 15:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979642;
	bh=ztqZVVUK/hETcWfHR15n3yNIPULR+vgsEPc6Plh6Rws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0RJARq3PcaQsS3HijObcOBu0H/DfrVPBMaC214OlT7ecPo2BA+S73FTtb6oR1yyo
	 F7zIjcb6gJf6RMj4f5+8V2OT0Gx8tMAxjNCfJBER4mctt4i4jA8H7elPlqNOfbNb/d
	 bnSNVzqIFCO4JJTdx97WK01Y5Si99tQLwf6Wox/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 297/609] mm/damon/core: disallow overlapping input ranges for damon_set_regions()
Date: Mon, 17 Aug 2026 15:29:53 +0200
Message-ID: <20260817132554.160636035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

commit 954157679ec34661c2e87e7eb796104a797c32db upstream.

damon_set_regions() assumes the input ranges are sorted by the address and
don't overlap each other.  Hence the assumption was initially to be
explicitly validated.  But commit 97d482f4592f ("mm/damon/sysfs: reuse
damon_set_regions() for regions setting") has mistakenly removed the
validation.

This can make DAMON behave in unexpected ways.  At the best, the
monitoring results snapshot will just look weird since there will be
overlapping regions.  DAMOS will also work weirdly, applying the same
action multiple times for overlapping regions, and make DAMOS quota weird.
More seriously, depending on the setup and regions updates sequence,
negative size regions can be made.  It will trigger WARN_ONCE() if the
kernel is built with CONFIG_DAMON_DEBUG_SANITY=y.  Depending on the
monitoring results, the negative size region can further trigger division
by zero in damon_merge_two_regions().

Note that some of the consequences including the WARN_ONCE() and the
divide by zero depend on commits that were introduced after the root cause
commit 97d482f4592f ("mm/damon/sysfs: reuse damon_set_regions() for
regions setting").

Fix the problems by checking the assumption and returning an error if
the input ranges don't meet the assumption.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260703165610.92894-1-sj@kernel.org
Link: https://lore.kernel.org/20260630041806.151124-1-sj@kernel.org [1]
Fixes: 97d482f4592f ("mm/damon/sysfs: reuse damon_set_regions() for regions setting")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0a0bb033f28a..dd4eafe8b961 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -210,12 +210,19 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 {
 	struct damon_region *r, *next;
 	unsigned int i;
+	unsigned long last_end;
 	int err;
 
 	for (i = 0; i < nr_ranges; i++) {
-		if (ALIGN_DOWN(ranges[i].start, DAMON_MIN_REGION) >=
-				ALIGN(ranges[i].end, DAMON_MIN_REGION))
+		unsigned long start, end;
+
+		start = ALIGN_DOWN(ranges[i].start, DAMON_MIN_REGION);
+		end = ALIGN(ranges[i].end, DAMON_MIN_REGION);
+		if (start >= end)
+			return -EINVAL;
+		if (i > 0 && last_end > start)
 			return -EINVAL;
+		last_end = end;
 	}
 
 	/* Remove regions which are not in the new ranges */
-- 
2.53.0



