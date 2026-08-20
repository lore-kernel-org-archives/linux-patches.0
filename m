Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651DA37C925;
	Thu, 20 Aug 2026 15:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238377; cv=none; b=HRhBaMWyojokkEFxo7u/EWB9XJhZPrwfwcG/4lr5sCunzTnKVxqzY9TQDZTV4zpWFlGNsLWA32X6ksgoyIHqYiJMxipfjdOukzuF9MnW31Cx4MOgkx4h+VzF4owi576ibm7tJuvg6Nr3uqdB+/foeUX+nJuhIBN08wHPr3+6UUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238377; c=relaxed/simple;
	bh=mPnpovqvv7OpgOQuQcXmK3rtYx2FIgdc7FMaP0WqjjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTSo1usizUy9goip273fgx32OuO8JKXgBCaep1hWGgdaLcak8QtE7xEE245V2RHuk7SaKXKjvykWAZbahsVKG5Mc+ZezmwhxmuPliaPsBcqkE4LPT5xgRMwxNtolGOU+eEblbkeHZoBFcCCT+kFfOdiJbYO04g5to8vXbZJi8Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qoCBXg0K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qoCBXg0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F3F1F000E9;
	Thu, 20 Aug 2026 15:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238376;
	bh=sVPZ0XBiheoMC1bJFvrLgF/NefGkwvcfBdFtzoFTQmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qoCBXg0Kx9kZJVd+CAlYdZ2hRckqvFzzmJ5l9SopYyghEv/q69isPfuGMvGUPBRGL
	 b7ehhJcHndTC9leIvr3wRKTaHztdplLLluE9qyBw3Jkz9acjm/84dPVdkQLe8edLrt
	 Te2moVq5p/hpyA+feK+30xf6RVO+G+1hy4A1DvdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 126/228] xfs: fix off-by-one in rtrefcount btree root level validation
Date: Thu, 20 Aug 2026 16:54:28 +0200
Message-ID: <20260820145248.447083455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

commit cc3144da377de5fb422d44a2311f978623f7c900 upstream.

xfs_rtrefcountbt_compute_maxlevels() sets

	mp->m_rtrefc_maxlevels = min(d_maxlevels, r_maxlevels) + 1;

where the trailing "+ 1" already accounts for the inode-root level, so the
deepest valid on-disk root level is m_rtrefc_maxlevels - 1 and a cursor must
satisfy bc_nlevels <= bc_maxlevels (= m_rtrefc_maxlevels).

The two on-disk validation paths, xfs_rtrefcountbt_verify() and
xfs_iformat_rtrefcount(), check the root level with ">" instead of ">=", so a
crafted rtreflink (metadir + realtime + reflink) image whose
/rtgroups/N.refcount inode has bb_level == m_rtrefc_maxlevels is accepted on
mount. xfs_rtrefcountbt_init_cursor() then sets bc_nlevels = bb_level + 1,
exceeding bc_maxlevels by one. Since the xfs_rtrefcountbt_cur slab object is
sized for exactly bc_maxlevels entries, the first btree op on such a cursor
indexes bc_levels[m_rtrefc_maxlevels] past the end of the object. This is
reached by the first rtrefcount cursor built after mount, via log/CoW
recovery (xfs_reflink_recover_cow() during xfs_mountfs()) or an
FS_IOC_GETFSMAP over the realtime device.

Reject a root level equal to m_rtrefc_maxlevels, matching the ">=" form
already used by the sibling data-device refcount/rmap verifiers and the
in-memory rtrmap verifier.

  BUG: KASAN: slab-out-of-bounds in xfs_btree_lookup (fs/xfs/libxfs/xfs_btree.c:2101)
  Write of size 2 at addr ffff888018391658 by task exploit/144
   xfs_btree_lookup (fs/xfs/libxfs/xfs_btree.c:2101)
   xfs_btree_query_range (fs/xfs/libxfs/xfs_btree.c:5308)
   xfs_refcount_recover_cow_leftovers (fs/xfs/libxfs/xfs_refcount.c:2113)
   xfs_reflink_recover_cow (fs/xfs/xfs_reflink.c:1085)
   xlog_recover_finish (fs/xfs/xfs_log_recover.c:3551)
   xfs_mountfs (fs/xfs/xfs_mount.c:1158)
   xfs_fs_fill_super (fs/xfs/xfs_super.c:1940)
   get_tree_bdev_flags (fs/super.c:1634)
   vfs_get_tree (fs/super.c:1694)
   path_mount (fs/namespace.c:4161)
   __x64_sys_mount (fs/namespace.c:4367)
   entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
  The buggy address belongs to the cache xfs_rtrefcountbt_cur of size 216
  The buggy address is located 8 bytes to the right of
   allocated 216-byte region [ffff888018391578, ffff888018391650)
  Kernel panic - not syncing: Fatal exception

Cc: stable@vger.kernel.org # v6.14
Fixes: 9abe03a0e4f978 ("xfs: introduce realtime refcount btree ondisk definitions")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -201,7 +201,7 @@ xfs_rtrefcountbt_verify(
 	if (fa)
 		return fa;
 	level = be16_to_cpu(block->bb_level);
-	if (level > mp->m_rtrefc_maxlevels)
+	if (level >= mp->m_rtrefc_maxlevels)
 		return __this_address;
 
 	return xfs_btree_fsblock_verify(bp, mp->m_rtrefc_mxr[level != 0]);
@@ -651,7 +651,7 @@ xfs_iformat_rtrefcount(
 	numrecs = be16_to_cpu(dfp->bb_numrecs);
 	level = be16_to_cpu(dfp->bb_level);
 
-	if (level > mp->m_rtrefc_maxlevels ||
+	if (level >= mp->m_rtrefc_maxlevels ||
 	    xfs_rtrefcount_droot_space_calc(level, numrecs) > dsize) {
 		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
 		return -EFSCORRUPTED;


