Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2D0E55B;
	Tue,  5 Aug 2025 13:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399550; cv=none; b=VIyVbU3yDoh7erGRULB3zoEkUuLFKIXkqHlol87iVVMst0Jqsfg33zsYZuS6/qOXEb+0ledEApwXJ2xbfSNkn2AexMKzKz/UeTtKefyFBwGIBOdBay78Gd1gHwkUyihXzEyIR03pT0x6FK+8+CUK4cWKSg9m1BVsMKfYXSLm14k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399550; c=relaxed/simple;
	bh=aFWkHqBtz2+ILMDSo00KvvPIAklMYgnvlzrKoRBhTTs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AE5zPDgNu32WIB6u9aXnNeRe4hi0Q2oFbTtEOe9YZEfOvhMl89i7TXoHNZN5k80kmeRRD86+r0fTFeWsUV+XQ90GvmOaew0r+lOi61pvSDvkVXn/QmtzZuZLzxRR4jZQudkrHifWkk4cMOyGD/PAz28f26Dzs0b9H61IEo6tTV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t4h773sK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t4h773sK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED75CC4CEF4;
	Tue,  5 Aug 2025 13:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399550;
	bh=aFWkHqBtz2+ILMDSo00KvvPIAklMYgnvlzrKoRBhTTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t4h773sKMJV/xtbDQZXN1JuW1kVozH8PzBUFMQg0xkCTefOyXfon+8iwXBJttYYyD
	 ojr5k/kd3tkMwBYK6378aB24VrDGXtAGy6dA5L36zU+uvUkAIkDpat0w9M/j7WS1RD
	 Z392HvnnoDFeuxmnIRI4JDHIhsT3M30GC/rMfTh2XJ6Rm/k0K4LCr2VOFpOzzynAuY
	 d1VwMGx9zM2MsSGipRJxKX/mIzoM7G0ciRid4fdaJH3KnvLZgRg9LJm9tFEQ+2lV8D
	 AKjgN+G0Qir1MZd1e4BTc/frWjssNEKGVEZynLer3XcxkSzKubOt/GgaZNM8RC1g6y
	 7lcsEI4bbOukA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arnaud Lecomte <contact@arnaud-lcm.com>,
	syzbot+cffd18309153948f3c3e@syzkaller.appspotmail.com,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	shaggy@kernel.org,
	rand.sec96@gmail.com,
	eadavis@qq.com,
	rbrasga@uci.edu,
	ghanshyam1898@gmail.com,
	kovalev@altlinux.org,
	zheng.yu@northwestern.edu,
	aha310510@gmail.com,
	jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.16-5.4] jfs: upper bound check of tree index in dbAllocAG
Date: Tue,  5 Aug 2025 09:09:45 -0400
Message-Id: <20250805130945.471732-70-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
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

From: Arnaud Lecomte <contact@arnaud-lcm.com>

[ Upstream commit c214006856ff52a8ff17ed8da52d50601d54f9ce ]

When computing the tree index in dbAllocAG, we never check if we are
out of bounds realative to the size of the stree.
This could happen in a scenario where the filesystem metadata are
corrupted.

Reported-by: syzbot+cffd18309153948f3c3e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cffd18309153948f3c3e
Tested-by: syzbot+cffd18309153948f3c3e@syzkaller.appspotmail.com
Signed-off-by: Arnaud Lecomte <contact@arnaud-lcm.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Security Impact Analysis

This commit fixes a **critical out-of-bounds array access
vulnerability** in the JFS filesystem that can be triggered by corrupted
filesystem metadata. The vulnerability allows reading/writing beyond the
bounds of the `dcp->stree[]` array.

## Specific Code Analysis

1. **The Vulnerability**: In `dbAllocAG()`, the code calculates a tree
   index `ti` at line 1390:
  ```c
  ti = bmp->db_agstart + bmp->db_agwidth * (agno & (agperlev - 1));
  ```
  This calculated value is then used directly to access the `stree`
  array at line 1407:
  ```c
  if (l2nb > dcp->stree[ti])
  ```

2. **Missing Bounds Check**: Before this patch, there was **no
   validation** that `ti` falls within the valid range of the `stree`
   array. The `stree` array has a fixed size of `CTLTREESIZE` (1365
   elements), and `nleafs` field indicates the actual number of valid
   leaves.

3. **The Fix**: The patch adds a critical bounds check (lines
   1392-1396):
  ```c
  if (ti < 0 || ti >= le32_to_cpu(dcp->nleafs)) {
  jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmapctl page\n");
  release_metapage(mp);
  return -EIO;
  }
  ```

## Why This Qualifies for Stable Backport

1. **Security Vulnerability**: This fixes a real security issue reported
   by syzbot that can be triggered by corrupted filesystem metadata,
   potentially leading to:
   - Kernel memory corruption
   - Information disclosure
   - System crashes
   - Potential privilege escalation

2. **Small, Contained Fix**: The patch is minimal (6 lines of code) and
   adds only a defensive bounds check without changing any logic or
   architecture.

3. **Clear Bug Fix**: This is purely a bug fix, not a feature addition
   or architectural change.

4. **No Side Effects**: The fix only adds validation that prevents
   invalid memory access. It doesn't change normal operation paths.

5. **Tested**: The commit indicates it was tested by syzbot, providing
   confidence in the fix.

6. **Follows Stable Rules**:
   - Fixes a real bug that users can hit
   - Minimal change (< 100 lines)
   - Obviously correct
   - Already tested
   - Fixes a security issue

7. **Critical Subsystem**: While JFS is not the most commonly used
   filesystem, it's still in active use, and filesystem corruption
   vulnerabilities are serious security issues that should be fixed in
   all supported kernels.

The vulnerability could be exploited by:
- Mounting a specially crafted JFS filesystem image
- Corrupting JFS metadata through other means
- Potentially through unprivileged mount operations in containers

This is exactly the type of security fix that stable kernels exist to
provide - protecting users from known vulnerabilities without requiring
them to upgrade to newer kernel versions.

 fs/jfs/jfs_dmap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 35e063c9f3a4..5080d59089bd 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1389,6 +1389,12 @@ dbAllocAG(struct bmap * bmp, int agno, s64 nblocks, int l2nb, s64 * results)
 	    (1 << (L2LPERCTL - (bmp->db_agheight << 1))) / bmp->db_agwidth;
 	ti = bmp->db_agstart + bmp->db_agwidth * (agno & (agperlev - 1));
 
+	if (ti < 0 || ti >= le32_to_cpu(dcp->nleafs)) {
+		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmapctl page\n");
+		release_metapage(mp);
+		return -EIO;
+	}
+
 	/* dmap control page trees fan-out by 4 and a single allocation
 	 * group may be described by 1 or 2 subtrees within the ag level
 	 * dmap control page, depending upon the ag size. examine the ag's
-- 
2.39.5

