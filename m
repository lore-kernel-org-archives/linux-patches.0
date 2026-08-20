Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA9447CA8F;
	Thu, 20 Aug 2026 17:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247081; cv=none; b=VUPITpbHRfA646JC9JQcDkYwWwJ3LHtK/ipiTVOVY8h+UneiSbkY/a8HOG3BeANPqzcT+tH7wASAWviLH+Zc30r/O3fGwiIHkeLxm/auGq2TBJqfiowo5Qaxscfze5t+l6dz/oUc1FqU2qE2OhqaoA/LiR0NIzQDcjaoPdhxypI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247081; c=relaxed/simple;
	bh=aETHf37sm40DSpi0ak4rSXPBWZqhlu9DdqT3qA3VSkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3H0jxuL7yssNpBJPz+UGXrBmSJmZCVErwo8kuDPdohcNwGnIHMpYP15rDcPE8PH+2H3+/X57/1HKIEdaQ+vdsXMfZsqTvq8NwR30KqaqsbPhY76hhn9iyjfYwu2cAyH6qDqdC0RIxMM2rXT3rSs0Ny8tauxwQjQ0NV9qsMFzH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXY+JiC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXY+JiC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2651F00A3A;
	Thu, 20 Aug 2026 17:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247080;
	bh=C2PxsT+252djwvUbCR4jBSaPkMbFmjwsUbv1yOEnCdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXY+JiC9IAv+fAAoARyn4SNP0X8DD6ti2NSAN98rQOCdglkvNX4aEzfvRIfIEbY5K
	 Wmv9gRlJN8rjurdFkoh+gsP1DnOixEHntbj1WUfm9+dsmV4dAu84CZlYHlRl0LfaQZ
	 e1SlLGvo7uepQ70Suw7Nn1eBgYbCBUeS12HbUxPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 103/220] xfs: fix allocated inodes that show up in the unlinked list
Date: Thu, 20 Aug 2026 16:54:53 +0200
Message-ID: <20260820145226.576534874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1359,6 +1366,35 @@ xrep_iunlink_resolve_bucket(
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
@@ -1541,6 +1577,24 @@ xrep_iunlink_rebuild_buckets(
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
@@ -1576,8 +1630,7 @@ xrep_iunlink_relink_next(
 		if (error)
 			goto out_rele;
 
-		trace_xrep_iunlink_relink_prev(ip, prev_agino);
-		ip->i_prev_unlinked = prev_agino;
+		set_inode_prev_unlinked(ip, prev_agino);
 	}
 
 	/* Update the forward pointer. */
@@ -1646,11 +1699,7 @@ xrep_iunlink_relink_prev(
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
@@ -3460,6 +3460,7 @@ DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_wronglist);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_nolist);
 DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_ok);
+DEFINE_REPAIR_IUNLINK_RESOLVE_EVENT(xrep_iunlink_resolve_allocated);
 
 TRACE_EVENT(xrep_iunlink_relink_next,
 	TP_PROTO(struct xfs_inode *ip, xfs_agino_t next_agino),


