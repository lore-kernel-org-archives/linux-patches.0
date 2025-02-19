Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C0C1EFFA4;
	Wed, 19 Feb 2025 09:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957238; cv=none; b=FB7k1JgEmUdoPdH9fMaIVoWATJ07NuPkucmpj0NXpCUjUEU+J/GoLl1LhloiS6lVs/FKYs3feEh3kdjOZcHYrfYmOFYE+em97xDnZEA2Y7Lx0cy7EnuOuSAGdr/d9hbGIx9ZNC4jtdHnpCEcA+ETXTxYOVFn9mf/sw/sojz0h/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957238; c=relaxed/simple;
	bh=DedF2ZN7JZZD6KDXz0D7roWAeNwQlZ043fyeQDqpoQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKqT4xaHG8iJOEoWvuLXVf3oyf+FqlZV9ohzvYUUfUm2RBxmgTgpIBDA4Pq9OQLzrSsGRp41R0eBMAZRsxx3vv8fCNb36coFVeNRf4tMSLQqsd2yzMzjZFCmtyBXpIRxlORBoEe9TSnmS53lMDyvrMhCc2JKzMR7zpFkgbC++Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iA6IeJn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iA6IeJn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E277AC4CED1;
	Wed, 19 Feb 2025 09:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957238;
	bh=DedF2ZN7JZZD6KDXz0D7roWAeNwQlZ043fyeQDqpoQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iA6IeJn6Ot5dmTag6ooAh1HHMvNQW94lvm2nBBcQ+v3adXJKNIx/cM7t+gN5owOT8
	 kcHpQF3/7Uwck3V3q0nzveei+TGW9M5R23F6eR9Pk8eNY8cwNsgIMshsJJUSJB8H1E
	 RKO8STBL7niySgqN24KjbxACw2Mfhyjb8e+MkUYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 6.1 425/578] pnfs/flexfiles: retry getting layout segment for reads
Date: Wed, 19 Feb 2025 09:27:09 +0100
Message-ID: <20250219082709.734008714@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

From: Mike Snitzer <snitzer@kernel.org>

commit eb3fabde15bccdf34f1c9b35a83aa4c0dacbb4ca upstream.

If ff_layout_pg_get_read()'s attempt to get a layout segment results
in -EAGAIN have ff_layout_pg_init_read() retry it after sleeping.

If "softerr" mount is used, use 'io_maxretrans' to limit the number of
attempts to get a layout segment.

This fixes a long-standing issue of O_DIRECT reads failing with
-EAGAIN (11) when using flexfiles Client Side Mirroring (CSM).

Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -839,6 +839,9 @@ ff_layout_pg_init_read(struct nfs_pageio
 	struct nfs4_pnfs_ds *ds;
 	u32 ds_idx;
 
+	if (NFS_SERVER(pgio->pg_inode)->flags &
+			(NFS_MOUNT_SOFT|NFS_MOUNT_SOFTERR))
+		pgio->pg_maxretrans = io_maxretrans;
 retry:
 	ff_layout_pg_check_layout(pgio, req);
 	/* Use full layout for now */
@@ -852,6 +855,8 @@ retry:
 		if (!pgio->pg_lseg)
 			goto out_nolseg;
 	}
+	/* Reset wb_nio, since getting layout segment was successful */
+	req->wb_nio = 0;
 
 	ds = ff_layout_get_ds_for_read(pgio, &ds_idx);
 	if (!ds) {
@@ -868,14 +873,24 @@ retry:
 	pgm->pg_bsize = mirror->mirror_ds->ds_versions[0].rsize;
 
 	pgio->pg_mirror_idx = ds_idx;
-
-	if (NFS_SERVER(pgio->pg_inode)->flags &
-			(NFS_MOUNT_SOFT|NFS_MOUNT_SOFTERR))
-		pgio->pg_maxretrans = io_maxretrans;
 	return;
 out_nolseg:
-	if (pgio->pg_error < 0)
-		return;
+	if (pgio->pg_error < 0) {
+		if (pgio->pg_error != -EAGAIN)
+			return;
+		/* Retry getting layout segment if lower layer returned -EAGAIN */
+		if (pgio->pg_maxretrans && req->wb_nio++ > pgio->pg_maxretrans) {
+			if (NFS_SERVER(pgio->pg_inode)->flags & NFS_MOUNT_SOFTERR)
+				pgio->pg_error = -ETIMEDOUT;
+			else
+				pgio->pg_error = -EIO;
+			return;
+		}
+		pgio->pg_error = 0;
+		/* Sleep for 1 second before retrying */
+		ssleep(1);
+		goto retry;
+	}
 out_mds:
 	trace_pnfs_mds_fallback_pg_init_read(pgio->pg_inode,
 			0, NFS4_MAX_UINT64, IOMODE_READ,


