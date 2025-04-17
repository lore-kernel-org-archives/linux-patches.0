Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BC225335A;
	Thu, 17 Apr 2025 18:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915349; cv=none; b=gNhFG6QjzxgrZAC3ajReKbi9vxzCjuRUzcxm91eA5YGyd7G/BINmuWQWSHqVgceF3gvLixBImQf012yN6kXGxyodx8LBIRquIkL5JapG95odkrU2iijaUbih0rVc0WgXgq68fbFts3+NLP2cMESC7fBPPbjDtu2JDzKoWplJe80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915349; c=relaxed/simple;
	bh=gBIbbDX2Uf3LMPerbUmGBX4Z55yhEirJsCJBz6OAZ8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2iRI3u9GHOLf1RArjzDEYZuL5VTGaMGEvDyLzdEcIGxAHOrgtU7o8SIzvgExSFMRY4tArfKW7bk/QWvtImz3Q+qs6M8j/OhJBN5P1JJ6Ky6rG3JoWdBlnzdGSQVYl+89U5fYMG8qcUWED9ulykxtRYD25cNIhGJqjV5lGUKy4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9RswXnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9RswXnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521B7C4CEE4;
	Thu, 17 Apr 2025 18:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915349;
	bh=gBIbbDX2Uf3LMPerbUmGBX4Z55yhEirJsCJBz6OAZ8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9RswXnBbUz/UOzTfmx3vGbMWpHylVHT6tmatCTbZQnLSwnPs2vmCmmZcCtPXyMd2
	 l5WSr0Ifs9Fdvp1BakAz4JmAUVFtiVyhgS0FYIWPg/GakMHkBdwVRfZXbVe26nkKbU
	 +mkpTB/rA504YE80KGBVrsCsYwv97wHGcdJQO82I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/393] fs/jfs: Prevent integer overflow in AG size calculation
Date: Thu, 17 Apr 2025 19:48:29 +0200
Message-ID: <20250417175111.619908655@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



