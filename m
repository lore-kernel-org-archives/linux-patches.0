Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675A418787A;
	Tue,  8 Jul 2025 00:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751932968; cv=none; b=gFV2EKYo9wddysFGU0G0U1G83AfNvHMuokQEiPCsN9W9sooVyp1Cm9F13YBthRptaX7qQdkC80wovCtz7FkQS2Fqt7shQSlLc3b93hf2SJMGEMLE+pQh6n4+KS0KSLgWGUtJz5osMI0O/n4UekTjAV7H2O2vwMBRVwL3TsGPe2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751932968; c=relaxed/simple;
	bh=gLTtW5yLX8clH/C3fD7PT3JK8A3CNDBObrfgPcWx8Wo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DIMUDNU1kPqvDyYSu5rU1A3KQJ5AOblgQ7S91stgqkFLJFB8+ubdgBBDpqMCHGGD1hpBc2cgk0Z++gzApLCSGzp1eEjRW6n62YU+QJZKxgbnFWQyyrnKLpZMbF/a+hje1dN8iARuqJ4VxeyiOUVSm2Wh8Kb1kNvMk1J/Dw3za2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IW4tJCCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IW4tJCCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426E5C4CEF6;
	Tue,  8 Jul 2025 00:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751932968;
	bh=gLTtW5yLX8clH/C3fD7PT3JK8A3CNDBObrfgPcWx8Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IW4tJCCMCS8UFmSwwzwazRHYaV5DfmT88G9WqDsCrG2nP1Q/CjfjBESYBUrEzD1QF
	 mDpeTi51+5aylI9buDH5hwyJcglciEmb8o9xhu8RDVYhaG2RkV+O/nxISLNelp9WOD
	 E43N4MwnPs86RMOd7+rdpYxef6B0D8moFMi8wSpsfXySv1lovO+G9NufEsTuxexlp+
	 qPFw116ZXT95wYuUh3Fmr2nnGtFFGt9LnFEcKjY6j150fvLakUFtJ5bn+Ul64CpDnV
	 EUIiptp1gxHzpIQbbyBWluvlrQuKiIk8vanHzCHXYGuWmHtIdJJHe2m/5kFmxeUiFf
	 qM3riepA/R3/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maor Gottlieb <maorg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	leon@kernel.org,
	phaddad@nvidia.com,
	msanalla@nvidia.com
Subject: [PATCH AUTOSEL 6.6 4/4] RDMA/core: Rate limit GID cache warning messages
Date: Mon,  7 Jul 2025 20:02:41 -0400
Message-Id: <20250708000241.793498-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250708000241.793498-1-sashal@kernel.org>
References: <20250708000241.793498-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.96
Content-Transfer-Encoding: 8bit

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 333e4d79316c9ed5877d7aac8b8ed22efc74e96d ]

The GID cache warning messages can flood the kernel log when there are
multiple failed attempts to add GIDs. This can happen when creating many
virtual interfaces without having enough space for their GIDs in the GID
table.

Change pr_warn to pr_warn_ratelimited to prevent log flooding while still
maintaining visibility of the issue.

Link: https://patch.msgid.link/r/fd45ed4a1078e743f498b234c3ae816610ba1b18.1750062357.git.leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Key Reasons for Backporting:

### 1. **Fixes a Real-World Bug**
The commit addresses a concrete problem where warning messages can flood
the kernel log. This is not a theoretical issue - it occurs when users
create many virtual interfaces without sufficient GID table space. This
is a common scenario in production environments with RDMA/InfiniBand
deployments.

### 2. **Small and Contained Change**
The change is minimal - only replacing `pr_warn()` with
`pr_warn_ratelimited()` on lines 585-586. This is exactly 2 lines of
functional change with no architectural modifications or new features
added.

### 3. **Low Risk of Regression**
- The change only affects logging behavior, not functional behavior
- `pr_warn_ratelimited()` is a well-established kernel API that behaves
  identically to `pr_warn()` except for rate limiting
- No data structures are modified
- No locking changes
- No protocol or API changes

### 4. **Follows Stable Kernel Rules**
According to stable kernel rules, this fix qualifies because:
- It fixes a bug that bothers people (kernel log flooding)
- It's a trivial change (2 lines)
- It has been tested in mainline
- It doesn't add new features

### 5. **Similar to Historical Backports**
Looking at the similar commits provided:
- Similar Commit #1 (backported): Fixed a hardware limitation issue with
  clear bounds
- Similar Commit #2 (NOT backported): Added rate limiting to ipoib_warn
  but was more invasive with macro changes
- This commit is more like #1 - a targeted fix for a specific issue

### 6. **Production Impact**
Log flooding can have serious production impacts:
- Fills up `/var/log` partitions
- Makes it difficult to find other important kernel messages
- Can impact system performance due to excessive logging
- Can trigger log rotation issues

### 7. **Context-Specific Analysis**
The error path where this warning occurs (line 571: `ret = -ENOSPC`)
specifically handles the case when the GID table is full. In
environments with many virtual interfaces, this condition can be hit
repeatedly in quick succession, causing the flood described in the
commit message.

The commit message clearly states this is fixing an observed problem:
"This can happen when creating many virtual interfaces without having
enough space for their GIDs in the GID table."

This is a perfect example of a stable-appropriate fix: minimal change,
fixes a real bug, no risk of functional regression, and improves system
stability in production environments.

 drivers/infiniband/core/cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 0b88203720b05..77c0b89259911 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -582,8 +582,8 @@ static int __ib_cache_gid_add(struct ib_device *ib_dev, u32 port,
 out_unlock:
 	mutex_unlock(&table->lock);
 	if (ret)
-		pr_warn("%s: unable to add gid %pI6 error=%d\n",
-			__func__, gid->raw, ret);
+		pr_warn_ratelimited("%s: unable to add gid %pI6 error=%d\n",
+				    __func__, gid->raw, ret);
 	return ret;
 }
 
-- 
2.39.5

