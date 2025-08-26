Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F662BAF7;
	Tue, 26 Aug 2025 13:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213307; cv=none; b=FoMdze1qabp2+l6M7nBpHuCMGFf4CrGOTbWn6aCv1ceW1GcV5n75ClIbIIXioPWR+Whkyk/7DaisreBTFBCfEgvbCkkoy/mvlJ2Fa2Jyb+LTdfxYoNLFOlYG5DoOfiz24RwPHTiuXaipA1Bw/XFREQh0jNi+CKh6zJihX0wiVNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213307; c=relaxed/simple;
	bh=3HE1bemLJjow/1tQzNFqWl3RghntReju/bNjSNIAVZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhinrG3vq+V7l7uZ6X/U4qKVezReuDQr81oiE0lYuG5MeZmc4VcIHKYlXKMYGjzUo/Z4gxToEDz07EndwX6axeH8o5uenGONyUp+LvULfcDtVjOBBoFzZFYwXoNid5nzPRPE2gFP+HTMjJYZUfSSkFG8i72NrAqCqNl3JGQDkwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mKoiadKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mKoiadKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77316C4CEF1;
	Tue, 26 Aug 2025 13:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213306;
	bh=3HE1bemLJjow/1tQzNFqWl3RghntReju/bNjSNIAVZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKoiadKyCmEUjuXFzrll1FkDG0J0eE0z7/piM2El/R46r5PSZYpkeGm7YrfK8c0qC
	 pu6PKnl7JMpc0Ib7Zjs/4KWUrrpTdGOZD2NBMatpFlfEjSqwGTK4MZYaPB99Lf5hBy
	 3WwwayjLFUdxlmuCmw+8OZaFk9rwDWFnjdwd8GsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Evtushenko <koevtushenko@yandex.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 291/587] pNFS: Handle RPC size limit for layoutcommits
Date: Tue, 26 Aug 2025 13:07:20 +0200
Message-ID: <20250826111000.330553400@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Bashirov <sergeybashirov@gmail.com>

[ Upstream commit d897d81671bc4615c80f4f3bd5e6b218f59df50c ]

When there are too many block extents for a layoutcommit, they may not
all fit into the maximum-sized RPC. This patch allows the generic pnfs
code to properly handle -ENOSPC returned by the block/scsi layout driver
and trigger additional layoutcommits if necessary.

Co-developed-by: Konstantin Evtushenko <koevtushenko@yandex.com>
Signed-off-by: Konstantin Evtushenko <koevtushenko@yandex.com>
Signed-off-by: Sergey Bashirov <sergeybashirov@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250630183537.196479-5-sergeybashirov@gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/pnfs.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 79d1ffdcbebd..b40c20bd364b 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -3216,6 +3216,7 @@ pnfs_layoutcommit_inode(struct inode *inode, bool sync)
 	struct nfs_inode *nfsi = NFS_I(inode);
 	loff_t end_pos;
 	int status;
+	bool mark_as_dirty = false;
 
 	if (!pnfs_layoutcommit_outstanding(inode))
 		return 0;
@@ -3267,19 +3268,23 @@ pnfs_layoutcommit_inode(struct inode *inode, bool sync)
 	if (ld->prepare_layoutcommit) {
 		status = ld->prepare_layoutcommit(&data->args);
 		if (status) {
-			put_cred(data->cred);
+			if (status != -ENOSPC)
+				put_cred(data->cred);
 			spin_lock(&inode->i_lock);
 			set_bit(NFS_INO_LAYOUTCOMMIT, &nfsi->flags);
 			if (end_pos > nfsi->layout->plh_lwb)
 				nfsi->layout->plh_lwb = end_pos;
-			goto out_unlock;
+			if (status != -ENOSPC)
+				goto out_unlock;
+			spin_unlock(&inode->i_lock);
+			mark_as_dirty = true;
 		}
 	}
 
 
 	status = nfs4_proc_layoutcommit(data, sync);
 out:
-	if (status)
+	if (status || mark_as_dirty)
 		mark_inode_dirty_sync(inode);
 	dprintk("<-- %s status %d\n", __func__, status);
 	return status;
-- 
2.39.5



