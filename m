Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585251;
	b=mnjBQR48pDporl3S1osSEH5gYMJvcZ2WrJb5cW39aMbaNwFKwaWkEOQhwIz255bp1TK1
	 6sc9Gtm7HpeBSz4RQKbyKPRvZLQfa1MZK7Qgtkl8Hy3zexCRs3ia9a3qP9MPSYtwLSf3K
	 O6u80hRk/3M9ZF5i+jw2uKnsElpkkkGMbfDWjzMGLq+970Aa5hvf8kCFcG+vR1y6NAQKt
	 8/8Bnk+/WnCxkjWPeDVkb9YzI7cHhwAuKSrK1yBZ7XP8WHnvkWblXsV8IcWW0GgMueW0/
	 7jnhnzn0UmbtARH0ELuyToKbz1fGNU/rAsHOx8734YB7hfIfztybtpQnNnfaqhMfTUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585251;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lum/mAdnQVFSClkpkaHJ5TKnNR4ws4D0vwEgg50y6yo=;
	b=LFBdqweQaxK79uS/CIbStzDtCekgJGI4MWMdeI1O38JTzGQsigkGk31CaY7xzO3JAg6d
	 0dNa1LAGveEG4YgOv3E7bjfDe98mCZI8+FtnA4gLaDghS57nU/tON+T3bUpRz6kpmnVjy
	 OAKItyP97TJ26oI2SttA5ljM8DfLuWiirANRnzLupoJ0cx5qXwubSpvbOrSrIHlcl6EZH
	 cNH0ysNKyuEER+PJltd6/ZAuKl6AY29Pfd4+rBoDM7gYAzg9mi11WP1gd2o/WPnI7xY9g
	 cfijN43ZtKz0bOSNyHETCBLtFRksuh03sqcYUt+CDHTwa6Z9ujTVC42g9NdhUH09uNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1JayOhfh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2A0606A894;
	Fri, 13 Nov 2026 15:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1JayOhfh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6141F000C4;
	Fri, 13 Nov 2026 15:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585251;
	bh=lum/mAdnQVFSClkpkaHJ5TKnNR4ws4D0vwEgg50y6yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JayOhfhwxZ9hRAw7V6OTH3PiOSKKnAQlmZhfjg9p1FQhqGX9lVeyhZslVCldc/bh
	 unww9MPCpUs8HqQ15N0Tj831fflt/YchoW8R6ONEgqRP1b1wKjHdEZa+15LbEy++Ua
	 7l2pJFtekphfFx0rxZ1SD58aq7EmBULrhubp+fXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 006/507] xfs: break out xattr entry checks into separate functions
Date: Fri, 13 Nov 2026 10:45:10 -0500
Message-ID: <20261113153753.593630256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 9eb04a6d41c7e474d4665118895c3c2d8e5a2741 ]

We're going to add more xattr entry checking code in xchk_xattr_entry so
break these out into separate functions so that we don't go crazy
indenting.  There's a slight behavior change here where we skip updating
the usedmap if we've decided the xattr structure is corrupt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: 91c41f952490 ("xfs: check for buffer overruns when examining local/remote xattr entries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/attr.c | 90 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 68 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 842d65834afbc..f7c00ea1af5d3 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -293,6 +293,66 @@ xchk_xattr_set_map(
 	return ret;
 }
 
+static unsigned int
+xchk_xattr_local_entry(
+	struct xchk_da_btree		*ds,
+	int				level,
+	char				*buf_end,
+	struct xfs_attr_leafblock	*leaf,
+	int				idx)
+{
+	struct xfs_attr_leaf_name_local	*lentry =
+			xfs_attr3_leaf_name_local(leaf, idx);
+	char				*name_end;
+	unsigned int			namesize;
+
+	namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
+			be16_to_cpu(lentry->valuelen));
+	name_end = (char *)lentry + namesize;
+	if (lentry->namelen == 0) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+	if (name_end > buf_end) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+
+	return namesize;
+}
+
+static unsigned int
+xchk_xattr_remote_entry(
+	struct xchk_da_btree		*ds,
+	int				level,
+	char				*buf_end,
+	struct xfs_attr_leafblock	*leaf,
+	int				idx,
+	struct xfs_attr_leaf_entry	*ent)
+{
+	struct xfs_attr_leaf_name_remote *rentry =
+			xfs_attr3_leaf_name_remote(leaf, idx);
+	char				*name_end;
+	unsigned int			namesize;
+
+	namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
+	name_end = (char *)rentry + namesize;
+	if (rentry->namelen == 0) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+	if (rentry->valueblk == 0 && !(ent->flags & XFS_ATTR_INCOMPLETE)) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+	if (name_end > buf_end) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
+
+	return namesize;
+}
+
 /*
  * Check this leaf entry's relations to everything else.
  * Returns the number of bytes used for the name/value data.
@@ -311,9 +371,6 @@ xchk_xattr_entry(
 {
 	struct xfs_mount		*mp = ds->state->mp;
 	struct xchk_xattr_buf		*ab = ds->sc->buf;
-	char				*name_end;
-	struct xfs_attr_leaf_name_local	*lentry;
-	struct xfs_attr_leaf_name_remote *rentry;
 	unsigned int			nameidx;
 	unsigned int			namesize;
 
@@ -333,25 +390,14 @@ xchk_xattr_entry(
 	}
 
 	/* Check the name information. */
-	if (ent->flags & XFS_ATTR_LOCAL) {
-		lentry = xfs_attr3_leaf_name_local(leaf, idx);
-		namesize = xfs_attr_leaf_entsize_local(lentry->namelen,
-				be16_to_cpu(lentry->valuelen));
-		name_end = (char *)lentry + namesize;
-		if (lentry->namelen == 0)
-			xchk_da_set_corrupt(ds, level);
-	} else {
-		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
-		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
-		name_end = (char *)rentry + namesize;
-		if (rentry->namelen == 0)
-			xchk_da_set_corrupt(ds, level);
-		if (rentry->valueblk == 0 &&
-		    !(ent->flags & XFS_ATTR_INCOMPLETE))
-			xchk_da_set_corrupt(ds, level);
-	}
-	if (name_end > buf_end)
-		xchk_da_set_corrupt(ds, level);
+	if (ent->flags & XFS_ATTR_LOCAL)
+		namesize = xchk_xattr_local_entry(ds, level, buf_end, leaf,
+				idx);
+	else
+		namesize = xchk_xattr_remote_entry(ds, level, buf_end, leaf,
+				idx, ent);
+	if (!namesize)
+		return;
 
 	if (!xchk_xattr_set_map(ds->sc, ab->usedmap, nameidx, namesize))
 		xchk_da_set_corrupt(ds, level);
-- 
2.53.0



