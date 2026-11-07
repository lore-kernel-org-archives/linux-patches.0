Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061635;
	b=NInh8+pEw206T/ZSlrEeO14Rg4fCf4B0Rde+ZTDV1VBvqWSFdVMR7TaU9eGi2tvVvJqn
	 S0zDrVnL+QM4i9in8WaFpfIIssF7S6lY/TWEHCBjEXLhw08OZ3wXd2avTSrI9wEHL36Wd
	 ncZvppeRwqCAcZLatg9rEZYhhG2wRfdCWLUUI0ICcSPTyXQ3vBUJ76UoBmlcGLOwws8ZP
	 zi86PKyAMNXTk+OHrJ4UcOmH4Ulqwcn7WBa3QZcqI7wzDzPSNLW7L/qQmBQPHnsvLo/32
	 nxO/+JPBzZ1+cU1V0IUvO/CNb0RuHYHb51ljoZ6KVYDwikN4KG6X8Bbs4uvSqRc9gAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XFSTXhWrVW3gtyOru+sp5COZEP7w2SQ07q5QWIjOIdM=;
	b=tyHTSRad6HJuhf3JpPx1zmSW/32vJnYVGiL9CZDff8nWkof4uPnb2m/ernWtHZhlgCNH
	 5jazql21xZ9Ki+GWnpQ3YsrID0JU6PXtOXG89JXZBSVB+iyuJ8+QN1lz2YTxwfxUKAo6u
	 iYNz085v1unL4nLOXrcaf5uCweHJCDcl3F+9yEuvKLZ+ltqXV/hGzI39myzt6lEqxNoNs
	 zuZXPyvBB8BF8u+HDCfGjY6bbMKgpw66hztS+Iz50u/yefpCxT5P9K30FDfdvFsKW319A
	 FLI5S+2hmoITzxyB4LISTjUzvpU7gEsfdNzpKWxd9dhL51iB+OQymoFsRuC+H0G+CNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zXW5xdyu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2932606A326;
	Sat,  7 Nov 2026 14:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zXW5xdyu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651071F0089F;
	Sat,  7 Nov 2026 14:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061634;
	bh=XFSTXhWrVW3gtyOru+sp5COZEP7w2SQ07q5QWIjOIdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zXW5xdyuJi3hG2uVS0n5vaAgwZetauFavaTS2nslx7Z1ZsSuODgxDv6P/tE7VTwWA
	 QlqibTVm0HWRti7qpeI4b/bTnAX/F4B9snpVk7ouAMawoSt583+1ocwrqQIJlbHlq3
	 Mwu7w0YEkHRIZwdslYxQ6v/qjB5O9VrXfZtkompE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0697/1536] xfs: fix inode btree repair when a cluster is larger than a chunk
Date: Sat,  7 Nov 2026 08:45:13 -0500
Message-ID: <20261107135017.068364550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 65b89ac3e8c2f041384f715a71b9d113edfa32e5 upstream.

LOLLM noticed that on filesystems where an inode cluster buffer is
larger than an inode chunk, we can run through the loop body in
xrep_ibt_process_cluster more than once, and the number of inodes that
we pass to xrep_ibt_cluster_record is incorrectly large.  In this case
we can run right off the end of the buffer.  Fix this by moving the
nr_inodes computation inside the loop.

Note that this is only likely to happen on filesystems with (say) 512b
inodes and 64k fsblocks.

Cc: stable@vger.kernel.org # v6.8
Fixes: dbfbf3bdf639a2 ("xfs: repair inode btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/ialloc_repair.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -296,12 +296,8 @@ xrep_ibt_process_cluster(
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	xfs_agino_t		cluster_ag_base;
 	xfs_agino_t		irec_index;
-	unsigned int		nr_inodes;
 	int			error;
 
-	nr_inodes = min_t(unsigned int, igeo->inodes_per_cluster,
-			XFS_INODES_PER_CHUNK);
-
 	/*
 	 * Grab the inode cluster buffer.  This is safe to do with a broken
 	 * inobt because imap_to_bp directly maps the buffer without touching
@@ -322,6 +318,10 @@ xrep_ibt_process_cluster(
 	for (irec_index = 0;
 	     irec_index < igeo->inodes_per_cluster;
 	     irec_index += XFS_INODES_PER_CHUNK) {
+		unsigned int	nr_inodes =
+			min_t(unsigned int, XFS_INODES_PER_CHUNK,
+					igeo->inodes_per_cluster - irec_index);
+
 		error = xrep_ibt_cluster_record(ri,
 				cluster_ag_base + irec_index, cluster_bp,
 				nr_inodes);


