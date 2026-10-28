Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209256;
	b=v8JKQTTBC4zUGLZIoC0LB3P/yNgWQLzT1VUtr8kWGuLbtTLGI7SiVPHHm8VMg2lDTOG/
	 iPYEDRu3gtM1A7TLdUBOtTJ7y7XtQEsCu8iuh04NAt9IxCqiTiBNrleH1SHbvkabbWP6x
	 kVxay1mVK9+Lsbmmhc71YhgxcrOWjCC9xPTTH9G/hfZmokY1OUypY8CHyVCKn7M3xhTHa
	 YITgF8xsyF4XzDh1Zh7aCReNwTrMlpOluWJ1asfULadiKYnFn2mXiQP36VroNIYoK6Xih
	 pgbMFUjuNnB4YpdvEI7u/Zfm7CKq9ZewyOzQFEZ/++13oLJPotEs7tGQxQvy+hEEb8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tsWDcVf4DjCu4mJYAniZqG8LQtcMZR8X1aW2wlL4hcs=;
	b=RU0KAryKBMU73Non8PlCoC3lFLBsjL7+sT9ZPUoC9cOX04NzvEKtsydJGhROzEIP6zlX
	 +Vz/WVhP2m10jK8CMLgimPQ2b5vkjfCM1iwaC86mAm0y5Y5B9W03IPpOoF/Ud31et6THy
	 CN/P0jcfGY6PeqtGEGDSnozafezjpTESEasZmoUZIZimxZu1ufnxdd03zjuGh0QQPp78Z
	 AX+rP+BhTlsz/iApS3Id94n6BVIlyrjmmazqpKcGh2t0vpr2I+Q+yutyQMxXhI1mY30kd
	 XEs8qHjNY7cgVmRR0mkRCPZUAad0o60oy9KPd2jh1JsQfjQXtX35b8NDNL9i5dy6TZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLV6mzaW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A8A606A31A;
	Wed, 28 Oct 2026 17:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLV6mzaW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA2C1F01825;
	Wed, 28 Oct 2026 17:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209255;
	bh=tsWDcVf4DjCu4mJYAniZqG8LQtcMZR8X1aW2wlL4hcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLV6mzaWHniMBss3fz9eFOEMfTSS9wyEsTurVBB5XhFEVZSb5cKsatVxftr+dgGsI
	 mICUFD0rJYmdzEQxWOpGJWuFE2OE+ctYUb18BuhqUZR6v13nH/dxzv7Ozr8Id6rdFv
	 eKHqaLYXzUpDGFu+wyjzcRtsLZ9TonfUdXD/zbwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Brian Foster <bfoster@redhat.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 406/516] xfs: improve the code that checks recovered rmap intent items
Date: Wed, 28 Oct 2026 17:59:18 +0100
Message-ID: <20261028170013.102840280@linuxfoundation.org>
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

[ Upstream commit c447ad62dc906f4b5f788e8ff20c1768ab2eab2c ]

The code that validates recovered rmap intent items is kind of a mess --
it doesn't use the standard xfs type validators, and it doesn't check
for things that it should.  Fix the validator function to use the
standard validation helpers and look for more types of obvious errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Stable-dep-of: 7b5f775be14a ("xfs: fix unmount hang with unflushable inodes stuck in the AIL")
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_rmap_item.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 31cfd734962fd..f248e2b0ab5df 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -466,11 +466,9 @@ xfs_rui_validate_map(
 	struct xfs_mount		*mp,
 	struct xfs_map_extent		*rmap)
 {
-	xfs_fsblock_t			startblock_fsb;
-	bool				op_ok;
+	if (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS)
+		return false;
 
-	startblock_fsb = XFS_BB_TO_FSB(mp,
-			   XFS_FSB_TO_DADDR(mp, rmap->me_startblock));
 	switch (rmap->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
 	case XFS_RMAP_EXTENT_MAP:
 	case XFS_RMAP_EXTENT_MAP_SHARED:
@@ -480,17 +478,25 @@ xfs_rui_validate_map(
 	case XFS_RMAP_EXTENT_CONVERT_SHARED:
 	case XFS_RMAP_EXTENT_ALLOC:
 	case XFS_RMAP_EXTENT_FREE:
-		op_ok = true;
 		break;
 	default:
-		op_ok = false;
-		break;
+		return false;
 	}
-	if (!op_ok || startblock_fsb == 0 ||
-	    rmap->me_len == 0 ||
-	    startblock_fsb >= mp->m_sb.sb_dblocks ||
-	    rmap->me_len >= mp->m_sb.sb_agblocks ||
-	    (rmap->me_flags & ~XFS_RMAP_EXTENT_FLAGS))
+
+	if (!XFS_RMAP_NON_INODE_OWNER(rmap->me_owner) &&
+	    !xfs_verify_ino(mp, rmap->me_owner))
+		return false;
+
+	if (rmap->me_startoff + rmap->me_len <= rmap->me_startoff)
+		return false;
+
+	if (rmap->me_startblock + rmap->me_len <= rmap->me_startblock)
+		return false;
+
+	if (!xfs_verify_fsbno(mp, rmap->me_startblock))
+		return false;
+
+	if (!xfs_verify_fsbno(mp, rmap->me_startblock + rmap->me_len - 1))
 		return false;
 
 	return true;
-- 
2.53.0



