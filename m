Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F15B2D8DCF;
	Wed, 25 Feb 2026 06:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002623; cv=none; b=GHM5FuQQ/zlzIqu1/KOwGA+GBISY37ahQnmCIVEWpta/eBkAhlAwXViJWZcvPwuaN0p509m9r6nJQ9erVcepwaRi4RwZa30SHTXC2QlsPUWFj/zVAakA9s2vQqylnZkEKK68GKytLR431nKZVwd7wzpwfsSKzLLPGq39mAHilYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002623; c=relaxed/simple;
	bh=s4nQYYfq5N9CBkzNU6etv64a/fH51JJFJ/m4tss9uHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J8f3bDBDtNNTsw4bRSVEO5BIXlpWayuQjeQtfWtFMNyF0twP3y4OCAaRAqR7o3glN8Ey0vD/aq2F9DY6+xhIMdN1tYAXHxLLc7iDeSBu+NSfx7M7LhQCuyM1HdjJrL19CybB+9mFzWik6wB0OudTW9a3/T/CV1KYFQDKKafD6jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h/gPgMHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h/gPgMHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3CAC116D0;
	Wed, 25 Feb 2026 06:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002623;
	bh=s4nQYYfq5N9CBkzNU6etv64a/fH51JJFJ/m4tss9uHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h/gPgMHs1KgKoIAtvSHCof9u1WjoxrZbbo4MXJ0jzmfFqQ/dH+gar2+3daq9qpCY7
	 DYjiE68zaNwZInZ8rLwLPVAYxT+Tnt5aQtM8wei2kpAAIYLoR8qvwlf46htJIJIOfz
	 vyREuZhoeK2Y3dHSkwJALTRqf+DdMfWjt7f0W6V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Cagle <john.cagle@hammerspace.com>,
	Allen Lu <allen.lu@hammerspace.com>,
	Benjamin Coddington <bcodding@hammerspace.com>,
	Mike Snitzer <snitzer@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 374/641] NFS/localio: prevent direct reclaim recursion into NFS via nfs_writepages
Date: Tue, 24 Feb 2026 17:21:40 -0800
Message-ID: <20260225012357.665210997@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Mike Snitzer <snitzer@hammerspace.com>

[ Upstream commit 67435d2d8a33a75f9647724952cb1b18279d2e95 ]

LOCALIO is an NFS loopback mount optimization that avoids using the
network for READ, WRITE and COMMIT if the NFS client and server are
determined to be on the same system. But because LOCALIO is still
fundamentally "just NFS loopback mount" it is susceptible to recursion
deadlock via direct reclaim, e.g.: NFS LOCALIO down to XFS and then
back into NFS via nfs_writepages.

Fix LOCALIO's potential for direct reclaim deadlock by ensuring that
all its page cache allocations are done from GFP_NOFS context.

Thanks to Ben Coddington for pointing out commit ad22c7a043c2 ("xfs:
prevent stack overflows from page cache allocation").

Reported-by: John Cagle <john.cagle@hammerspace.com>
Tested-by: Allen Lu <allen.lu@hammerspace.com>
Suggested-by: Benjamin Coddington <bcodding@hammerspace.com>
Fixes: 70ba381e1a43 ("nfs: add LOCALIO support")
Signed-off-by: Mike Snitzer <snitzer@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/localio.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/nfs/localio.c b/fs/nfs/localio.c
index ea7b35191d0af..ff430e6b773a5 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -291,6 +291,18 @@ nfs_local_open_fh(struct nfs_client *clp, const struct cred *cred,
 }
 EXPORT_SYMBOL_GPL(nfs_local_open_fh);
 
+/*
+ * Ensure all page cache allocations are done from GFP_NOFS context to
+ * prevent direct reclaim recursion back into NFS via nfs_writepages.
+ */
+static void
+nfs_local_mapping_set_gfp_nofs_context(struct address_space *m)
+{
+	gfp_t gfp_mask = mapping_gfp_mask(m);
+
+	mapping_set_gfp_mask(m, (gfp_mask & ~(__GFP_FS)));
+}
+
 static void
 nfs_local_iocb_free(struct nfs_local_kiocb *iocb)
 {
@@ -315,6 +327,7 @@ nfs_local_iocb_alloc(struct nfs_pgio_header *hdr,
 		return NULL;
 	}
 
+	nfs_local_mapping_set_gfp_nofs_context(file->f_mapping);
 	init_sync_kiocb(&iocb->kiocb, file);
 
 	iocb->hdr = hdr;
@@ -1010,6 +1023,8 @@ nfs_local_run_commit(struct file *filp, struct nfs_commit_data *data)
 			end = LLONG_MAX;
 	}
 
+	nfs_local_mapping_set_gfp_nofs_context(filp->f_mapping);
+
 	dprintk("%s: commit %llu - %llu\n", __func__, start, end);
 	return vfs_fsync_range(filp, start, end, 0);
 }
-- 
2.51.0



