Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB7541F35E;
	Sat, 12 Sep 2026 11:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211727; cv=none; b=YmTbk1w4ScJpXI3aw16Yc2h3nx+yWtxi57XisI9clLIAI/Nwth1ECgXco6Cra+zCV8u3iNWO0blUfGxGw/ic1dVLEimiyTVjALz+HEl/ldFJQSLQCkxUaXtxkCT0l5BzM2BxvjVdhbm3f6Gs42p5hrXvQ8RytUQGNmKzuR3ugsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211727; c=relaxed/simple;
	bh=fPHmsT6IAeL0RZ5I5ypoQ1SKR1pweFelAGT1l5F2uqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMP4vcWjGb2iW/VYhFtzdRS1X/ZiLomCyirxDMZfnepCGaJsi2XYkajcYYwaeg93mOUp8Vk3BX63gYMY8wcCtCBeFWaWnDMK9evUx2vE0kH5+3IfmCAZpEVKpmTg9yV+0d6MseVwQl/ZLLBg9Ry5+GyaGyKyGX6C9V4BIiJcQD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neFAyJ9t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neFAyJ9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085D51F000FF;
	Sat, 12 Sep 2026 11:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211726;
	bh=MQEIOOrKUoV8OX3mb3MApCGEL918GBcJCHmx80Jxm24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=neFAyJ9tDcC0acB5iw5O3F9jpsRIXoiiBVAri3nBqSUkny8RJT17vP3zImF18UOLI
	 hqOIQ1OawA4O2qu/dgkPo1uPlEWxvcCjZBHStA3oVX7hGdZr6HCfal8W+44uPtCIRn
	 qFm924fjYaRoENvowzkQ8iRwzLQ0DrSc/0gJc2Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agatha Isabelle Moreira <code@agatha.dev>,
	Arnaud Bonnet <abo@medichon.fr>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1247/1518] nfs: refactor pNFS functions using clear_and_wake_up_bit
Date: Sat, 12 Sep 2026 08:56:56 +0200
Message-ID: <20260912065651.717103537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Arnaud Bonnet <abo@medichon.fr>

[ Upstream commit 187bfc974eefa9e5d88a0b4ee9d08ae8fe485df4 ]

Commit 8236b0ae31c83 ("bdi: wake up concurrent wb_shutdown() callers.")
introduces the clear_and_wake_up_bit() helper as a wrapper for the
common clear -> barrier -> wake up bitops sequence.

The file pnfs.c has several helpers with identical contents. Thus they
are replaced with the more recent clean_and_wake_up_bit() global helper
which describes accurately its effects at the call and still specifies
the cleared bit. This also homogenizes the code with other subsystems.

Since the helpers are no longer used after this, they can be safely
removed.

Suggested-by: Agatha Isabelle Moreira <code@agatha.dev>
Link: https://kernelnewbies.org/Beginner%20Cleanup%20and%20Refactor%20Tasks%20by%20Agatha%20Isabelle%20Moreira#task_007
Fixes: d67ae825a59d ("pnfs/flexfiles: Add the FlexFile Layout Driver")
Signed-off-by: Arnaud Bonnet <abo@medichon.fr>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 35 ++++++++++-------------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 57067589786f0..cf0dcf9e35d75 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -2088,15 +2088,6 @@ static bool pnfs_is_first_layoutget(struct pnfs_layout_hdr *lo)
 	return test_bit(NFS_LAYOUT_FIRST_LAYOUTGET, &lo->plh_flags);
 }
 
-static void pnfs_clear_first_layoutget(struct pnfs_layout_hdr *lo)
-{
-	unsigned long *bitlock = &lo->plh_flags;
-
-	clear_bit_unlock(NFS_LAYOUT_FIRST_LAYOUTGET, bitlock);
-	smp_mb__after_atomic();
-	wake_up_bit(bitlock, NFS_LAYOUT_FIRST_LAYOUTGET);
-}
-
 static void _add_to_server_list(struct pnfs_layout_hdr *lo,
 				struct nfs_server *server)
 {
@@ -2272,7 +2263,8 @@ pnfs_update_layout(struct inode *ino,
 					iomode, lo, lseg,
 					PNFS_UPDATE_LAYOUT_INVALID_OPEN);
 			nfs4_schedule_stateid_recovery(server, ctx->state);
-			pnfs_clear_first_layoutget(lo);
+			clear_and_wake_up_bit(NFS_LAYOUT_FIRST_LAYOUTGET,
+				&lo->plh_flags);
 			pnfs_put_layout_hdr(lo);
 			goto lookup_again;
 		}
