Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73B646D2A0;
	Tue, 21 Jul 2026 18:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657195; cv=none; b=tf7vHUpz7F9P5hTNNxnzqtnz80VfXBJUYZIT54iA+yy9hkhmN+kznscV7uk+SISgjgrzhNZiZSuHrErCZid74+dfHJj3dMdA70Ayo0OEEezzJKqH7YBMBPgCkj9yMJXb13UJqn7XNW0/Dd+qa+PJ3x9g5ucAefVTRZaAgK6uDmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657195; c=relaxed/simple;
	bh=sZDdg6fOG/pMoRbFT+3lKybfHhk8gi2TEmyKOps9z6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHUHdEJUULbZRvgh3DvYNdmibEz0MZHWja/cwwV2CqLgO1b7iQEp9uzCiWsxKS6UAqLZAMFh/gH0UVhpAa4+9RnKazHEm5kZ4hpE7/4i07DAUHsjBiiUinU36F4augiEjhN0Me3prrdIpjy9GHQ33bplVh+tYmi/v2zI34ePmCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPoCekCQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPoCekCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170241F000E9;
	Tue, 21 Jul 2026 18:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657194;
	bh=OiiHojRCx7/1noVYm3j//m8Q067njll8NGVaFZ4RNOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPoCekCQKX+BZfmtRv+7f6F64WiTIp+Jl8U09I74+XkzJmS2ibasE25NkdOPzjLsI
	 PiaGk5/nVgWncnsuZotzvclMTwIqPuPXRH7Syl5DOaVUOzB+t35tD55YHUVhZKPkny
	 pHYf9rf3cq9P5MmIPOBwvKwYUMzU0/EzZwINv1vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0673/1611] NFSv4/flexfiles: honor FF_FLAGS_NO_IO_THRU_MDS in pg_get_mirror_count_write
Date: Tue, 21 Jul 2026 17:13:09 +0200
Message-ID: <20260721152530.520630026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 1d62e659c0bf11649cf48e002c2a55d148f2610a ]

The FF_FLAGS_NO_IO_THRU_MDS flag lives on each lseg, so any fallback
decision made when there is no current lseg (e.g. between LAYOUTRETURN
and the next LAYOUTGET) cannot run the per-lseg check.

Introduce a sticky hdr-level ditto for FF_FLAGS_NO_IO_THRU_MDS in
struct nfs4_flexfile_layout::flags (NFS4_FF_HDR_NO_IO_THRU_MDS bit),
set whenever ff_layout_alloc_lseg() parses an lseg with the flag.  The
bit is never cleared for the lifetime of the layout hdr; the server is
assumed to be consistent in its no-fallback policy per file.
kzalloc() in ff_layout_alloc_layout_hdr() zero-initializes the field.

Use the new ff_layout_hdr_no_fallback_to_mds() helper to gate
ff_layout_pg_get_mirror_count_write(): when pnfs_update_layout() returns
NULL (e.g. NFS_LAYOUT_BULK_RECALL, pnfs_layout_io_test_failed,
pnfs_layoutgets_blocked) the existing code unconditionally calls
nfs_pageio_reset_write_mds().  This is a source of unwanted WRITE to
MDS.  Fix it by checking NFS4_FF_HDR_NO_IO_THRU_MDS bit, and if set
surface -EAGAIN instead; the writepage-side caller (nfs_do_writepage()
for buffered, nfs_direct_write_reschedule() for O_DIRECT) then
redirties the request so writeback retries via pNFS.

Fixes: 260074cd8413 ("pNFS/flexfiles: Add support for FF_FLAGS_NO_IO_THRU_MDS")
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c | 13 +++++++++++++
 fs/nfs/flexfilelayout/flexfilelayout.h | 16 ++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/fs/nfs/flexfilelayout/flexfilelayout.c b/fs/nfs/flexfilelayout/flexfilelayout.c
index b602118d80216b..4604f108827227 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -638,6 +638,9 @@ ff_layout_alloc_lseg(struct pnfs_layout_hdr *lh,
 	if (!p)
 		goto out_sort_mirrors;
 	fls->flags = be32_to_cpup(p);
+	if (fls->flags & FF_FLAGS_NO_IO_THRU_MDS)
+		set_bit(NFS4_FF_HDR_NO_IO_THRU_MDS,
+			&FF_LAYOUT_FROM_HDR(lh)->flags);
 
 	p = xdr_inline_decode(&stream, 4);
 	if (!p)
@@ -1187,6 +1190,16 @@ ff_layout_pg_get_mirror_count_write(struct nfs_pageio_descriptor *pgio,
 			0, NFS4_MAX_UINT64, IOMODE_RW,
 			NFS_I(pgio->pg_inode)->layout,
 			pgio->pg_lseg);
+	if (NFS_I(pgio->pg_inode)->layout &&
+	    ff_layout_hdr_no_fallback_to_mds(NFS_I(pgio->pg_inode)->layout)) {
+		/*
+		 * FF_FLAGS_NO_IO_THRU_MDS: no current lseg but the server's
+		 * policy forbids MDS fallback.  Surface -EAGAIN so writeback
+		 * retries rather than silently issuing the WRITE via MDS.
+		 */
+		pgio->pg_error = -EAGAIN;
+		goto out;
+	}
 	/* no lseg means that pnfs is not in use, so no mirroring here */
 	nfs_pageio_reset_write_mds(pgio);
 out:
diff --git a/fs/nfs/flexfilelayout/flexfilelayout.h b/fs/nfs/flexfilelayout/flexfilelayout.h
index 17a008c8e97ce9..a5bd00f69e8242 100644
--- a/fs/nfs/flexfilelayout/flexfilelayout.h
+++ b/fs/nfs/flexfilelayout/flexfilelayout.h
@@ -112,12 +112,16 @@ struct nfs4_ff_layout_segment {
 	struct nfs4_ff_layout_mirror	*mirror_array[] __counted_by(mirror_array_cnt);
 };
 
+/* nfs4_flexfile_layout::flags bit indices */
+#define NFS4_FF_HDR_NO_IO_THRU_MDS  0   /* any lseg has had FF_FLAGS_NO_IO_THRU_MDS */
+
 struct nfs4_flexfile_layout {
 	struct pnfs_layout_hdr generic_hdr;
 	struct pnfs_ds_commit_info commit_info;
 	struct list_head	mirrors;
 	struct list_head	error_list; /* nfs4_ff_layout_ds_err */
 	ktime_t			last_report_time; /* Layoutstat report times */
+	unsigned long		flags;
 };
 
 struct nfs4_flexfile_layoutreturn_args {
@@ -184,6 +188,18 @@ ff_layout_no_fallback_to_mds(struct pnfs_layout_segment *lseg)
 	return FF_LAYOUT_LSEG(lseg)->flags & FF_FLAGS_NO_IO_THRU_MDS;
 }
 
+/*
+ * Sticky hdr-level mirror of FF_FLAGS_NO_IO_THRU_MDS so callers that have
+ * no current lseg (e.g. between LAYOUTRETURN and the next LAYOUTGET) can
+ * still honor the no-MDS-fallback policy.
+ */
+static inline bool
+ff_layout_hdr_no_fallback_to_mds(struct pnfs_layout_hdr *lo)
+{
+	return test_bit(NFS4_FF_HDR_NO_IO_THRU_MDS,
+			&FF_LAYOUT_FROM_HDR(lo)->flags);
+}
+
 static inline bool
 ff_layout_no_read_on_rw(struct pnfs_layout_segment *lseg)
 {
-- 
2.53.0



