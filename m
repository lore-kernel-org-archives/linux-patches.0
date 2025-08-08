Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D017145329;
	Fri,  8 Aug 2025 15:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754667060; cv=none; b=mlClohpUVylKRh2toPu6GUDh+J8sHaopRoNQNtNa3JfBKppAMZmy8oACTMhFCtkU7LBOE+03QM5k+6Gr77cMMmyD+fqIh5UPB+wZMmMtukZa5dSL7XySBVmdGZxlqiaa/eN1besuBP/ADgCX8RK0E57OhOsaHm2H/HU3Lf7L1hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754667060; c=relaxed/simple;
	bh=DxzlDCi4qQcmnDW8qwHvFCDPnAYgxTVD/uGeUdZo+SE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lHENROwO1uiq3dBpFzK9FDesI0n4lrkBtzl09dr3ehYn5ixyb8l70B7dpSHs7dBJSSicuMxnutAKno1vHLqP6oLQomlbH3e+kUHRxfOC6d76ChiN/6jtCyGfrb0I2wxUr5bh1/hoYTdKcM8ex2IaH0P2dZcQuOIHB36//nc/m9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eJTvQP94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eJTvQP94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961CAC4CEF4;
	Fri,  8 Aug 2025 15:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754667060;
	bh=DxzlDCi4qQcmnDW8qwHvFCDPnAYgxTVD/uGeUdZo+SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eJTvQP94vnwo62/RByVdF0cMERMtj0KxfUBhVY6HG7gf4fmqk7O7Bnn/726sjb+KY
	 7CiIuF/0s9DSqZCPF9hC07UjHIgGUE0bZsPnm/g+TbbofDO3j7xBnqdj1kNSoNpW+g
	 Fss12Sou2zXBH36a5zDNSO6AMT++Cn83ppuSN8fXpOliZGytRNd5DMhs+k9taIJA/u
	 KW8RP8UYiHBoVbXWedpHqLTr9iP3uTsNJkXCGiQsq8Ngmdvfio4mdm8PJdzupXryIU
	 9mRGWu/j5IFPkwZr70FJwJ4PTdRXSsadBSFHf1jRuuJv3uotNea9tNodYmv6nf7ujN
	 ID2Ya7HjiJ0/Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Purva Yeshi <purvayeshi550@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.16-5.10] md: dm-zoned-target: Initialize return variable r to avoid uninitialized use
Date: Fri,  8 Aug 2025 11:30:42 -0400
Message-Id: <20250808153054.1250675-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250808153054.1250675-1-sashal@kernel.org>
References: <20250808153054.1250675-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Purva Yeshi <purvayeshi550@gmail.com>

[ Upstream commit 487767bff572d46f7c37ad846c4078f6d6c9cc55 ]

Fix Smatch-detected error:
drivers/md/dm-zoned-target.c:1073 dmz_iterate_devices()
error: uninitialized symbol 'r'.

Smatch detects a possible use of the uninitialized variable 'r' in
dmz_iterate_devices() because if dmz->nr_ddevs is zero, the loop is
skipped and 'r' is returned without being set, leading to undefined
behavior.

Initialize 'r' to 0 before the loop. This ensures that if there are no
devices to iterate over, the function still returns a defined value.

Signed-off-by: Purva Yeshi <purvayeshi550@gmail.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Analysis of the Bug

The commit fixes a genuine uninitialized variable bug in
`dmz_iterate_devices()` function in drivers/md/dm-zoned-target.c:1073.
The bug occurs when:

1. The variable `r` is declared but not initialized at line 1065
2. If `dmz->nr_ddevs` is 0, the for loop at line 1067 is never entered
3. The function returns `r` at line 1073, which contains garbage data

This is a clear programming error that can lead to undefined behavior.
The function could return any arbitrary value when there are no devices
to iterate over.

## Why This Should Be Backported

1. **Real Bug Fix**: This fixes an actual bug that can cause
   unpredictable behavior. An uninitialized return value can lead to:
   - Incorrect error handling by callers
   - Potential system instability
   - Unpredictable behavior in device mapper operations

2. **Small and Contained Fix**: The fix is minimal - just initializing
   `r` to 0. This follows the pattern used in other similar
   iterate_devices implementations like `dm-cache-target.c:3438` where
   `int r = 0;` is properly initialized.

3. **No Side Effects**: The change has no architectural impact or side
   effects. It simply ensures the function returns a defined value (0)
   when there are no devices to iterate, which is the expected behavior.

4. **Affects Users**: While the condition (nr_ddevs == 0) might be rare,
   it's still a possible configuration that could affect users of dm-
   zoned devices. The undefined behavior could manifest in various ways
   depending on what's in memory.

5. **Static Analysis Finding**: This was caught by Smatch static
   analysis, indicating it's a real code quality issue that should be
   fixed.

6. **Follows Stable Rules**: The fix is:
   - Obviously correct
   - Fixes a real bug (uninitialized variable use)
   - Minimal risk of regression
   - Small change (1 line)
   - No new features or architectural changes

## Technical Context

Looking at the code structure, `nr_ddevs` is set from `argc` in line
858, which must be at least 1 based on the check at line 835. However,
there could be error paths or future code changes that might result in
this function being called with nr_ddevs == 0, making this defensive
programming important.

The fix aligns with how other device mapper targets handle their
iterate_devices functions, where the return value is properly
initialized before use.

 drivers/md/dm-zoned-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 5da3db06da10..9da329078ea4 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -1062,7 +1062,7 @@ static int dmz_iterate_devices(struct dm_target *ti,
 	struct dmz_target *dmz = ti->private;
 	unsigned int zone_nr_sectors = dmz_zone_nr_sectors(dmz->metadata);
 	sector_t capacity;
-	int i, r;
+	int i, r = 0;
 
 	for (i = 0; i < dmz->nr_ddevs; i++) {
 		capacity = dmz->dev[i].capacity & ~(zone_nr_sectors - 1);
-- 
2.39.5

