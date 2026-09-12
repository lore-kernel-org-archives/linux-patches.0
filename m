Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5479C2DC792;
	Sat, 12 Sep 2026 13:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218616; cv=none; b=lb1poSNlcKRSMXYwErNa8v19O1r6s40KP8+q8PwUF+/JR/LrLBo44ewyzXB2PN+/swpQdQfZ+D5587PLZrZnJqkPl1umt3H0DoXGFUPMc3oGzRwzttl72rqivk6OBUO8PfYOSc+YL4Ds4tcmUl8n3rLiE6GSueLApQ8zR34BuPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218616; c=relaxed/simple;
	bh=oNGJemcg9LP/UDsS9TKHAmcK0ttIZfDRyc9zdc2Zsdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z6w2NFN2VjPPaFvUI1a7XL1pOYZd8LO8OwzpPqKASgAmML+SaGZfxYSFaLrINPp6zwt1x/HsRq87rIKTT2TCCPex0G6VcEY3SAI2HfBqXkZhMQ1uvxptur5v7Tdn5tnomWdsgE1DNEWXfstEvJ83E9g/0c+BjxO1NSGN0fl2PYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frTWi4lm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frTWi4lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EB21F000FF;
	Sat, 12 Sep 2026 13:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218615;
	bh=vl28jqLKhTPwvMap+0qVIbVm1w6Z6N0tKA8ra8v5AXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=frTWi4lmwgO5G6c3NFd1lfB5Kx3IJmyv/Mk1TJLWTz80LRw7up1A3cP+RYNM9HVRs
	 qtL14k+V4AbJebf4Ufn0sbk8m/P8+8u8OOpiyLI+sjcf8xnez0A8nmBBrPCjPMMP50
	 SGwUAX6vtH8eqLr7DkStPHRJfiEFvLO74bYb/TxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agatha Isabelle Moreira <code@agatha.dev>,
	Arnaud Bonnet <abo@medichon.fr>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1181/1376] nfs: refactor pNFS functions using clear_and_wake_up_bit
Date: Sat, 12 Sep 2026 09:00:07 +0200
Message-ID: <20260912065633.873091254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index a430b3da5c1b4..41081f393d393 100644
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



