Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6002030A;
	Tue,  8 Jul 2025 00:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751932992; cv=none; b=RwbVnkHMWZ0qYmNEYeJiAFWgCt18iA9hASlGHEghpk776GogMvSTAJhhux8yN6TazgtyHkRJZul812jq1Xn/u5a1bidvOMhvYhXjlwu4Dq45bgS72Qp4YcZ47PtWre9v6R9VyHD2VK0qsZuXoUH3X2/Pd5YLWHvh8I07/0CAfPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751932992; c=relaxed/simple;
	bh=xq5sJP2IXD6XlYbJV37Zz2Oy/i0Bn1yBR02wa9zTCI8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XhPfSv5C2YRnGOs4AfWf/fGWWXFbVF4B9F29u/IeSdoJh85XK21C4rF5GAyHd4s8chN+ZE9AE5WA4lqhn1idx46syXabdyCMzCHJI+E7g8K6tXU5WfYPjd2M6nAGS3x4Wucp1MVm7jv0dvIGJrjIfq4cEnd2k2N34Etv3w5pDg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f5p4Gorj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f5p4Gorj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429CFC4CEF5;
	Tue,  8 Jul 2025 00:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751932992;
	bh=xq5sJP2IXD6XlYbJV37Zz2Oy/i0Bn1yBR02wa9zTCI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5p4GorjD2Ag9Wy7+srD/NkE3WfwLTxxVOJJ9NNYTt6OVGRSRJbe2W5s7QshusIyp
	 k0MKuVyZVFbG1DckD19EOIxBs1zx6vs5cK8hGL7SYug+2ilrT+AYla/nXpDtayeDwB
	 PHEJ7bCTnomO6pyX8plE+/CThx3hNz1LkI00OKAAhU/U4NVmNBJy+JAA5aTsWmQZBq
	 RtlCGIRNJUlPO+IbJfXA7T94MVCnLboK2LJd2JCbD9NTIz6Hj/RbN/yYHjaFgJ6hPs
	 NPDRoVD2iqQ6dewXvedcbBKqkgUjyEpoDHR4XoXGLqNtgTvGiAhwJmkyX9/Iw77B2o
	 rptJTxQjTLDBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maor Gottlieb <maorg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	leon@kernel.org,
	msanalla@nvidia.com,
	phaddad@nvidia.com
Subject: [PATCH AUTOSEL 5.4 3/3] RDMA/core: Rate limit GID cache warning messages
Date: Mon,  7 Jul 2025 20:03:05 -0400
Message-Id: <20250708000306.793995-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250708000306.793995-1-sashal@kernel.org>
References: <20250708000306.793995-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.295
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
index 7affe6b4ae210..641e537a0069a 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -578,8 +578,8 @@ static int __ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
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

