Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066E035AABF;
	Tue, 26 Aug 2025 14:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218807; cv=none; b=n3GceRcBAmDUkSAb61CCXLC//By38vYJ3m7nmxnfYpJvT5+P3IFGOPRZELl/C1VGD7mRGiJnj7iZTsmPcV0CWbUI261AMYgbIxFZ4luw7kHk3Z0Rt5Y09xyrxy9EfX+adBhu3qCjY2U27mtlnePXa49oWch4J//OXb7+pcQQ4Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218807; c=relaxed/simple;
	bh=lhnBjVi4+2pIe1jep4sOsHFt5eiD+ou2Lsn52oZvdPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qi8nvJPHMFQ80gJvg1sxtmbQeeWTBkegoL2U2725eI3Y1upRabSa7+FU7SpQ0DQGOWLBoaqtx517DjdpN5GVfEyY8A9DWi1EsmCbwbi12VHOsnVkIIC7BMGFT0KkbqkTIEXIQxOL2SusSgInNQxDhmq/Q0lvWOAWDsUUTZkHw8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLM87aEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLM87aEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D8BC4CEF1;
	Tue, 26 Aug 2025 14:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218806;
	bh=lhnBjVi4+2pIe1jep4sOsHFt5eiD+ou2Lsn52oZvdPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLM87aEtbXOjOwZn8aqGtu2x2LK9iTO1lkxvtfbATPt5oC8lcpO1A3j9jWbKM6mlp
	 EQRUOsE4UqEigrHgKq0JdrRNVi8C/C/LjcBlcQPfOnhMbBlVWVP3cR1b4XVhatXcev
	 xbtiCoQa0oIiVtp8xkdgMzPt+8Zy7Bt9ch8CCt6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhangjian <zhangjian496@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 140/403] NFS: Fix filehandle bounds checking in nfs_fh_to_dentry()
Date: Tue, 26 Aug 2025 13:07:46 +0200
Message-ID: <20250826110910.623942587@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index deecb67638aa..97b6fa0adb57 100644
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



