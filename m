Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7045518B0A;
	Wed, 25 Feb 2026 01:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983353; cv=none; b=Bn2yNPl2SILk3DJ756XAX/lGUXtVi3ujiBExSstE5bzvrWGjP0LLfb2o6Z/7/zOvKqXYkl4MsW560EQ2GPLVncQsVOthC/0HNHM8T9WkUlT0/fimSugxWBIK6OIJk2bYOztjBtF7uwmDUP/QgPhvw5MGSP6Vl+ixxM6q7efq6d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983353; c=relaxed/simple;
	bh=vHCROGLlUjxZwidZMgl1UBtNKTDpBiMyksrmDNlc348=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DaEQCmAuOHUmS13piSL97aN6pLmDBX3AH8LUWms8WHnaOIZfebKVfWqhLD5bhBroOrhXjt6WhP5Uo1UubeMofNz84SonblrVbISf3XMzd7+pR2RaOeZ0nHCtXuz+N1eg9ljse2xswDu4DsBxbw222odo8flwRYAYjI524mkV7ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UARMOuoN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UARMOuoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F710C116D0;
	Wed, 25 Feb 2026 01:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983353;
	bh=vHCROGLlUjxZwidZMgl1UBtNKTDpBiMyksrmDNlc348=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UARMOuoNpfXJ1eyeCU1jJZv16Qg2E5wm1ZRB4LynkzLCO/fxlUARHuFNWPW60lUXw
	 5y+CnDnqjCp2QBWHNvMdDpvWn1utT6t0dMJMrdAaas0Xq5opuTTzB2GtjwUUkuJCgM
	 YoukOcuQzElv4tYoJrq7D5JdakrKRmNEwnVoDpZs=
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
Subject: [PATCH 6.19 478/781] NFS/localio: prevent direct reclaim recursion into NFS via nfs_writepages
Date: Tue, 24 Feb 2026 17:19:47 -0800
Message-ID: <20260225012411.538570224@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 00bbac6c9fe40..84f53f27a9089 100644
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
@@ -1004,6 +1017,8 @@ nfs_local_run_commit(struct file *filp, struct nfs_commit_data *data)
 			end = LLONG_MAX;
 	}
 
+	nfs_local_mapping_set_gfp_nofs_context(filp->f_mapping);
+
 	dprintk("%s: commit %llu - %llu\n", __func__, start, end);
 	return vfs_fsync_range(filp, start, end, 0);
 }
-- 
2.51.0



