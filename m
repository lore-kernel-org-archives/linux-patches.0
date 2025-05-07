Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459D278F2F;
	Wed,  7 May 2025 18:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643594; cv=none; b=KMS1pTSbMgSTRLTAzmyy8hepSSbCfURm4+gDiBbfdD+sa4WUWsXqeaCmffWHgBNzsujbt5mm6ICi7zMs7yCRR50iFFiqnSjQDzuWGzdTAVa5xGM21frM49oVsaMMfoQNIOpk9Nt3hbqG/CIKVNdewLhfXZPAtV5LuzJr9qRCnpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643594; c=relaxed/simple;
	bh=ng/gyJPTjUwLWpW2uvdUjf1BNYcFmJ7XhJWncAa7wvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8d0oKC5AH84hGCSY0eBghVbtYWy9dChsCtE81QgYc2O43Hq46Lk/rdTpyl9+y3WZxwyt1eM/uKycyrYjenzriVzHZug26fUoRFQQN9+2d7dv2jqpdNuBJfUDvqUD74LmMXTKzr0+u9FSSf/NHmAWqE2thOeP2vCtE5KGMMn8NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGlmR4ld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGlmR4ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB48AC4CEE2;
	Wed,  7 May 2025 18:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643594;
	bh=ng/gyJPTjUwLWpW2uvdUjf1BNYcFmJ7XhJWncAa7wvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGlmR4ldW3+FX7b7FKWhlqdaG0O8j7OCD+wBzw6i3r9/LFjNG2Cl7hUWP9A87HWp9
	 QlAqFSL9Hr80HWEa2gEa0qYKhYw7qmjbUp6b9Zdu2opxDBv5C0OFCi/n2p2pcLV6yn
	 DqRRkd4TaP3Bb+3ElgU59CaG/UJVuDorSlWWXYes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 24/97] xfs: fix xfs_bmap_add_extent_delay_real for partial conversions
Date: Wed,  7 May 2025 20:38:59 +0200
Message-ID: <20250507183807.956993540@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d69bee6a35d3c5e4873b9e164dd1a9711351a97c ]

xfs_bmap_add_extent_delay_real takes parts or all of a delalloc extent
and converts them to a real extent.  It is written to deal with any
potential overlap of the to be converted range with the delalloc extent,
but it turns out that currently only converting the entire extents, or a
part starting at the beginning is actually exercised, as the only caller
always tries to convert the entire delalloc extent, and either succeeds
or at least progresses partially from the start.

If it only converts a tiny part of a delalloc extent, the indirect block
calculation for the new delalloc extent (da_new) might be equivalent to that
of the existing delalloc extent (da_old).  If this extent conversion now
requires allocating an indirect block that gets accounted into da_new,
leading to the assert that da_new must be smaller or equal to da_new
unless we split the extent to trigger.

Except for the assert that case is actually handled by just trying to
allocate more space, as that already handled for the split case (which
currently can't be reached at all), so just reusing it should be fine.
Except that without dipping into the reserved block pool that would make
it a bit too easy to trigger a fs shutdown due to ENOSPC.  So in addition
to adjusting the assert, also dip into the reserved block pool.

Note that I could only reproduce the assert with a change to only convert
the actually asked range instead of the full delalloc extent from
xfs_bmapi_write.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1530,6 +1530,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
@@ -1559,6 +1560,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -1592,6 +1594,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
@@ -1624,6 +1627,7 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			}
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
@@ -1661,6 +1665,7 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_LEFT_FILLING:
@@ -1748,6 +1753,7 @@ xfs_bmap_add_extent_delay_real(
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &PREV);
 		xfs_iext_next(ifp, &bma->icur);
 		xfs_iext_update_extent(bma->ip, state, &bma->icur, &RIGHT);
+		ASSERT(da_new <= da_old);
 		break;
 
 	case BMAP_RIGHT_FILLING:
@@ -1795,6 +1801,7 @@ xfs_bmap_add_extent_delay_real(
 		PREV.br_blockcount = temp;
 		xfs_iext_insert(bma->ip, &bma->icur, &PREV, state);
 		xfs_iext_next(ifp, &bma->icur);
+		ASSERT(da_new <= da_old);
 		break;
 
 	case 0:
@@ -1915,11 +1922,9 @@ xfs_bmap_add_extent_delay_real(
 	}
 
 	/* adjust for changes in reserved delayed indirect blocks */
-	if (da_new != da_old) {
-		ASSERT(state == 0 || da_new < da_old);
+	if (da_new != da_old)
 		error = xfs_mod_fdblocks(mp, (int64_t)(da_old - da_new),
-				false);
-	}
+				true);
 
 	xfs_bmap_check_leaf_extents(bma->cur, bma->ip, whichfork);
 done:


