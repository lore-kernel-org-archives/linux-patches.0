Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A376F137F
	for <patches@lists.linux.dev>; Fri,  1 Apr 2022 18:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A57C340F3;
	Fri,  1 Apr 2022 18:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648837738;
	bh=FxgTMCltgj8iR00ivm3JJTqJdRoqVdzMYU6tKfr4jU8=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=vRfchcMietkIjkan8zWCrOtZIpnM3U0pITB5DhmDx4AHNKK0rfIyoXg5EwmIaBwCm
	 JHxlyIF6bVxGeecxhTynjz3JI8lXfTJvAOVwq4u/uBqZT0sWTrRR/KnbD/ijSPhLxR
	 xcl7elSLtBu6EufaSo5pb4oCZeQu6VdiWiRlJsFA=
Date: Fri, 01 Apr 2022 11:28:57 -0700
To: sj@kernel.org,tome01@ajou.ac.kr,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220401112740.351496714b370467a92207a6@linux-foundation.org>
Subject: [patch 16/16] mm/damon: prevent activated scheme from sleeping by deactivated schemes
Message-Id: <20220401182858.73A57C340F3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Jonghyeon Kim <tome01@ajou.ac.kr>
Subject: mm/damon: prevent activated scheme from sleeping by deactivated schemes

In the DAMON, the minimum wait time of the schemes decides whether the
kernel wakes up 'kdamon_fn()'.  But since the minimum wait time is
initialized to zero, there are corner cases against the original
objective.

For example, if we have several schemes for one target, and if the wait
time of the first scheme is zero, the minimum wait time will set zero,
which means 'kdamond_fn()' should wake up to apply this scheme.  However,
in the following scheme, wait time can be set to non-zero.  Thus, the
mininum wait time will be set to non-zero, which can cause sleeping this
interval for 'kdamon_fn()' due to one deactivated last scheme.

This commit prevents making DAMON monitoring inactive state due to other
deactivated schemes.

Link: https://lkml.kernel.org/r/20220330105302.32114-1-tome01@ajou.ac.kr
Signed-off-by: Jonghyeon Kim <tome01@ajou.ac.kr>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-prevent-activated-scheme-from-sleeping-by-deactivated-schemes
+++ a/mm/damon/core.c
@@ -1019,12 +1019,15 @@ static int kdamond_wait_activation(struc
 	struct damos *s;
 	unsigned long wait_time;
 	unsigned long min_wait_time = 0;
+	bool init_wait_time = false;
 
 	while (!kdamond_need_stop(ctx)) {
 		damon_for_each_scheme(s, ctx) {
 			wait_time = damos_wmark_wait_us(s);
-			if (!min_wait_time || wait_time < min_wait_time)
+			if (!init_wait_time || wait_time < min_wait_time) {
+				init_wait_time = true;
 				min_wait_time = wait_time;
+			}
 		}
 		if (!min_wait_time)
 			return 0;
_
