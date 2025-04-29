Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3325427453;
	Tue, 29 Apr 2025 16:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945149; cv=none; b=OP6x6wAkvmQj8e+JkCtTn/ZA6TradU9Zrv+Dp7z/vL6yjS4LUoi9CtCu/8kIvIbgmzJ/N3yYKzDOdbbA7r2Ne/B37BUv3s3s2/CdVA0QfWGzV2Bf8Jerc5kUY/KB9DZerF7XpPnVdRaJ4zJ5OuXz+MWPWipjN2y8nRvcVkqDAXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945149; c=relaxed/simple;
	bh=XEq4zHJmTo243ECKWgdJi8bdmeZnlF2uDDTXWEPbPK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHx20d+Otgz2lf6uuaT9xVylU6T3mWkApY+Pk8eXaZ3VAfi6oY+iwEQ42M/suXcOVYOkB/+F8I7ijEX5vkYrL/0dOvZpq+Loqm9nSTHTlcZqRMdzWBGFQCoFtYYYxOVuL8Eglt57LP/z2hlUq2z7pLcumdawBHDjg3zFywW5pSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPiAFHM/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPiAFHM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F42C4CEE9;
	Tue, 29 Apr 2025 16:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945148;
	bh=XEq4zHJmTo243ECKWgdJi8bdmeZnlF2uDDTXWEPbPK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPiAFHM/33HlzPVhfVo+vF5M6L0ddeuXXQA/bjC1GFcUK/JrxS8PUqCiTVr+fNIFN
	 u0c6cOfh02V/9HFp5veCFY+VHHRFQwgG8h4BlTSHFDc7jeubKW2W08ZlK185t1wQIG
	 284FEf3sm51lmemXikOwI3+EK+N3xQU5MP/nDkak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rand Deeb <rand.sec96@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 018/179] fs/jfs: Prevent integer overflow in AG size calculation
Date: Tue, 29 Apr 2025 18:39:19 +0200
Message-ID: <20250429161050.145691342@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3bc304d4886e6..d4e26744b2005 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -3465,7 +3465,7 @@ int dbExtendFS(struct inode *ipbmap, s64 blkno,	s64 nblocks)
 	oldl2agsize = bmp->db_agl2size;
 
 	bmp->db_agl2size = l2agsize;
-	bmp->db_agsize = 1 << l2agsize;
+	bmp->db_agsize = (s64)1 << l2agsize;
 
 	/* compute new number of AG */
 	agno = bmp->db_numag;
-- 
2.39.5



