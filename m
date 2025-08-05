Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E1C2749E8;
	Tue,  5 Aug 2025 13:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399498; cv=none; b=Xidse4tS0PMixQjMSgPt4Spk5xsV6z+WpRLdTVlCXAIQofe7BQYTx4hoKD/rCySvGhnY34o0gKX54rEJSla88VniAbpc8D8Q2Y4ULYorLKmqAOWSx2K1JTHOAnJ0/w5540j2W4ab0yNGYuG78G2Dgjn3Qthh7MCCvNIR6Y11Jx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399498; c=relaxed/simple;
	bh=29x8TnAnP+R3c6a0dRVh3yLd0srO63UnLQAfwhxj40k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OFlMrT1puZQLWkY7/Hhzm+Eh5udxwHElsfF9qAQL/2ks52wfCYxsodPTyY8O6yS/QyETCr2tnku5/c+SWVB9kQvFHiwDpbKfADYRnLROw9sUNlPLbbAB7E0kIMrtI4qAxXmOUZOlZOgypBmAgCQr8L3nKVyBTmtKgDzzDqizVdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FIRW/zlR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FIRW/zlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23FFC4CEF0;
	Tue,  5 Aug 2025 13:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399497;
	bh=29x8TnAnP+R3c6a0dRVh3yLd0srO63UnLQAfwhxj40k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIRW/zlRhtZQXXBHAljGSC1adcoSFAOADxJcTeA3Tr3iy13M5D+X0XVWUgHugKSiG
	 IIJm5xGXFp6MglyqAPTolXI+DTu4dQYm6/jE7zHShI9L0ckksfYAo6v3nvOuj3i2QJ
	 w68gp+3/4IY9EZGc10ida8Bv+RtDPSx9aUXdAKMHWuddi3F+OEO/ZKKQ0YtljjD9Yz
	 4NCrXdJc4NNdEPzb3sUIkdIXiF9yOLR8of6LR0Ap2g7ya6vIJfCdn+ceH34YFwZ6wI
	 WhjbwxnNRZsLmYUEIg9lYSmDsLR9vNMMRuFhAY157JS5Yg4Q3JxMq3UxnuMU5LzJsT
	 J3FV4sHU3RlpA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lizhi Xu <lizhi.xu@windriver.com>,
	syzbot+6e516bb515d93230bc7b@syzkaller.appspotmail.com,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	shaggy@kernel.org,
	brauner@kernel.org,
	willy@infradead.org,
	josef@toxicpanda.com,
	kovalev@altlinux.org,
	chentaotao@didiglobal.com,
	jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.16-5.4] jfs: truncate good inode pages when hard link is 0
Date: Tue,  5 Aug 2025 09:09:25 -0400
Message-Id: <20250805130945.471732-50-sashal@kernel.org>
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

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit 2d91b3765cd05016335cd5df5e5c6a29708ec058 ]

The fileset value of the inode copy from the disk by the reproducer is
AGGR_RESERVED_I. When executing evict, its hard link number is 0, so its
inode pages are not truncated. This causes the bugon to be triggered when
executing clear_inode() because nrpages is greater than 0.

Reported-by: syzbot+6e516bb515d93230bc7b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6e516bb515d93230bc7b
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Backport Status: YES**

This commit should be backported to stable kernel trees based on the
following extensive analysis:

## Critical Bug Fix Nature

This commit fixes a kernel BUG_ON() crash that can be triggered in
production systems. Looking at the code changes and commit message:

1. **The Bug**: When JFS evicts an inode with `fileset ==
   AGGR_RESERVED_I` and hard link count of 0, the inode pages were not
   being truncated. This leads to a BUG_ON() trigger in `clear_inode()`
   at fs/inode.c when checking `BUG_ON(inode->i_data.nrpages)`.

2. **Root Cause**: The original code only called
   `truncate_inode_pages_final()` for inodes with `fileset ==
   FILESYSTEM_I`, missing other fileset types like `AGGR_RESERVED_I`.
   This left pages in memory when they should have been freed.

## Fix Characteristics

The fix is ideal for stable backporting:

1. **Minimal and Contained**: The change is just moving one line of code
   - `truncate_inode_pages_final(&inode->i_data)` is moved outside the
   `if (JFS_IP(inode)->fileset == FILESYSTEM_I)` condition block,
   ensuring it runs for ALL inodes with 0 hard links, not just
   FILESYSTEM_I inodes.

2. **Low Risk**: The change ensures proper cleanup for all inode types
   during eviction, which is the expected behavior. The function
   `truncate_inode_pages_final()` is safe to call for any inode being
   evicted with no links.

3. **Clear Bug Report**: This fixes a syzbot-reported crash with a
   reproducible test case
   (syzbot+6e516bb515d93230bc7b@syzkaller.appspotmail.com).

## Impact Analysis

- **User Impact**: Without this fix, users can experience kernel
  panics/crashes when specific JFS inode conditions occur
- **Security**: Prevents potential denial-of-service through triggerable
  BUG_ON()
- **Regression Risk**: Minimal - the change ensures proper cleanup that
  should have been happening all along

## Historical Context

Looking at related commits:
- Similar eviction-related fixes have been backported (e.g.,
  e0e1958f4c36 "jfs: fix uaf in jfs_evict_inode")
- JFS has had multiple stability fixes in the eviction path that were
  deemed stable-worthy
- The subsystem maintainer (Dave Kleikamp) signed off on this fix

The commit clearly meets stable kernel criteria: it fixes a real bug
that causes system crashes, the fix is minimal and correct, and there's
no risk of introducing new features or architectural changes.

 fs/jfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 60fc92dee24d..81e6b18e81e1 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -145,9 +145,9 @@ void jfs_evict_inode(struct inode *inode)
 	if (!inode->i_nlink && !is_bad_inode(inode)) {
 		dquot_initialize(inode);
 
+		truncate_inode_pages_final(&inode->i_data);
 		if (JFS_IP(inode)->fileset == FILESYSTEM_I) {
 			struct inode *ipimap = JFS_SBI(inode->i_sb)->ipimap;
-			truncate_inode_pages_final(&inode->i_data);
 
 			if (test_cflag(COMMIT_Freewmap, inode))
 				jfs_free_zero_link(inode);
-- 
2.39.5

