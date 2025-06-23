Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4E84315A;
	Mon, 23 Jun 2025 21:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714926; cv=none; b=ej5N1lnQikg1XVmqROhs7Vxkv9I/ySTKciPeWtDFV/YNlx489vndfaUpCT+Bj35//bUjuguIHhtMAwZmCFrRLfprvMeGbynUteX1HJ1X9G4HTa2KOB4EAA48MbSTtZVJ+u3y9UxVHG89qYw6l66+Q6NsFlt8SN4Evc+OxzEbthg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714926; c=relaxed/simple;
	bh=auGH6DEU4t4YbKYEs9VNFe7xe7VPPVpEoJDEBzo/qVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GAb+dJVXgRI7q3YSk4kcnAKREZfVujgnxnL6/TQfEmBXsPHZ+l77XIwMEC5C2atkMa0MVUY4yXUyRZfdqx/RTLkcLoDdtKDH2gqW0YdDwpGsdAp9me+Y0HWY7+vrj8UDdg32CbF7EMqm9n8Smyd4z6XTCrkNfo8uXDTOvMHYheU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3ZQwCLA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3ZQwCLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30AC7C4CEEA;
	Mon, 23 Jun 2025 21:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714926;
	bh=auGH6DEU4t4YbKYEs9VNFe7xe7VPPVpEoJDEBzo/qVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W3ZQwCLA0W0jPitFRHTXoqb2u1ZIoBs9W4ncJIPU1EAsjCn4ILSMootSf9H9CS0cP
	 On4bCsaA7LLt2u9ze3JAZooaXOZgUGd/eYeUG2PS9tNMIu/l0hs4siYolZQn3RZaPJ
	 n1EwbUhGKWf1SkK4FGPlXwwSLCDjR0mbGXr4Ln0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.1 204/508] xfs: Fix xfs_flush_unmap_range() range for RT
Date: Mon, 23 Jun 2025 15:04:09 +0200
Message-ID: <20250623130650.287862193@linuxfoundation.org>
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

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit d3b689d7c711a9f36d3e48db9eaa75784a892f4c ]

Currently xfs_flush_unmap_range() does unmap for a full RT extent range,
which we also want to ensure is clean and idle.

This code change is originally from Dave Chinner.

Reviewed-by: Christoph Hellwig <hch@lst.de>4
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 62b92e92a685d..dabae6323c503 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -963,14 +963,18 @@ xfs_flush_unmap_range(
 	xfs_off_t		offset,
 	xfs_off_t		len)
 {
-	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
 	xfs_off_t		rounding, start, end;
 	int			error;
 
-	rounding = max_t(xfs_off_t, mp->m_sb.sb_blocksize, PAGE_SIZE);
-	start = round_down(offset, rounding);
-	end = round_up(offset + len, rounding) - 1;
+	/*
+	 * Make sure we extend the flush out to extent alignment
+	 * boundaries so any extent range overlapping the start/end
+	 * of the modification we are about to do is clean and idle.
+	 */
+	rounding = max_t(xfs_off_t, xfs_inode_alloc_unitsize(ip), PAGE_SIZE);
+	start = rounddown_64(offset, rounding);
+	end = roundup_64(offset + len, rounding) - 1;
 
 	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (error)
-- 
2.39.5



