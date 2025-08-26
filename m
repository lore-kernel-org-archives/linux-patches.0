Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEBB352066;
	Tue, 26 Aug 2025 14:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218053; cv=none; b=BVHNI4Flv2VRrfdySiiJhOBqtTE0IqI+RE/19xUa3Xt0dkeLLfRQIinv9j3HcN8qfg8D3qakpeQlOAOXlGgYfSICG+xVPY1VTxnhwA6X0RWx46iyua0hvnyAUGoR0IT4MoUuVoEpMM9kEm6GwgisuwcynyyU14Ne/JFylh9QwZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218053; c=relaxed/simple;
	bh=9gXjk+YYhT4tHWuRg9h7kAjdKUdy1zUvQd5CHnYYkKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxhextBY9x1kI3GjVGjjgWFhEqk6elkCr+chs2GtL3/wEFYlz1r4MLujWE7FrCSxBXKgOyg7+/MfxCgb/v4/cnwCssoph0R0hKgbvtCiQQ/j9M1kiBygg0TQazA2eZ/L5svJGL1q1ThLYQ4e2KubadaYySipWEj4QopcZQsxwGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vw4C670v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vw4C670v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F0FC4CEF1;
	Tue, 26 Aug 2025 14:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218052;
	bh=9gXjk+YYhT4tHWuRg9h7kAjdKUdy1zUvQd5CHnYYkKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vw4C670v3ZO++4FzYyODC0fZe2Fw7nHQObue9LIh4Cz4m4vstWGsuzQ4JRRNZEzNd
	 6w5VWZ29ykFFnpHd/JifTm4BayNFjeI+DYniK4bQMpmxYG71OlA0DrhkJrTxucB4Ls
	 K29m8+VWroGGec+Gv1IMBiKrTeITOz60WCeyYjDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Evtushenko <koevtushenko@yandex.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 334/523] pNFS: Handle RPC size limit for layoutcommits
Date: Tue, 26 Aug 2025 13:09:04 +0200
Message-ID: <20250826110932.714389028@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 758689877d85..e14cf7140bab 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -3219,6 +3219,7 @@ pnfs_layoutcommit_inode(struct inode *inode, bool sync)
 	struct nfs_inode *nfsi = NFS_I(inode);
 	loff_t end_pos;
 	int status;
+	bool mark_as_dirty = false;
 
 	if (!pnfs_layoutcommit_outstanding(inode))
 		return 0;
@@ -3270,19 +3271,23 @@ pnfs_layoutcommit_inode(struct inode *inode, bool sync)
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



