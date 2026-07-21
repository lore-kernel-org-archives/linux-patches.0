Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF3C46EC94;
	Tue, 21 Jul 2026 18:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659575; cv=none; b=i1zgUQWSJyx1XGjSbVVmcTDY6LZewieK1FAFZ0nMubAllB3Uycw19L47SyQlj4BBrT34YVd8lDK4RGxkS1nQCEtXZ0BT/zlk/CoAxh4MVXJ5ifb/Ru1+5MWKhu+8hZPQoF/u7KtDpuB3u0NwrOgBTe5+LvLPZk0zpopMTuX3dXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659575; c=relaxed/simple;
	bh=rL8D99+5Lxu79tcYlp3Xl9QQ20XgCK/SvkZzpYtgXSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDC+HczLiA6iAGeSQy1NMU6VXoTH7FRVWFJH0KzNJsyrMe4UAvHJdQ6XOXbu3RSKB4F6J6DIiJZtDpRaHcuOX1QGd08PssAilvPuOPV/8NN5GO+JbYGFKj4JzfoOwvzmo1SH3d5p64IIKlZed+E5EedUr/diOK5KJKckRkeq9K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYi+tTwp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYi+tTwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636CC1F000E9;
	Tue, 21 Jul 2026 18:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659573;
	bh=harRTJ89T6c+14tYJfuirlLJOnnijyvifOE5SijWVVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pYi+tTwpIosKeTqZ7RscULl9A8w87Lx+i4Z9V1TcAyf+9KZcoGJqVCftc2H31hI/m
	 jD4T5NCwapvanYeNgjfFz2gQH4SPOHhmNMXx/AqvciXf2wcU7bcBSMt0TRV6tsmQW9
	 L+RsTXtPzEy6/68dweeCNh434HueDzxYqVziKS8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1570/1611] xfs: add a xfs_groups_to_rfsbs helper
Date: Tue, 21 Jul 2026 17:28:06 +0200
Message-ID: <20260721152550.779188146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 0ec73eb3f12350799c4b3fb764225f6e38b42d1e ]

Plus a rtgroup wrapper and use that to avoid overflows when converting
zone/rtg counts to block counts.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Stable-dep-of: 44cccefe6574 ("xfs: only log freed extents for the current RTG in zoned growfs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_group.h    |    9 +++++++++
 fs/xfs/libxfs/xfs_rtgroup.h  |    8 ++++++++
 fs/xfs/xfs_zone_gc.c         |    3 +--
 fs/xfs/xfs_zone_space_resv.c |    8 +++-----
 4 files changed, 21 insertions(+), 7 deletions(-)

--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -98,6 +98,15 @@ xfs_group_max_blocks(
 	return xg->xg_mount->m_groups[xg->xg_type].blocks;
 }
 
+static inline xfs_rfsblock_t
+xfs_groups_to_rfsbs(
+	struct xfs_mount	*mp,
+	uint32_t		nr_groups,
+	enum xfs_group_type	type)
+{
+	return (xfs_rfsblock_t)mp->m_groups[type].blocks * nr_groups;
+}
+
 static inline xfs_fsblock_t
 xfs_group_start_fsb(
 	struct xfs_group	*xg)
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -371,4 +371,12 @@ static inline int xfs_initialize_rtgroup
 # define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
 #endif /* CONFIG_XFS_RT */
 
+static inline xfs_rfsblock_t
+xfs_rtgs_to_rfsbs(
+	struct xfs_mount	*mp,
+	uint32_t		nr_groups)
+{
+	return xfs_groups_to_rfsbs(mp, nr_groups, XG_TYPE_RTG);
+}
+
 #endif /* __LIBXFS_RTGROUP_H */
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -181,8 +181,7 @@ xfs_zoned_need_gc(
 	available = xfs_estimate_freecounter(mp, XC_FREE_RTAVAILABLE);
 
 	if (available <
-	    mp->m_groups[XG_TYPE_RTG].blocks *
-	    (mp->m_max_open_zones - XFS_OPEN_GC_ZONES))
+	    xfs_rtgs_to_rfsbs(mp, mp->m_max_open_zones - XFS_OPEN_GC_ZONES))
 		return true;
 
 	free = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS);
--- a/fs/xfs/xfs_zone_space_resv.c
+++ b/fs/xfs/xfs_zone_space_resv.c
@@ -54,12 +54,10 @@ xfs_zoned_default_resblks(
 {
 	switch (ctr) {
 	case XC_FREE_RTEXTENTS:
-		return (uint64_t)XFS_RESERVED_ZONES *
-			mp->m_groups[XG_TYPE_RTG].blocks +
-			mp->m_sb.sb_rtreserved;
+		return xfs_rtgs_to_rfsbs(mp, XFS_RESERVED_ZONES) +
+				mp->m_sb.sb_rtreserved;
 	case XC_FREE_RTAVAILABLE:
-		return (uint64_t)XFS_GC_ZONES *
-			mp->m_groups[XG_TYPE_RTG].blocks;
+		return xfs_rtgs_to_rfsbs(mp, XFS_GC_ZONES);
 	default:
 		ASSERT(0);
 		return 0;


