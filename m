Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C074037E2ED;
	Thu, 20 Aug 2026 15:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238442; cv=none; b=EY3w/a61r2mqDD3vGOrVbFxQ2jRV6sN8/Zn2CJXEpTnjm4R4xPNZA8GHa6BZLbUQEqo2BnlnZhc7xo3lRNL6o7nMofMGvg/YGhoh7OYiJWDMvq7K9JzUF9Dkli/GrIvhfzcWyyLJjYBpZ+1OTd0prquh7jMKEQtS6MhGQU0ggOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238442; c=relaxed/simple;
	bh=8KbvEQJzDYmaUyV92JR0h69JcfnCo0qrjtiKeivFJ30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsXXfufwWrk/Up8WATuxFM0bIvHQf0xLHad8dQJRSh0TQi6GCVf+bbtjbh4yJ++EVlfuXT1qGOWojLsD6tw7XVhoAO6HAzsnWCqlRpBvYuvjEQlb8D2DjsIlTtkpR0qBKk6nkdatla4sc1w/KHEA0Hxy2LP9NWhIO44GAE8Ze2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qIGAAOzQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qIGAAOzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243F91F00A3A;
	Thu, 20 Aug 2026 15:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238441;
	bh=0aoPpp+19CTCJHPDQyJWglgv2yErlzPM59mu1IPgTi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qIGAAOzQG6GoXtpYF52B61gXo8MPRueIoFcNjbvxzJpWSs6CVzUhvZIkwwIAC/wct
	 0amBI5GkdjrTQ3NQ0lycvg/5nYx/jxTCyVCoar2UspaFwZGjM+lJDkoJts2fJdtZOY
	 43Cr73sU2WfO+ARHbjllSMB2tRKmw3bT+2nHOFjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.1 142/228] xfs: fix allocated inodes that show up in the unlinked list
Date: Thu, 20 Aug 2026 16:54:44 +0200
Message-ID: <20260820145248.920149217@linuxfoundation.org>
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


