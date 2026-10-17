Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47EB35C1BC;
	Sat, 17 Oct 2026 16:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253985; cv=none; b=h7Gk6cFu6GAO1GydDh0wH0jrIQfsRoz3fwGBBMuldh7ut1W2OorwAEPzDySHmmJ/zfbjIwV78qF3LEjHoM+C4Mr1OOY8x3d/zciVXMI9Tt94jE38fgG/BqIEdc0YKq8D912LUk4Xn9qX7AEKQBUeRsyqn7KQM8S6DZ1m/tGtBDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253985; c=relaxed/simple;
	bh=zvO2QkkT9vf9TOq9sLty5uYtUjWeFp9B38rufQOP+e8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rg6FfOclX+I2C2Y4GbKybPB2e/hefNvl0oo6yzUZVZfYHfYtjfubIWLZIykTfD9toUgbtX8KXuZdztfhkr5Zpx0/bX6fMtPA0afa//zYnUXWZpu/oykh5+ySjI1jR4Ay/HXSTOY67yVrloRRa6f5vp4A4y9P8UtH3hwlfBOLo0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZpS8R+x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZpS8R+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5BE1F000C6;
	Sat, 17 Oct 2026 16:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253984;
	bh=OfR+zyFBMBVZDBMnxa/i+VywjYsz0jtT7OwNdABNt6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pZpS8R+xj1LDIb5LYxCDvUYmEgmDXz/FkC8UORwQ45lDV+34STlVWnIXBNRGzuDNi
	 P91BtHWBwwyar71wAMOTyg7yFB59RjTm7AqnzvVwO6rgR16+3QgCNL3WKRQc3G9OPY
	 QfPYgfkOIyNnc498NCs0IExW9rVcb265KjZMpawg=
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
Subject: [PATCH 6.12 299/869] NFS/localio: prevent direct reclaim recursion into NFS via nfs_writepages
Date: Sat, 17 Oct 2026 17:52:20 +0200
Message-ID: <20261017160044.741843924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index c59f205b51308..fe76b8a9f2e67 100644
--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -270,6 +270,18 @@ nfs_bvec_alloc_and_import_pagevec(struct page **pagevec,
 	return bvec;
 }
 
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
@@ -293,6 +305,7 @@ nfs_local_iocb_alloc(struct nfs_pgio_header *hdr,
 		return NULL;
 	}
 
+	nfs_local_mapping_set_gfp_nofs_context(file->f_mapping);
 	if (localio_O_DIRECT_semantics &&
 	    test_bit(NFS_IOHDR_ODIRECT, &hdr->flags)) {
 		iocb->kiocb.ki_filp = file;
@@ -734,6 +747,8 @@ nfs_local_run_commit(struct file *filp, struct nfs_commit_data *data)
 			end = LLONG_MAX;
 	}
 
+	nfs_local_mapping_set_gfp_nofs_context(filp->f_mapping);
+
 	dprintk("%s: commit %llu - %llu\n", __func__, start, end);
 	return vfs_fsync_range(filp, start, end, 0);
 }
-- 
2.53.0



