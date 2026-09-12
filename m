Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB9025B0A5;
	Sat, 12 Sep 2026 19:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240296; cv=none; b=WmZcLZ+cl9V5Ap3T9/3bxi0ydbcM/PCt4mmk6na4Kv5Xhot9pmwgcvkdpE9J+kdmded0hplEzCiYeP5QBQQ1xCT3MwoU73xveLFiOHoCnZcT1DY+E9WILruVlzBLsbjr2DxSTT656cjfquCw2Xd9KVr31qkFcbOTi4JSWOdCoXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240296; c=relaxed/simple;
	bh=seaMtECBPGxd7W/0Lf7bfDJ4Ga1hWPUXUJrPygjnhDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2rtX3Ua6rdGEANy0N4PLKtjSHZEEofrRdst0y9fqj8NEhULT+Pzd+Yi/mWRG9zyTzd+GtZ923UadFQQ6f+VGqTk2FvSKNUnUiMYcm4kCbR0wQifgeihIkzMZjv1lo0+p263PKD890vw4Asii4TtKhpdKRzrOlSn3spktwRHi88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sF4WpSzz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sF4WpSzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A996B1F000FF;
	Sat, 12 Sep 2026 19:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240294;
	bh=zLJBPZieHOEs3+tN5W+b+Ss2bJhbhEa/6W1VRbYwwhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sF4WpSzz6jvqsmKCZt7OtKZB9n8nTJfCsL3ow2ejnP/uSek2ES28pSP75pSPpn6D1
	 tx5FLJy4u5iN3p9egxk0cJOq+I2ZSI3qKylypNseB6mHopPeruDt+JIHS/4eH4MUFp
	 Chc9A/RPOshVGMCAFHfVcoSoSXfUOK9agVb4I3jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agatha Isabelle Moreira <code@agatha.dev>,
	Arnaud Bonnet <abo@medichon.fr>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 839/935] nfs: refactor pNFS functions using clear_and_wake_up_bit
Date: Sat, 12 Sep 2026 09:04:29 +0200
Message-ID: <20260912065546.069053085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1bb98ecacc1b5..43413e2cf5876 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1940,15 +1940,6 @@ static bool pnfs_is_first_layoutget(struct pnfs_layout_hdr *lo)
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
@@ -2122,7 +2113,8 @@ pnfs_update_layout(struct inode *ino,
 					iomode, lo, lseg,
 					PNFS_UPDATE_LAYOUT_INVALID_OPEN);
 			nfs4_schedule_stateid_recovery(server, ctx->state);
-			pnfs_clear_first_layoutget(lo);
+			clear_and_wake_up_bit(NFS_LAYOUT_FIRST_LAYOUTGET,
+				&lo->plh_flags);
 			pnfs_put_layout_hdr(lo);
 			goto lookup_again;
 		}
@@ -2189,7 +2181,8 @@ pnfs_update_layout(struct inode *ino,
 		}
 		if (lseg) {
 			if (first)
-				pnfs_clear_first_layoutget(lo);
+				clear_and_wake_up_bit(NFS_LAYOUT_FIRST_LAYOUTGET,
+					&lo->plh_flags);
 			trace_pnfs_update_layout(ino, pos, count,
 				iomode, lo, lseg, PNFS_UPDATE_LAYOUT_RETRY);
 			pnfs_put_layout_hdr(lo);
@@ -2201,7 +2194,7 @@ pnfs_update_layout(struct inode *ino,
 
 out_put_layout_hdr:
 	if (first)
-		pnfs_clear_first_layoutget(lo);
+		clear_and_wake_up_bit(NFS_LAYOUT_FIRST_LAYOUTGET, &lo->plh_flags);
 	trace_pnfs_update_layout(ino, pos, count, iomode, lo, lseg,
 				 PNFS_UPDATE_LAYOUT_EXIT);
 	pnfs_put_layout_hdr(lo);
@@ -2293,7 +2286,7 @@ static void _lgopen_prepare_attached(struct nfs4_opendata *data,
 	lgp = pnfs_alloc_init_layoutget_args(ino, ctx, &current_stateid,
 					     &rng, GFP_KERNEL);
 	if (!lgp) {
-		pnfs_clear_first_layoutget(lo);
+		clear_and_wake_up_bit(NFS_LAYOUT_FIRST_LAYOUTGET, &lo->plh_flags);
 		nfs_layoutget_end(lo);
 		pnfs_put_layout_hdr(lo);
 		return;
@@ -2397,7 +2390,8 @@ void nfs4_lgopen_release(struct nfs4_layoutget *lgp)
 {
 	if (lgp != NULL) {
 		if (lgp->lo) {
-			pnfs_clear_first_layoutget(lgp->lo);
+			clear_and_wake_up_bit(NFS_LAYOUT_FIRST_LAYOUTGET,
+				&lgp->lo->plh_flags);
 			nfs_layoutget_end(lgp->lo);
 		}
 		pnfs_layoutget_free(lgp);
@@ -3122,15 +3116,6 @@ pnfs_generic_pg_readpages(struct nfs_pageio_descriptor *desc)
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
@@ -3155,7 +3140,7 @@ static void pnfs_list_write_lseg_done(struct inode *inode, struct list_head *lis
 		pnfs_put_lseg(lseg);
 	}
 
-	pnfs_clear_layoutcommitting(inode);
+	clear_and_wake_up_bit(NFS_INO_LAYOUTCOMMITTING, &NFS_I(inode)->flags);
 }
 
 void pnfs_set_lo_fail(struct pnfs_layout_segment *lseg)
@@ -3295,7 +3280,7 @@ pnfs_layoutcommit_inode(struct inode *inode, bool sync)
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



