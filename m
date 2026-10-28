Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209261;
	b=u1nQ7bw3QEi7XhjFFrbaAlXXLE8MKCgI1wFpWXQbNjL+BxWrsL2YYaAStlPs34L7/e/u
	 5dovw5lcEjjh8fYpZaBSNWbR06/k0ALkxUbSHtICMF9+JGNiR25tzPUU3kdX2jPYhtXTp
	 wuFB+ZLZWQByFAk5QKZZUq48DoO5g9Ht5nvrGOIH3DF0DXRlkIpizdQR3C6FF4chWqtoH
	 K9IVeIY4rh7FJ9h3xLB5r65IGXsFx2SoQRN6S/m3yEVQwk1oj5DPyZqrs3WJz7lhXqzcx
	 LG4HiYITCJxZVEydISUabQ6Z+/OXmQBsGreTe0MBLSmly0WCNTRIPtL+VLxXa3f1FfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f5r916iSeFVYbFexVF7Gz+7j7d3wNWaSxJnzDm7wU5g=;
	b=DLC5aoGFQpvH7En4e93AtQ8VA6YNp4d4j48VAySu8a7UtK2rLjZ2xpT3ikqKeRXnDVJ8
	 j0GGdhbs3bwBHYgujX7mMLjT5Z1miDgkVU2y9VGAOcqcZYmN76OXuZ3g0U/6nlWA2djlG
	 FyD4ictdarCKCvkrqWNA4oqOXfwdsla+HHdF9brukEqQ26SFigBlblKxf735z98tYnqg4
	 wPULxaelNr6t7klAD79D1oM6AJtJocdWuLfxVv4kKwfaKjmgXLK9G7qZ+SRPpbRRYOSra
	 qjwZeqLbnhfhkhEHEomQHAmCQhkvXdh9CLPFla6ej6hG3dbVyQ5AhqvQVJYxBAK849A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VpbM9D8l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B797606A31A;
	Wed, 28 Oct 2026 17:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VpbM9D8l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2AC1F01825;
	Wed, 28 Oct 2026 17:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209261;
	bh=f5r916iSeFVYbFexVF7Gz+7j7d3wNWaSxJnzDm7wU5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VpbM9D8lprpje4SctoWYiQu7Ij8dqfgmlb7tgMx9Al/m29SsINQqXNYz1Z66TyOk1
	 QAMGnJ7pY+bfWOpzE/NJ8B6wSMD1xeYs9xT/ASvS9wxrvSwyqt8a9e96BjcpHutUBm
	 6xnDxyafCtpl5hH+yjjRFgB24vddTA4csAjtNqDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Brian Foster <bfoster@redhat.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 408/516] xfs: improve the code that checks recovered refcount intent items
Date: Wed, 28 Oct 2026 17:59:20 +0100
Message-ID: <20261028170013.151275143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <darrick.wong@oracle.com>

[ Upstream commit 0d79781a1aa6a6a567e63294012eee2384f406f2 ]

The code that validates recovered refcount intent items is kind of a
mess -- it doesn't use the standard xfs type validators, and it doesn't
check for things that it should.  Fix the validator function to use the
standard validation helpers and look for more types of obvious errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_refcount_item.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 83dddec08f3cc..2532a2a1cd593 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -423,27 +423,26 @@ xfs_cui_validate_phys(
 	struct xfs_mount		*mp,
 	struct xfs_phys_extent		*refc)
 {
-	xfs_fsblock_t			startblock_fsb;
-	bool				op_ok;
+	if (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS)
+		return false;
 
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			   XFS_FSB_TO_DADDR(mp, refc->pe_startblock));
 	switch (refc->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK) {
 	case XFS_REFCOUNT_INCREASE:
 	case XFS_REFCOUNT_DECREASE:
 	case XFS_REFCOUNT_ALLOC_COW:
 	case XFS_REFCOUNT_FREE_COW:
-		op_ok = true;
 		break;
 	default:
-		op_ok = false;
-		break;
+		return false;
 	}
-	if (!op_ok || startblock_fsb == 0 ||
-	    refc->pe_len == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    refc->pe_len >= mp->m_sb.sb_agblocks ||
-	    (refc->pe_flags & ~XFS_REFCOUNT_EXTENT_FLAGS))
+
+	if (refc->pe_startblock + refc->pe_len <= refc->pe_startblock)
+		return false;
+
+	if (!xfs_verify_fsbno(mp, refc->pe_startblock))
+		return false;
+
+	if (!xfs_verify_fsbno(mp, refc->pe_startblock + refc->pe_len - 1))
 		return false;
 
 	return true;
-- 
2.53.0



