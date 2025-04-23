Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0462F2E;
	Wed, 23 Apr 2025 15:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420424; cv=none; b=bEvE22pghPmJScUuMloVk5ztBXrOcyO0iO1Lz0nJNLImBggMOMjblPAvAkNFtz4alIBcYh2yobc/ZgfvE2Sdo2wgcafccfLOrZ8O01VR4tfBDkiL7jxoXCakWMycD+ocMdto8I9j+7hRYdYjlXiuJgu9t3cLuoqPYcXZZvwrk7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420424; c=relaxed/simple;
	bh=uWqMTn7/O5IynKoIvJ75lfhucUtN3VHv1wf1cQQqgGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVhZcJZEO93DjYvUIttjfiUnn6+ZJ7n1bnWP/F9lgO6tpM4Yw4OLLeKTYzmK8K7eaariYu1WmneoCWuOjNc4jvQZ5t+153SWkwiK0j1e4SkqbBH73GtnIMQSPvs2dQBfoGhDaAQCm/vXMtlbIlFg/MyaXV+21qFp/VpfVmbeVmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8xZZux6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8xZZux6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D283FC4CEE2;
	Wed, 23 Apr 2025 15:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420424;
	bh=uWqMTn7/O5IynKoIvJ75lfhucUtN3VHv1wf1cQQqgGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8xZZux6nxe/4lhTj+AXwwqMrxisiQREO91LI4El13zIZYaspX246swmlAwd+Yqas
	 sCe0j56uZNW03QRO22Gqw4JTULzBQsyavRuU54h9ia1AzSyY2AgzBNnQf0oV6BwFMZ
	 0DwcCCdvUsptl4DMevQNads5ckYPg8qSYGnNJigs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/393] fs/jfs: Prevent integer overflow in AG size calculation
Date: Wed, 23 Apr 2025 16:39:29 +0200
Message-ID: <20250423142646.321328749@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rand Deeb <rand.sec96@gmail.com>

[ Upstream commit 7fcbf789629cdb9fbf4e2172ce31136cfed11e5e ]

The JFS filesystem calculates allocation group (AG) size using 1 <<
l2agsize in dbExtendFS(). When l2agsize exceeds 31 (possible with >2TB
aggregates on 32-bit systems), this 32-bit shift operation causes undefined
behavior and improper AG sizing.

On 32-bit architectures:
- Left-shifting 1 by 32+ bits results in 0 due to integer overflow
- This creates invalid AG sizes (0 or garbage values) in
sbi->bmap->db_agsize
- Subsequent block allocations would reference invalid AG structures
- Could lead to:
  - Filesystem corruption during extend operations
  - Kernel crashes due to invalid memory accesses
  - Security vulnerabilities via malformed on-disk structures

Fix by casting to s64 before shifting:
bmp->db_agsize = (s64)1 << l2agsize;

This ensures 64-bit arithmetic even on 32-bit architectures. The cast
matches the data type of db_agsize (s64) and follows similar patterns in
JFS block calculation code.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rand Deeb <rand.sec96@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index f89f07c9580ea..9ac1fc2ed05bc 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -3403,7 +3403,7 @@ int dbExtendFS(struct inode *ipbmap, s64 blkno,	s64 nblocks)
 	oldl2agsize = bmp->db_agl2size;
 
 	bmp->db_agl2size = l2agsize;
-	bmp->db_agsize = 1 << l2agsize;
+	bmp->db_agsize = (s64)1 << l2agsize;
 
 	/* compute new number of AG */
 	agno = bmp->db_numag;
-- 
2.39.5