@@ -2341,7 +2333,8 @@ pnfs_update_layout(struct inode *ino,
 			if (!exception.retry)
 				goto out_put_layout_hdr;
 			if (first)
-				pnfs_clear_first_layoutget(lo);
+				clear_and_wake_up_bit(NFS_LAYOUT_FIRST_LAYOUTGET,
+					&lo->plh_flags);
 			trace_pnfs_update_layout(ino, pos, count,
 				iomode, lo, lseg, PNFS_UPDATE_LAYOUT_RETRY);
 			pnfs_put_layout_hdr(lo);
@@ -2353,7 +2346,7 @@ pnfs_update_layout(struct inode *ino,
 
 out_put_layout_hdr:
 	if (first)
-		pnfs_clear_first_layoutget(lo);
+		clear_and_wake_up_bit(NFS_LAYOUT_FIRST_LAYOUTGET, &lo->plh_flags);
 	trace_pnfs_update_layout(ino, pos, count, iomode, lo, lseg,
 				 PNFS_UPDATE_LAYOUT_EXIT);
 	pnfs_put_layout_hdr(lo);
@@ -2445,7 +2438,7 @@ static void _lgopen_prepare_attached(struct nfs4_opendata *data,
 	lgp = pnfs_alloc_init_layoutget_args(ino, ctx, &current_stateid, &rng,
 					     nfs_io_gfp_mask());
 	if (!lgp) {
-		pnfs_clear_first_layoutget(lo);
+		clear_and_wake_up_bit(NFS_LAYOUT_FIRST_LAYOUTGET, &lo->plh_flags);
 		nfs_layoutget_end(lo);
 		pnfs_put_layout_hdr(lo);
 		return;
@@ -2549,7 +2542,8 @@ void nfs4_lgopen_release(struct nfs4_layoutget *lgp)
 {
 	if (lgp != NULL) {
 		if (lgp->lo) {
-			pnfs_clear_first_layoutget(lgp->lo);
+			clear_and_wake_up_bit(NFS_LAYOUT_FIRST_LAYOUTGET,
+				&lgp->lo->plh_flags);
 			nfs_layoutget_end(lgp->lo);
 		}
 		pnfs_layoutget_free(lgp);
@@ -3262,15 +3256,6 @@ pnfs_generic_pg_readpages(struct nfs_pageio_descriptor *desc)
 }
 EXPORT_SYMBOL_GPL(pnfs_generic_pg_readpages);
 
-static void pnfs_clear_layoutcommitting(struct inode *inode)
-{
-	unsigned long *bitlock = &NFS_I(inode)->flags;
-
-	clear_bit_unlock(NFS_INO_LAYOUTCOMMITTING, bitlock);
-	smp_mb__after_atomic();
-	wake_up_bit(bitlock, NFS_INO_LAYOUTCOMMITTING);
-}
-
 /*
  * There can be multiple RW segments.
  */
@@ -3295,7 +3280,7 @@ static void pnfs_list_write_lseg_done(struct inode *inode, struct list_head *lis
 		pnfs_put_lseg(lseg);
 	}
 
-	pnfs_clear_layoutcommitting(inode);
+	clear_and_wake_up_bit(NFS_INO_LAYOUTCOMMITTING, &NFS_I(inode)->flags);
 }
 
 void pnfs_set_lo_fail(struct pnfs_layout_segment *lseg)
@@ -3435,7 +3420,7 @@ pnfs_layoutcommit_inode(struct inode *inode, bool sync)
 	spin_unlock(&inode->i_lock);
 	kfree(data);
 clear_layoutcommitting:
-	pnfs_clear_layoutcommitting(inode);
+	clear_and_wake_up_bit(NFS_INO_LAYOUTCOMMITTING, &NFS_I(inode)->flags);
 	goto out;
 }
 EXPORT_SYMBOL_GPL(pnfs_layoutcommit_inode);
-- 
2.53.0



