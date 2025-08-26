Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4197D3451D5;
	Tue, 26 Aug 2025 13:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215969; cv=none; b=B1XL17dv+9Vv8GAKU/xaTyC/2cCg0e7xhy5Kmylb5UBmJN+q4Dp92uUPLQPkqkTsVfFEkcnrO6cVksqbwrWMsBxM3x/ktVE5nR9rWzkzUhtErx50yUomSMzbG31vlO0L8TgUi9ZS3ruR84cl4y3TocTCVTctWu4dg1LW8cpqPFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215969; c=relaxed/simple;
	bh=pvlAVlnCkW9wASnQvU29RrLul4R7IIJcPO5aH3Wr96Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSjHbB6SH2IwMqowLCO2iAG8eRSP0qgOCSFMxeVbCA2n2v7pRZXfGo1k77CDzMCFgj7DKUM2/rEH/m5HUndRxj8yRGpO8+HXp33fSYCnjgQnm+uGpeQCZ8DVl5/bHU/pJeL8yGzuGvLhlmtsj8G+fL+YmuM8jl9qWZ3Mw07ZkBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDLHvWNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDLHvWNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC28CC4CEF1;
	Tue, 26 Aug 2025 13:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215969;
	bh=pvlAVlnCkW9wASnQvU29RrLul4R7IIJcPO5aH3Wr96Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDLHvWNz8+ZMykq4zuUboe0ovnu60DBkdruOtutwcS1Rzudfs7BQe04RWy+CxSDrK
	 c0picm3DN+zhlu9qqNLogXZ4gKGwTJoXTBHDxlKouwm9sHNo5QmxBEk2cdF0e4Drx1
	 N65EGRlWyz+hrBlP6QR4qDk9lHAb9Cskh042FRo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhangjian <zhangjian496@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/644] NFS: Fix filehandle bounds checking in nfs_fh_to_dentry()
Date: Tue, 26 Aug 2025 13:05:18 +0200
Message-ID: <20250826110952.040477798@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit ef93a685e01a281b5e2a25ce4e3428cf9371a205 ]

The function needs to check the minimal filehandle length before it can
access the embedded filehandle.

Reported-by: zhangjian <zhangjian496@huawei.com>
Fixes: 20fa19027286 ("nfs: add export operations")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/export.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/export.c b/fs/nfs/export.c
index eafa9d7b0911..6bbe92a4eb0c 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -67,14 +67,21 @@ nfs_fh_to_dentry(struct super_block *sb, struct fid *fid,
 	struct nfs4_label *label = NULL;
 	struct nfs_fattr *fattr = NULL;
 	struct nfs_fh *server_fh = nfs_exp_embedfh(fid->raw);
-	size_t fh_size = offsetof(struct nfs_fh, data) + server_fh->size;
+	size_t fh_size = offsetof(struct nfs_fh, data);
 	const struct nfs_rpc_ops *rpc_ops;
 	struct dentry *dentry;
 	struct inode *inode;
-	int len = EMBED_FH_OFF + XDR_QUADLEN(fh_size);
+	int len = EMBED_FH_OFF;
 	u32 *p = fid->raw;
 	int ret;
 
+	/* Initial check of bounds */
+	if (fh_len < len + XDR_QUADLEN(fh_size) ||
+	    fh_len > XDR_QUADLEN(NFS_MAXFHSIZE))
+		return NULL;
+	/* Calculate embedded filehandle size */
+	fh_size += server_fh->size;
+	len += XDR_QUADLEN(fh_size);
 	/* NULL translates to ESTALE */
 	if (fh_len < len || fh_type != len)
 		return NULL;
-- 
2.39.5



