Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA2C4E06CC;
	Wed, 30 Sep 2026 16:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786982; cv=none; b=O/lZAkvsyJSFMxGHtFMlx3JR6i+iBHavkucJH+sVpwdrJt/PBKN+a3lwIgW9H5H37lp/H6+IzQSUOzv3MvtxVQE9GeoRe5B3Y1k2SnyQfMxL0LkbJdNVWaebxRWrni7zVuBqNvVJJUz88KSxjoCBnm6XD2yAoBgz0vz39U1dehQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786982; c=relaxed/simple;
	bh=fvF5SJae4z0ZoOpsqkiCEHFPeRxJ0UmmDOSDI/VdPFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+E8/cLUye4Vza3Eog+cmZ2mwboB1Lxf74GbapCoVS7CksuOx0HyOdvyWqMCI6KFfF6IiBjHlT3gdIsf7K4LThT9HxZYCjSddyGYJsqCv8fd0d7LA8GQgcMMjU0UfwgorXlc4OiI2af8YdDRt2JYBlqvJjCcENEVhEIoatlSsD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsZwrbYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsZwrbYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60771F000FF;
	Wed, 30 Sep 2026 16:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786981;
	bh=JX+Jr6F1SxRW6RYIJhm16iiLYpsqHEpsd1NNBE+Pf1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YsZwrbYDw8gcSUDMcp2zUjFocUDInRNni94OQVYGj//19yFObbXNYbfbXK8oMFOnc
	 smAP+Q3vjSzPhmqxiDgoY0AW2r3z3CyqxV9I7O8c2G613jvWdWZ0fAB01d8kcThrGy
	 A9nkgSnUB3XdM/Ft2OFaIFsgqtIohnMZ93gra7qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heyang Tan <thy15333007817@163.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 071/457] octeontx2-af: use seq_file for rsrc_alloc debugfs
Date: Wed, 30 Sep 2026 17:22:56 +0200
Message-ID: <20260930152347.581655355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heyang Tan <thy15333007817@163.com>

[ Upstream commit 39c6580765dad6477fb2637f6f616e0d276aae65 ]

The rsrc_alloc debugfs reader writes rows directly to userspace without
respecting the caller's read count. It also uses the current row length as
the userspace stride, which can corrupt output when rows have different
widths.

Use seq_file to handle userspace buffer sizes, offsets, and partial reads,
and write output columns directly to the seq_file buffer.

Fixes: 23205e6d06d4 ("octeontx2-af: Dump current resource provisioning status")
Signed-off-by: Heyang Tan <thy15333007817@163.com>
Reviewed-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20260914020521.146-1-thy15333007817@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/af/rvu_debugfs.c        | 104 ++++++------------
 1 file changed, 33 insertions(+), 71 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 904374baae6f3..2927633465d96 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -714,110 +714,72 @@ static int get_max_column_width(struct rvu *rvu)
 }
 
 /* Dumps current provisioning status of all RVU block LFs */
