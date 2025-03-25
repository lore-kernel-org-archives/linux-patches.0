Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4959025745F;
	Tue, 25 Mar 2025 12:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905673; cv=none; b=ZUkzDXFy2RJyJkiQw8/AdVPE5Z7Dq6EUb9DWWJkS0wQ10E0Zupa0oNO9X8JA88OQMxPPJAgQvAnDtZXLaNBkrJcfAoMyRO99uTv9tY0gTpLTchHmXGWVwJvERK6GEr50hRCgwq9tUWrsD1+NrU5SdIRi9qrFGFkd504gKFk41V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905673; c=relaxed/simple;
	bh=RO8SCDAOXdh/Q3q63dQvOhLpqFNEPkzZMf9RPdvkPbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/2L6RPiJo0O6UIQOT6sXrfMyEA02hY2+dzxPmnl9Q10wLwpMrp8ylfMPRfxxUQu9n+9Yi2NlPWHK6uXSsG4p+4qYAPvDn+ZImAziEwMbrsYqE8Zp4GFOal5BU1KAbGhLQdlY3SA7CTtBFpvSPeRgh1F3oKE64sUvmv0hnUPsyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kaITt8u2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kaITt8u2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE43C4CEE9;
	Tue, 25 Mar 2025 12:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905673;
	bh=RO8SCDAOXdh/Q3q63dQvOhLpqFNEPkzZMf9RPdvkPbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaITt8u2MpXcTdniry0+I1aXlfB8klAq0spzkoXdJuzFtDpSl4KUarNtoQNEShRLc
	 x7L7zUttZZHdxxtgJU+cqwC7M/PJTlqcHs3Rl9P0xZRF0DyWaTmuumVfyGJTgjdAQz
	 ZLEQYdrkyi20eG2gRVn4SAgT1XPn2yH1KSiY3XAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 100/198] xfs: ensure logflagsp is initialized in xfs_bmap_del_extent_real
Date: Tue, 25 Mar 2025 08:21:02 -0400
Message-ID: <20250325122159.272637346@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>

[ Upstream commit e6af9c98cbf0164a619d95572136bfb54d482dd6 ]

In the case of returning -ENOSPC, ensure logflagsp is initialized by 0.
Otherwise the caller __xfs_bunmapi will set uninitialized illegal
tmp_logflags value into xfs log, which might cause unpredictable error
in the log recovery procedure.

Also, remove the flags variable and set the *logflagsp directly, so that
the code should be more robust in the long run.

