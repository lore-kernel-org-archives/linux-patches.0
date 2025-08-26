Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2E0350825;
	Tue, 26 Aug 2025 14:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217580; cv=none; b=C/DtwqEYugdpVsP1QgGn7vA/xvV7j9vIrfT7hxgiQSpSofki+xPZ9iRP7Gye2yVkY/LGpje1T1J9PBoo9y+qYXxu4/nvIO6/zh90UcfedjqkReYvKIELvqh2KKHaZmZOyQ6lek4BPAgJKEinQlRdjI9///TQMdfq52Zx5bF1QI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217580; c=relaxed/simple;
	bh=t0lw5MLIqX/MLXnFDqKHWJgFb9eUQyaE0ZRgqT51QPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=do0X6V/dGsPzfnOY6HuY4dUcfxAjOSpSiBiMkN4LqlU85cB7liXZyzQmT+Al1amgN2fSD6Q9GBRQC++m30uluWKM/t1lWwMH1TGjkwARGBcs3b7vi/rzEGo7q/khvzDE+LAEnIedPLztJV9NV0pGBoudb7Z9RgaL8aQdy1KT1W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ds9r4L7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ds9r4L7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3966C113D0;
	Tue, 26 Aug 2025 14:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217580;
	bh=t0lw5MLIqX/MLXnFDqKHWJgFb9eUQyaE0ZRgqT51QPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ds9r4L7Si6aSdxu/z6UBZ8QXdyu8ZdZTRFIg0VOXWhNKJSR3oz8gFuZ1DotgIMyHY
	 Inc4PVZTbVYhiLD7pmARXixM0G4j7VxEEr0bDuLy5URrHfzBsEH/RMwYHiPFUsbACA
	 a4Ta6XfGMpGpIBAOxTefpTqK9AzNejKL0wNMN9bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhangjian <zhangjian496@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 169/523] NFS: Fix filehandle bounds checking in nfs_fh_to_dentry()
Date: Tue, 26 Aug 2025 13:06:19 +0200
Message-ID: <20250826110928.637759412@linuxfoundation.org>
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
index 993be63ab301..784d0f1cfb93 100644
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