-static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
-					  char __user *buffer,
-					  size_t count, loff_t *ppos)
+static int rvu_dbg_rsrc_attach_status(struct seq_file *filp, void *unused)
 {
-	int index, off = 0, flag = 0, len = 0, i = 0;
-	struct rvu *rvu = filp->private_data;
-	int bytes_not_copied = 0;
+	struct rvu *rvu = filp->private;
+	int index, pf, vf, pcifunc;
 	struct rvu_block block;
-	int pf, vf, pcifunc;
-	int buf_size = 2048;
 	int lf_str_size;
 	char *lfs;
-	char *buf;
-
-	/* don't allow partial reads */
-	if (*ppos != 0)
-		return 0;
-
-	buf = kzalloc(buf_size, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
 
-	/* Get the maximum width of a column */
 	lf_str_size = get_max_column_width(rvu);
+	if (lf_str_size < 0)
+		return lf_str_size;
 
 	lfs = kzalloc(lf_str_size, GFP_KERNEL);
-	if (!lfs) {
-		kfree(buf);
+	if (!lfs)
 		return -ENOMEM;
-	}
-	off +=	scnprintf(&buf[off], buf_size - 1 - off, "%-*s", lf_str_size,
-			  "pcifunc");
-	for (index = 0; index < BLK_COUNT; index++)
-		if (strlen(rvu->hw->block[index].name)) {
-			off += scnprintf(&buf[off], buf_size - 1 - off,
-					 "%-*s", lf_str_size,
-					 rvu->hw->block[index].name);
-		}
 
-	off += scnprintf(&buf[off], buf_size - 1 - off, "\n");
-	bytes_not_copied = copy_to_user(buffer + (i * off), buf, off);
-	if (bytes_not_copied)
-		goto out;
+	seq_printf(filp, "%-*s", lf_str_size, "pcifunc");
+	for (index = 0; index < BLK_COUNT; index++)
+		if (strlen(rvu->hw->block[index].name))
+			seq_printf(filp, "%-*s", lf_str_size,
+				   rvu->hw->block[index].name);
 
-	i++;
-	*ppos += off;
+	seq_putc(filp, '\n');
 	for (pf = 0; pf < rvu->hw->total_pfs; pf++) {
 		for (vf = 0; vf <= rvu->hw->total_vfs; vf++) {
-			off = 0;
-			flag = 0;
 			pcifunc = rvu_make_pcifunc(rvu->pdev, pf, vf);
 			if (!pcifunc)
 				continue;
 
-			if (vf) {
+			for (index = 0; index < BLK_COUNT; index++) {
+				block = rvu->hw->block[index];
+				if (!strlen(block.name))
+					continue;
+				lfs[0] = '\0';
+				get_lf_str_list(&block, pcifunc, lfs);
+				if (strlen(lfs))
+					break;
+			}
+			if (index == BLK_COUNT)
+				continue;
+
+			if (vf)
 				sprintf(lfs, "PF%d:VF%d", pf, vf - 1);
-				off = scnprintf(&buf[off],
-						buf_size - 1 - off,
-						"%-*s", lf_str_size, lfs);
-			} else {
+			else
 				sprintf(lfs, "PF%d", pf);
-				off = scnprintf(&buf[off],
-						buf_size - 1 - off,
-						"%-*s", lf_str_size, lfs);
-			}
+			seq_printf(filp, "%-*s", lf_str_size, lfs);
 
 			for (index = 0; index < BLK_COUNT; index++) {
 				block = rvu->hw->block[index];
 				if (!strlen(block.name))
 					continue;
-				len = 0;
-				lfs[len] = '\0';
-				get_lf_str_list(&block, pcifunc, lfs);
-				if (strlen(lfs))
-					flag = 1;
 
-				off += scnprintf(&buf[off], buf_size - 1 - off,
-						 "%-*s", lf_str_size, lfs);
-			}
-			if (flag) {
-				off +=	scnprintf(&buf[off],
-						  buf_size - 1 - off, "\n");
-				bytes_not_copied = copy_to_user(buffer +
-								(i * off),
-								buf, off);
-				if (bytes_not_copied)
-					goto out;
-
-				i++;
-				*ppos += off;
+				lfs[0] = '\0';
+				get_lf_str_list(&block, pcifunc, lfs);
+				seq_printf(filp, "%-*s", lf_str_size, lfs);
 			}
+			seq_putc(filp, '\n');
 		}
 	}
 
-out:
 	kfree(lfs);
-	kfree(buf);
-	if (bytes_not_copied)
-		return -EFAULT;
 
-	return *ppos;
+	return 0;
 }
 
-RVU_DEBUG_FOPS(rsrc_status, rsrc_attach_status, NULL);
+RVU_DEBUG_SEQ_FOPS(rsrc_status, rsrc_attach_status, NULL);
 
 static int rvu_dbg_rvu_pf_cgx_map_display(struct seq_file *filp, void *unused)
 {
-- 
2.53.0