Fixes: 1b24b633aafe ("xfs: move some more code into xfs_bmap_del_extent_real")
Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   73 +++++++++++++++++++----------------------------
 1 file changed, 31 insertions(+), 42 deletions(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4999,7 +4999,6 @@ xfs_bmap_del_extent_real(
 	xfs_fileoff_t		del_endoff;	/* first offset past del */
 	int			do_fx;	/* free extent at end of routine */
 	int			error;	/* error return value */
-	int			flags = 0;/* inode logging flags */
 	struct xfs_bmbt_irec	got;	/* current extent entry */
 	xfs_fileoff_t		got_endoff;	/* first offset past got */
 	int			i;	/* temp state */
@@ -5012,6 +5011,8 @@ xfs_bmap_del_extent_real(
 	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
 	struct xfs_bmbt_irec	old;
 
+	*logflagsp = 0;
+
 	mp = ip->i_mount;
 	XFS_STATS_INC(mp, xs_del_exlist);
 
@@ -5024,7 +5025,6 @@ xfs_bmap_del_extent_real(
 	ASSERT(got_endoff >= del_endoff);
 	ASSERT(!isnullstartblock(got.br_startblock));
 	qfield = 0;
-	error = 0;
 
 	/*
 	 * If it's the case where the directory code is running with no block
@@ -5040,13 +5040,13 @@ xfs_bmap_del_extent_real(
 	    del->br_startoff > got.br_startoff && del_endoff < got_endoff)
 		return -ENOSPC;
 
-	flags = XFS_ILOG_CORE;
+	*logflagsp = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
 		if (!(bflags & XFS_BMAPI_REMAP)) {
 			error = xfs_rtfree_blocks(tp, del->br_startblock,
 					del->br_blockcount);
 			if (error)
-				goto done;
+				return error;
 		}
 
 		do_fx = 0;
@@ -5061,11 +5061,9 @@ xfs_bmap_del_extent_real(
 	if (cur) {
 		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
-			goto done;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			error = -EFSCORRUPTED;
-			goto done;
-		}
+			return error;
+		if (XFS_IS_CORRUPT(mp, i != 1))
+			return -EFSCORRUPTED;
 	}
 
 	if (got.br_startoff == del->br_startoff)
@@ -5082,17 +5080,15 @@ xfs_bmap_del_extent_real(
 		xfs_iext_prev(ifp, icur);
 		ifp->if_nextents--;
 
-		flags |= XFS_ILOG_CORE;
+		*logflagsp |= XFS_ILOG_CORE;
 		if (!cur) {
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		if ((error = xfs_btree_delete(cur, &i)))
-			goto done;
-		if (XFS_IS_CORRUPT(mp, i != 1)) {
-			error = -EFSCORRUPTED;
-			goto done;
-		}
+			return error;
+		if (XFS_IS_CORRUPT(mp, i != 1))
+			return -EFSCORRUPTED;
 		break;
 	case BMAP_LEFT_FILLING:
 		/*
@@ -5103,12 +5099,12 @@ xfs_bmap_del_extent_real(
 		got.br_blockcount -= del->br_blockcount;
 		xfs_iext_update_extent(ip, state, icur, &got);
 		if (!cur) {
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		error = xfs_bmbt_update(cur, &got);
 		if (error)
-			goto done;
+			return error;
 		break;
 	case BMAP_RIGHT_FILLING:
 		/*
@@ -5117,12 +5113,12 @@ xfs_bmap_del_extent_real(
 		got.br_blockcount -= del->br_blockcount;
 		xfs_iext_update_extent(ip, state, icur, &got);
 		if (!cur) {
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 			break;
 		}
 		error = xfs_bmbt_update(cur, &got);
 		if (error)
-			goto done;
+			return error;
 		break;
 	case 0:
 		/*
@@ -5139,18 +5135,18 @@ xfs_bmap_del_extent_real(
 		new.br_state = got.br_state;
 		new.br_startblock = del_endblock;
 
-		flags |= XFS_ILOG_CORE;
+		*logflagsp |= XFS_ILOG_CORE;
 		if (cur) {
 			error = xfs_bmbt_update(cur, &got);
 			if (error)
-				goto done;
+				return error;
 			error = xfs_btree_increment(cur, 0, &i);
 			if (error)
-				goto done;
+				return error;
 			cur->bc_rec.b = new;
 			error = xfs_btree_insert(cur, &i);
 			if (error && error != -ENOSPC)
-				goto done;
+				return error;
 			/*
 			 * If get no-space back from btree insert, it tried a
 			 * split, and we have a zero block reservation.  Fix up
@@ -5163,33 +5159,28 @@ xfs_bmap_del_extent_real(
 				 */
 				error = xfs_bmbt_lookup_eq(cur, &got, &i);
 				if (error)
-					goto done;
-				if (XFS_IS_CORRUPT(mp, i != 1)) {
-					error = -EFSCORRUPTED;
-					goto done;
-				}
+					return error;
+				if (XFS_IS_CORRUPT(mp, i != 1))
+					return -EFSCORRUPTED;
 				/*
 				 * Update the btree record back
 				 * to the original value.
 				 */
 				error = xfs_bmbt_update(cur, &old);
 				if (error)
-					goto done;
+					return error;
 				/*
 				 * Reset the extent record back
 				 * to the original value.
 				 */
 				xfs_iext_update_extent(ip, state, icur, &old);
-				flags = 0;
-				error = -ENOSPC;
-				goto done;
-			}
-			if (XFS_IS_CORRUPT(mp, i != 1)) {
-				error = -EFSCORRUPTED;
-				goto done;
+				*logflagsp = 0;
+				return -ENOSPC;
 			}
+			if (XFS_IS_CORRUPT(mp, i != 1))
+				return -EFSCORRUPTED;
 		} else
-			flags |= xfs_ilog_fext(whichfork);
+			*logflagsp |= xfs_ilog_fext(whichfork);
 
 		ifp->if_nextents++;
 		xfs_iext_next(ifp, icur);
@@ -5213,7 +5204,7 @@ xfs_bmap_del_extent_real(
 					((bflags & XFS_BMAPI_NODISCARD) ||
 					del->br_state == XFS_EXT_UNWRITTEN));
 			if (error)
-				goto done;
+				return error;
 		}
 	}
 
@@ -5228,9 +5219,7 @@ xfs_bmap_del_extent_real(
 	if (qfield && !(bflags & XFS_BMAPI_REMAP))
 		xfs_trans_mod_dquot_byino(tp, ip, qfield, (long)-nblks);
 
-done:
-	*logflagsp = flags;
-	return error;
+	return 0;
 }
 
 /*


