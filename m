Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9DF2DE1E2;
	Tue, 12 Aug 2025 17:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021169; cv=none; b=U1faoNtbyCF6vZ5LMtqLbuTEeqE7uNH0BmzX7uHdUIHTlhQZl7FnvbOq5mL5jLNDcm1d/7WS47P4wWeGilhp6iilKgPsy8kNo4mq5clOoMyuW/ZCZHrT9kkNxwUSI3+8HIMPNVmQ1EWMSHpcAu/0CLJ1gUs7TbbwW+epZtx/eiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021169; c=relaxed/simple;
	bh=E54oIxuIe/mpVmqJjpyq2C799XGVE39/SR+Mf/+pkok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWhk62EytkZVtMsxt6IK2RZ5/GhatsVvnBzFfl5j84pp9nzM3OwCQ9xXYGYNkMXUjnK1STzPfQeEjjbbKam+TE2T/k8FYkW5Tbdd8QzpqKBgXQchyLHnhUXdK8ynqBfr/+jehQPjBFw/MhoXPkw/EiuqXjYsd3BhKLniVFH24wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYd058Zw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYd058Zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF02C4CEF0;
	Tue, 12 Aug 2025 17:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021168;
	bh=E54oIxuIe/mpVmqJjpyq2C799XGVE39/SR+Mf/+pkok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYd058ZwdEkUbOK5AoJksWdrOuKNvAHiiW9K1blFlpbgCvefYP8VS7pqbEaUJLBYT
	 9CoVqLohwcAQmxyKJiLDpfQefSLjDfLhNTEe0hFk66XC0li1pOHzUyDBkZWRDdoJU9
	 zQGCryM4PmGzef/ZadQRaXCfx5bVo9YZ6WW506uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhangjian <zhangjian496@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 215/253] NFS: Fix filehandle bounds checking in nfs_fh_to_dentry()
Date: Tue, 12 Aug 2025 19:30:03 +0200
Message-ID: <20250812172957.985448388@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9fe9586a51b7..aacf6220ab44 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -66,14 +66,21 @@ nfs_fh_to_dentry(struct super_block *sb, struct fid *fid,
 {
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



