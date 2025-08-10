Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CCC26CE36;
	Sun, 10 Aug 2025 16:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754844764; cv=none; b=VstMff6lzaiURX6XE08Lfo0kWzR/nOUkO9cKLjsmlWLKEGHLwLVvyGiHnlV1aeezl2vQYAlIxrD4kkXtA9dI99wnxTF5/iRkORuA4IbHlVgu/I5RQm/a6jkEohM2jdUwpI5Vx9wYJlDvfPKbcIsmdhGbQCZK+0GDSH5SaIENWIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754844764; c=relaxed/simple;
	bh=doK/zJmOU7JySDpUp7DaaVQlVCndfsG+lEe1+op8Yv8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B6B+jYUO9Qquec6Pb5wRYjLjP1Y15LWDiuPLIDWbMGD0ebvJkXcwRP2YyAgzoiCIZhQZ6+c4g1lYtf2Y8rmvv7KOxzRG2z0kAgVA1BIZ3hq2jm6h3WGEQyXOLcL/tJGVVrnseh1htHdioBkX73WX7QVpWWaYVY9JWagRroolYVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m7h+D1iS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m7h+D1iS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E87CC4CEF7;
	Sun, 10 Aug 2025 16:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754844762;
	bh=doK/zJmOU7JySDpUp7DaaVQlVCndfsG+lEe1+op8Yv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m7h+D1iSbiXd4Hi9FuaHMef0467n3KEPdS4HUFig4tREOpZVdeDAHrsICPi36KmZ1
	 UpSh5YcnFsQFIPtSCVqV1SV44+Sq15WnoCkymj4Of2eIuhUhSViztBpoAdK8SAQQyk
	 eNMSw7tyLNDAK5pHLV+le3bRcFZAzUcxWLw6ulOS5WL/LcxYFuXKXeOrdPzqz/9vaG
	 +5XEDtgI5gp97EgYvX1V/lISyizUORTF7WuXgAYHrra3FxnMV8z2VKsCo/cZaG099r
	 3037jAgXoeKI0V2Kvj7nNW4gCF0LwWyXs+tyGrDn5d03Em/lv8Jk/B5jWGzOkRB5rl
	 T5Z40ountzwSQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>,
	bcodding@redhat.com,
	chuck.lever@oracle.com
Subject: [PATCH AUTOSEL 6.16-5.4] pNFS: Fix disk addr range check in block/scsi layout
Date: Sun, 10 Aug 2025 12:51:56 -0400
Message-Id: <20250810165158.1888206-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250810165158.1888206-1-sashal@kernel.org>
References: <20250810165158.1888206-1-sashal@kernel.org>
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

From: Sergey Bashirov <sergeybashirov@gmail.com>

[ Upstream commit 7db6e66663681abda54f81d5916db3a3b8b1a13d ]

At the end of the isect translation, disc_addr represents the physical
disk offset. Thus, end calculated from disk_addr is also a physical disk
offset. Therefore, range checking should be done using map->disk_offset,
not map->start.

Signed-off-by: Sergey Bashirov <sergeybashirov@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250702133226.212537-1-sergeybashirov@gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit is a clear bugfix that should be backported to stable kernel
trees. Here's my detailed analysis:

## Bug Analysis

The commit fixes an incorrect range check in the pNFS block/SCSI layout
code. Looking at the code flow:

1. **Variable Transformations** (lines 140-148):
   - `disk_addr` starts as a physical disk offset (line 141)
   - It gets adjusted by `map->disk_offset` (line 147)
   - Then it's adjusted by subtracting `map->start` (line 148)
   - After these operations, `disk_addr` represents the **relative
     offset within the mapped region**

2. **The Bug** (lines 151-153):
   - `end = disk_addr + *len` calculates the end position using the
     **transformed** disk_addr
   - The buggy check `if (end >= map->start + map->len)` incorrectly
     compares this relative end position against `map->start + map->len`
   - This is wrong because `end` is now relative to the mapping, not an
     absolute address

3. **The Fix**:
   - Changes the comparison to `if (end >= map->disk_offset + map->len)`
   - This correctly uses `map->disk_offset` which corresponds to the
     physical disk space after the transformations

## Why This Should Be Backported

1. **Clear Bug Fix**: This fixes a logical error in range checking that
   could lead to:
   - Incorrect I/O length calculations
   - Potential data corruption if writes go beyond intended boundaries
   - Read errors or incomplete data transfers

2. **Small and Contained**: The fix changes only 2 lines in a single
   function, making it low-risk for regression

3. **Critical Subsystem**: pNFS block layout is used in production NFS
   environments for high-performance storage access

4. **No New Features**: This is purely a bugfix - no new functionality
   or architectural changes

5. **Stable Impact**: The bug could cause silent data corruption or I/O
   errors in stable kernels using pNFS block layouts

6. **Related History**: The codebase shows previous fixes for similar
   range checking issues (commit f34462c3c8a2), indicating this is a
   sensitive area that needs correct boundary validation

The incorrect range check could allow I/O operations to proceed with
incorrect length limits, potentially accessing memory beyond the
intended device mapping boundaries. This is exactly the type of bug that
stable kernels need fixed - a subtle logic error with potentially
serious consequences in production systems.

 fs/nfs/blocklayout/blocklayout.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 47189476b553..5d6edafbed20 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -149,8 +149,8 @@ do_add_page_to_bio(struct bio *bio, int npg, enum req_op op, sector_t isect,
 
 	/* limit length to what the device mapping allows */
 	end = disk_addr + *len;
-	if (end >= map->start + map->len)
-		*len = map->start + map->len - disk_addr;
+	if (end >= map->disk_offset + map->len)
+		*len = map->disk_offset + map->len - disk_addr;
 
 retry:
 	if (!bio) {
-- 
2.39.5

