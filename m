Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3436C36A37A;
	Thu, 20 Aug 2026 15:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239064; cv=none; b=Zb6qthT3bhexADI8wEuWZ0kH/fKKo//C5Ybrj032Ufi35c2Qy/BXMtca27aXn7nkBFlnvACtsYtUcNBvUOahhd7bEx17R7xKJmz61Xt0I4t/pmhkj7P1wcNjd0MPW0H7EBiYSIxQ0cvzxhP33odBa13GWQhSmapMJwHZFXI9wsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239064; c=relaxed/simple;
	bh=lMXDMynCW/StaxBrM54/G1lD/IINr6VvirukKcHp5A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=es1wvRlaekeAc+aOcgKWMcJ4Tz7OF/7/pxedc47wlQ1F82K2Kozk3TGsW01lzpKLm7JV7ElxmUtmMU39JwN+jTmakA5gJW0PdpMjMlHRIjQmL78sHnHegkaufYMkM5kDvHW/WnXa0PferrFg+0r+/QKNnTbCdpEilPUyAdt6Skc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jUlI1zBP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUlI1zBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3941F000E9;
	Thu, 20 Aug 2026 15:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239063;
	bh=vIgKtRcuz1dFU0G/BkFwweduh87j3TFTGCHcWLSKCf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jUlI1zBPTyTK6i2Kh0jV6Ki5ob+UhjJG+ZJ8KcUGsKZHsIgHHiqupBn3y79gvX25Y
	 PZiFEaSPK0cd425m1PUUgbptgaQaQjcCIxsYgiSoyFmutQ2m2OEPkqLfdQU93FJs4i
	 0qYAGrc+UBFK4uJ5E2BQIkUQrw/eC6yLDt4QlnUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 120/217] xfs: fix allocated inodes that show up in the unlinked list
Date: Thu, 20 Aug 2026 16:54:48 +0200
Message-ID: <20260820145241.346405578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 68ab37650ce5195b4f4f8466444a36a78207840c upstream.

If an allocated inode shows up in the unlinked list, we need to get it
completely off the list.  Set the corrected next/prev pointers such that
the inode will not look like it should be on an unlinked list at all.

Cc: stable@vger.kernel.org # v6.10
Fixes: ab97f4b1c03075 ("xfs: repair AGI unlinked inode bucket lists")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader_repair.c |   63 ++++++++++++++++++++++++++++++++++++-----
 fs/xfs/scrub/trace.h           |    1 
 2 files changed, 57 insertions(+), 7 deletions(-)

--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -980,6 +980,13 @@ err:
 }
 
 /*
+ * Magic value that means "not unlinked" because xfarrays don't support storing
+ * totally zeroed elements.  There can't be a cluster that starts in daddr 0 so
+ * there can't be an inode #1 either.
+ */
+#define LINKED_AGINO	(0x1)
+
+/*
  * Record a forwards unlinked chain pointer from agino -> next_agino in our
  * staging information.
  */
@@ -1355,6 +1362,35 @@ xrep_iunlink_resolve_bucket(
 			break;
 		}
 
+		if (VFS_I(ip)->i_nlink != 0) {
+			/*
+			 * Inode is linked somewhere!  Blow out both unlinked
+			 * list pointers, advance the list, and pretend we
+			 * didn't see this inode.  Clear it from iunlink_bmp
+			 * because it's linked.
+			 */
+			trace_xrep_iunlink_resolve_allocated(sc->sa.pag,
+					bucket, prev_agino, next_agino);
+
+			error = xrep_iunlink_store_next(ragi, next_agino,
+					NULLAGINO);
+			if (error)
+				return error;
+
+			error = xrep_iunlink_store_prev(ragi, next_agino,
+					LINKED_AGINO);
+			if (error)
+				return error;
+
+			error = xagino_bitmap_clear(&ragi->iunlink_bmp,
+					next_agino, 1);
+			if (error)
+				return error;
+
+			next_agino = ip->i_next_unlinked;
+			continue;
+		}
+
 		if (next_agino % XFS_AGI_UNLINKED_BUCKETS != bucket) {
 			/*
 			 * Inode is in the wrong bucket.  Advance the list,
@@ -1537,6 +1573,24 @@ xrep_iunlink_rebuild_buckets(
 			xrep_iunlink_add_lost_inodes, ragi);
 }
 
+static inline void
+set_inode_prev_unlinked(
+	struct xfs_inode	*ip,
+	xfs_agino_t		prev_agino)
+{
+	/*
+	 * Magic value that means "not unlinked" because xfarrays don't support
+	 * storing totally zeroed elements.
+	 */
+	if (prev_agino == LINKED_AGINO)
+		prev_agino = 0;
+
+	if (ip->i_prev_unlinked != prev_agino) {
+		trace_xrep_iunlink_relink_prev(ip, prev_agino);
+		ip->i_prev_unlinked = prev_agino;
+	}
+}
+
 /* Update i_next_iunlinked for the inode @agino. */
 STATIC int
 xrep_iunlink_relink_next(
@@ -1570,8 +1624,7 @@ xrep_iunlink_relink_next(
 		if (error)
 			goto out_rele;
 
-		trace_xrep_iunlink_relink_prev(ip, prev_agino);
-		ip->i_prev_unlinked = prev_agino;
+		set_inode_prev_unlinked(ip, prev_agino);
 	}
 
 	/* Update the forward pointer. */
@@ -1638,11 +1691,7 @@ xrep_iunlink_relink_prev(
 		ip->i_next_unlinked = next_agino;
 	}
 
-	/* Update the backward pointer. */
-	if (ip->i_prev_unlinked != prev_agino) {
-		trace_xrep_iunlink_relink_prev(ip, prev_agino);
-		ip->i_prev_unlinked = prev_agino;
-	}
+	set_inode_prev_unlinked(ip, prev_agino);
 
 out_rele:
 	/*
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -3583,6 +3583,7 @@ DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_wronglist);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_nolist);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_ok);
+DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_allocated);
 
 TRACE_EVENT(xrep_iunlink_relink_next,
 	TP_PROTO(struct xfs_inode *ip, xfs_agino_t next_agino),


