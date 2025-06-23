Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9454315A;
	Mon, 23 Jun 2025 21:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714912; cv=none; b=fyRJ0MI6//4hoG1jSwQtDfpzOiEFpm42brX1FRE5RVBVEV9gIj476w4F+FuDlpbjXC+H7hS3hYymQyppmb1aIRLTHvLmF+DzN7bl/T5VUDQ94u8mJTZEKhaHzTUzEG3nHY3XPHKDDoDeF1tkKA2Is3VcyUEQox3WPXt/fZ/3ymw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714912; c=relaxed/simple;
	bh=cnjJIRBz5fc76CdJsCR6cOMMaTX/eN50mxN/+/MjHWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIHhChve/eioyIjUZwbl5M+0RZ0Vvg5Hh+omTSwBx2u3wetiIMym1ZrKE/jNtvCG7gl0f6A+6lawXRGjK3UvATUmyjNisSfTTXst7Um9LK/gapAAg7NnBft43YKpkuU4Qr5E/ELRSOYHfs3fM54QcLSNNtyiWoSXRwBDYp+dwSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBaZzksH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBaZzksH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1FAC4CEEA;
	Mon, 23 Jun 2025 21:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714911;
	bh=cnjJIRBz5fc76CdJsCR6cOMMaTX/eN50mxN/+/MjHWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBaZzksHkz67ZYIR0XL2mutVGQX/FKQKVyRPN7WvMSpNowKJc0gp/nQDocvSwBZZn
	 ay/BhoTSFRrZpz0JC09e0nb66H843GwV7K2gRyyXjBhbCVCVSvX2cNgdCqHZMnPHsh
	 Ad0VRZfxSqgSMgIBLQH883hq48LGoH0ekIx5Mi8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/508] xfs: create a new helper to return a files allocation unit
Date: Mon, 23 Jun 2025 15:04:08 +0200
Message-ID: <20250623130650.263510763@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit ee20808d848c87a51e176706d81b95a21747d6cf ]

Create a new helper function to calculate the fundamental allocation
unit (i.e. the smallest unit of space we can allocate) of a file.
Things are going to get hairy with range-exchange on the realtime
device, so prepare for this now.

Remove the static attribute from xfs_is_falloc_aligned since the next
patch will need it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_file.c  | 32 ++++++++++++--------------------
 fs/xfs/xfs_file.h  |  3 +++
 fs/xfs/xfs_inode.c | 13 +++++++++++++
 fs/xfs/xfs_inode.h |  2 ++
 4 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 6f7522977f7f7..3c910e36da69b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -39,33 +39,25 @@ static const struct vm_operations_struct xfs_file_vm_ops;
  * Decide if the given file range is aligned to the size of the fundamental
  * allocation unit for the file.
  */
-static bool
+bool
 xfs_is_falloc_aligned(
 	struct xfs_inode	*ip,
 	loff_t			pos,
 	long long int		len)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-	uint64_t		mask;
-
-	if (XFS_IS_REALTIME_INODE(ip)) {
-		if (!is_power_of_2(mp->m_sb.sb_rextsize)) {
-			u64	rextbytes;
-			u32	mod;
-
-			rextbytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
-			div_u64_rem(pos, rextbytes, &mod);
-			if (mod)
-				return false;
-			div_u64_rem(len, rextbytes, &mod);
-			return mod == 0;
-		}
-		mask = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize) - 1;
-	} else {
-		mask = mp->m_sb.sb_blocksize - 1;
+	unsigned int		alloc_unit = xfs_inode_alloc_unitsize(ip);
+
+	if (!is_power_of_2(alloc_unit)) {
+		u32	mod;
+
+		div_u64_rem(pos, alloc_unit, &mod);
+		if (mod)
+			return false;
+		div_u64_rem(len, alloc_unit, &mod);
+		return mod == 0;
 	}
 
-	return !((pos | len) & mask);
+	return !((pos | len) & (alloc_unit - 1));
 }
 
 /*
diff --git a/fs/xfs/xfs_file.h b/fs/xfs/xfs_file.h
index 7d39e3eca56dc..2ad91f755caf3 100644
--- a/fs/xfs/xfs_file.h
+++ b/fs/xfs/xfs_file.h
@@ -9,4 +9,7 @@
 extern const struct file_operations xfs_file_operations;
 extern const struct file_operations xfs_dir_file_operations;
 
+bool xfs_is_falloc_aligned(struct xfs_inode *ip, loff_t pos,
+		long long int len);
+
 #endif /* __XFS_FILE_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 88d0a088fa862..3ccbc31767b3c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3775,3 +3775,16 @@ xfs_inode_reload_unlinked(
 
 	return error;
 }
+
+/* Returns the size of fundamental allocation unit for a file, in bytes. */
+unsigned int
+xfs_inode_alloc_unitsize(
+	struct xfs_inode	*ip)
+{
+	unsigned int		blocks = 1;
+
+	if (XFS_IS_REALTIME_INODE(ip))
+		blocks = ip->i_mount->m_sb.sb_rextsize;
+
+	return XFS_FSB_TO_B(ip->i_mount, blocks);
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c177c92f3aa57..c4f426eadf8e2 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -622,4 +622,6 @@ xfs_inode_unlinked_incomplete(
 int xfs_inode_reload_unlinked_bucket(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_inode_reload_unlinked(struct xfs_inode *ip);
 
+unsigned int xfs_inode_alloc_unitsize(struct xfs_inode *ip);
+
 #endif	/* __XFS_INODE_H__ */
-- 
2.39.5



