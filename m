Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FF2155A59;
	Tue,  8 Jul 2025 00:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751932961; cv=none; b=eKfZlExlShyRfcmA8hiQE2KfuytNq9oihWdmwjyeTsKu8VaYO50BQzyqsPr778rT2rAVT+w6p1oTdvBHCU6xaUyWAAmG0wCJHb8OEdhhvRsE5VNr3xrrB0JQJQWqgzbshDnDmIZxLRsZo9Kt+TgLbaSZyeMR3XsfBTovCRh7U0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751932961; c=relaxed/simple;
	bh=q5vJbPHhif8TjMH7ecJ38whhHyagF7VMFbvZWsTMp24=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Jm/glhnsfSbK8eIPRwlfezZOgtnlBEX7iSMNn868smYj+maWfIfnvmWg4L3VBM6eW7R07Hq7OVx6SOoYN0a7IvK1xOfmRZxrHo32bWlN+DXr485r/vc8171b/if8b6rVyr+XVcwqwMTHCed3no/Ben7VGTjZxo/srLrgTWDtCxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sp44U7OF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sp44U7OF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03125C4CEE3;
	Tue,  8 Jul 2025 00:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751932961;
	bh=q5vJbPHhif8TjMH7ecJ38whhHyagF7VMFbvZWsTMp24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sp44U7OFsLDUEOCl+F8Kul4ph1NzhTDTPVB5WmcTvkozr8uDIm6m8i8W3Eq3C2qUO
	 g57eO9R5l8JPABxBKIKK56b4jknWN5QZ8eY3Ln9OhNZhRCFrNYO3YPtbp93A7LCjVX
	 dWfbwNkT7ZT851k5z7vNE8l9lFlydHZnzYNbQyrZhUKB59rbvDkIwYRv2vd7eI0Be3
	 Oo1XfPO9dDnZ6TefamspJAyJl3mLXPxquL5c/+EBvVCvpd0ckDg4oVRpsLe1C4fpZc
	 ohaulPHPZzrqq3QHQtcMrmA9dNYcY3iWBLXLQAaJWCARVfBbrD9sjDfKC5/uNcfRR1
	 i35lVL9QcHPkQ==
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
Subject: [PATCH AUTOSEL 6.12 6/6] RDMA/core: Rate limit GID cache warning messages
Date: Mon,  7 Jul 2025 20:02:30 -0400
Message-Id: <20250708000230.793347-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250708000230.793347-1-sashal@kernel.org>
References: <20250708000230.793347-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.36
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
index b7c078b7f7cfd..a1291f475466d 100644
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

