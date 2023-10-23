Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E8315E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaTbZoFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA77EC433C9;
	Mon, 23 Oct 2023 11:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060386;
	bh=OMxN+MAuJTEM3cNtG/ORCZ5nABEUjPPn8G/dSlpQF58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yaTbZoFEiSvUdZ21eTceYYOKMqWSM7A9v2+lRjjQM3ERY0jckalqo+vOGpZLu4T23
	 45J/hy0zyu5x2PEVIoJqQT9dyevbGqOCOQ12va7VJIN2uzhmQ8s987xnJav7xmSzpN
	 csVDJD80yWqFx5dWhekk/KwF5/uRC56My9XkUZKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 6.1 155/196] pNFS/flexfiles: Check the layout validity in ff_layout_mirror_prepare_stats
Date: Mon, 23 Oct 2023 12:57:00 +0200
Message-ID: <20231023104832.846229351@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit e1c6cfbb3bd1377e2ddcbe06cf8fb1ec323ea7d3 upstream.

Ensure that we check the layout pointer and validity after dereferencing
it in ff_layout_mirror_prepare_stats.

Fixes: 08e2e5bc6c9a ("pNFS/flexfiles: Clean up layoutstats")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/flexfilelayout/flexfilelayout.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/fs/nfs/flexfilelayout/flexfilelayout.c
+++ b/fs/nfs/flexfilelayout/flexfilelayout.c
@@ -2520,9 +2520,9 @@ ff_layout_mirror_prepare_stats(struct pn
 	return i;
 }
 
-static int
-ff_layout_prepare_layoutstats(struct nfs42_layoutstat_args *args)
+static int ff_layout_prepare_layoutstats(struct nfs42_layoutstat_args *args)
 {
+	struct pnfs_layout_hdr *lo;
 	struct nfs4_flexfile_layout *ff_layout;
 	const int dev_count = PNFS_LAYOUTSTATS_MAXDEV;
 
@@ -2533,11 +2533,14 @@ ff_layout_prepare_layoutstats(struct nfs
 		return -ENOMEM;
 
 	spin_lock(&args->inode->i_lock);
-	ff_layout = FF_LAYOUT_FROM_HDR(NFS_I(args->inode)->layout);
-	args->num_dev = ff_layout_mirror_prepare_stats(&ff_layout->generic_hdr,
-						       &args->devinfo[0],
-						       dev_count,
-						       NFS4_FF_OP_LAYOUTSTATS);
+	lo = NFS_I(args->inode)->layout;
+	if (lo && pnfs_layout_is_valid(lo)) {
+		ff_layout = FF_LAYOUT_FROM_HDR(lo);
+		args->num_dev = ff_layout_mirror_prepare_stats(
+			&ff_layout->generic_hdr, &args->devinfo[0], dev_count,
+			NFS4_FF_OP_LAYOUTSTATS);
+	} else
+		args->num_dev = 0;
 	spin_unlock(&args->inode->i_lock);
 	if (!args->num_dev) {
 		kfree(args->devinfo);


